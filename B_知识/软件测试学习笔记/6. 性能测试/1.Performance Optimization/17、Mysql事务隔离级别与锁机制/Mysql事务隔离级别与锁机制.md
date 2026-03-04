# 一、概述

我们的数据库一般都会并发执行多个事务，多个事务可能会并发的对相同的一批数据进行增删改查操作，可能就会导致我们说的脏写、脏读、不可重复读、幻读这些问题。这些问题的本质都是数据库的多事务并发问题，为了解决多事务并发问题，数据库设计了事务隔离机制、锁机制、MVCC多版本并发控制隔离机制，用一整套机制来解决多事务并发问题。接下来，我们会深入讲解这些机制，让大家彻底理解数据库内部的执行原理。



# 二、事务及其ACID属性

事务是由一组SQL语句组成的逻辑处理单元,事务具有以下4个属性,通常简称为事务的ACID属性。

- 原子性(Atomicity) ：事务是一个原子操作单元,其对数据的修改,要么全都执行,要么全都不执行。
- 一致性(Consistent) ：在事务开始和完成时,数据都必须保持一致状态。这意味着所有相关的数据规则都必须应用于事务的修改,以保持数据的完整性。
- 隔离性(Isolation) ：数据库系统提供一定的隔离机制,保证事务在不受外部并发操作影响的“独立”环境执行。这意味着事务处理过程中的中间状态对外部是不可见的,反之亦然。
- 持久性(Durable) ：事务完成之后,它对于数据的修改是永久性的,即使出现系统故障也能够保持。



## 2.1、并发事务处理带来的问题

### 更新丢失或脏写

　　当两个或多个事务选择同一行，然后基于最初选定的值更新该行时，由于每个事务都不知道其他事务的存
在，就会发生丢失更新问题–最后的更新覆盖了由其他事务所做的更新。

### 脏读

　　一个事务正在对一条记录做修改，在这个事务完成并提交前，这条记录的数据就处于不一致的状态；这
时，另一个事务也来读取同一条记录，如果不加控制，第二个事务读取了这些“脏”数据，并据此作进一步的
处理，就会产生未提交的数据依赖关系。这种现象被形象的叫做“脏读”。
　　一句话：事务A读取到了事务B已经修改但尚未提交的数据，还在这个数据基础上做了操作。此时，如果B
事务回滚，A读取的数据无效，不符合一致性要求。

### 不可重读

　　一个事务在读取某些数据后的某个时间，再次读取以前读过的数据，却发现其读出的数据已经发生了改
变、或某些记录已经被删除了！这种现象就叫做“不可重复读”。
　　一句话：事务A内部的相同查询语句在不同时刻读出的结果不一致，不符合隔离性

### 幻读

　　在当前事务按相同的查询条件重新读取以前检索过的数据，却发现其他事务插入了满足其查询条件的新数
据，这种现象就称为“幻读”。
　　一句话：事务A读取到了事务B提交的新增数据，不符合隔离性





## 2.2、事务隔离级别

“脏读”、“不可重复读”和“幻读”,其实都是数据库读一致性问题,必须由数据库提供一定的事务隔离机制来解决。



 √: 可能出现  ×: 不会出现

| 脏读                               | 脏读 | 不可重复读 | 幻读 |
| :--------------------------------- | :--- | :--------- | ---- |
| Read uncommitted 读未提交          | √    | √          | √    |
| Read committed     读已提交        | ×    | √          | √    |
| Repeatable read     可重复读       | ×    | ×          | √    |
| Serializable              可串行化 | ×    | ×          | ×    |

数据库的事务隔离越严格,并发副作用越小,但付出的代价也就越大,因为事务隔离实质上就是使事务在一定程度上“串行化”进行,这显然与“并发”是矛盾的。
同时,不同的应用对读一致性和事务隔离程度的要求也是不同的,比如许多应用对“不可重复读"和“幻读”并不敏感,可能更关心数据并发访问的能力。

