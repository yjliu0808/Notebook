



## python入门基础-学习笔记

### pycharm的一些常用设置

- 进入setting>Editor>File and Code Templates，点击python script，进行设置：

  ```python
  """
  =================================================
  Author : A
  Time : ${DATE} ${TIME} 
  =================================================
  """
  ```

- pycharm中将代码变工整对齐的快捷键：ctrl + alt + L

- 在代码前加# 可以注释单行代码，快捷键为Ctrl + / 

- 第一种 小驼峰式命名法（lower camel case)： 第一个单词以小写字母开始；第二个单词的首字母大写，例如：myName、aDog

  第二种 大驼峰式命名法（upper camel case）： 每一个单字的首字母都采用大写字母，例如：FirstName、LastName

  第三种 用下划线“_”来连接所有的单词，比如send_buf，这是python主推的命名方法，叫做snake-case。

### Python 基础语法

- Python是一个动态类型的语言，可以为变量赋任意类型的值，也可以任意修改变量的值。也就是说，变量的值是什么全取决于你，你给他什么，他就是什么。

- 在Python中所有可以自主命名的内容都属于标识符，比如：变量名，函数名，类名。虽说是自主命名，但也不是想叫什么叫什么，需要遵守标识符规范，如果使用不符合标准的标识符，将会报错SyntaxError: invalid syntax(语法错误)

- 标识符规范：

  1.标识符中可以含有字母，数字和_，但不能使用数字开头。

  2.标识符不能是Python中的关键字和保留字关键字有如下：['False', 'None', 'True', 'and', 'as', 'assert', 'async', 'await', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 'if', 'import','in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try','while', 'with', 'yield']

- 以双下划线开头的 __foo 代表类的私有成员，以双下划线开头和结尾的   _foo _ 代表 Python 里特殊方法专用的标识，如__ init() __代表类的构造函数。
  Python 可以同一行显示多条语句，方法是用分号 ; 分开

- 学习 Python 与其他语言最大的区别就是，Python 的代码块不使用大括号 **{}** 来控制类，函数以及其他逻辑判断。python 最具特色的就是用缩进来写模块。缩进的空白数量是可变的，但是所有代码块语句必须包含相同的缩进空白数量，这个必须严格执行。

