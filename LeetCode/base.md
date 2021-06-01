# RunLoop

> Run loops are part of the fundamental infrastructure associated with threads.
A run loop is an event processing loop that you use to schedule work and coordinate the receipt of incoming events. The purpose of a run loop is to keep your thread busy when there is work to do and put your thread to sleep when there is none.

RunLoop是部分与线程相关的基础功能。RunLoop是用于调度工作，协调接收传入事件的事件处理循环。RunLoop的目的是让线程在有任务时工作，无任务时休眠。

线程在处理完自己的任务后一般会退出，RunLoop可以让线程在没有任务时也不退出，而是保持闲等状态（其他操作系统中的EventLoop）。

线程和RunLoop是一一对应的，对应关系保存在一个全局字典当中。线程刚创建时没有RunLoop，直到第一次主动获取RunLoop才会被系统创建，RunLoop随线程的结束而销毁。RunLoop只能在对应线程内部获取。

# 锁🔐

## 概念

1. 公平锁 / 非公平锁

> 公平锁是指多个线程按照申请锁的顺序来获取锁。

> 非公平锁是指多个线程获取锁的顺序并不是按照申请锁的顺序，有可能后申请的线程比先申请的线程优先获取锁。有可能，会造成优先级反转或者饥饿现象。

2. 可重入锁 / 不可重入锁

> 广义上的可重入锁指的是可重复可递归调用的锁，在外层使用锁之后，在内层仍然可以使用，并且不发生死锁（前提得是同一个对象或者class）

> 不可重入锁，与可重入锁相反，不可递归调用，递归调用就发生死锁。


3. 独享锁 / 共享锁

> 独享锁：该锁每一次只能被一个线程所持有。

> 共享锁：该锁可被多个线程共有

4. 互斥锁 / 读写锁

互斥锁

> 在访问共享资源之前对进行加锁操作，在访问完成之后进行解锁操作。加锁后，任何其他试图再次加锁的线程会被阻塞，直到当前进程解锁。
> 
> 如果解锁时有一个以上的线程阻塞，那么所有该锁上的线程都被变成就绪状态， 第一个变为就绪状态的线程又执行加锁操作，那么其他的线程又会进入等待。在这种方式下，只有一个线程能够访问被互斥锁保护的资源

读写锁

> 读写锁既是互斥锁，又是共享锁，read模式是共享，write是互斥(排它锁)的。
> 一次只有一个线程可以占有写模式的读写锁，但是多个线程可以同时占有读模式的读写锁。
> 
> 只有一个线程可以占有写状态的锁，但可以有多个线程同时占有读状态锁，这也是它可以实现高并发的原因。当其处于写状态锁下，任何想要尝试获得锁的线程都会被阻塞，直到写状态锁被释放；如果是处于读状态锁下，允许其它线程获得它的读状态锁，但是不允许获得它的写状态锁，直到所有线程的读状态锁被释放；为了避免想要尝试写操作的线程一直得不到写状态锁，当读写锁感知到有线程想要获得写状态锁时，便会阻塞其后所有想要获得读状态锁的线程。所以读写锁非常适合资源的读操作远多于写操作的情况。

5. 乐观锁 / 悲观锁

> 乐观锁：总是假设最好的情况，每次去拿数据的时候都认为别人不会修改，所以不会上锁，但是在更新的时候会判断一下在此期间别人有没有去更新这个数据，可以使用版本号机制和CAS算法实现。乐观锁适用于多读的应用类型，这样可以提高吞吐量，像数据库提供的类似于write_condition机制，其实都是提供的乐观锁。
> 
> 悲观锁：总是假设最坏的情况，每次去拿数据的时候都认为别人会修改，所以每次在拿数据的时候都会上锁，这样别人想拿这个数据就会阻塞直到它拿到锁（共享资源每次只给一个线程使用，其它线程阻塞，用完后再把资源转让给其它线程）。传统的关系型数据库里边就用到了很多这种锁机制，比如行锁，表锁等，读锁，写锁等，都是在做操作之前先上锁。


