# JDK体系结构
```
JDK (Java Development Kit)
│
├── 开发工具 (Tools & Tool APIs)
│   ├── java, javac, javadoc, jar, javap, JPDA
│   ├── JConsole, VisualVM, JMC, JFR
│   ├── Java DB, JVM TI, Intl, Deploy, Security, Web Services, RMI
│
└── JRE (Java Runtime Environment)
    │
    ├── Deployment (部署)
    │   ├── Java Web Start
    │   └── Applet / Java Plug-in
    │
    ├── User Interface Toolkits (界面工具包)
    │   ├── AWT, Swing, JavaFX, Java 2D
    │   ├── Accessibility, Drag & Drop, Input Methods
    │   ├── Image I/O, Print Service, Sound
    │
    ├── Integration Libraries (集成库)
    │   ├── JDBC, JNDI, RMI, RMI-IIOP
    │   ├── IDL, Scripting
    │
    ├── Other Base Libraries (其他基础库)
    │   ├── Beans, Intl Support, Input/Output, JMX
    │   ├── JNI, Math, Networking
    │   ├── Security, Serialization, Extension Mechanism
    │   ├── XML JAXP, Override Mechanism
    │
    ├── lang & util Base Libraries (语言与工具库)
    │   ├── java.lang, java.util, Collections
    │   ├── Concurrency Utilities, Logging, Reflection
    │   ├── Regular Expressions, Management, Preferences API
    │   ├── Versioning, Zip, Instrumentation, Ref Objects, JAR
    │
    └── JVM (Java Virtual Machine) 
        └── Java HotSpot VM (运行字节码, JIT, GC)

```

- **JDK** 包含 **JRE**（运行环境 + 类库 + JVM）
- **JRE** 包含 **JVM**（执行引擎）
- **JVM** 是最底层核心

# JVM整体结构及内存模型


![[2025-09-17-21.57.18.png]]

- 左边的 **main线程** 和下面的 **线程2** 都各自拥有 程序计数器，虚拟机栈 ，本地方法栈 (Native Method Stack) ，即每个线程运行时有自己的一份执行上下文
- 多个线程共享同一个 JVM 堆和方法区
	- 比如 main 线程创建的 `math`、`user` 对象都放在堆里，线程2 也能访问到这些对象
	- 方法区里存放的 `Math.class` 类信息，是所有线程共享的

![[2025-09-17-22.38.03.png]]




# JVM内存参数设置
![[2025-09-18-21.50.34.png]]


Spring Boot程序的JVM参数设置格式(Tomcat启动直接加在bin目录下catalina.sh文件里)：

java -Xms2048M -Xmx2048M -Xmn1024M -Xss512K -XX:MetaspaceSize=256M -XX:MaxMetaspaceSize=256M -jar microservice-eureka-server.jar

-Xss：每个线程的栈大小

-Xms：设置堆的初始可用大小，默认物理内存的1/64

-Xmx：设置堆的最大可用大小，默认物理内存的1/4

-Xmn：新生代大小

-XX:NewRatio：默认2表示老年代 : 新生代 = 2:1，也就是新生代占 整个堆的 1/3。

-XX:SurvivorRatio：默认8表示 Eden : Survivor = 8:1:1，即一个 Survivor 占用 Eden 的 **1/8**，等价于占新生代的 1/10。

关于元空间的JVM参数有两个：-XX:MetaspaceSize=N和 -XX:MaxMetaspaceSize=N

-XX：MaxMetaspaceSize： 设置元空间最大值， 默认是-1， 即不限制， 或者说只受限于本地内存大小。

-XX：MetaspaceSize： 指定元空间触发Fullgc的初始阈值(元空间无固定初始大小)， 以字节为单位，默认是21M左右，达到该值就会触发full gc进行类型卸载， 同时收集器会对该值进行调整： 如果释放了大量的空间， 就适当降低该值； 如果释放了很少的空间， 那么在不超过-XX：MaxMetaspaceSize（如果设置了的话） 的情况下， 适当提高该值。

由于调整元空间的大小需要Full GC，这是非常昂贵的操作，如果应用在启动的时候发生大量Full GC，通常都是由于永久代或元空间发生了大小调整，基于这种情况，一般建议在JVM参数中将MetaspaceSize和MaxMetaspaceSize设置成一样的值，并设置得比初始值要大，对于8G物理内存的机器来说，一般我会将这两个值都设置为256M。

StackOverflowError示例：

```java
// JVM设置 -Xss128k(默认1M)
public class StackOverflowTest {
    
    static int count = 0;
    
    static void redo() {
        count++;
        redo();
    }

    public static void main(String[] args) {
        try {
            redo();
        } catch (Throwable t) {
            t.printStackTrace();
            System.out.println(count);
        }
    }
}

```

运行结果:
```
java.lang.StackOverflowError
	at com.tuling.jvm.StackOverflowTest.redo(StackOverflowTest.java:12)
	at com.tuling.jvm.StackOverflowTest.redo(StackOverflowTest.java:13)
	at com.tuling.jvm.StackOverflowTest.redo(StackOverflowTest.java:13)
   ......
```



结论：

-Xss设置越小count值越小，说明一个线程栈里能分配的栈帧就越少，但是对JVM整体来说能开启的线程数会更多

JVM内存参数大小该如何设置？

JVM参数大小设置并没有固定标准，需要根据实际项目情况分析，给大家举个例子

# 日均百万级订单交易系统如何设置JVM参数
![[2025-09-18-21.57.01.png]]

```
java -Xms3072M -Xmx3072M -Xss1M -XX:MetaspaceSize=512M -XX:MaxMetaspaceSize=512M -jar microservice-eureka-server.jar
```

![[2025-09-18-21.59.08.png]]


阿里面试题：能否对JVM调优，让其几乎不发生Full GC

```
java -Xms3072M -Xmx3072M -Xmn2048M -Xss1M -XX:MetaspaceSize=256M -XX:MaxMetaspaceSize=256M -jar microservice-eureka-server.jar
```
结论：通过上面这些内容介绍，大家应该对JVM优化有些概念了，就是尽可能让对象都在新生代里分配和回收，尽量别让太多对象频繁进入老年代，避免频繁对老年代进行垃圾回收，同时给系统充足的内存大小，避免新生代频繁的进行垃圾回收。

参考文章：
《[JVM 基础 - JVM 内存结构](https://pdai.tech/md/java/jvm/java-jvm-struct.html)》