常看当前数据库的事务隔离级别: 

```mysql
mysql> select @@global.transaction_isolation,@@transaction_isolation;
+--------------------------------+-------------------------+
| @@global.transaction_isolation | @@transaction_isolation |
+--------------------------------+-------------------------+
| REPEATABLE-READ                | REPEATABLE-READ         |
+--------------------------------+-------------------------+
1 row in set (0.00 sec)
```

Mysql默认的事务隔离级别是可重复读，用Spring开发程序时，如果不设置隔离级别默认用Mysql设置的隔
离级别，如果Spring设置了就用已经设置的隔离级别



## 2.3、行锁与事务隔离级别案例分析

### 示例表

```mysql
 CREATE TABLE `account` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `name` varchar(255) DEFAULT NULL,
 `balance` int(11) DEFAULT NULL,
 PRIMARY KEY (`id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

```mysql
 INSERT INTO `account` (`name`, `balance`) VALUES ('lilei', '450');
 INSERT INTO `account` (`name`, `balance`) VALUES ('hanmei', '16000');
 INSERT INTO `account` (`name`, `balance`) VALUES ('lucy', '2400');
```

### 读未提交

（1）打开一个客户端A，并设置当前事务模式为read uncommitted，查询表account的初值：

```mysql
SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

select @@global.transaction_isolation,@@transaction_isolation;
```

```mysql
mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)


mysql> select * from account;
+----+--------+---------+
| id | name   | balance |
+----+--------+---------+
|  1 | lilei  |     450 |
|  2 | hanmei |   16000 |
|  3 | lucy   |    2400 |
+----+--------+---------+
```

（2）打开另一个客户端B，更新表account：

```mysql
START TRANSACTION;
update account set balance = balance - 50 where id =1;

-- ROLLBACK;
```

（3）这时，虽然客户端B的事务还没提交，但是客户端A就可以查询到B更新的数据

（4）一旦客户端B的事务因为某种原因回滚，所有的操作都将会被撤销，那客户端A查询到的数据其实就是脏读

### 读已提交

（1）打开一个客户端A，并设置当前事务模式为read committed，查询表account的所有记录：

```mysql
SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

select @@global.transaction_isolation,@@transaction_isolation;
```

```mysql
mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)


mysql> select * from account;
+----+--------+---------+
| id | name   | balance |
+----+--------+---------+
|  1 | lilei  |     400 |
|  2 | hanmei |   16000 |
|  3 | lucy   |    2400 |
+----+--------+---------+
```

（2）打开另一个客户端B，更新表account：

```mysql
START TRANSACTION;
update account set balance = balance - 50 where id =1;

-- ROLLBACK;
```

（3）这时，客户端B的事务还没提交，客户端A不能查询到B未提交的数据，解决了脏读问题。

```
此时客户端B查询出余额为350，A查询出余额为400
```

（4）客户端B的事务提交

```mysql
commit;
```

此时客户端A再次查看数据，余额为350，同一个事务中前后两次读取到的数据不一样，发生了不可重复度现象。

### 可重复读

（1）打开一个客户端A，并设置当前事务模式为read committed，查询表account的所有记录：

```mysql
SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

select @@global.transaction_isolation,@@transaction_isolation;
```

```mysql
mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)


mysql> select * from account;
+----+--------+---------+
| id | name   | balance |
+----+--------+---------+
|  1 | lilei  |     350 |
|  2 | hanmei |   16000 |
|  3 | lucy   |    2400 |
+----+--------+---------+
```

（2）打开另一个客户端B，更新表account：

```mysql
START TRANSACTION;
update account set balance = balance - 50 where id =1;

-- ROLLBACK;
```

（3）在客户端A查询表account的所有记录， 余额为350。而此时客户端B的余额已经变成300了。

（4）在客户端B提交事务

```
commit;
```

此时客户端A再次查看数据，余额依然为350，同一个事务中前后两次读取到的数据是一致的，没有出现不可重复读的问题