6. 分段锁

> 分段锁其实是一种锁的设计，并不是具体的一种锁，对于ConcurrentHashMap而言，其并发的实现就是通过分段锁的形式来实现高效的并发操作。
> 
> 并发容器类的加锁机制是基于粒度更小的分段锁，分段锁也是提升多并发程序性能的重要手段之一。
> 
> 在并发程序中，串行操作是会降低可伸缩性，并且上下文切换也会减低性能。在锁上发生竞争时将同时导致这两种问题，使用独占锁时保护受限资源的时候，基本上是采用串行方式—-每次只能有一个线程能访问它。所以对于可伸缩性来说最大的威胁就是独占锁。

7. 偏向锁 / 轻量级锁 / 重量级锁

> 锁的状态：无锁状态，偏向锁状态，轻量级锁状态，重量级锁状态
> 
> 偏向锁是指一段同步代码一直被一个线程所访问，那么该线程会自动获取锁。降低获取锁的代价。
> 轻量级锁是指当锁是偏向锁的时候，被另一个线程所访问，偏向锁就会升级为轻量级锁，其他线程会通过自旋的形式尝试获取锁，不会阻塞，提高性能。
> 重量级锁是指当锁为轻量级锁的时候，另一个线程虽然是自旋，但自旋不会一直持续下去，当自旋一定次数的时候，还没有获取到锁，就会进入阻塞，该锁膨胀为重量级锁。重量级锁会让其他申请的线程进入阻塞，性能降低。

8. 自旋锁

> 自旋锁（spinlock）：是指当一个线程在获取锁的时候，如果锁已经被其它线程获取，那么该线程将循环等待，然后不断的判断锁是否能够被成功获取，直到获取到锁才会退出循环。
> 
> 它是为实现保护共享资源而提出一种锁机制。其实，自旋锁与互斥锁比较类似，它们都是为了解决对某项资源的互斥使用。无论是互斥锁，还是自旋锁，在任何时刻，最多只能有一个保持者，也就说，在任何时刻最多只能有一个执行单元获得锁。但是两者在调度机制上略有不同。对于互斥锁，如果资源已经被占用，资源申请者只能进入睡眠状态。但是自旋锁不会引起调用者睡眠，如果自旋锁已经被别的执行单元保持，调用者就一直循环在那里看是否该自旋锁的保持者已经释放了锁，”自旋”一词就是因此而得名。

## 多读单写 - 信号量实现(P,V实现读者写者问题)
```swift
semaphore sa
semaphore sc
int readCount = 0

getAValue() {
    sc.wait()
    if (readCount == 0) sa.wait()
    readCount +=1
    sc.signal()
    // read option
    sc.wait()
    readCount -= 1
    if (readCount == 0) sa.signal()
    sc.signal()
}

setAValue(value) {
    sa.wait()
    // write option
    sa.signal()
}
```

```objc
getAValue() -> String {
    dispatch_sync(self.concurrentQueue, ^{
        t = self->_t
    })
    return t
}

setAValue(value) {
    dispatch_barrier_async(self.concurrentQueue, ^{
        self->_t = value
    })
}
```

# 进程、线程通讯方式

## 进程 IPC(Inter-Process Communication)

1. 管道
2. 消息队列
3. 共享内存
4. 信号(signal)
5. 信号量(semaphore)
6. 套接口(Socket)

## 线程

1. 锁
2. 信号量
3. 全局变量-共享内存
4. wait/notify阻塞/唤醒

## 死锁的4个必要条件
1. 互斥条件：一个资源每次只能被一个进程使用。
2. 占有且等待：一个进程因请求资源而阻塞时，对已获得的资源保持不放。
3. 不可强行占有:进程已获得的资源，在末使用完之前，不能强行剥夺。
4. 循环等待条件:若干进程之间形成一种头尾相接的循环等待资源关系。

