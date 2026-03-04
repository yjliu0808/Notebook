
从 JDK 9 开始，VisualVM 就被移出 JDK 了。
现在 JDK 自带的工具主要只有：
- `jcmd` 
- `jconsole`
- `jmap`
- `jstack`
- `jfr`（Java Flight Recorder）
        
VisualVM 需要单独下载：https://visualvm.github.io  下载后，它可以监控任意 JDK 版本运行的应用，包括 JDK 21。

|工具|主要功能|适用场景|
|---|---|---|
|`jcmd`|通用诊断入口，支持堆、线程、GC、JFR 操作|日常 JVM 运维和调试，替代部分 jmap/jstack|
|`jconsole`|GUI 监控，基于 JMX|实时查看内存、线程、MBeans（轻量监控）|
|`jmap`|堆信息 & 堆转储|内存泄漏分析，配合 MAT/VisualVM 使用|
|`jstack`|线程栈快照|排查死锁、线程阻塞、CPU 高占用|
|`jfr`|性能剖析（低开销事件采样）|生产环境性能瓶颈排查，配合 Mission Control 使用|

# 一、 `jcmd` 
- 相当于一个“瑞士军刀”，可以向 JVM 发送各种诊断命令（dump 堆、线程、GC、JFR 等）。
- JDK 9 之后很多功能都集中到 `jcmd`，它算是统一入口。
```
	  jcmd <pid> VM.flags          # 查看 JVM 启动参数
	  jcmd <pid> GC.heap_info      # 查看堆信息
	  jcmd <pid> Thread.print      # 打印线程栈（类似 jstack）
      jcmd <pid> GC.run            # 触发一次 GC
      jcmd <pid> JFR.start         # 启动 Java Flight Recorder
      jcmd <pid> VM.system_properties # 查看系统属性
```
写一个简单的 Java 程序保持运行，比如：
 ```java
 public class test {
	 public static void main(String[] args) throws Exception {  
	    while (true) {  
	        String s = new String("hello");  // 制造一些对象  
	        Thread.sleep(100);  
	    }  
	}
}
 ```
```
javac test.java
java test
```
编译运行后，它会一直占着一个 JVM 进程，方便你实验。
>列出当前运行的所有 Java 进程 `jcmd -l`   
>```
27108 jdk.jcmd/sun.tools.jcmd.JCmd -l
27092 test
>```

## 1、查看jvm 启动参数
```
jcmd 27092 VM.flags
```
得到输出结果如下：
```
27092:
-XX:CICompilerCount=4                  # JIT 编译线程数
-XX:ConcGCThreads=2                    # 并发 GC 线程数
-XX:G1ConcRefinementThreads=8          # G1 卡表精炼线程数
-XX:G1EagerReclaimRemSetThreshold=32
-XX:G1HeapRegionSize=4M                # G1 堆分区大小
-XX:G1RemSetArrayOfCardsEntries=32
-XX:G1RemSetHowlMaxNumBuckets=8
-XX:G1RemSetHowlNumBuckets=8
-XX:GCDrainStackTargetSize=64
-XX:InitialHeapSize=512M               # 初始堆大小
-XX:MarkStackSize=4M
-XX:MaxHeapSize=8G                     # 最大堆大小
-XX:MaxNewSize=4.8G
-XX:MinHeapDeltaBytes=4M
-XX:MinHeapSize=8M
-XX:NonNMethodCodeHeapSize=5.6M
-XX:NonProfiledCodeHeapSize=117M
-XX:ProfiledCodeHeapSize=117M
-XX:ReservedCodeCacheSize=240M         # 代码缓存大小
-XX:+SegmentedCodeCache
-XX:SoftMaxHeapSize=8G
-XX:+UseCompressedOops
-XX:+UseG1GC                           # 使用 G1 垃圾回收器
-XX:-UseNUMA
-XX:-UseNUMAInterleaving
```

## 2、查看堆信息
```
jcmd 27092 GC.heap_info
```

得到输出结果如下：
```
27092:

Garbage-First Heap
  Total      : 528384K   ≈ 516 MB
  Used       : 3513K     ≈ 3.4 MB
  Address    : [0x0000000600000000, 0x0000000800000000)
  Region Size: 4096K     = 4 MB
  Young      : 1 region (4096K ≈ 4 MB)
  Survivors  : 0 regions (0K)

Metaspace
  Used       : 90K       ≈ 0.09 MB
  Committed  : 320K      ≈ 0.31 MB
  Reserved   : 1114112K  ≈ 1088 MB ≈ 1.06 GB

Class Space
  Used       : 5K        ≈ 0.005 MB
  Committed  : 128K      ≈ 0.125 MB
  Reserved   : 1048576K  ≈ 1024 MB = 1 GB


```
## 3、打印线程栈
```
jcmd 27092 Thread.print
```
得到输出结果如下： [[jcmd打印线程栈]]

