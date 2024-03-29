### GO开发语言

go build hello.go  hello.exe

go run hello.go

注释：

```go
//行注释   ctrl+/
/*多行注释*/  //ctrl +shift+/
```

Go 官方编码指南：https://golang.org/#

GoLang 中文标准文档：https://studygolang.com/pkgdoc

#### Go 语言变量

Go 语言变量名由字母、数字、下划线组成，其中首个字符不能为数字。

声明变量的一般形式是使用 var 关键字：

```go
	//行注释   ctrl+/
	/*多行注释*/  //ctrl +shift+/
	var num = 2 + 4 * 5
	fmt.Println(num)
	//定义变量，赋值，使用
	var a3 int
	    a3 = 100
	fmt.Println(a3)
	//变量使用方式第一种： 指定变量类型，声明后不赋值，使用默认值
	var a1 int
	fmt.Println(a1) //默认打印0
	//变量使用方式第二种：不指定变量类型，根据赋值判断变量类型
	var a2 = 1
	fmt.Println(a2)
	var a4 = 100.11
	fmt.Println(a4)
	//变量使用方式第三种：省略var, ：=方式
	name :="Athena" // 等价 var name string = "Athena"
	fmt.Println(name)
```

2.多个变量的声明方式

```go
package main

import "fmt"
//声明多个全局变量
var m1 = 100
var m2 = 200
var (
	m3 = 300
	m4 = 400
)
func main()  {
	//一次性声明多个变量的方式
	var n1, n2, n3 int
	fmt.Println("n1=",n1,"n2=",n2,"n3=",n3)
	//一次性声明多个变量的方式
	var n11, name, n22 = 100, "Athena",888
	fmt.Println("n11=",n11,"name=",name,"n22=",n22,n3)
	//一次性声明多个变量的方式2
	n111, name1, n222 := 100, "T",888
	fmt.Println("n111=",n111,"name1=",name1,"n222=",n222,n3)
    fmt.Println(m1,m2,m3,m4)
}

```

#### Go 语言数据类型

在 Go 编程语言中，数据类型用于声明函数和变量。

数据类型的出现是为了把数据分成所需内存大小不同的数据，编程的时候需要用大数据的时候才需要申请大内存，就可以充分利用内存。

Go 语言按类别有以下几种数据类型：

| 序号 | 类型和描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **布尔型** 布尔型的值只可以是常量 true 或者 false。一个简单的例子：var b bool = true。 |
| 2    | **数字类型** 整型 int 和浮点型 float32、float64，Go 语言支持整型和浮点型数字，并且支持复数，其中位的运算采用补码。 |
| 3    | **字符串类型:** 字符串就是一串固定长度的字符连接起来的字符序列。Go 的字符串是由单个字节连接起来的。Go 语言的字符串的字节使用 UTF-8 编码标识 Unicode 文本。 |
| 4    | **派生类型:** 包括：(a) 指针类型（Pointer）(b) 数组类型(c) 结构化类型(struct)(d) Channel 类型(e) 函数类型(f) 切片类型(g) 接口类型（interface）(h) Map 类型 |

------

#### 数字类型

Go 也有基于架构的类型，例如：int、uint 和 uintptr。

| 序号 | 类型和描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **uint8** 无符号 8 位整型 (0 到 255)                         |
| 2    | **uint16** 无符号 16 位整型 (0 到 65535)                     |
| 3    | **uint32** 无符号 32 位整型 (0 到 4294967295)                |
| 4    | **uint64** 无符号 64 位整型 (0 到 18446744073709551615)      |
| 5    | **int8** 有符号 8 位整型 (-128 到 127)                       |
| 6    | **int16** 有符号 16 位整型 (-32768 到 32767)                 |
| 7    | **int32** 有符号 32 位整型 (-2147483648 到 2147483647)       |
| 8    | **int64** 有符号 64 位整型 (-9223372036854775808 到 9223372036854775807) |

#### 浮点型

| 序号 | 类型和描述                        |
| :--- | :-------------------------------- |
| 1    | **float32** IEEE-754 32位浮点型数 |
| 2    | **float64** IEEE-754 64位浮点型数 |
| 3    | **complex64** 32 位实数和虚数     |
| 4    | **complex128** 64 位实数和虚数    |

------

#### 其他数字类型

以下列出了其他更多的数字类型：

| 序号 | 类型和描述                               |
| :--- | :--------------------------------------- |
| 1    | **byte** 类似 uint8                      |
| 2    | **rune** 类似 int32                      |
| 3    | **uint** 32 或 64 位                     |
| 4    | **int** 与 uint 一样大小                 |
| 5    | **uintptr** 无符号整型，用于存放一个指针 |

