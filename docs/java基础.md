### Java基础

#### 1.基础知识

1.1java编译运行过程:

- 编译器(.java源文件,经过编译,生成.class字节码文件)
- 运行期：JVM加载.class文件并运行.class文件

1.2JVM、JRE、JDK的关系：

- JVM：是java虚拟机
- JRE：java运行环境，除了包含jvm以外还包含java程序所必须的环境
  （JRE=JVM+java开发工具包）
- JDK:java开发工具包，JDK=JRE+编译、运行等命令工具

- 运行java程序的最小的环境为JRE
- 开发java程序的最小的环境为JDK

1.3变量命名规则：

- 只能包含字母、数字、_和$符，并且不能以数字开头
- 严格区分大小写
- 不能使用关键字
- 驼峰命名法

1.4变量初始化及使用

- 当变量作为作为类成员使用时，Java才确保给定其初始值，防止程序运行时错误
  （成员变量在使用之前如果没有初始化，jvm就会帮我们初始化，）
- 方法中基本类型的所有变量在使用之前要保证是经过初始化的

```java
/*int b;
		b=3.14;//编译错误，不能赋值与不匹配的类型
		System.out.print(b);*/		
 /*int c;
		System.out.print(c);//编译错误，使用前必须赋值*/
```

#### 2.基本数据类型

(数据存储是以“字节”（Byte）为单位，数据传输大多是以“位”（bit，又名“比特”）为单位，一个位就代表一个0或1（即二进制），每8个位（bit，简写为b）组成一个字节（Byte，简写为B），是最小一级的信息单位 )

字节是二进制数据的单位。一个字节通常8位长

| 序号 | 数据类型 | 位数          | 字节 | 默认值 |
| ---- | -------- | ------------- | ---- | ------ |
| 1    | byte     | 8(1个字节8位) | 1    | 0      |
| 2    | boolean  | 8             | 1    | false  |
| 3    | char     | 16            | 2    | 空     |
| 4    | short    | 16            | 2    | 0      |
| 5    | int      | 32            | 4    | 0      |
| 6    | float    | 32            | 4    | 0.0    |
| 7    | long     | 64            | 8    | 0      |
| 8    | double   | 64            | 8    | 0.0    |

- 整数直接量默认为int型，但不能超范围，超范围则编译错误
- 两个整数相除，结果还是整数，小数位无条件舍弃
- 整数运算时超出范围会发生溢出，溢出是需要避免的
- 浮点数运算时，有可能会出现舍入误差，所以精确场合不建议使用
- 采用Unicode编码，每个字符都对应一个码
- 表现的形式是char字符，但实质上是int码
- 数据类型间的转换:
  1. 自动类型转换:从小类型转到大类型
  2. 强转类型转换:从大类型转到小类型  ，(要转换成的数据类型)变量，强转有可能会溢出或丢失精度
- 整数直接可以直接赋值给byte,short,char，但不能超范围
- byte、short、char型数据参与运算时，先一律转换为int再运算
- boolean只有2个值：true、false,可以用1bit来存储，但具体大小没有明确规定。JVM会在编译时期将boolean类型的数据转化为int,使用1来表示true,0来表示false。JVM支持boolean数组，但是是通过读写byte数组来实现的。

#### 3.运算符

- 算术运算符:+-*/%,++,--*
- 关系运算符:>,<,>=,<=,==,!=
- 逻辑运算符:&&,||,!(双与，提高效率 &&  & )
- 赋值运算符:=,+=,-=,*=,/=,%=
- 字符串连接运算符:+
- 三目/条件运算符:boolean?数1:数2
- 参与运算：(++a),(a++)： ++在前面先自增再运算，++在后面先运算再自增
- a前面有加号的加了再运算，前面没有加号的先运算再加

#### 4.数组

- 创建一位数组

```java
        int[] arr1 = {100,200,300,400,500};
        int[] arr2 = new int[5];
        arr2[0] = 100;
        arr2[1] = 200;
        arr2[2] = 300;
        arr2[3] = 400;
        arr2[4] = 500;
```

- 创建二位数组

```java
        String[][] str1 = {{"java","html"},{"css","javascript"}};
        String[][] str2 = new String[2][2];
        str2[0][0] = "java";
        str2[0][1] = "html";
        str2[1][0] = "css";
        str2[1][1] = "javascript";
```
#### 5.包装类型

基本类型都有对应的包装类型，基本类型与其对应的包装类型之间的赋值使用自动装箱与拆箱完成。

```
Integer x=2;//装箱 调用了Integer.valueOf(2)
int y=x; //拆箱 调用了 x.intValue()
```