## 4、触发一次 GC
```
jcmd 27092 GC.run
```
得到输出结果如下：
```
27092:
Command executed successfully
```
执行后再查看堆信息
```
27092:

Garbage-First Heap
  Total      : 28672K   ≈ 28 MB
  Used       : 2102K    ≈ 2.1 MB
  Address    : [0x0000000600000000, 0x0000000800000000)
  Region Size: 4096K    = 4 MB
  Young      : 1 region (4096K ≈ 4 MB)
  Survivors  : 0 regions (0K)

Metaspace
  Used       : 90K      ≈ 0.09 MB
  Committed  : 320K     ≈ 0.31 MB
  Reserved   : 1114112K ≈ 1088 MB ≈ 1.06 GB

Class Space
  Used       : 5K       ≈ 0.005 MB
  Committed  : 128K     ≈ 0.125 MB
  Reserved   : 1048576K ≈ 1024 MB = 1 GB

```
总结：
- 执行前：堆空间大（516 MB），已用 3.4 MB。
- 执行后：堆空间缩小（28 MB），已用 2.1 MB。
- 原因：
    - GC 回收了 Eden 里的垃圾对象。
    - G1GC 自动把多余的堆内存归还给操作系统。

## 5、启动 JFR 录制
```
jcmd 27092 JFR.start name=TestRecording filename=recording.jfr duration=60s
```
- 说明：会启动 Java Flight Recorder，持续 60 秒，并保存到 `recording.jfr`
- 打开方式：用 JDK Mission Control 或 VisualVM 打开 `.jfr` 文件

## 6、查看系统属性
```
jcmd 27092 VM.system_properties

```
用途场景
- 快速确认 JVM 版本与厂商
- 排查编码/时区问题，工作目录等关键信息
- 检查操作系统相关信息
- 线上排查问题（无需修改代码或重启应用），直接在生产环境里查看

# 二、`jconsole`
```
jconsole
```
- 一个基于 Swing 的图形界面，可以通过 JMX 连接 JVM，监控内存、线程、类加载、GC 活动等。
- 类似轻量版 VisualVM。

# 三、`jmap`
- 打印内存相关信息，或把堆导出为 `.hprof` 文件供 VisualVM / Eclipse MAT 分析。

1、查看对象直方图
```
jmap -histo 2778 | head -20

jmap -histo:live 2778 | head -20
```
输出前 20 行，能看到哪些类的实例最多、占内存最大

输出结果如下：
```
 num     #instances         #bytes  class name (module)
-------------------------------------------------------
   1:         33503        2605048  [B (java.base@21.0.7)
   2:            98        2229688  [Ljdk.internal.vm.FillerElement; (java.base@21.0.7)
   3:         16383         824808  [Ljava.lang.Object; (java.base@21.0.7)
   4:          1981         656680  [C (java.base@21.0.7)
   5:         26966         647184  java.lang.String (java.base@21.0.7)
   6:          5805         383632  [I (java.base@21.0.7)
   7:          2886         350872  java.lang.Class (java.base@21.0.7)
   8:          1918         230160  java.io.ObjectStreamClass (java.base@21.0.7)
   9:          1784         156992  java.lang.reflect.Method (java.base@21.0.7)
  10:          4683         149856  java.util.HashMap$Node (java.base@21.0.7)
  11:          4612         147584  java.util.concurrent.ConcurrentHashMap$Node (java.base@21.0.7)
  12:          2392         114816  java.util.HashMap (java.base@21.0.7)
  13:          1388         112944  [Ljava.util.HashMap$Node; (java.base@21.0.7)
  14:          1395         111600  jdk.internal.event.DeserializationEvent (java.base@21.0.7)
  15:          3426         104992  [Ljava.lang.String; (java.base@21.0.7)
  16:           428          96208  [J (java.base@21.0.7)
  17:          3827          91848  java.lang.Long (java.base@21.0.7)
  18:          3270          78480  java.lang.StringBuilder (java.base@21.0.7)
```

- num：排名（从大到小，按内存字节数排序）
- `#instances`：该类当前在堆上的对象个数
- `#bytes`：这些对象总共占用的堆内存大小（单位：字节）
- class name：类的名字
    - `[B` → byte 数组
    - `[C` → char 数组
    - `[I` → int 数组
    - `[Ljava.lang.Object;` → Object 数组
    - 普通类名如 `java.lang.String`


2、导出堆转储文件
```
jmap -dump:live,format=b,file=/Users/grey/Downloads/heap_live.hprof 2778
```
用 VisualVM 打开 `.hprof`


3、查看 Finalizer 队列
```
jmap -finalizerinfo 2778
```
如果这里有大量对象，说明应用里有对象依赖 `finalize()` 回收，但迟迟没有执行，可能造成内存压力


4、查看类加载器情况
```
jmap -clstats 2778 | head -20
```
- 能看到每个 ClassLoader 加载了多少类。
- 场景：排查 类加载器泄漏（常见于应用服务器、热部署场景）。



