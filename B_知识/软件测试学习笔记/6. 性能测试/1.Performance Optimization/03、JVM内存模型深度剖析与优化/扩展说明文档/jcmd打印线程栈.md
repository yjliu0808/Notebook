```
27092:
2025-09-10 21:00:03
Full thread dump OpenJDK 64-Bit Server VM (21.0.7 mixed mode, sharing):

线程列表 (SMR Info)
- JVM 当前有 11 个 Java 线程
- 每个元素是线程的地址（JVM 内部结构体指针）  
Threads class SMR info:
_java_thread_list=0x000060000269e9e0, length=11, elements={
0x000000013e80d800, 0x000000013e80e000, 0x000000013e81d000, 0x000000013e81d800,
0x000000012e038400, 0x000000012e036600, 0x000000012e036e00, 0x000000012e03ca00,
0x000000013e848400, 0x000000013f01c200, 0x000000013f01a000
}

主要 Java 线程
(1) 应用主线程
- 这是程序的入口线程，名字是 `"main"`
- 状态：TIMED_WAITING，即在 sleep
- 栈帧显示调用了 `Thread.sleep()`，来源于 `test.java:7`，说明业务逻辑就是在 main 方法里让线程睡眠    
"main" #1 [8963] prio=5 os_prio=31 cpu=405.75ms elapsed=627.99s tid=0x000000013e80d800 nid=8963 waiting on condition  [0x000000016d22e000]
   java.lang.Thread.State: TIMED_WAITING (sleeping)
	at java.lang.Thread.sleep0(java.base@21.0.7/Native Method)
	at java.lang.Thread.sleep(java.base@21.0.7/Thread.java:509)
	at test.main(test.java:7)

(2) Reference Handler
- JVM 的后台守护线程，负责处理 `Reference`（如 `WeakReference`, `SoftReference`）队列
- 一直存在，用于垃圾回收后清理对象  
"Reference Handler" #9 [28931] daemon prio=10 os_prio=31 cpu=0.09ms elapsed=627.97s tid=0x000000013e80e000 nid=28931 waiting on condition  [0x000000016e3a6000]
   java.lang.Thread.State: RUNNABLE
	at java.lang.ref.Reference.waitForReferencePendingList(java.base@21.0.7/Native Method)
	at java.lang.ref.Reference.processPendingReferences(java.base@21.0.7/Reference.java:246)
	at java.lang.ref.Reference$ReferenceHandler.run(java.base@21.0.7/Reference.java:208)

(3) Finalizer
- 负责调用对象的 `finalize()` 方法
- 当前处于等待队列中（等待 GC 推送需要 finalization 的对象）  
"Finalizer" #10 [28675] daemon prio=8 os_prio=31 cpu=0.07ms elapsed=627.97s tid=0x000000013e81d000 nid=28675 in Object.wait()  [0x000000016e5b2000]
   java.lang.Thread.State: WAITING (on object monitor)
	at java.lang.Object.wait0(java.base@21.0.7/Native Method)
	- waiting on <0x000000061fc025a0> (a java.lang.ref.NativeReferenceQueue$Lock)
	at java.lang.Object.wait(java.base@21.0.7/Object.java:366)
	at java.lang.Object.wait(java.base@21.0.7/Object.java:339)
	at java.lang.ref.NativeReferenceQueue.await(java.base@21.0.7/NativeReferenceQueue.java:48)
	at java.lang.ref.ReferenceQueue.remove0(java.base@21.0.7/ReferenceQueue.java:158)
	at java.lang.ref.NativeReferenceQueue.remove(java.base@21.0.7/NativeReferenceQueue.java:89)
	- locked <0x000000061fc025a0> (a java.lang.ref.NativeReferenceQueue$Lock)
	at java.lang.ref.Finalizer$FinalizerThread.run(java.base@21.0.7/Finalizer.java:173)


(4) Signal Dispatcher
- JVM 内部线程，处理操作系统信号（如 kill、attach、jcmd 等）
"Signal Dispatcher" #11 [28163] daemon prio=9 os_prio=31 cpu=0.15ms elapsed=627.97s tid=0x000000013e81d800 nid=28163 waiting on condition  [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

(5) Service Thread
- JVM 内部的服务线程，用于周期性任务，例如清理弱引用、监控 JFR、GC 统计等
"Service Thread" #12 [24323] daemon prio=9 os_prio=31 cpu=0.03ms elapsed=627.97s tid=0x000000012e038400 nid=24323 runnable  [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

(6) Monitor Deflation Thread
- 定期清理（deflate）未使用的监视器锁对象，减少内存消耗
"Monitor Deflation Thread" #13 [24579] daemon prio=9 os_prio=31 cpu=73.04ms elapsed=627.97s tid=0x000000012e036600 nid=24579 runnable  [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

(7) JIT 编译线程
- C1/C2 编译器线程：C1 是 client compiler，C2 是 server compiler
- 负责把热点方法编译为机器码
- 当前显示 `No compile task`，说明此刻没有正在编译的任务    
"C2 CompilerThread0" #14 [27651] daemon prio=9 os_prio=31 cpu=10.51ms elapsed=627.97s tid=0x000000012e036e00 nid=27651 waiting on condition  [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE
   No compile task

"C1 CompilerThread0" #17 [27395] daemon prio=9 os_prio=31 cpu=7.23ms elapsed=627.97s tid=0x000000012e03ca00 nid=27395 waiting on condition  [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE
   No compile task

(8) Notification Thread
- JVM 内部事件通知线程（JFR、JMX 相关）  
"Notification Thread" #18 [27139] daemon prio=9 os_prio=31 cpu=0.03ms elapsed=627.96s tid=0x000000013e848400 nid=27139 runnable  [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

(9) Common-Cleaner
- 负责 `Cleaner` 任务的执行（类似于 Finalizer，但更现代）
- 当前在等待队列里  
"Common-Cleaner" #19 [26883] daemon prio=8 os_prio=31 cpu=1.52ms elapsed=627.96s tid=0x000000013f01c200 nid=26883 waiting on condition  [0x000000016f406000]
   java.lang.Thread.State: TIMED_WAITING (parking)
	at jdk.internal.misc.Unsafe.park(java.base@21.0.7/Native Method)
	- parking to wait for  <0x000000061fc125d0> (a java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject)
	at java.util.concurrent.locks.LockSupport.parkNanos(java.base@21.0.7/LockSupport.java:269)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.await(java.base@21.0.7/AbstractQueuedSynchronizer.java:1852)
	at java.lang.ref.ReferenceQueue.await(java.base@21.0.7/ReferenceQueue.java:71)
	at java.lang.ref.ReferenceQueue.remove0(java.base@21.0.7/ReferenceQueue.java:143)
	at java.lang.ref.ReferenceQueue.remove(java.base@21.0.7/ReferenceQueue.java:218)
	at jdk.internal.ref.CleanerImpl.run(java.base@21.0.7/CleanerImpl.java:140)
	at java.lang.Thread.runWith(java.base@21.0.7/Thread.java:1596)
	at java.lang.Thread.run(java.base@21.0.7/Thread.java:1583)
	at jdk.internal.misc.InnocuousThread.run(java.base@21.0.7/InnocuousThread.java:186)


(10) Attach Listener
- 用于响应外部工具的 `attach` 请求，例如 `jcmd`, `jconsole`, `jvisualvm`
"Attach Listener" #20 [29959] daemon prio=9 os_prio=31 cpu=0.92ms elapsed=497.78s tid=0x000000013f01a000 nid=29959 waiting on condition  [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

除了 Java 线程，还有一些 JVM 内部线程
- `VM Thread`：执行 GC、safepoint 等 VM 操作的核心线程
- `VM Periodic Task Thread`：周期性任务线程，比如统计信息收集
- `G1 Service`、`G1 Refine#0`、`G1 Conc#0`、`G1 Main Marker`、`GC Thread#0`：这些是 G1 GC 的工作线程，分别负责不同的 GC 阶段（服务线程、refinement、并发标记、主标记、垃圾回收）
  