#### 6.缓存池

new Integer(123) 与 Interger.valueOf(123)区别在于：

- new Integer(123)每次都会新建一个对象；

- Integer.valueOf(123) 会使用缓存池中的对象，多次调用会取同一个对象引用。

  ```java
  Integer x = new Integer(123);
  Integer y = new Integer(123);
  System.out.println(x==y);//false
  Integer z = Integer.valueOf(123);
  Integer k = Integer.valueOf(123);//true
  ```

  valueOf()方法的实现比较简单，就是先判断是否在缓存池中，如果在的话就直接返回缓存池的内容。

  ```java
  public static Integer valueOf(int i){
  	if (i>=IntegerCache.low && i <=IntergerCache.high)
  		return IntegerCache.cache[i+(-IntegerCache.low)];
  	return new Integer(i);
  }
  ```

   在 Java 8 中，Integer 缓存池的大小默认为 -128~127。 

  ```java
  static final int low = -128;
  static final int high;
  static final Integer cache[];
  
  static {
      // high value may be configured by property
      int h = 127;
      String integerCacheHighPropValue =
          sun.misc.VM.getSavedProperty("java.lang.Integer.IntegerCache.high");
      if (integerCacheHighPropValue != null) {
          try {
              int i = parseInt(integerCacheHighPropValue);
              i = Math.max(i, 127);
              // Maximum array size is Integer.MAX_VALUE
              h = Math.min(i, Integer.MAX_VALUE - (-low) -1);
          } catch( NumberFormatException nfe) {
              // If the property cannot be parsed into an int, ignore it.
          }
      }
      high = h;
  
      cache = new Integer[(high - low) + 1];
      int j = low;
      for(int k = 0; k < cache.length; k++)
          cache[k] = new Integer(j++);
      // range [-128, 127] must be interned (JLS7 5.1.7)
      assert IntegerCache.high >= 127;
  }
  ```
  

编译器会在自动装箱过程中调用valueOf()方法，因此多个值相同且值在缓存池范围内的Integer实例使用自动装箱来创建，那么就会引用相同的对象。

```java
  Integer m=123;
  Integer n=123;
  System.out.println(m==n);//true
```

基本类型对应的缓冲池如下：

- boolean values true and false

- all byte values

- short values between -128 and 127

- int values between -128 and 127

- char in the range \u0000 to \u007F

在使用这些基本类型对应的包装类型时，如果该数值范围在缓冲池范围内，就可以直接使用缓冲池中的对象。

在 jdk 1.8 所有的数值类缓冲池中，Integer 的缓冲池 IntegerCache 很特殊，这个缓冲池的下界是 - 128，上界默认是 127，但是这个上界是可调的，在启动 jvm 的时候，通过 -XX:AutoBoxCacheMax=<size> 来指定这个缓冲池的大小，该选项在 JVM 初始化的时候会设定一个名为 java.lang.IntegerCache.high 系统属性，然后 IntegerCache 初始化的时候就会读取该系统属性来决定上界。

#### 7.引用数据类型String

string 被申明为final,因此它不可继承.(Integer等包装类也不能被继承)

value 数组被声明为 final，这意味着 value 数组初始化之后就不能再引用其它数组。并且 String 内部没有改变 value 数组的方法，因此可以保证 String 不可变。 

#### 8.for循环

- 1.格式：for(初始化语句1;条件判断语句2;循环体执行之后的语句4){循环体3}
  2.执行流程1 —>2—>3—>4 —>2—>3—>4—>2false(结束)

- 增强for循环:for(数据类型 变量名：数组或者集合名){}

- 求和思想

  ```java
  int sum=0;
  for(int i=1;i<=100;i++){
  sum+=i
  }
  System.out.println(sum);
  ```

- while格式:
  初始化语句1
  while(条件判断语句2){循环体3;循环体之后的语句4;}
  执行顺序：和for是一样；1—>2—>3—>4—>2—>3—>4—>2false(结束)

- do while格式：
  初始化语句1
  do{循环体3;循环体之后的语句4;}while(条件判断语句2);
  特点：do whlie至少会执行一次循环体

- 循环控制语句
  continue //跳出本次循环，继续下次循环
  break //跳出全部循环

- 嵌套循环

  ```java
  for(int i=1;i<=4;i++){
       for(int j=1;j<=5;j++){
            System.out.print("*");
       } 
    System.out.println();
  }
  ```

- 条件控制语句
  格式1：if(){}
  格式2：if()else{}
  格式3：if()else if(){}else if(){}else{}
  格式4：if()if()if()else{}//和格式3区别：主要满足条件就进if，不存在互斥