（4）在客户端A，接着执行

```mysql
update account set balance = balance - 50 where id = 1
```

执行后查看余额没有变成 350-50=300，余额值用的是B客户端中的300来算的，所以是250，数据的一致性倒是没有被破坏。

这是因为在可重复读的隔离级别下使用了MVCC(multi-version concurrency control)机制。

在 MVCC 中，每个事务在开始时会获取一个事务开始的时间戳。当执行 select 操作时，会基于事务开始时间戳去读取对应时间点的数据版本，这样就可以实现快照读（历史版本）。而 insert、update 和 delete 操作会更新数据行的版本号，这样其他事务在并发执行时能够正确读取到最新的数据版本，实现当前读（当前版本）。

（5）重新打开客户端B，插入一条新数据后提交

```mysql
 INSERT INTO `account` (`name`, `balance`) VALUES ('jon', '5000');
```

（6）在客户端A查询表account的所有记录，没有查出新增数据，所以没有出现幻读。即使客户端B插入了一条数据，但是客户端A查询不出来这条数据的，所以就很好了避免幻读问题。
（7）在客户端A执行

```mysql
update account set balance=888 where id = 4;
```

能更新成功，再次查询能查到客户端B新增的数据。客户端A就能看到客户端B插入的记录了，幻读就是发生这种违和的场景。因为这种特殊现象的存在，所以我们认为  MySQL`Innodb` 中的 MVCC 并不能完全避免幻读现象。

### 串行化

（1）打开一个客户端A，并设置当前事务模式为serializable，查询表account的所有记录：

```mysql
SET GLOBAL TRANSACTION ISOLATION LEVEL serializable;
SET SESSION TRANSACTION ISOLATION LEVEL serializable;

select @@global.transaction_isolation,@@transaction_isolation;
```

```mysql
mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)


mysql> select * from account where id = 1;
+----+--------+---------+
| id | name   | balance |
+----+--------+---------+
|  1 | lilei  |     350 |
+----+--------+---------+
```



（2）打开一个客户端B，更新相同的id为1的记录会被阻塞等待。

```
update account set balance=1000 where id = 1;
```

更新id为2的记录可以成功，说明在串行模式下innodb的查询也会被加上行锁。

如果客户端A执行的是一个范围查询，那么该范围内的所有行包括每行记录所在的间隙区间范围(就算该行数据
还未被插入也会加锁，这种是间隙锁)都会被加锁。此时如果客户端B在该范围内插入数据都会被阻塞，所以就
避免了幻读。
这种隔离级别并发性极低，开发中很少会用到。



# 三、锁详解

锁是计算机协调多个进程或线程并发访问某一资源的机制。
在数据库中，除了传统的计算资源（如CPU、RAM、I/O等）的争用以外，数据也是一种供需要用户共享的资
源。如何保证数据并发访问的一致性、有效性是所有数据库必须解决的一个问题，锁冲突也是影响数据库并发
访问性能的一个重要因素。

### 3.1、锁分类

- 从性能上分为乐观锁(用版本对比来实现)和悲观锁
- 从对数据库操作的类型分，分为读锁和写锁(都属于悲观锁)
  - 读锁（共享锁，S锁(`Shared`)）：针对同一份数据，多个读操作可以同时进行而不会互相影响
  - 写锁（排它锁，X锁(`eXclusive`)）：当前写操作没有完成前，它会阻断其他写锁和读锁
- 从对数据操作的粒度分，分为表锁和行锁



### 3.2、表锁

每次操作锁住整张表。开销小，加锁快；不会出现死锁；锁定粒度大，发生锁冲突的概率最高，并发度最低；
一般用在整表数据迁移的场景。

基本操作

```mysql
create table `mylock` (
      `id` int (11) not null auto_increment,
      `name` varchar (20) default null,
       primary key (`id`)
 ) engine = myisam default charset = utf8;

```