# osi七层模型、五层模型

1. 物理层，数据链路层，网络层，传输层，会话层，表示层，应用层
2. 物理层，数据链路层，网络层，传输层，应用层
3. 网络接口层，网际层，传输层，应用层

# 三次握手，四次挥手

## 三次握手

1. 客户端发送连接请求，syn = 1，seq = x，进入syn_send状态（请求信息包含端口号，初始序列号x）
2. 服务器回确认包，syn = 1，seq = y， ack = 1， acknum = x + 1，进入syc_rcvd状态
3. 客户端发送确认包，syn = 0，ack = 1，acknum = y + 1，进入establish状态，服务器收到后同样进入

## 四次挥手（客户端为例）

1. 客户端发出可以结束信息，fin = 1，seq = x，进入fin_wait_1状态（表示无数据可发，但仍然接收数据）
2. 服务器确认回包，ack = 1， acknum = x + 1，进入close_wait状态（表示收到客户端关闭请求，但还没有准备好），客户端收到后进入fin_wait_2状态
3. 服务器发包，fin = 1，seq = y，进入last_ack状态（表示已经可以关闭，等客户端的最后一个ack）
4. 客户端回包，ack = 1，acknum = y + 1，进入time_wait状态（表示可以关闭，并等待可能出现的ack包）。。服务器收到确认包，关闭连接，进入close状态。。客户端等一定的时间（两个最大段生命周期，2MSL，2 Maximum Segment Lifttime），没有收到服务器ack回传，就认为成功关闭，自己进入close状态

# 银行家算法

# 内存分页分段

# 4k对齐

# CPU密集型和IO密集型
> CPU密集型也是指计算密集型，大部分时间用来做计算逻辑判断等CPU动作的程序称为CPU密集型任务。该类型的任务需要进行大量的计算，主要消耗CPU资源。这种计算密集型任务虽然也可以用多任务完成，但是任务越多，花在任务切换的时间就越多，CPU执行任务的效率就越低，所以，要最高效地利用CPU，计算密集型任务同时进行的数量应当等于CPU的核心数。
>
> IO密集型任务指任务需要执行大量的IO操作，涉及到网络、磁盘IO操作，对CPU消耗较少。

# 和线程池配置的关系
> CPU密集型任务应配置尽可能小的线程，如配置CPU数目+1个线程的线程池。由于IO密集型任务线程并不是一直在执行任务，则应配置尽可能多的线程，如2*CPU数目。

# 三序遍历

```swift
class Stack<Element> {
    var data = [Element?]()
    func pop() -> Element? {
        let ret = data.last ?? nil
        data = Array(data.dropLast())
        return ret
    }
    
    func push(_ e: Element?) {
        data.append(e)
    }
    
    func isEmpty() -> Bool { return data.filter{ $0 != nil }.count <= 0 }
}

class TreeNode {
    var left: TreeNode?
    var right: TreeNode?
    
    private var _value: Int = 0
    var value: Int {
        get {
            return _value
        }
        set {
            _value = newValue
        }
    }
    
    init(_ value: Int, left: TreeNode? = nil, right: TreeNode? = nil) {
        self.value = value
        self.left = left
        self.right = right
    }
}

func visit(_ node: TreeNode) {
    print(node.value)
}
```
```swift
//先序遍历
func preOrderRecursion(node: TreeNode?) {
    guard let node = node else {
        return
    }
    visit(node)
    preOrderRecursion(node: node.left)
    preOrderRecursion(node: node.right)
}

func preOrderTraversal(node: TreeNode?) {
    guard let node = node else {
        return
    }
    let stack = Stack<TreeNode>()
    stack.push(node)
    while !stack.isEmpty() {
        if let currentNode = stack.pop() {
            visit(currentNode)
            stack.push(currentNode.right)
            stack.push(currentNode.left)
        }
    }
}

```
```swift
//中序遍历
func inOrderRecursion(node: TreeNode?) {
    guard let node = node else {
        return
    }
    inOrderRecursion(node: node.left)
    visit(node)
    inOrderRecursion(node: node.right)
}

func inOrderTraversal(node: TreeNode?) {
    guard let node = node else {
        return
    }
    let stack = Stack<TreeNode>()
    var currentNode: TreeNode? = node
    
    while currentNode != nil || !stack.isEmpty() {
        while currentNode != nil {
            stack.push(currentNode)
            currentNode = currentNode?.left
        }
        currentNode = stack.pop()
        visit(currentNode!)
        currentNode = currentNode?.right
    }
}

```
```swift
//后序遍历
func postOrderRecursion(node: TreeNode?) {
    guard let node = node else {
        return
    }
    postOrderRecursion(node: node.left)
    postOrderRecursion(node: node.right)
    visit(node)
}

func postOrderTraversal(node: TreeNode?) {
    let stack = Stack<TreeNode>()
    var ret = [TreeNode]()
    stack.push(node)
    while !stack.isEmpty() {
        if let curNode = stack.pop() {
            ret.append(curNode)
            stack.push(curNode.left)
            stack.push(curNode.right)
        }
    }
    for node in ret.reversed() {
        print(node.value)
    }
}
```