"VM Thread" os_prio=31 cpu=18.69ms elapsed=627.98s tid=0x000000013d606d50 nid=19203 runnable

"VM Periodic Task Thread" os_prio=31 cpu=447.98ms elapsed=627.98s tid=0x000000013e005760 nid=20483 waiting on condition

"G1 Service" os_prio=31 cpu=20.94ms elapsed=627.98s tid=0x000000011e5065a0 nid=21507 runnable

"G1 Refine#0" os_prio=31 cpu=0.03ms elapsed=627.98s tid=0x000000013f858200 nid=16387 runnable

"G1 Conc#0" os_prio=31 cpu=0.03ms elapsed=627.98s tid=0x000000011e504080 nid=13059 runnable

"G1 Main Marker" os_prio=31 cpu=0.03ms elapsed=627.98s tid=0x000000013d706230 nid=14083 runnable

"GC Thread#0" os_prio=31 cpu=0.04ms elapsed=627.98s tid=0x000000013d705a90 nid=12291 runnable

JNI 全局引用
JNI global refs: 6, weak refs: 0
```

总结
1. 应用线程只有一个 `"main"`，目前在 `Thread.sleep()` 中休眠。
2. 后台守护线程（Reference Handler、Finalizer、Cleaner）都在正常运行，负责 GC 后处理。
3. JIT 编译线程、Service/Notification 线程空闲，等待任务。
4. GC 线程（G1GC）常驻运行，处于 `RUNNABLE` 状态，等待或执行垃圾回收工作。
5. VM 内部线程负责调度、信号、周期性维护。

换句话说，这份线程 dump 显示 JVM 正常、空闲，只有 main 在 sleep，其他都是 JVM 自带的 housekeeping 线程。