```mysql
insert into `mylock` (`id`, `name`) values ('1', 'a');
insert into `mylock` (`id`, `name`) values ('2', 'b');
insert into `mylock` (`id`, `name`) values ('3', 'c');
insert into `mylock` (`id`, `name`) values ('4', 'd');
```

手动增加表锁

```mysql
lock table mylock read;  -- write
```

查看表上加过的锁

```mysql
mysql> show OPEN TABLES where In_use > 0;
+----------+--------+--------+-------------+
| Database | Table  | In_use | Name_locked |
+----------+--------+--------+-------------+
| Test     | mylock |      1 |           0 |
+----------+--------+--------+-------------+
1 row in set (0.00 sec)
```

删除表锁

```mysql
mysql> UNLOCK TABLES;
Query OK, 0 rows affected (0.00 sec)
```



### 3.3、行锁

每次操作锁住一行数据。开销大，加锁慢；会出现死锁；锁定粒度最小，发生锁冲突的概率最低，并发度最

高。

`InnoDB`与`MYISAM`的最大不同有两点：

- `InnoDB` 支持行级锁，提供细粒度的并发控制，而 `MyISAM` 只支持表级锁，导致并发性能较差。

- `InnoDB` 支持事务，能够保证数据的一致性和完整性，而 `MyISAM` 不支持事务。

具体来讲：

- `MyISAM`在执行查询语句SELECT前，会自动给涉及的所有表加读锁,在执行update、insert、delete操作会自动给涉及的表加写锁。
- `InnoDB`在执行查询语句SELECT时(非串行隔离级别)，不会加锁。但是update、insert、delete操作会加行锁。

简而言之，就是读锁会阻塞写，但是不会阻塞读。而写锁则会把读和写都阻塞。

### 3.4、间隙锁

间隙锁Gap Lock)，锁的就是两个值之间的空隙。间隙锁是在可重复读隔离级别下才会生效。有办法解决幻读问题吗？间隙锁在某些情况下可以解决幻读问题。

假设account表里数据如下：

```mysql
mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from account;
+----+--------+---------+
| id | name   | balance |
+----+--------+---------+
|  1 | lilei  |    1000 |
|  2 | hanmei |    1000 |
|  3 | lucy   |    2400 |
| 10 | faker  |    5000 |
| 20 | zos    |    5000 |
+----+--------+---------+
5 rows in set (0.00 sec)
```

那么间隙就有 id 为 (3,10)，(10,20)，(20,正无穷) 这三个区间。在Session_1下面执行

```mysql
 update account set name = 'zhuge' where id > 8 and id <18;
```

如果Session_1 事务还没有提交，则其他Session没法在这个范围所包含的所有行记录(包括间隙行记录)以及行记录所在的间隙里插入或修改任何数据，即id在(3,20]区间都无法修改数据，注意最后那个20也是包含在内的。



### 3.5、临键锁 

Next-Key Locks是行锁与间隙锁的组合。像上面那个例子里的这个(3,20]的整个区间可以叫做临键锁。





### 无索引行锁会升级为表锁

锁主要是加在索引上，如果对非索引字段更新，行锁可能会变表锁。

session1 执行：

```mysql
update account set balance = 800 where name = 'lilei';
```

在session1 事务提交前，session2 对该表的插入或任一行的更新操作都会阻塞住。
`InnoDB` 的行锁是针对索引加的锁，不是针对记录加的锁。并且该索引不能失效，否则都会从行锁升级为
表锁。



锁定某一行还可以用lock in share mode(共享锁) 和for update(排它锁)，例如：

```mysql
select * from account where id = 1 lock in share mode;
select * from account where id = 1 for update;
```

 这样其他session只能读这行数据，修改则会被阻塞，直到锁定行的session提交。



### 行锁分析

通过检查`InnoDB_row_lock`状态变量来分析系统上的行锁的争夺情况