- Python 可以使用引号( **'** )、双引号( **"** )、三引号( **'''** 或 **"""** ) 来表示字符串，引号的开始与结束必须是相同类型的。

  其中三引号可以由多行组成，编写多行文本的快捷语法，常用于文档字符串，在文件的特定地点，被当做注释。

- python中单行注释采用 # 开头。

- 函数之间或类的方法之间用空行分隔，表示一段新的代码的开始。类和函数入口之间也用一行空行分隔，以突出函数入口的开始。

  空行与代码缩进不同，空行并不是Python语法的一部分。书写时不插入空行，Python解释器运行也不会出错。但是空行的作用在于分隔两段不同功能或含义的代码，便于日后代码的维护或重构。记住：空行也是程序代码的一部分。

- print输入打印示例

  ```python
  import sys
  name = 'Athena';
  #默认不换行
  sys.stdout.write(name);
  #默认换行
  print(name);
  ```

- 多个语句构成代码组

- 缩进相同的一组语句构成一个代码块，我们称之代码组。像if、while、def和class这样的复合语句，首行以关键字开始，以冒号( : )结束，该行之后的一行或多行代码构成代码组。我们将首行及后面的代码组称为一个子句(clause)。如下实例：

  ```python
  if True:
       print("True")
  else:
      print("False")
  ```

### Python 变量类型

- 变量存储在内存中的值，这就意味着在创建变量时会在内存中开辟一个空间。基于变量的数据类型，解释器会分配指定内存，并决定什么数据可以被存储在内存中。因此，变量可以指定不同的数据类型，这些变量可以存储整数，小数或字符。

**变量赋值**

- Python 中的变量赋值不需要类型声明。

- 每个变量在内存中创建，都包括变量的标识，名称和数据这些信息。

- 每个变量在使用前都必须赋值，变量赋值以后该变量才会被创建。

- 等号 **=** 用来给变量赋值。等号 **=** 运算符左边是一个变量名，等号 **=** 运算符右边是存储在变量中的值。

  ```python
  a=1        # 赋值整型变量
  b=1.0      # 赋值浮点型
  c='test'   # 赋值字符串
  d="test"   # 赋值字符串
  T=true     #布尔值
  A = B = C = 100  #多个变量赋值
  # 两个整型对象 1 和 2 分别分配给变量 a 和 b，字符串对象 "john" 分配给变量 c
  a =1
  print(type(a))
  aa=1.3
  print(type(aa))
  b= '1'
  print(type(b))
  d=True
  print(type(d))
  l = ['Athena','test',100,10.2]
  print(type(l))
  tup = ('python','java',13,14)
  print(type(tup))
  dic = {'name':'Athena','age':13,'性别':'f'}
  print(type(dic))
  ----------------------------
  <class 'int'>
  <class 'float'>
  <class 'str'>
  <class 'bool'>
  <class 'list'>
  <class 'tuple'>
  <class 'dict'>
  
  ```

```
name =input('姓名:')
age =input("年龄:")
print('my name is %s,my age is %d'%(name,int(age)))
这就用到了占位符，如：%s、%d
'''
# name = input('输入名字')
# # 一个值的话直接放到%后面
# print('my name is %s'%name)
# %s 占位符 可以接受所有的数据类型 %d只能接受数字 有局限性
# 多个值的话直接放到%后面要有括号
print('My name is %s，my age is %d'%('dahai',18))
```

**五个标准的数据类型**

- Numbers（数字）

- String（字符串）

- List（列表）

- Tuple（元组）

- Dictionary（字典）


### Python中的运算符

- 1、算术运算符：加+ 减- 乘* 除/ 取余% 幂运算** 商取整//

  ```python
  a=10;b=20;
  print('加：',a+b);print('减：',a-b); print('乘：',a*b); print('除：',a/b); print('取余：',a%b)
  print('幂运算：',a**b); print('商取整：',a//b)
  ```

- 2、赋值运算符：= += -= *= /= %=

- ```python
  a = 1
  print('a=：', a)
  a+=100
  print('a+=：', a)
  a-=100
  print('a-=：', a)
  a*=100
  print('a*=：', a)
  a/=100
  print('a/=：', a)
  a%=100
  print('a%=：', a)
  ```

- 3、比较运算符：== > < >= <= !=

  ```python
  print(a,b,)
  print('a>b？', a>b )
  print('a<b？', a<b )
  print('a>=b？', a>=b)
  print('a<=b？', a<=b)
  print('a!=b？', a!=b)
  ```

- 4、逻辑运算符：and --->一假为假  or --->一真为真  not --->取反

  ```python
  a = 1
  b = 2
  c = 3
  #and:所有条件正确返回Ture，否则返回False.
  #or:有一个条件正确就返回Ture，所有条件错误则返回False.
  #not:取反（取条件的反值返回False，否则返回Ture)
  print(a<b and a<c)
  print(a>a or a<b)
  print(not a==a )
  ```

- 5、成员运算符：in 、 not in 

  ```python
  str = "测试同学"
  #in：如果在指定的序列中找到值返回 True，否则返回 False。
  #not in：如果在指定的序列中没有找到值返回 True，否则返回 False。
  a = "测" in str
  b = "测" not in str
  print(a,b)
  ```

- 6、身份运算符：is 、 is not

  ```python
  var1 = 100
  var2 = 100
  #is 是判断两个标识符是不是引用自一个对象
  #is not 是判断两个标识符是不是引用自不同对象
  t1 = var1 is var2
  t2= var1 is not  var2
  print(t1)
  print(t2)
  ```

- is 与 == 区别：is 用于判断两个变量引用对象是否为同一个(同一块内存空间)， == 用于判断引用变量的值是否相等。

### Python 字符串

- 字符串是 Python 中最常用的数据类型。我们可以使用引号('或")来创建字符串。创建字符串很简单，只要为变量分配一个值即可。

- 1、字符串赋值：

  ```python
  str1='1'; str2="1"
  str3=""" test
   Athena 可直接换行"""
  str4=''' test
  可直接换行'''
  #字符串中有单引号时，外面要用双引号区分
  a="'aaaa'"
  ```

- 2、字符串拼接：

  ```python
  a='你好'
  b="测试同学"
  c="""A
  """
  d='''B'''
  p=a+b+c+d;
  print(p);
  #--------------------输出
  你好测试同学A
  B
  ```

- 3、下标取值：

  ```python
  # 下标取值：可以正向取，也可以反向取
  # 注意点：正向从0开始，反向从-1开始，空格也算一个字符。
  str='0123456789'
  print(str)
  print(str[0])
  print(str[9])
  print(str[-1])
  print(str[-10])
  # [a:b]取值时左闭右开,a代表起始位置下标，b代表终止位置下标
  print(str[0:10])
  #[a:b:c]默认步长为1，a代表起始位置下标，b代表终止位置下标，c代表步长
  print(str[0:10:2])
  # #正向切片（步长为正）：起始位置值小于结束位置的值
  print(str[0:10:2])
  # #反向切片（步长为负）：起始位置值大于结束位置的值
  print(str[-10:-5:2])
  ```

- 4、python字符常用的方法

  ```python
  # 1、find方法：查找指定元素的下标位置
  str='Atheea'
  print(str.find('h'))  #返回对应元素的下标  ---2
  print(str.find('e'))  #返回对应元素的下标  ---3
  print(str.find('S'))  #没有找到返回的是-1
  # 2、count方法：查找指定元素的个数
  str='Atheea'
  print(str.count('A'))  #返回1
  print(str.count('e'))  #返回2
  # 3、replace方法：替换字符
  str='AtheeaAth'
  # 第一个参数：待替换的字符串片段，
  # 第二个参数：替换之后的字符串片段，
  # 第三个参数：默认替换所有，赋值可控制替换次数
  print(str.replace('Ath','XYZ',1))  #返回XYZeeaAth
  print(str.replace('Ath','XYZ'))    #返回XYZeeaXYZ
  # 4、split方法：字符串分割
  str='123456789054321'
  # #第一个参数：分割点分割字符串
  # #第二个参数：默认是找到所有的分割点进行分割，赋值可控制分割的次数
  print(str.split('5'))  #返回['1234', '67890', '4321']
  print(str.split('5',1))  #返回['1234', '6789054321']
  # 5、upper方法：将字母大写;lower方法：将字母小写
  str1='abcd';str2='ABCD'
  print(str1.upper())
  print(str2.lower())
  # 6、format方法：格式化输出
  # 格式化输出：format，使用{}进行占位
  str="操作人员：{},年龄：{}"
  name=input("你好，输入姓名：")
  age=input("你好，输入年龄：")
  print(str.format(name,age));
  ----------------
  你好，输入姓名：Athena
  你好，输入年龄：20
  操作人员：Athena,年龄：20
  # 通过下标来控制传入的数据显示的位置
  str1 = "我的名字：{}，年龄：{}，性别：{}。".format("Athena","18","nv")
  print(str1)
  str2 = "我的名字：{2}，年龄：{0}，性别：{1}。".format("20","nv","Athena")
  print(str2)
  #str3 = "我的名字：{0}，年龄：{1}，性别：{3}。" .format("小明","Athena","男") #报错,输入了不存在的下标
  
  # 通过变量名来控制显示的位置
  str4 = "我的名字：{a}，年龄：{b}，性别：{c}。".format(b = "20",a = "Athena",c = "nv")
  print(str4)
  str5= "我的名字：{a}，年龄：{b}，性别：{c}。".format(a = "Athena",c = "nv",b = "18")
  print(str5)
  #format
  print('my name is {0}'.format(1))
  print('my name is {0},my age is {1}'.format('athena',20))
  print('my name is {name},my age is {age}'.format(name='athena',age=18))
  s1='ab'
  s2='bc'
  s3='ef'
  print(''.join([s1,s2,s3]))
  print(''+s1+s2+s3)
  #split分割
  s='root:123'
  print(s.split(':'))
  print(s.split(':')[0])
  print(s.split(':')[1])
  print(s[0:8])
  ```

- 5、字符串的转义

  ```python
  # \n: 表示的是一个换行符   --->换行
  print('It is\na Wonderful Life')
  # \t: 制表符   --->空格（tap键的距离）
  print('It is\ta Wonderful Life')
  # \\:      ---> \
  print('D:\\Program Files\\study')
  # r/R:   --->防止字符串转义
  print(r'D:\Program Files\study')
  print(R'D:\Program Files\study')
  ```

### python数据类型的转换

- ```python
  # 整数和浮点数转换为字符串：使用str
  a = 10
  print(type(str(a)))
  b = 11.5
  print(type(str(b)))
  # 字符串和浮点数转换为整数：使用int
  # 注意点：使用字符串去转换为int和float是，字符串的内容必须是数字（不能有字母和符号）
  # 使用input输入的内容，接受到的数据都是字符串类型
  c = "100"
  print(type(int(c)))
  d = 11.5
  print(type(int(b)))
  # 整数和字符串转换为浮点数：使用float
  e = 12
  f = '13.6'
  print(type(float(e)))
  print(type(float(f)))
  
  # 整数和字符串、浮点数转换为布尔类型：使用bool
  g = 50
  k = "67"
  l = 45.8
  print(type(bool(g)))
  print(type(bool(k)))
  print(type(bool(l)))
  ```

### Python 列表(List)

- 序列是Python中最基本的数据结构。序列中的每个元素都分配一个数字 - 它的位置，或索引，第一个索引是0，第二个索引是1，依此类推。

- Python有6个序列的内置类型，但最常见的是列表和元组。

- 序列都可以进行的操作包括索引，切片，加，乘，检查成员。

- 此外，Python已经内置确定序列的长度以及确定最大和最小的元素的方法。

- 列表是最常用的Python数据类型，它可以作为一个方括号内的逗号分隔值出现。

- 列表的数据项不需要具有相同的类型

- 创建一个列表，只要把逗号分隔的不同的数据项使用方括号括起来即可。

  ```python
  list1 = ['Athena', 'test', 100, 10.2]
  list2 = [1, 2, 3, 4, 5 ]
  list3 = ["a", "b", "c", "d"]
  # 1.访问列表中的值
  # list1 = ['Athena', 'test', 100, 10.2]
  # print(list1[0])   # ---Athena
  # print(list1[0:3])  # 左闭右开 ---['Athena', 'test', 100]
  # 2.添加元素的方法：append()
  # list2 = [1, 2, 3, 4, 5]
  # print(list2.append(6))  # 在列表尾部加入元素
  # 3.删除元素的方法：pop()
  # pop方法：根据下标删除对应的元素,删除不存在的元素会报错,默认删除列表最后一个元素，赋值可控制删除指定位置元素
  list3 = ["a", "b", "c", "d"]
  list3.pop()
  print(list3)
  list3.pop(0)
  print(list3)
  # 4.insert方法：在指定位置插入元素
  # 第一个参数：插入数据的位置
  # 第二个参数：插入的数据
  list4 = ['a', 'b', 1, 2]
  list4.insert(0, '_a')
  print(list4)
  # 5. extend方法：一次性添加多个元素到列表的尾部
  list4.extend([11, 22, 33])
  print(list4)
  # 6.remove方法：删除指定的元素，括号中参数为列表中的元素
  list4.remove('a')
  list4.remove(11)
  print(list4)
  # 7.clear方法：清除列表的所有元素
  list4.clear()
  print(list4)
  # index：根据元素查找对应的下标（如果找不到对应的元素，会报错）
  list5 = [1, 2, 3, 4, 5, 1]
  print(list5.index(1))  # --0
  # count：查找某个元素在列表中出现的次数
  print(list5.count(1))  #--2
  # 通过下标获取获取到列表中对应的元素，进行重新赋值
  list5[0] = 'a'
  print(list5)
  # sort：排序(小到大)
  list6 = [6, 2, 3, 4, 5, 1, 0]
  list6.sort()
  print(list6)  # ---- [0, 1, 2, 3, 4, 5, 6]
  # reverse：列表反向（倒序/反转）
  list6.reverse()
  print(list6)  # -----[6, 5, 4, 3, 2, 1, 0]
  # copy：复制列表
  list7 = list6.copy()
  print(list7)
  # 内置函数：id(查看数据的内存地址)
  print(list7, id(list7))
  
  ```

### python元组

- Python的元组与列表类似，不同之处在于元组的元素不能修改。

- 元组使用小括号，列表使用方括号。

- 元组创建很简单，只需要在括号中添加元素，并使用逗号隔开即可。

  ```python
  # 元组中的数据可以是任意类型
  tup1 = ('physics', 'chemistry', 1997, 2000)
  tup2 = (1, 2, 3, 4, 5)
  tup3 = "a", "b", "c", "d"
  print(type(tup1))  # <class 'tuple'>
  print(type(tup2))  # <class 'tuple'>
  print(type(tup3))   # <class 'tuple'>
  # 创建空元组
  tup0= ()
  print(tup0)
  # 注意点：元组中只有一个元素的时候，要在括号中加一个逗号
  tup4 = (1)
  tup5 = (1,)
  print(type(tup4))  # ----<class 'int'>
  print(type(tup5))  # ----<class 'tuple'>
  
  
  # 注意点：
  # 元组是不可变类型的数据：定义的之后内部的数据是不可以修改
  # 字符串、数值类型数据也是不可变类型的数据，列表是可变类型的数据
  # 数据内容发生变化，id不变的是可变类型数据，数据发生变化，
  # id也发生了变化（意味着不是同一个数据了），那么就是不可变类型数据
  # 下标取值
  tu6 = ("a", 1, 2, 3, 4, 5)
  print(tu6[0], tu6[5])
  # 切片 左闭右开
  print(tu6[0:6])
  # 将元组转换成列表
  tu7 = ('11', '22')
  print(tu7)        # --('11', '22')
  print(list(tu7))  # ---['11', '22']
  #  index：根据元素查找对应的下标（如果找不到对应的元素，会报错）
  print(tu6.index("a"), tu6.index(3))
  # count：查找某个元素在列表中出现的次数
  tu8 = ("Athena", "", 1, "1", "2", "3", "1")
  print(tu8.count("1"))
  ```

### python数据类型的可变/不可变

- 数据类型的可变不可变

  ```python
  # ---------不可变的数据类型----------
  # id也发生了变化（意味着不是同一个数据了），那么就是不可变类型数据
  # 数值类型数据是不可变类型数据
  a = 5
  print(id(a))
  a = a + 2
  print(id(a))
  # 字符串类型数据是不可变类型数据
  str1 = '123abc'
  print(id(str1))  # --2487481605616
  str1 = str1.replace('1', '11')
  print(id(str1))  # --2487481951792
  # ----------可变的数据类型----------
  # 列表类型数据是可变类型数据
  li0 = [11, 22, 33]
  print(id(li0))
  li0.append(44)
  print(id(li0))
  ```

### Python 字典(Dictionary)

- 字典是另一种可变容器模型，且可存储任意类型对象。

- 字典的定义：使用{}来表示字典，每一个元素都是由一个键值对（key:value)组成

  ```python
  # ----------字典的定义----------
  # 第一种方法
  user_info_1 = {'name': 'Athena', 'age': 23, '性别': 'nv'}
  print(user_info_1, type(user_info_1))
  # 第二种方法
  user_info_2 = dict(name='Athena', age=18, 性别='nv')
  print(user_info_2, type(user_info_2))
  # 第三种方法
  data1 = [('name', 'Athena'), ('age', 20), ('性别', 'nv')]
  user_info_3 = dict(data1)
  print(user_info_3,type(user_info_3))
  # 字典中的数据规范：
  # key：不能重复，只能是不可变类型的数据（字符串，数值，元组），建议key都使用字符串。
  # value：可以是任意类型的数据
  user_info = {"name": "Athena", "age": 20, "性别": "nv"}
  # 通过键查找值
  name = user_info['name']
  print(name)
  print(user_info['age'])
  # 如果有重复的key，那么最后一个会把前面的覆盖掉
  dic1 = {'a': 11, 'a': 111, 'a': 1111}
  dic2 = {'a': 11, 'b': 111, 'c': 1111}
  print(dic1)
  print(dic2)
  # 字典的增删查改
  # 1、添加元素
  # 直接通过键去赋值(如果有这个键那就是修改这个键所对应的值）
  dic = {'a': 11, 'b': 22, 'c': 33}
  dic['d'] = 44
  print(dic)  # --{'a': 11, 'b': 22, 'c': 33, 'd': 44}
  # 2、修改元素
  #  update:一次往字典中添加多个键值对（将一个字典更新到原来的字典中）
  dic.update({'f': 55, 'k': 66})
  print(dic)
  # 直接通过键去赋值，修改这个键所对应的值
  dic['a'] = 100
  print(dic)
  # 3、删除元素
  # Python中的关键之：del-->可以用来删除任何数据
  # 由于python都是引用，而python有GC机制，所以，del语句作用在变量上，而不是数据对象上。
  # 删除字典中的键值对的有del语句与pop方法，del 语句和 pop() 函数作用相同，pop() 函数有返回值，返回值为对应的值，del语句没有返回值。
  # pop()函数语法：pop(key[,default])，其中key: 要删除的键值，default: 如果没有 key，返回 default 值
  dic1 = {"张三": 24, "李四": 23, "王五": 25, "赵六": 27}
  del dic1["张三"]
  print(dic1)
  print(dic1.pop("李四"))
  print(dic1)
  # popitem:默认删除字典中最后一个键值对
  dic1.popitem()
  print(dic1)
  # 4、查找元素
  # 通过键去找对应的值（如果键不存在会报错：KeyError）
  a = dic['a']
  print(a)
  # 5、其他几个方法
  # get方法查找:如果键不存在返回的是None
  b = dic.get('a')
  print(b)
  c = dic.get('Z')
  print(c)
  # keys:获取字典中所有键，可以通过list转换为一个列表
  dic3 = {'a': 11, 'b': 22, 'c': '33'}
  res3 = dic.keys()
  res4 = list(dic.keys())
  print(res3, type(res3))
  print(res4, type(res3))
  # value：获取字典中所有的值，可以通过list转换为一个列表
  dic5 = {'a': 11, 'b': 22, 'c': '33'}
  res5 = dic3.values()
  res6 = list(dic3.values())
  print(res5, type(dic5))
  print(res6, type(dic5))
  # items：获取字典中的键值对，可以通过list转换为一个列表
  dic7 = {'a': 11, 'b': 22, 'c': '33'}
  res7 = dic.items()
  res8 = list(dic.items())
  print(res7, type(dic7))
  print(res8, type(dic7))
  ```

  ```python
  # 关键字del
  # （1）删除变量
  a = 10
  del a
  list1 = [1, 2, 3]
  # （2）删除列表中的某个元素
  del list1[0]
  print(list1)
  # （3）删除字典中的某个键值对
  dic1 = {'a': 11, 'b': 22, 'c': '33'}
  del dic1['a']
  print(dic1)  # --{'b': 22, 'c': '33'}
  ```

### 总结数据类型

```java
# 1个值的数据类型：字符串、数字、布尔
# 多个值的数据类型：列表、字典、元组、集合
#列表通过下标索引取值，有序
l=['name',1]
dic={'name':1}
#元组无法修改
tup=('name',1)
s={'name',1}
print(type(l))
print(type(dic))
print(type(tup))
print(type(s))
```

### Python 日期和时间

-   Python 程序能用很多方式处理日期和时间，转换日期格式是一个常见的功能。

- Python 提供了一个 time 和 calendar 模块可以用于格式化日期和时间。

- 时间间隔是以秒为单位的浮点小数。

- 每个时间戳都以自从1970年1月1日午夜（历元）经过了多长时间来表示。

- Python 的 time 模块下有很多函数可以转换常见日期格式。如函数time.time()用于获取当前时间戳。

  ```python
  
  import time  # 引入time模块
  ticks = time.time()
  print("当前时间戳为:", ticks)
  localtime1 = time.localtime(time.time())
  # 获取当前时间
  print("本地时间为 :", localtime1)
  # 获取格式化的时间
  localtime2 = time.asctime(time.localtime(time.time()))
  print("本地时间为 :", localtime2)
  # 格式化日期
  # 我们可以使用 time 模块的 strftime 方法来格式化日期，：
  # 格式化成2021-09-02 15:53:04形式
  print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))
  # 格式化成Thu Sep 02 15:53:04 2021形式
  print(time.strftime("%a %b %d %H:%M:%S %Y", time.localtime()))
  # 将格式字符串转换为时间戳
  a = "Thu Sep 02 15:53:04 2021"
  print(time.mktime(time.strptime(a, "%a %b %d %H:%M:%S %Y")))
  # python中时间日期格式化符号：
  # %y 两位数的年份表示（00-99）
  # %Y 四位数的年份表示（000-9999）
  # %m 月份（01-12）
  # %d 月内中的一天（0-31）
  # %H 24小时制小时数（0-23）
  # %I 12小时制小时数（01-12）
  # %M 分钟数（00-59）
  # %S 秒（00-59）
  # %a 本地简化星期名称
  # %A 本地完整星期名称
  # %b 本地简化的月份名称
  # %B 本地完整的月份名称
  # %c 本地相应的日期表示和时间表示
  # %j 年内的一天（001-366）
  # %p 本地A.M.或P.M.的等价符
  # %U 一年中的星期数（00-53）星期天为星期的开始
  # %w 星期（0-6），星期天为星期的开始
  # %W 一年中的星期数（00-53）星期一为星期的开始
  # %x 本地相应的日期表示
  # %X 本地相应的时间表示
  # %Z 当前时区的名称
  # %% %号本身
  # 获取某月日历
  import  calendar
  cal = calendar.month(2021, 9)
  print("以下输出2016年1月份的日历:"+cal)
  '''
  以下输出2016年1月份的日历:   September 2021
  Mo Tu We Th Fr Sa Su
         1  2  3  4  5
   6  7  8  9 10 11 12
  13 14 15 16 17 18 19
  20 21 22 23 24 25 26
  27 28 29 30
  '''
  ```


### Python 条件循环流程

- 控制流程

  ```python
  # 控制流程
  # 1、从上往下执行；
  # 2、分支：根据不同的条件，执行不同的代码块
  # 3、循环：特定的代码重复执行
  # 注意：Python是通过缩进来区分代码块的
  # if条件：条件成立执行的代码块
  # else：条件不成立执行的代码块
  # if 判断成不成立：取决于后面表达式的布尔值是否为True，为True成立，否则不成立
  # python中的任何数据都有布尔值，通过bool这个函数可以获取数据的布尔值
  # python中数据的布尔值: 非0为True
  # 0的含义：数字0布尔值 为False   # 数据的长度为0布尔值 为False  # None的布尔值 为False
  n = input("请输入1或2")
  # 使用if进行调节判断：
  if n==1:
      print("输入数字=1")
  else:
      print("输入数字！=1")
      
  # 条件判断
  n = 3
  if n > 1:
      print(">1")
  elif n >2 :
      print(">2")
  else:
      print("等于0")
  
  ```

- while循环

  ```python
  i = 0
  while i < 100:
      i = i + 1
      print("这是第{}遍打印：hello".format(i))
  # -------------------------------死循环-------------------------
  #  循环条件始终成立的循环称之为死循环
  while True:
     print("hello python")
  i = 0
  while i < 100:
    print("这是第{}遍打印：hello python".format(i))
  ```

- break的作用

  ```python
  # break的作用：终止循环，
  i = 0
  while i < 100:
          i = i + 1
          print("这是第{}遍打印：hello".format(i))
          if i == 5:
             break
          print("end")
  print("---------循环体之外的代码-------------")
  ```

- continue的作用

  ```python
  # continue:中止当前本轮循环，进行下一轮循环的条件判断（执行到continue之后，会直接回到while后面进行添加判断）
  i = 0
  while i < 10:
          i = i + 1
          print("这是第{}遍打印：hello".format(i))
          if i == 5:
             continue
          print("end")
  print("---------循环体之外的代码-------------")
  ```

- for循环

  ```python
  # for循环也支持使用break,continue
  # 内置函数range:
  # range(n):默认生成一个 0到n-1的整数序列，对于这个整数序列，我们可以通过list()函数转化为列表类型的数据。
  print(list(range(10)))  #---[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  # range（n,m)：默认生成一个n到m-1的整数序列，对于这个整数序列，我们可以通过list()函数转化为列表类型的数据。
  print(list(range(1, 10)))  # ---[1, 2, 3, 4, 5, 6, 7, 8, 9]
  # range(n,m,k)：相当于其他函数里面的for循环。n 初始值  m 结束值 ， k 步长，会生成初始值为n,结束值为m-1,递减或者是递增的整数序列。
  print(list(range(1, 52, 5)))  # ---[1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51]
  #  range返回的数据是支持使用for进行遍历的,也能够进行下标取值 和切片（切片返回的还是range类型的数据）
  #1+2+3+4+5+6+7+8+9+10=55
  s = 0
  for i in range(1, 11):
      s = s + i
      print(s)  # ---每次的合计
  print(s)  #---最终合计55
  
  # while循环实现
  i = 1
  s = 0
  while i <= 10:
      s = s + i
      i += 1
      print(s)
  print(s)
  ```

-  for循环的应用场景 遍历列表、 遍历字符串 、遍历字典、 遍历元组

  ```python
  # 遍历字符串
  str1 = 'Athena'
  for i in str1:
      print(i)
  # 遍历元组
  tu1 = (1, 2, 3, 4, 5)
  for i in tu1:
      print(i)
  # 遍历列表
  list1 = [11, 22, 33, 44]
  for i in list1:
      print(i)
  # 字典的遍历
  # 直接遍历字典:遍历出来的是字典的键
  dic1 = {"AA": "BB", 88: 99}
  for i in dic1:
      print(i)
  # 遍历字典中元素的值：values
  for i in dic1.values():
      print(i)
  # 同时遍历字典的键和值：items ,遍历出来的是一个包含键和值的元组
  for i in dic1.items():
      print(i)
  
  # 使用两个变量对元组进行拆包
  for k, v in dic1.items():
      print("key:", k)
      print("value:", v)
  ```

### Python 函数

- 函数是组织好的，可重复使用的，用来实现单一，或相关联功能的代码段。函数能提高应用的模块性，和代码的重复利用率。你已经知道Python提供了许多内建函数，比如print()。但你也可以自己创建函数，这被叫做用户自定义函数。
- 你可以定义一个由自己想要功能的函数，以下是简单的规则：
  - 函数代码块以 **def** 关键词开头，后接函数标识符名称和圆括号**()**。
  - 任何传入参数和自变量必须放在圆括号中间。圆括号之间可以用于定义参数。
  - 函数的第一行语句可以选择性地使用文档字符串—用于存放函数说明。
  - 函数内容以冒号起始，并且缩进。
  - **return [表达式]** 结束函数，选择性地返回一个值给调用方。不带表达式的return相当于返回 None。

- 内置函数

  ```python
  # print: 打印内容的控制台
  # input: 用户输入
  # id：查看数据的内存地址
  # type: 查看数据的类型额
  # len: 查看数据的长度
  ```

- 自定封装函数

  ```python
  def num( str ):
     str1=str+5
     return str1
  ```

- 函数的调用：函数名（）

  ```python
  # 函数的调用：函数名（）
  # 注意点：函数定义了之后
  # 不会直接执行函数内的代码，只有在调用函数的时候，才会执行函数内部的代码
  # 关键字：pass:没有语义，表示一行空的代码（占个位置）
  def num(st):
      str1 = st + 5
      return str1
  
  
  print(num(3))
  
  #  定义个会打印 三角形的函数
  # *
  # * *
  # * * *
  # * * * *
  
  def func():
      for i in range(1, 5):
          print()
          for j in range(1, i + 1):
              print('* ', end="")
  
  
  func()
  
  # 函数的返回值,关键字：return,函数没写return, 函数返回的内容为None(为空)
  # 注意点：一个函数中只会执行一个return, 函数执行到return之后就不会再继续执行，会直接跳出函数, 返回结果
  def ff(n):
      if n == 1:
          return n + 1
      else:
          return n - 1
  
  
  print(ff(1))
  ```

1. 函数的参数

   ```python
   # 形参：在定义函数的时候，定义的参数
   # 实参：在调用函数的时候，传入进行的参数，叫实参
   # 1、必需参数（必备参数）：必备参数定义了，调用函数的时候就必须要传；
   def func(a, b):
       print("a的值：{}".format(a))
       print("b的值：{}".format(b))
       return a + b
   
   
   res = func(11, 88)
   
   
   # 2、默认参数（缺省参数）：调用函数时，默认参数的值如果没有传入，就使用定义时的默认值；
   def func(a, b=10, name="Athena"):
       print("a的值：{}".format(a))
       print("b的值：{}".format(b))
       print("name的值:{}".format(name))
       return a, b, name
   
   
   print(func(1))
   print(func(1, 2, 'Athena'))
   
   # 定义参数的时候在参数前面，加个*或者**,那么这个参数就是一个不定长参数
   # 3、不定长参数（动态参数）：调用函数时需要传入比定义时更多的参数，这些参数在定义时不会命名：
   # *args：可以用来接收0个或者多个参数(只能接收以位置传参方式传递的参数)，以元组形式保存
   def func(a, b=111, *args):
       print("a的值：{}".format(a))
       print("b的值：{}".format(b))
       print("ppp的值：{}".format(args))
       return a, b, args
   pass
   print(func(1, 2, 3, 4, 5))
   # **kwargs：可以用来接收0个或者多个参数(只能接收以关键字指定参数传参方式传递的参数)，以字典的形式保存
   def func(a, b=99, **kwargs):
       return a, b, kwargs
   
   
   print(func(a=11, b=22, c=333, d=999))
   ```

### python变量作用域

- 变量作用域：一个程序的所有的变量并不是在哪个位置都可以访问的。访问权限决定于这个变量是在哪里赋值的。变量的作用域决定了在哪一部分程序你可以访问哪个特定的变量名称。两种最基本的变量作用域:全局变量\局部变量

  ```python
  # 全局变量：直接定在在模块中的变量，在该模块中任何地方都可以直接访问（使用）
  # 局部变量：定义在函数内部的变量，只能在定义的那个函数内部使用
  name = 'lyj' # 全局变量
  def tefun():
      a='lyj'  # 局部变量
  print(name)
  # print(a) 不可引用变量a
  
  #  ---------在函数内部修改全局变量的值---------
  a = 100
  print(a)
  print(id(a))
  def func():
      global a, b   # 使用global声明某个变量之后，那么这个变量在函数内进行的操作会对全局生效
      a = 101
      b = 102
      print(id(a))
  func()
  print(id(a))
  ```

### python-内置函数

- 常用函数

  ```python
  # --内置函数: max函数：最大值，min函数：最小值
  a = -88, 2, 3, 4, 700
  li = [0, 3, 10000]
  st = (-1, 3, 500)
  print(max(a))
  print(max(li))
  print(max(st))
  print(max(1, 2, 3))
  print(min(a))
  print(min(li))
  print(min(st))
  print(min(1, 2, 3))
  print(sum(st))
  
  # enumerate：同时获取索引和值
  li1 = (11, 22, 331, 21, 322)
  dic = {"a": 11, "b": 333}
  li1s = enumerate(li1)
  dics = enumerate(dic)
  print(li1s)
  print(dics)
  for i in li1s:
      print(i)
  for i in dics:
      print(i)
  # eval：识别字符串中有效的python表达式，将字符串转换成列表/字典
  # 把str1转换为字典
  str1 = "{'a':11,'b':22}"
  dic1 = eval(str1)
  # str2转换为列表
  str2 = "[11,22,33,44]"
  list1 = eval(str2)
  print(dic1, type(dic1))
  print(list1, type(list1))
  
  # zip：聚合打包
  li = [1, 2, 3, 4, 5, 6]
  li2 = [11, 22, 33, 44, 55, 66]
  li3 = [111, 222, 333, 444, 555, 666, ]
  res = zip(li, li2, li3)
  print(list(res))
  
  # 注意点：zip打包之后返回的数据，只能使用一次
  title = ["aa", "bb", "cc"]
  value = [11, 22, 33]
  res1 = zip(title, value)
  print(dict(res1))  # --{'aa': 11, 'bb': 22, 'cc': 33}
  print(list(res1))  # -- []
  # filter:过滤器
  # 过滤的原理:filter会将第二个参数中的数据，进行遍历，然后当成参数传入第一个参数（函数中），根据函数返回的结果是否为True，来决定是否要将改数据过滤出来
  # iterable:可迭代对象，可以使用for循环进行遍历的都是可迭代对象。
  # 可迭代对象的：字符串，列表，元组，字典，集合、range创建的数据
  def func(a):
      print("参数a", a)
      return  a<12
  li = [11, 22, 33, 44, 111, 222, 222,10]
  res = filter(func, li)
  print(res)
  print(list(res))
  ```

### Python 基本的 I/O 函数

- Python操作文件

  ```python
  # Python操作文件
  fi1 = open(r"D:\Program Files\work_project\test1\list_1.py", "r", encoding="utf8")
  # open的常用参数：
  # 第一个参数：要打开的文件名字或者文件路径 ，读取同级目录下的文件，可以直接写文件名 # 读取不在同一个目录下的文件，要写上文件的完整路径
  # 第二个参数：文件打开的模式（r:只读模式 rb:只读模式，以二进制的编码格式去打开文件）
  # 第三个参数： encoding：用来指定打开文件的编码格式（使用rb的时候，不需要加该参数）
  # 打开文件
  fi2 = open(r"list_1.py", "r", encoding="utf8")
  # 读取内容
  content = fi2.read()
  # 打印读取出来的内容
  print("文件中读取出来的内容为：", content)
  #关闭文件
  fi2.close()
  
  # 文件的写入操作
  # a: 以追加写入的模式打开文件，如果打开的文件不存在，不会报错（会自动创建一个）
  # ab: 以追加写入的模式打开文件，如果打开的文件不存在，不会报错（会自动创建一个），二进制的编码格式去打开文件
  # w: 以写入的模式打开文件，覆盖写入(会将原文件中的内容给清空），如果打开的文件不存在，不会报错（会自动创建一个）
  # wb: 以写入的模式打开文件，覆盖写入(会将原文件中的内容给清空），如果打开的文件不存在，不会报错（会自动创建一个），二进制的编码格式去打开文件
  # 注意点：a,ab，w,wb，只能写入内容，不能读取内容！
  
  # 打开一个文件
  fo = open("foo.txt", "w",encoding="utf8")
  # 文件写入write()
  fo.write("TEST")
  # 关闭打开的文件
  fo.close()
  
  # read:读取文件中所有的内容，该方法可以通过参数去指定读取内容的大小
  # readline:每次读取一行内容
  # 读取不在同一个目录下的文件，要写上文件的完整路径
  f11 = open("foo.txt", "r", encoding="utf8")
  # 按行读取内容：每次读取一行
  content1 = f11.readline()
  print(content1)
  content2 = f11.readline()
  print(content2)
  content3 = f11.readline()
  print(content3)
  f11.close()
  
  # readlines:按行读取所有的内容，每一行作为一个元素，放到一个列表中
  f22 = open("foo.txt", "r", encoding="utf8")
  content22 = f22.readlines()
  print(content22)
  f22.close()
  # 使用with来打开文件，会自动帮我们关闭文件，with可以开启文件操作的上下文管理器
  with open("foo.txt", "r", encoding="utf8") as f:
      content = f.read()
      print(content)
  ```

### Python 面向对象

Python从设计之初就已经是一门面向对象的语言，正因为如此，在Python中创建一个类和对象是很容易的。

- 面向对象技术简介：

- **类(Class):** 用来描述具有相同的属性和方法的对象的集合。它定义了该集合中每个对象所共有的属性和方法。对象是类的实例。

- **类变量：**类变量在整个实例化的对象中是公用的。类变量定义在类中且在函数体之外。类变量通常不作为实例变量使用。

- **数据成员：**类变量或者实例变量, 用于处理类及其实例对象的相关的数据。

- **方法重写：**如果从父类继承的方法不能满足子类的需求，可以对其进行改写，这个过程叫方法的覆盖（override），也称为方法的重写。

- **局部变量：**定义在方法中的变量，只作用于当前实例的类。

- **实例变量：**在类的声明中，属性是用变量来表示的。这种变量就称为实例变量，是在类声明的内部但是在类的其他成员方法之外声明的。

- **继承：**即一个派生类（derived class）继承基类（base class）的字段和方法。继承也允许把一个派生类的对象作为一个基类对象对待。例如，有这样一个设计：一个Dog类型的对象派生自Animal类，这是模拟"是一个（is-a）"关系（例图，Dog是一个Animal）。

- **实例化：**创建一个类的实例，类的具体对象。

- **方法：**类中定义的函数。

- **对象：**通过类定义的数据结构实例。对象包括两个数据成员（类变量和实例变量）和方法。

- import 导入模块：

  ```python
  # 导入模块中的某个函数或者变量  ，from 模块名 import 变量或函数
  # 导入的时候给导入的内容起别名：from 模块 import 变量或函数 as 别名,from  文件夹.文件夹 import 模块 as 别名
  from base import a
  a()
  from base import  A
  print(A)
  
  from base import a  as a_1
  a_1()
  from base import  A  as A_1
  print(A_1)
  ```

- 定义类\创建对象

  - 第一种方法__init__()方法是一种特殊的方法，被称为类的构造函数或初始化方法，当创建了这个类的实例时就会调用该方法
  - self 代表类的实例，self 在定义类的方法时是必须有的，虽然在调用时不必传入相应的参数。
  - 在Python中定义类经常会用到__init__函数（方法），首先需要理解的是，两个下划线开头的函数是声明该属性为私有，不能在类的外部被使用或访问。而__init__函数（方法）支持带参数类的初始化，也可为声明该类的属性（类中的变量）。__init__函数（方法）的第一个参数必须为self，后续参数为自己定义。

  ```python
  class Employee:
      # 静态变量
      empCount = 0
      def __init__(self, name2, age):
          # 初始化变量
          self.name = name2
          self.age = age
          Employee.empCount += 1
      # 类中方法
      def displayCount(self):
          print("Total Employee %d" % Employee.empCount)
      def displayEmployee(self):
          print( "Name : ", self.name, ", age: ", self.age)
  # 创建实例对象
  #创建对象的格式为:对象名 = 类名()
  # "创建 Employee 类的第一个对象"
  emp1 = Employee('Athena',20)
  print(emp1.name,emp1.age)
  print(id(emp1))
  # "创建 Employee 类的第二个对象"
  # 实例对象的地址均不同
  emp2 = Employee('Athena1',21)
  print(emp2.name,emp2.age)
  print(Employee.empCount)
  print(id(emp2))
  emp3 = Employee('Athena1',21)
  print(id(emp3))
  # 调用函数
  emp1.displayEmployee()
  emp1.displayCount()
  ```

### Python之类的继承

- 虽然子类没有定义`__init__`方法，但是父类有，所以在子类继承父类的时候这个方法就被继承了，所以只要创建Bosi的对象，就默认执行了那个继承过来的`__init__`方法

- 子类在继承的时候，在定义类时，小括号()中为父类的名字

- 父类的属性、方法，会被继承给子类

  ```python
  # 定义一个父类A:
  class A(object):
      A1 = 1
      def __init__(self,ax):
          self.ax=ax
          print("TEST")
          pass
      def A2(self):
          print("父类的方法")
  
  
  # 定义一个子类，继承A类如下:
  class a(A):
      def a1(self, newName):
          self.name = newName
  
      def a2(self):
          print("子类方法")
  x1 = a(222)
  ```

- 私有属性和方法的继承

  ```python
  class Animal():
  
      def __init__(self, name='动物', color='白色'):
          self.__name = name
          self.color = color
  
      # 私有方法和私有属性
      # 私有方法只能在类内部被调用，不能被对象使用
      # 私有属性只能在类内部使用，不能被对象使用
      # 私有属性只能在类内部使用，对象不能使用，但是，我们可以通过在类内部定义公有方法对私有属性进行调用或修改，然后对象在调用这个公有方法使用。
      def __test(self):
          print(self.__name)
          print(self.color)
      def __aa(self):
          print("私有方法")
  
      def test(self):
          print(self.__name)
          print(self.color)
          self.__aa()
  
  class Dog(Animal):
      def dogTest1(self):
          # print(self.__name) #不能访问到父类的私有属性
          print(self.color)
  
      def dogTest2(self):
          # self.__test() #不能访问父类中的私有方法
          self.test()
  an1 = Animal()
  an2 = Animal(1,2)
  an1.test()
  an2.test()
  
  
  A = Animal()
  # print(A.__name) #程序出现异常，不能访问私有属性
  print(A.color)
  #A.__test() #程序出现异常，不能访问私有方法
  A.test()
  D1 = Dog("小狗", color="黄")
  D2 = Dog(name="小花狗", color="黄色")
  D1.dogTest1()
  D1.dogTest2()
  D2.dogTest1()
  D2.dogTest2()
  ```

- Python中多继承

  ```python
  class A:
      def setA(self):
          print("setA")
          def xx(self):
              print("xx--A")
  class B:
      def setB(self):
          print("setB")
      def xx(self):
          print("xx--B")
  # 定义一个子类，继承自A、B
  class C(A,B):
      def setC(self):
          print("setC")
  obj_c = C()
  obj_c.setA()
  obj_c.setB()
  obj_c.setC()
  
  #如果父类A和父类B中，有一个同名的方法，那么通过子类去调用的时候，调用哪个？
  obj_c.xx()
  print("搜索顺序：",C.__mro__)  # 可以查看C类的对象搜索方法时的先后顺序
  ```

- 重写父类方法

  ```python
  class A:
      def printA(self):
          print('----A----')
  
  class B(A):
      def printA(self):
          print('----B----')
  x=B()
  x.printA()   # ----B----
  ```

### python静态方法和类方法

- 类方法是类对象所拥有的方法，需要用修饰器@classmethod来标识其为类方法
- 类方法，第一个参数必须是类对象，一般以cls作为第一个参数（当然可以用其他名称的变量作为其第一个参数，但是大部分人都习惯以’cls’作为第一个参数的名字，就最好用’cls’了），能够通过实例对象和类对象去访问。
- 类方法还有一个用途就是可以对类属性进行修改
- 静态方法需要通过修饰器`@staticmethod`来进行修饰，静态方法不需要多定义参数
- 类方法和实例方法以及静态方法的定义形式就可以看出来，类方法的第一个参数是类对象cls，那么通过cls引用的必定是类对象的属性和方法
- 实例方法的第一个参数是实例对象self，那么通过self引用的可能是类属性、也有可能是实例属性（这个需要具体分析），不过在存在相同名称的类属性和实例属性的情况下，实例属性优先级更高。静态方法中不需要额外定义参数，因此在静态方法中引用类属性的话，必须通过类对象来引用