# 四、`jstack`
- 打印 JVM 线程栈，用于排查 死锁、阻塞、CPU 占用高 等问题。
- 类似于 Linux `kill -3 <pid>` 的线程转储，但更灵活。

1、打印正常线程堆栈
```
jstack 2778 | head -30
```



# 五、 `jfr`
- JDK 自带的 低开销性能剖析器。
- 可以记录 JVM 内部事件（方法调用、GC、JIT、锁竞争、I/O 等），然后在 JDK Mission Control 或 VisualVM 里分析。
- 类似商业 APM 工具，但更轻量。



# 六、VisualVM
## 作用
- 自带 CPU/内存采样、线程监控、堆 dump 分析等常用功能。
- 打开进程时你能看到基本的内存曲线、线程数变化。

## 安装
mac笔记本上面，jdk是通过 Homebrew 安装的，路径在
```
/opt/homebrew/opt/openjdk
```
但是 `/usr/libexec/java_home` 没能识别到它，所以 VisualVM 找不到 JDK
运行下面命令（Apple Silicon Mac）让 macOS 识别：
```
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
```
这样就可以双击启动 VisualVM 了 ,或者通过下面命令启动： 
```
/Applications/VisualVM.app/Contents/MacOS/visualvm

```

# 七、Visual GC 插件

## 作用
- 提供更细致的 垃圾回收可视化界面，包括：
    - Eden/Survivor/Old 区的实时使用率
    - GC 次数、停顿时间
    - 各代对象晋升情况
- 是学习 JVM 内存分区、观察 GC 行为的“最佳入门工具”。

## 安装
- 打开 VisualVM → 菜单 工具 (Tools) → 插件 (Plugins)。
- 在 可用插件 (Available Plugins) 里找到 Visual GC，勾选安装。
- 重启 VisualVM。
- 之后在监控的进程上右键 → Open Visual GC。


## 界面说明

![[2025-09-14-20.36.11.png]]

整个区域分为三部分：spaces、graphs、histogram

1、spaces区域：代表虚拟机内存分布情况。从图中可以看出，虚拟机堆内存分为 Eden、S0、S1、Old Gen，另外类元数据存放在堆外的 Metaspace。

- Metaspace：类元数据就是 JVM 用来描述类本身结构和信息的“蓝图”，包括方法、字段、继承关系等，用于指导对象的创建和运行
- java heap ：Java 堆由新生代（Eden+S0+S1）和老年代组成，其中 新生代内部默认比例是 Eden:S0:S1 = 8:1:1
	- `new` 出来的对象和数组默认放在堆里
	- 垃圾回收 (GC) 的主要场所

2、Graphs区域：内存使用详细介绍
- Compile Time(编译时间)：2760compiles 表示编译总数，2.226s表示编译累计时间。一个脉冲表示一次JIT编译，窄脉冲表示持续时间短，宽脉冲表示持续时间长。
- Class Loader Time(类加载时间): 1527 loaded表示加载类数量, 0 unloaded表示卸载的类数量，196.367s表示类加载花费的时间
- GC Time(GC Time)：1 collections表示垃圾收集的总次数，2.293ms表示垃圾收集花费的时间，last cause表示最近垃圾收集的原因
- Eden Space(Eden 区)：括号内的8G表示最大容量，44M表示当前容量，后面的16M表示当前使用情况，1collections表示垃圾收集次数，2.293s表示垃圾收集花费时间
- Survivor 0/Survivor 1(S0和S1区)：括号内的8G表示最大容量，4M表示前容量，之后的值是当前使用情况
- Old Gen(老年代)：括号内的8G表示最大容量，468M表示当前容量，之后的1.031表示当前使用情况， 0 collections表示垃圾收集次数 ，0 s表示垃圾收集花费时间
- Metaspace:括号内的 1.062G 表示最大容量（受系统本地内存限制），7.250M 表示当前容量，之后的值表示当前使用量。Metaspace 用于存放 **类的元数据**（例如类的结构信息、方法、字段、常量池等），在 JDK8 之后替代了 PermGen。它不在 Java 堆里，而是使用本地内存（native memory）


3、Histogram区域：survivor区域参数跟年龄柱状图
- JVM 默认最多显示 15 个年龄段（`-XX:MaxTenuringThreshold=15`）：
    - 第 1 根柱子：Age=1，对象经历 1 次 GC 存活
    - 第 2 根柱子：Age=2，对象经历 2 次 GC 存活
    - …
    - 第 15 根柱子：Age≥15，对象会晋升到老年代
- **柱子高低变化** 体现 Survivor 区对象的存活规律：
    - 矮柱子 → 大部分对象很快被回收（朝生暮死）
    - 柱子往右延伸 → 有些对象持续存活，逐渐老化
    - 高柱子集中在高龄段 → 说明大量对象即将晋升到老年代