- switch格式：
  switch(值)值的类型:byte、short、int、char、String、枚举
  switch什么时候结束，遇到break和}
  break穿透：没有遇到break,不会再次进行case匹配

  ```java
  switch(值){
      case 值1:
          语句;
          break;
      case 值1:
          语句;
          break;
      default:
          语句;
     		break; 
      }
  ```

- 遍历数组

  ```java
  int[] arr = {1,2,3,4,5};
  for(int i=0;i<arr.length;i++){
  System.out.println(arr[i]);
  }
  ```

  ```java
  int[] arr = {1,2,3,4,5};
  for(int i:arr){
      System.out.println(i);
  }
  ```

- 冒泡排序

  方法1：

  ```java
   for (int i = 0; i < arr.length - 1; i++) {//控制每次重新开始比较次数
              for (int j = 0; j < arr.length - 1; j++) {//循环次数数组长度-1，5个数比较4次
                  if (arr[j] > arr[j + 1]) {//若j<arr.length会导致下标越界
                      int t = arr[j];
                      arr[j] = arr[j + 1];
                      arr[j + 1] = t;
  
                  }
              }
          }
  ```

  方法2：

  ```java
   int temp = 0;
          for (int i = 0; i < arr.length; i++) {
              for (int j = i + 1; j < arr.length; j++) {
                  if (arr[i] > arr[j]) {
                      temp = arr[i];
                      arr[i] = arr[j];
                      arr[j] = temp;
                  }
              }
          }
  ```

- 打印等边三角形

  ```java
    for (int i = 1; i <= 5; i++) {//控制行数
              for (int m = 5; m > i; m--) {//控制打印空格的列循环
                  System.out.print(" ");
              }
              for (int j = 0; j < i; j++) {//控制列
                  System.out.print(" *");
              }
              System.out.println();
          }
  ```

#### 9.方法

- 类是对象的模板，对象是类的实例


- 1.方法的签名包含2个方面：方法名和参数列表; 一个类中不能有2个方法的签名完全相同。
- 2.方法的重载(Overload):发生在同一个类中，方法名称相同，参数列表不同。
      编译器在编译的时候会根据签名自动绑定调用不同的方法
- 3.构造方法：1)常常用于给成员变量赋初始值
                        2)与类名同名，没有返回值类型 
                        3)在创建(new)对象时被自动调用
                        4)默认提供一个无参空构造方法，若写了构造方法，则不再默认提供 
                        5)构造方法可以重载（相同的类名，方法参数不同）
- 4.this:指当前对象，一个构造方法可以通过this关键字调用另外一个重载的构造方法，在构造方法中，用初始化成员变量的参数和成员变量的取名相同的名字（成员变量和局部变量同名），这样必须通过this关键字来区分成员变量和参数，不能省略

```java
public class MyTest {
   int a ;
   int b;
   public MyTest(int a ){
       this.a=a;
   }
  public void find (int b ){
       this.b=b;
       System.out.print(b+3);
  }
}
```

- 5.封装的体现：私有属性的封装（set 赋值，get取值)
- 6.方法的重写(Override):
  1. 发生在父子类中，方法名称相同，参数列表相同，方法体不同
  2. 重写方法被调用时，看对象的类型
  3. 重写与重载的区别:重写(Override):发生在父子类中,方法名称相同,参数列表相同，方法体不同,遵循"运行期绑定",根据对象的类型来调用方法
  4. 重载(Overload):发生在一个类中,方法名称相同,参数列表不同遵循"编译期绑定",根据引用的类型来绑定调用方法.

#### 10.java内存

-  1.堆:

  1. 存储所有new出来的对象(包括成员变量)
  2. 成员变量的生命周期:创建对象时存在堆中，对象被回收时一并消失
  3. 没有任何引用指向的对象就是垃圾，垃圾回收器不定时的回收垃圾，回收过程是透明的(看不到的)，
                不一定发现垃圾就马上回收，但是调用System.gc()可以建议快一些回收
  4. 内存泄漏:不再使用的内存没有被及时的回收,建议:对象不再使用时及时将引用设置为null

-  2.栈:

  1. 存储正在调用中的方法中的所有的局部变量(包括参数)

  2. 调用方法时在栈中为该方法分配一块对应的栈桢，栈帧中存储方法中的所有局部变量(包括参数)，
            方法调用结束时，栈桢被清除，局部变量一并消失

  3. 局部变量的生命周期:调用方法时存在栈中，方法执行结束时与栈桢一并消失