# 事件传递，响应链

ios事件可以分为3种类型，分别是：触摸事件，加速计事件，远程控制事件。

当我们点击屏幕的时候，系统会将这个动作包装为UIEvent和UITouch的对象，找到当前运行的app，将这个点击操作传递，寻找能够处理的对象。

1. 我们点击屏幕产生触摸事件，系统将这个事件加入到一个由UIApplication管理的事件队列中，UIApplication会从消息队列里取事件分发下去，首先传给UIWindow
2. 在UIWindow中就会调用hitTest:withEvent:方法去返回一个最终响应的视图
3. 在hitTest:withEvent:方法中就会去调用pointInside: withEvent:去判断当前点击的point是否在UIWindow范围内，如果是的话，就会去遍历它的子视图来查找最终响应的子视图
4. 遍历的方式是使用倒序的方式来遍历子视图，也就是说最后添加的子视图会最先遍历，在每一个视图中都回去调用它的hitTest:withEvent:方法，可以理解为是一个递归调用
5. 最终会返回一个响应视图，如果返回视图有值，那么这个视图就作为最终响应视图，结束整个事件传递；如果没有值，那么就会将UIWindow作为响应者

1. 如果view的控制器存在，就传递给控制器处理；如果控制器不存在，则传递给它的父视图
2. 在视图层次结构的最顶层，如果也不能处理收到的事件，则将事件传递给UIWindow对象进行处理
3. 如果UIWindow对象也不处理，则将事件传递给UIApplication对象
4. 如果UIApplication也不能处理该事件，则将该事件丢弃

https://www.jianshu.com/p/2e074db792ba

# 内存管理

![](../Images/2021-04-21-14-38-44.png)



# 从编译到生成可执行文件都做了什么
# gcd block放哪里， 生成一个nsstring对象放哪里
# autoreleasepool
# layoutSubViews    drawRectxxxx

# NSNotification原理

- 收发不在相同线程会有问题吗

# [abc](https://github.com/ChenYilong/iOSInterviewQuestions)
# [abc](https://zhuanlan.zhihu.com/p/77892343)
# [abc](https://zhuanlan.zhihu.com/p/77789398)
# [abc](https://hit-alibaba.github.io/interview/iOS/ObjC-Basic/Runloop.html)

# kvo

# methond swizzling

# oc分类，扩展；分类是什么设计模式

# property修饰符 


# 寻找view的父VC
# runtime实现weak属性
# autoreleasePool 对象何时加入其中
# 引用计数是谁在计数
# 启动速度优化，包大小优化

# 算法
1. 单链表反转
2. 二叉树反转
3. 二叉树是否镜像对称