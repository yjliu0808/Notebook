### 性能测试GUI模式执行

+ JMETER-GUI模式 图像界面模式，只是用于 脚本开发以及调试脚本

+ CLI模式： no gui  无图像界面模式

+ jmeter -n

  + -n  no gui
  + -t  testplan 测试计划  jmx脚本文件
  + -l result 结果写入文件 jtl格式，**不存在**的文件
    + 因为命令行模式中，没有追加、覆盖功能，只能写在一个空文件
    + jmeter.save.saveservice.output_format=csv 这个配置要为csv
  + -e  转换
  + -o  输出   到一个**空文件夹**

  ```shell
  jmeter -n -t E:\Reository\GithubReository\Autotest\jmeter_jmx\Athenataotao.jmx -l E:\Reository\GithubReository\Autotest\jmeter_jmx0525.jtl -e -o E:\Reository\GithubReository\Autotest\jm0525
  ```

  

执行命令： 只能在进入jmeter的bin文件夹下执行， 因为我们没有配置jmeter的环境变量，所以jmeter这个命令不是系统命令，所以，要执行，必须在jmeter的bin文件夹下才能执行

命令执行的端口：4445 ~ 4455  10个端口 自动寻找这个端口区间

 html报告中取点时间间隔默认是1分钟 6w毫秒，如果觉得太长，可以修改 reportgreerator.properties中jmeter.reportgenerator.overall_granularity=60000