```mysql
mysql> show status like 'innodb_row_lock%';
+-------------------------------+-------+
| Variable_name                 | Value |
+-------------------------------+-------+
| Innodb_row_lock_current_waits | 0     |
| Innodb_row_lock_time          | 32525 |
| Innodb_row_lock_time_avg      | 4065  |
| Innodb_row_lock_time_max      | 7839  |
| Innodb_row_lock_waits         | 8     |
+-------------------------------+-------+
5 rows in set (0.00 sec)
```

- `Innodb_row_lock_current_waits`: 当前正在等待锁定的数量
- `Innodb_row_lock_time`: 从系统启动到现在锁定**总时间长度**
- `Innodb_row_lock_time_avg`: 每次**等待所花平均时间**
- `Innodb_row_lock_time_max`：从系统启动到现在等待最长的一次所花时间
- `Innodb_row_lock_waits`:系统启动后到现在**总共等待的次数**

尤其是当等待次数很高，而且每次等待时长也不小的时候，我们就需要分析系统中为什么会有如此多的等待，
然后根据分析结果着手制定优化计划。



查看INFORMATION_SCHEMA系统库锁相关数据表

在 MySQL 8 中，执行以下命令开启 Transaction Coordinator：

```mysql
UPDATE performance_schema.setup_instruments SET ENABLED = 'YES', TIMED = 'YES'
WHERE NAME LIKE '%transaction%';
```

执行以下命令查看当前活动的 `InnoDB` 事务信息：

```mysql
SELECT * FROM performance_schema.events_transactions_current;
```

如果你想查看所有连接的 `InnoDB` 事务信息，可以执行以下命令：

```mysql
SELECT * FROM performance_schema.events_transactions_history;
```



执行以下命令开启 performance_schema 的全局锁分类器

```mysql
UPDATE performance_schema.setup_instruments SET ENABLED = 'YES', TIMED = 'YES'
WHERE NAME LIKE '%wait/lock/%';
```

执行以下命令查看当前连接的锁信息：

```mysql
SELECT * FROM performance_schema.data_locks;
```



### 死锁

开启事务后 start transaction;

Session_1执行：select * from account where id=1 for update;
Session_2执行：select * from account where id=2 for update;
Session_1执行：select * from account where id=2 for update;
Session_2执行：select * from account where id=1 for update;

大多数情况 `mysql `可以自动检测死锁并回滚产生死锁的那个事务，但是有些情况 `mysql `没法自动检测死锁

查看近期死锁日志信息：

```mysql
show engine innodb status\G;
```

```mysql
------------------------
LATEST DETECTED DEADLOCK
------------------------
2023-12-22 10:48:39 140611412899392
*** (1) TRANSACTION:
TRANSACTION 134398, ACTIVE 17 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 3 lock struct(s), heap size 1128, 2 row lock(s)
MySQL thread id 1790, OS thread handle 140611732592192, query id 349964 localhost root statistics
select * from account where id=2 for update

*** (1) HOLDS THE LOCK(S):
RECORD LOCKS space id 29 page no 4 n bits 112 index PRIMARY of table `Test`.`account` trx id 134398 lock_mode X locks rec but not gap
Record lock, heap no 2 PHYSICAL RECORD: n_fields 5; compact format; info bits 0
 0: len 4; hex 80000001; asc     ;;
 1: len 6; hex 000000020cf3; asc       ;;
 2: len 7; hex 01000001440abe; asc     D  ;;
 3: len 5; hex 6c696c6569; asc lilei;;
 4: len 4; hex 80000320; asc     ;;
```

锁优化建议

- 尽可能让所有数据检索都通过索引来完成，避免无索引行锁升级为表锁
- 合理设计索引，尽量缩小锁的范围
- 尽可能减少检索条件范围，避免间隙锁
- 尽量控制事务大小，减少锁定资源量和时间长度，涉及事务加锁的sql尽量放在事务最后执行
- 尽可能低级别事务隔离