-  3.方法区:

  1.  用于存储.class字节码文件(包括方法)
  2.  方法只有一份，通过this来指代调用该方法的具体的对象

-  2个对象指向了同一个地址，取值都一样eg:u1.age,u2.age3

#### 11.类

- 1.类继承作用:避免代码重复，有利于代码的复用

   1. 通过extends来实现继承 父类:所有子类所共有的属性和行为
   2. 子类:子类所特有的属性和行为
   3. 子继承父后，子具有: 子+父
   4. 一个父类可以有多个子类，一个子类只能有一个父类----单一继承

- 2.继承具有传递性
  
   1. java规定:构造子类之前必须先构造父类
   2. 在子类构造中若不调用父类的构造，则默认super()调父类的无参构造，
       若子类构造中调用父类构造了，则不再默认提供
  3. super()调用父类构造必须位于子类构造的第一句;
     super:指代当前对象的父类对象
  4. super的用法:
     - super.成员变量名------访问父类的成员变量
     - super.方法名()--------调用父类的方法
   - super()---------------调用父类的构造方法
  5. 非私有的属性方法可以调用

- 3.向上造型:
  
   1. 父类型的引用指向子类的对象
2. 能点出来什么，看引用的类型
   
- 4.访问控制修饰符:
  
   1. public:公开的，任何类
   2. private:私有的，本类
   3. protected:受保护的，本类、子类、同包类
   4. 默认的:什么也不写，本类、同包类
5. 类的访问修饰: public和默认的,类中成员的访问修饰: 如上4个都可以
   
- 5.static:静态的

  1. 静态变量:由static修饰

     - 属于类的，存在方法区中，只有一份
     - 常常通过类名.来访问
     - 何时用:所有对象的数据都一样时使用

  2. 静态方法:由static修饰

     - 属于类的，存在方法区中，只有一份
     - 常常通过类名.来访问
     - 静态方法没有隐式的this传递
     - 静态方法中不能直接访问实例成员
     - 何时用:方法的操作仅与参数相关而与对象无关

  3. 静态块:属于类的，在类被加载期间自动执行，类只被加载一次，所以静态块也只执行一次

     - 何时用:常常用于加载/初始化静态资源(图片、音频、视频...)

  4. final:最终的

     -  修饰变量:变量不能被改变
     -  修饰方法:方法不能被重写
     -  修饰类  :类不能被继承

- 6.static final常量:
  
   1. 必须声明的同时初始化
   2. 通过类名点来访问，不能被修改
   3. 建议:常量名所有字母都大写
4. 编译器在编译时被自动替换为具体的值，效率高
   
- 7.abstract修饰
  
   1. 抽象方法:1)由abstract修饰
      - 只有方法的定义，没有具体的实现(连大括号都没有)
  2. 抽象类:
     - 由abstract修饰;
     - 包含抽象方法的类必须是抽象类,不包含抽象方法的类也可以声明为抽象类
     - 抽象类不能被实例化; 4)抽象类是需要被继承的;子类:重写抽象类中的所有抽象方法
  3. 抽象类的意义:
   - 封装子类所共有的属性和行为，实现代码复用
      - 为所有子类提供一种统一的类型----向上造型
      - 可以包含抽象方法，为所有子类提供了统一的入口
      - 子类的具体实现不同，但定义是一致的
  
- 8.接口:
  
   1. 遵守这个标准就能干某件事------API
   2. 接口也是一种数据类型(引用类型)
   3. 由interface定义，只能包含常量和抽象方法
   4. 接口不能被实例
   5. 接口是需要被实现/继承的，实现类/子类:必须重写接口中的所有抽象方法
   6. 一个类可以实现多个接口，用逗号隔开,若又继承又实现时，应先继承后实现
7. 接口可以继承接口

-  9.多态:
  1. 多态的意义:同一类型的引用，指向不同的对象时，有不同的实现
-  10向上造型:
   1. 父类型的引用指向子类的对象
   2. 能造型成的类型: 父类+所实现的接口
   3. 能点出来什么，看引用的类型
   4. 强制类型转换，成功的条件有两种:
   5. 引用所指向的对象，就是该类型
   6. 引用所指向的对象，实现了该接口
   7. 不符合那两种条件则转换失败，发生ClassCastException类型转换异常
   8. 建议在强转之前使用instanceof判断引用指向的对象是否是该类型

#### 12.String  引用类型

字符串的 == 判断和isEmpty 前者地址比较，后者只是判断内容为空
== 和equals 的区别

String-----重写了equals ,一般引用数据类型都用这个方法比较是否一致


	
	