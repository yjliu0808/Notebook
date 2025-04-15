# CentOS Stream 8接口性能框架部署手册



[TOC]



## ✅ 一、整体目标

构建一个**接口级别的性能测试与监控框架**，可实现：

- 压测接口性能（TPS / 响应时间 / 并发能力）
- 监控服务器资源（CPU / 内存 / 网络等）
- 分析 JVM 性能（GC、线程、内存）
- 数据可视化（测试报告 + 实时图表）

------

## ✅ 二、框架选型与模块划分

| 模块           | 工具/技术                   | 用途                                  |
| -------------- | --------------------------- | ------------------------------------- |
| 接口压测       | JMeter 或 Gatling           | 支持 HTTP、并发模拟、断言、参数化     |
| JVM 监控       | JMX Exporter                | 采集 JVM 指标（GC、内存、线程）       |
| 系统监控       | Node Exporter               | 采集服务器指标（CPU、内存、磁盘）     |
| 资源监控       | Server Agent（JMeter 插件） | 图形化展示服务器性能（整合进 JMeter） |
| 指标采集与存储 | Prometheus                  | 抓取指标并提供查询                    |
| 数据可视化     | Grafana                     | 展示性能趋势与监控面板                |
| 报告生成       | Allure + Jenkins（可选）    | 测试历史归档，自动化执行              |
| 调度工具       | Jenkins / Shell 定时任务    | 定时压测计划、触发构建、报警          |



------

## ✅ 三、测试流程概览

```
Jenkins 启动任务
    ↓
JMeter 执行压测脚本
    ↓
PerfMon/ServerAgent 收集资源指标
Node Exporter / JMX Exporter → Prometheus → Grafana
    ↓
JMeter HTML 报告 / Allure 报告生成
    ↓
分析结果，发现瓶颈，提出优化建议
```



------

## ✅ 四、部署建议

| 部署节点   | 安装内容                                |
| ---------- | --------------------------------------- |
| 本地压测机 | JMeter、Server Agent、Allure            |
| 被测服务器 | Node Exporter、JMX Exporter（Java服务） |
| 监控服务器 | Prometheus、Grafana                     |

## ✅ 五、需要安装的工具清单

| 安装机器       | 工具/服务                | 用途                                       | 安装后验证方式                            |
| -------------- | ------------------------ | ------------------------------------------ | ----------------------------------------- |
| **Windows 11** | JMeter                   | 发起接口压测                               | `jmeter.bat` 启动 GUI / 命令行执行 `.jmx` |
|                | PerfMon 插件             | 采集远程服务器性能指标（Server Agent）     | 添加监听器可看到指标曲线                  |
|                | Prometheus               | 收集 Node/JMX Exporter 指标                | 访问 `http://localhost:9090`              |
|                | Grafana                  | 展示性能趋势图表                           | 访问 `http://localhost:3000`              |
| **CentOS**     | API服务（你自己的）      | 被测接口                                   | curl 本地 IP 测试接口返回正常             |
|                | Node Exporter            | 系统级监控（CPU、内存、磁盘）              | `http://<server_ip>:9100/metrics`         |
|                | JMX Exporter（Java服务） | JVM 指标采集（GC、线程、内存）             | `http://<server_ip>:12345/metrics`        |
|                | Server Agent             | 给 JMeter 提供资源指标监控（配合 PerfMon） | JMeter 配置 PerfMon 后采集成功            |



## ✅ 六、本地压测机安装-  JMeter

### 📖 Prometheus 简介

> **Apache JMeter 是一款开源的性能测试工具，主要用于接口压力测试、负载测试与性能验证。**

它支持多种协议（HTTP、HTTPS、JDBC、SOAP、FTP、MQTT 等），可模拟大量并发用户访问目标接口，评估系统的吞吐量、响应时间、稳定性等关键性能指标。

### 📥 安装 JMeter + PerfMon 插件

- 官网：https://jmeter.apache.org
- 解压后运行 `bin/jmeter.bat`

- PerfMon 插件已内置于新版 JMeter，无需额外安装

- 验证：

  ```
  jmeter.bat      # 成功启动 GUI 即可
  ```

### 📟如何运行 .jmx 测试脚本（命令行模式）

> 命令行执行更轻量、适合定时执行、支持自动生成报告。
>
> 命令格式：
>
> ```
> jmeter -n -t mall.jmx -l result.jtl -e -o report/
> ```
>
> ```
> jmeter -n -t D:\repository\jmx\api_auto_mall_v1.5test.jmx ^
> -l D:\repository\jmx\CUI_api_auto_mall_v1.5test\result.jtl ^
> -e -o D:\repository\jmx\CUI_api_auto_mall_v1.5test\report_2025_04_11
> ```
>
> ### 参数说明：
>
> | 参数 | 含义                     |
> | ---- | ------------------------ |
> | -n   | 非 GUI 模式运行          |
> | -t   | 测试计划文件路径（.jmx） |
> | -l   | 结果文件输出路径（.jtl） |
> | -e   | 开启 HTML 报告生成功能   |
> | -o   | HTML 报告输出目录        |
>
> ------
>
> ### ✅ 示例操作步骤：
>
> 假设你把文件放在：
>
> - D:\apache-jmeter-5.6.3\bin\login_test.jmx
>
> 打开 PowerShell 或 cmd，执行：
>
> ```
> cd D:\apache-jmeter-5.6.3\bin
> 
> jmeter -n -t mall.jmx -l result.jtl -e -o report
> #这条命令中所有的文件路径（mall.jmx、result.jtl、report/）都是相对于你当前所在的命令行路径（当前目录）。
> ```
>
> 运行成功后会在 report/ 目录下生成一个 HTML 报告。
>
> 用浏览器打开：
>
> ```
> D:\apache-jmeter-5.6.3\bin\report\index.html
> ```
>



### 🧠 JMeter 运行压测脚本原理

> `.jmx` 脚本应该运行在 **压测机器** 上！

📌 场景角色说明

| 角色             | 机器                                       | 用途                    |
| ---------------- | ------------------------------------------ | ----------------------- |
| 💻 你的本地电脑   | Windows 11                                 | 安装了 JMeter（压测机） |
| 🌐 被测接口服务器 | 远程地址：http://129.28.122.208:8089/login | 提供 API 服务（被测）   |

**💡 理解原理：**

 **JMeter 的测试计划脚本**，它控制：

- [x] 你要测试哪个接口
- [x] 用多少线程并发
- [x] 请求的频率、参数、断言
- [x] 是否采集监控信息

**⚠️ 所以它并不是部署给被测服务器执行的，而是运行在发起测试的机器上，模拟大量客户端请求 发向你被测的接口地址（无论是在公网、内网、本机还是远程服务器上）。**

🚀 正确操作步骤：

1. 将 `.jmx` 文件放入 JMeter 的目录中（如 `bin/`）

2. 打开命令行终端，切换到该目录下

3. 执行以下命令进行压测

   ```
   jmeter -n -t login_test.jmx -l result.jtl -e -o report/
   ```

4. JMeter 本地会不断发起请求给远程服务器，观察响应时间、吞吐量等性能指标

5. 脚本中的接口地址就是被测服务器的公网地址

   ```
   http://129.28.122.208:8089/login
   ```

6. 报告生成后可用浏览器打开 `report/index.html` 查看压测趋势

## ✅ 七、本地压测机安装- Prometheus

### 📖 Prometheus 简介

> **Prometheus 是开源的监控系统与时序数据库，支持抓取服务器、JVM、系统等指标数据，并支持数据可视化与告警。**

你可以通过它：

- 定时去抓你服务器、应用、系统、JVM 的各种指标数据（CPU、内存、GC 等）
- 把这些数据保存成时序数据（时间 + 指标值）
- 可视化展示（Grafana），或者用它来做告警（CPU > 90% 报警）

✅ 你的使用目标是：

> 🧪 在**接口压测过程中**，通过 Prometheus 定时收集你服务器的系统资源（CPU、内存）和 Java 应用的 JVM 指标（GC、线程、内存等），**与 JMeter 的压测数据结合分析性能瓶颈。**

### 📥 下载 Prometheus

- 下载地址：https://prometheus.io/download
- 下载后解压完成后修改配置文件即可使用

### 📝  配置（prometheus.yml）

- **解压后进入目录，编辑 `prometheus.yml`：（最重要的部分）**

- 最基本的结构：可复制直接使用

  ```
  global:
    scrape_interval: 5s        # 每 5 秒采集一次数据，适合压测监控
    evaluation_interval: 5s    # 每 5 秒评估一次告警规则（可忽略）
  
  scrape_configs:
  
    - job_name: 'prometheus'
      static_configs:
        - targets: ['localhost:9090']   # 监控 Prometheus 自身运行情况
  
    - job_name: 'node_exporter'
      static_configs:
        - targets: ['129.28.122.208:9100']   # 替换为你的服务器 IP + Node Exporter 端口
  
    - job_name: 'jmx_exporter'
      static_configs:
        - targets: ['129.28.122.208:12345']  # 替换为你 Java 服务开启 JMX Exporter 的端口
  
  ```

  

### ▶️启动 Prometheus

```
prometheus.exe 
```

访问验证：http://localhost:9090



------

### 🧠Prometheus 监控体系原理

简化过程如下：

```
设置好的配置文件 prometheus.yml ↓
告诉 Prometheus：
   - 哪些主机（target）要抓
   - 多久抓一次
   - 怎么显示
Prometheus 就会定时去请求这些主机的 /metrics 接口
返回的指标数据就被保存下来
→ 你可以用 Prometheus Web UI 或 Grafana 查询这些数据
🖼️ Grafana 是最强大的 Prometheus 可视化面板工具
✅ 总结一句话：
Prometheus 是大脑（负责采集 + 存储 + 处理）
Grafana 是眼睛（负责展示 + 可视化 + 分析）
两者搭配，才能实现完整的监控闭环。
```

------

###  🧠**Prometheus **抓取数据原理

💡 `/metrics` 是 Prometheus 数据采集的“数据入口”

📌 简单理解就是：

> **Prometheus 是通过访问 `/metrics` 这个 URL 来获取监控数据的！**

❓ 为什么是 `/metrics` 这个路径？

> 📌 Prometheus 的 **行业约定**
>

❓**Prometheus**怎么抓取数据：

> 📌被测服务器需要将抓取信息暴露成 `/metrics`，才可以被抓取，所以，服务器需要安装Node Exporter / JMX Exporter 工具实现暴露。

❓Node Exporter / JMX Exporter 是干嘛的？**必须安装吗？**

| 工具          | 安装在哪里？      | 干嘛的？                                         | 必须装吗？                      |
| ------------- | ----------------- | ------------------------------------------------ | ------------------------------- |
| Node Exporter | 被测服务器        | 把系统指标（CPU、内存、磁盘等）暴露成 `/metrics` | ✅ 是，想监控系统资源就得装      |
| JMX Exporter  | Java 程序所在机器 | 把 JVM 运行时信息暴露成 `/metrics`               | ✅ 是，想监控 GC、堆、线程就得装 |

🎯 **它们不会主动发数据，它们只是一个“数据出口”，等 Prometheus 来拉（pull）**

------

❓Prometheus 是主动抓，还是别人推过来的？

🔄 **Prometheus 是主动抓（pull 模式）**！

```
Prometheus 每隔几秒，会按照配置中的 targets:
→ 主动访问 IP:端口/metrics
→ 拉取最新的监控数据
→ 存进自己的时序数据库
```



### 🔍 检查 Prometheus 抓取目标是否正常 UP

- 打开 Prometheus 页面：http://localhost:9090/targets

- 将看到所有配置中的 targets（被抓取的主机）列表：

- **📌jmx_exporter、node_exporter 安装后才是UP状态**

  | job name      | target               | 状态 |
  | ------------- | -------------------- | ---- |
  | prometheus    | localhost:9090       | ✅ UP |
  | node_exporter | 129.28.122.208:9100  | ✅ UP |
  | jmx_exporter  | 129.28.122.208:12345 | ✅ UP |

- 📌如果这些目标状态是 `UP`，说明一切正常，采集开始了！
- ❌ 如果是 `DOWN`，你可以点进去看具体错误信息（例如未安装工具、端口未监听、防火墙没放行等）

### 📈 PromQL 查询验证数据流

- 打开 Prometheus 页面：http://localhost:9090/

- 在页面顶部点击 **`Graph`**，Expression (press Shift+Enter for newlines) 位置，输入以下查询语句验证。

- 验证📡系统监控类（Node Exporter）可搜索：**node_cpu_seconds_total**

- 验证📡JVM监控类（JMX Exporter）可搜索：**jvm_memory_bytes_used**

- 验证📡Prometheus 自身的指标可搜索：**prometheus_tsdb_head_series**

  Prometheus 经典的PromQL 查询：

  | 查询指标             | PromQL                          | 含义                            |
  | -------------------- | ------------------------------- | ------------------------------- |
  | 当前活跃时间序列数   | `prometheus_tsdb_head_series`   | 多少个活跃监控指标              |
  | Prometheus 内存占用  | `process_resident_memory_bytes` | 常驻内存使用量（单位：字节）    |
  | 当前抓取成功次数     | `scrape_samples_scraped`        | 每次采集抓到了多少条指标数据    |
  | 当前抓取失败目标数量 | `up`                            | 返回 0 表示目标 DOWN，1 表示 UP |

- 点击 **“Execute”**，然后切到 “Graph” 标签页看图表折线。

- 📌 如果有数据（哪怕是平的），说明指标已经在持续采集 ✅

**🎯✅ 总结：Prometheus 配置检查与验证通过项**

| 检查项                       | 是否通过 | 说明                          |
| ---------------------------- | -------- | ----------------------------- |
| 能打开 `localhost:9090` 页面 | ✅        | Prometheus 主服务运行正常     |
| `Targets` 页面状态为 `UP`    | ✅        | 能抓到配置的 Node 和 JVM 数据 |
| PromQL 查询能查出指标数据    | ✅        | 指标抓取成功，入库成功        |
| 没有报错日志或启动异常       | ✅        | 安装无误                      |

------

## ✅ 八、本地压测机安装- Grafana

### 📖 Grafana 简介

> **Grafana 是一款开源的数据可视化平台**，可与 Prometheus、InfluxDB、ElasticSearch 等多种数据源对接，帮助用户构建实时仪表盘。你可以使用 Grafana 展示服务器监控、JVM 性能、接口压测趋势等图表，是性能监控体系中的核心展示工具

### 📥 下载 Grafana

- 官网：https://grafana.com/grafana/download
- 下载zip安装包解压后即可

### ▶️启动 Grafana 服务

- cmd进入 `grafana\bin\` 目录，执行：

  ```
  cd "D:\install\static install\grafana-v11.6.0\bin"
  
  .\grafana-server.exe --homepath=.. --config=..\conf\defaults.ini
  ```

- 安装后访问：http://localhost:3000
- 无法访问一般可以重新下载解压，可能过程丢包了导致。
- 默认账号密码：`admin / admin`

### 📋 Grafana 菜单结构

```
# Grafana 菜单结构（中英文对照）

| 菜单路径 | 英文名称 | 中文解释 |
|----------|-----------|----------|
| 📌 主菜单 | Grafana | Grafana 主入口 |
| ├── | Home | 首页，欢迎页面 |
| ├── | Bookmarks | 书签，标记的页面 |
| ├── | Starred | 已加星，收藏的仪表盘 |
| ├── | Dashboards | 仪表盘管理 |
| │   ├── | Playlists | 播放列表，用于轮播展示多个仪表盘 |
| │   ├── | Snapshots | 快照，用于保存与分享仪表盘状态 |
| │   ├── | Library panels | 组件库，复用的图表面板组件 |
| │   └── | Shared dashboards | 共享仪表盘 |
| ├── | Explore | 探索数据 |
| │   ├── | Metrics | 指标查询（例如 Prometheus） |
| │   ├── | Logs | 日志查询（例如 Loki） |
| │   └── | Profiles | 性能分析（例如 Pyroscope） |
| ├── | Alerting | 告警系统管理 |
| │   ├── | Alert rules | 告警规则定义 |
| │   ├── | Contact points | 联系方式配置（邮箱、Webhook 等） |
| │   ├── | Notification policies | 通知策略设置 |
| │   ├── | Silences | 告警静默设置 |
| │   ├── | Active notifications | 活跃中的告警通知 |
| │   └── | Settings | 告警系统设置 |
| ├── | Connections | 外部连接配置 |
| │   ├── | Add new connection | 添加新连接 |
| │   └── | Data sources | 数据源管理 |
| └── | Administration | 平台管理配置 |
    |    ├── General | 通用设置 |
    |    │   ├── Statistics and licensing | 统计信息与许可证 |
    |    │   └── Default preferences | 默认偏好设置（语言、主题等） |
    |    ├── Settings | 设置 |
    |    │   ├── Organizations | 组织管理（多租户） |
    |    │   └── Migrate to Grafana Cloud | 迁移到 Grafana Cloud |
    |    ├── Plugins and data | 插件与数据配置 |
    |    │   ├── Plugins | 插件管理 |
    |    │   └── Correlations | 数据源字段相关性配置 |
    |    └── Users and access | 用户与权限管理 |
          ├── Users | 用户列表 |
          ├── Teams | 团队（用户组）管理 |
          ├── Service accounts | 服务账号（供系统调用） |
          └── Authentication | 身份验证设置（OAuth、LDAP 等） |

```

### ⚙️Grafana 配置与使用

🔢 第一步：登录 Grafana 后台

- 打开浏览器，访问：http://localhost:3000
- 默认账号密码：`admin / admin`
- 首次登录会提示修改密码

------

🔢 第二步：添加数据源（Data Source）

- 左侧菜单 → 点击 **Connections > Data sources**

- 选择你使用的数据源类型，搜索：**Prometheus**（常用于监控）

- 点击右上角 **"Add new data source"**

  需要填写相关的Settings信息：

  ✅ Prometheus 数据源配置 -参考如下：

  ### 📄 Prometheus 数据源配置结构一览表（Grafana）

  | 配置分类   | 配置项名称（英文）              | 中文说明                   | 示例值                   | 配置目的 / 建议                                              |
  | ---------- | ------------------------------- | -------------------------- | ------------------------ | ------------------------------------------------------------ |
  | 🔹 基本信息 | Name                            | 数据源名称，建议与用途对应 | prometheus               | 作为 Grafana 中识别与调用该数据源的唯一标识，便于区分多个数据源 |
  | 🔹 连接设置 | Prometheus server URL           | Prometheus 服务地址        | http://localhost:9090/   | Grafana 拉取指标的接口地址，通常为 HTTP/HTTPS 地址           |
  | 🔹 认证方式 | Authentication method           | 认证方式（是否需要验证）   | No Authentication        | 若 Prometheus 开启认证（如 Basic/TLS），应配置相应认证方式   |
  | 🔹 TLS 设置 | Add self-signed certificate     | 添加自签证书（HTTPS）      | ❌                        | 若 Prometheus 使用自签名证书，需上传以建立信任               |
  |            | TLS Client Authentication       | 客户端证书认证             | ❌                        | 上传客户端证书与私钥，适用于双向认证                         |
  |            | Skip TLS certificate validation | 跳过 TLS 验证（测试用）    | ✅（测试环境）            | 测试环境可启用，生产环境不建议                               |
  | 🔹 高级设置 | Allowed cookies                 | 允许传递的 cookie 名称     | sessionid=abc            | 用于认证或跨系统传参                                         |
  |            | Timeout                         | 查询超时时间（秒）         | 60                       | 防止查询阻塞影响系统响应                                     |
  |            | Manage alerts via Alerting UI   | 启用报警管理界面           | ✅                        | 可视化管理告警规则与触发条件，推荐开启                       |
  |            | Scrape interval                 | 数据抓取时间间隔           | 15s                      | 建议与 Prometheus `scrape_interval` 一致                     |
  |            | Query timeout                   | 查询超时时间（格式带单位） | 60s                      | 防止长时间查询无响应                                         |
  |            | Interval behavior               | 区间行为控制               | auto / custom            | 自动选择或自定义评估时间区间                                 |
  |            | Default editor                  | 默认使用的查询编辑器       | Builder                  | Builder 为可视化编辑器，适合初学者                           |
  |            | Disable metrics lookup          | 禁用指标自动补全           | ❌                        | 默认不勾选，便于查询构造                                     |
  |            | Prometheus type                 | Prometheus 类型            | 空（默认）               | 保持默认，未来支持 Cloud 等特殊类型                          |
  |            | Cache level                     | 查询缓存等级               | Low / High               | 提高查询性能、减少 Prometheus 负载                           |
  |            | Incremental querying (beta)     | 增量查询支持（测试）       | ❌                        | 适用于大数据量优化，功能处于测试阶段                         |
  |            | Disable recording rules         | 禁用 recording rules 查询  | ❌                        | 默认开启，加快数据查询                                       |
  |            | Custom query parameters         | 自定义查询参数             | max_source_resolution=5m | 可限制返回数据精度或控制请求超时                             |
  |            | HTTP method                     | 查询请求使用方法           | POST                     | 推荐使用 POST，避免 URI 超长                                 |
  |            | Use series endpoint             | 使用标签维度查询 API       | ✅                        | 提升标签维度数据查询能力                                     |
  |            | Exemplars                       | 示例数据标签（traceID等）  | traceID / spanID         | 用于展示 tracing、metrics、logs 的关联信息                   |

**🔢 第三步：点击 “Save & Test”测试是否连接成功**

**🔢 第四步：查看保存的数据源位置：** 

- **左侧边栏导航 → Connections（连接） → Data sources（数据源）**



------

### 🛠️Grafana创建仪表盘（Dashboard）

1. 左侧菜单 → 点击**New >**  **Dashboards > New Dashboard**
2. 点击 **`Add visualization`** 来添加一个可视化面板
3. 在 **Query** 区域选择你刚刚添加的数据源**选择数据源:prometheus**
4. 填写一些查询指标后点击**Save dashboard**->仪表盘创建成功

### 📝Grafana的**查询编辑器（Query Editor）说明**



1. ❓ **Query Inspector 是什么？**

    > Query Inspector 是用来 **查看查询请求和响应详情** 的调试面板，可以帮助你分析图表为什么没有数据、请求是否成功、查询是否高效等。

2. ❓Grafana 中最核心的 **查询编辑器（Query Editor）**

    > 📊 查询 Prometheus 数据并可视化 —— 你在图表中看到的线、图、表，就是从这里定义出来的！

3. **📝Query Options 设置说明**

   | 配置项名称          | 示例值 | 中文说明                            | 配置目的与建议使用场景                                       |
   | ------------------- | ------ | ----------------------------------- | ------------------------------------------------------------ |
   | **Max data points** | 500    | 最大数据点数                        | 控制图表中最多显示多少个点，防止页面卡顿。自动与面板宽度挂钩，建议保持默认。 |
   | **Min interval**    | 15s    | 最小时间间隔                        | 限制 Grafana 查询时使用的最小粒度，避免抓取过于频繁导致 Prometheus 压力过大。 一般设置为 Prometheus 的 `scrape_interval` 一致。 |
   | **Interval**        | 30s    | 实际查询时间间隔                    | 由 Grafana 计算出的最终采样间隔（用于 PromQL 中的 `rate(x[__interval__])`）。一般自动计算。 |
   | **Relative time**   | 1h     | 面板相对时间范围（如仅看最近1小时） | 覆盖整个 dashboard 的全局时间选择器，只针对当前面板有效。 适合展示“最近1小时 CPU 使用率”等。 |
   | **Time shift**      | 1d     | 时间偏移，如向前或向后偏移时间      | 示例：`1d` 表示显示“昨天的数据”。常用于对比图，例如今天 vs 昨天的负载趋势。 也可以用 `7d` 查看一周前同一时间的数据。 |

4. **📝Add query和 Expression 设置说明**

   | 区块名称                  | 中文说明           | 作用 / 用途                                                  |
   | ------------------------- | ------------------ | ------------------------------------------------------------ |
   | **A (prometheus)**        | 查询编号和数据源   | A 是第一条查询，可以添加 B、C 等。括号里是选用的数据源类型，比如 Prometheus |
   | **Kick start your query** | 快速开始查询       | 引导新手构造 PromQL 查询                                     |
   | **Explain**               | 查询解释器（灰字） | 高级功能，能分析查询语法（如可用）                           |
   | **Run queries**           | 运行查询按钮       | 手动触发查询（一般自动触发）                                 |
   | **Metric**                | 选择指标           | Prometheus 中的指标名，例如 `node_cpu_seconds_total`         |
   | **Label filters**         | 选择标签过滤       | 筛选标签，如 `{job="node"}`，用于进一步缩小查询范围          |
   | **Operations**            | 运算操作           | 可添加数学运算，如 rate、sum、avg 等                         |
   | **Options**               | 查询设置           | 包含图例、格式、步长、时间类型、是否启用 exemplars 等        |
   | → Legend                  | 图例命名           | 替换默认图例显示名称（如 `CPU使用率`）                       |
   | → Format                  | 格式类型           | Time series（时序图） / Table（表格）                        |
   | → Step                    | 步长               | 自动或手动设置查询粒度，单位秒                               |
   | → Type                    | 查询类型           | Range（区间）查询 or Instant（瞬时值）查询                   |
   | → Exemplars               | 关联 trace 数据    | 是否显示 tracing 的 spanID/traceID（需支持）                 |
   | **Expression**            | PromQL 查询表达式  | 直接写 Prometheus 查询语句，如 `rate(http_requests_total[5m])` |
   | **Add query**             | 添加查询           | 添加 B、C... 查询，支持多线对比等操作                        |

   ------

   ### ✅ 📌 `Add query` 场景说明：

   > 用于**新增一条查询配置块**，通常用于多个查询组合展示（例如同图表中对比 CPU 与内存的使用），支持对比、多线图等。
   >  **适用场景**：你想添加第二条或更多 PromQL 查询来叠加展示。

   ------

   ### ✅ 📌 `Expression` 场景说明：

   > 用于**编写实际 PromQL 查询语句**，这是查询数据的核心。
   >  **适用场景**：你需要自定义查询内容，比如计算某个 rate、sum、avg、过滤标签等。

   ------

   - **📌 `Add query` 是“加一行”，用于多指标对比。**
   - **📌 `Expression` 是“写公式”，必须写 PromQL 查询语句。**

    

### 📝自定义添加可视化面板（Visualization Panels）

- 方案一：若已经创建好仪表盘：

  进入仪表盘点击右上方**Edid->Add->Visualization**

- 方案二：直接新建仪表盘同时新建面板：

  左侧菜单 → 点击**New >**  **Dashboards > New Dashboard**-> **`Add visualization`** 来添加一个可视化面板

- 填写相关的📌 `Add query` 或者📌 `Expression` 

- 点击右上角「**Save dashboard**」💾；

 **Node Exporter** 的系统监控指标参考：

| 面板标题          | 指标 / 查询语句                                              | 图表类型           |
| ----------------- | ------------------------------------------------------------ | ------------------ |
| CPU 使用率        | `100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)` | Time series 折线图 |
| 内存使用率        | `node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes` | Gauge 或 Bar       |
| 磁盘读写速率      | `rate(node_disk_read_bytes_total[1m])` / `rate(node_disk_written_bytes_total[1m])` | Bar Chart          |
| 网络流入/流出速率 | `rate(node_network_receive_bytes_total[1m])` / `rate(node_network_transmit_bytes_total[1m])` | Time series 折线图 |

------

### 📥导入 Grafana 仪表盘模板（Dashboard Template）

**🧭 操作步骤如下：**

1. **登录 Grafana**
   - 访问：http://localhost:3000
   - 默认账号密码：`admin / admin`
2. **打开导入界面**
   - 左侧边栏点击 **“Dashboards” ➜ New ➜ Import（导入）**
3. **选择导入方式**
   - 你可以选择：
     - 粘贴 `.json` 模板内容（推荐）
     - 上传 `.json` 文件
     - 输入仪表盘 ID（来自 Grafana 官方网站）

📌粘贴 `.json `后点击**下方的Load按钮**（注意是下方的按钮，上方是搜索ID的Load按钮）
📌下一步填写仪表盘Name，继续点击**Import**即可

✅ 导入完成后：

- 你将在左侧 **Dashboards ** 中看到新导入的仪表盘
- 点击即可查看可视化图表和实时数据

------

### 🧩导入Node Exporter 模板1

```
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "grafana",
          "uid": "-- Grafana --"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "description": "本仪表盘用于展示主机资源指标（Node Exporter）与 Go Runtime 性能（Go 应用暴露），如 GC、Goroutine、内存等。\n数据来源于 Prometheus。",
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": 17,
  "links": [],
  "panels": [
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "go_gc_duration_seconds{quantile=\"0.5\"} 表示中位数 GC 暂停时间",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 3,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "id": 100,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "go_gc_duration_seconds{quantile=\"0.5\"}",
          "legendFormat": "__auto",
          "refId": "A"
        }
      ],
      "title": "GC暂停耗时（秒）",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "go_goroutines 表示当前 goroutine 数量",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 3,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 0
      },
      "id": 101,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "go_goroutines",
          "legendFormat": "__auto",
          "refId": "A"
        }
      ],
      "title": "Goroutines 数量",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "go_memstats_alloc_bytes 表示当前已分配并使用的堆内存",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 3,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 8
      },
      "id": 102,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "go_memstats_alloc_bytes",
          "legendFormat": "__auto",
          "refId": "A"
        }
      ],
      "title": "Go 内存使用量",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "当前操作系统线程数（go_threads）",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 12,
        "x": 12,
        "y": 8
      },
      "id": 104,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "value",
        "wideLayout": true
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "go_threads",
          "refId": "A"
        }
      ],
      "title": "Go 线程数",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "堆上对象数量（go_memstats_heap_objects）",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "orange",
                "value": 50000
              },
              {
                "color": "red",
                "value": 100000
              }
            ]
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 12,
        "x": 12,
        "y": 12
      },
      "id": 105,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "value",
        "wideLayout": true
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "go_memstats_heap_objects",
          "refId": "A"
        }
      ],
      "title": "Go 内存对象数量",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "100 - (avg by(instance)(irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)\t计算非 idle 的 CPU 占比",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 16
      },
      "id": 7,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "100 - (avg by(instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
          "legendFormat": "__auto",
          "refId": "A"
        }
      ],
      "title": "CPU 使用率（%）",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "go_memstats_next_gc_bytes 表示 GC 触发时的堆内存阈值",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 3,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 16
      },
      "id": 103,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "go_memstats_next_gc_bytes",
          "legendFormat": "__auto",
          "refId": "A"
        }
      ],
      "title": "下一次 GC 阈值（字节）",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "Go 运行时的垃圾回收暂停时间分位数",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 24
      },
      "id": 107,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "go_gc_duration_seconds",
          "refId": "A"
        }
      ],
      "title": "🧠 GC 暂停时间（秒）",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "(1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100\t真实可用内存比总内存占比",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 24
      },
      "id": 106,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))",
          "legendFormat": "__auto",
          "refId": "A"
        }
      ],
      "title": "内存使用率（%）",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "磁盘读写总量变化速率（Prometheus rate 函数）",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 32
      },
      "id": 109,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "rate(node_disk_read_bytes_total[1m]) + rate(node_disk_written_bytes_total[1m])",
          "refId": "A"
        }
      ],
      "title": "💽 磁盘读写速率（bytes/sec）",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "Go 应用当前运行中的 goroutines 数量",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 32
      },
      "id": 108,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "go_goroutines",
          "refId": "A"
        }
      ],
      "title": "🧵 Goroutines 数量",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "网络接收与发送总量变化速率（Prometheus rate 函数）",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 40
      },
      "id": 110,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "rate(node_network_receive_bytes_total[1m]) + rate(node_network_transmit_bytes_total[1m])",
          "refId": "A"
        }
      ],
      "title": "🌐 网络流量（bytes/sec）",
      "type": "timeseries"
    }
  ],
  "preload": false,
  "refresh": "10s",
  "schemaVersion": 41,
  "tags": [
    "go",
    "node",
    "monitoring"
  ],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "Node Exporter 主机性能监控",
  "uid": "go-monitor-030250",
  "version": 5
}
```

### 🧩导入Node Exporter 模板2

```
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "grafana",
          "uid": "-- Grafana --"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": 20,
  "links": [],
  "panels": [
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 444287,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "100 - (avg by (instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[1m])) * 100)",
          "interval": "",
          "refId": "A"
        }
      ],
      "title": "CPU 利用率 (%)",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 24,
        "x": 0,
        "y": 8
      },
      "id": 444288,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100",
          "interval": "",
          "refId": "A"
        }
      ],
      "title": "内存使用率 (%)",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 24,
        "x": 0,
        "y": 16
      },
      "id": 444289,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "node_load1",
          "interval": "",
          "refId": "A"
        }
      ],
      "title": "系统负载（1m）",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 24
      },
      "id": 444290,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "node_netstat_Tcp_CurrEstab",
          "interval": "",
          "refId": "A"
        }
      ],
      "title": "TCP 活跃连接数",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "Mbps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 24
      },
      "id": 444291,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "rate(node_network_receive_bytes_total{device!=\"lo\"}[1m]) * 8 / 1000000",
          "interval": "",
          "refId": "A"
        }
      ],
      "title": "网卡入流量 (Mbps)",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "lineWidth": 2
          },
          "decimals": 2,
          "unit": "Mbps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 32
      },
      "id": 444292,
      "options": {
        "legend": {
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single"
        }
      },
      "targets": [
        {
          "expr": "rate(node_network_transmit_bytes_total{device!=\"lo\"}[1m]) * 8 / 1000000",
          "interval": "",
          "refId": "A"
        }
      ],
      "title": "网卡出流量 (Mbps)",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "lineWidth": 2
          },
          "decimals": 2,
          "unit": "KBps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 32
      },
      "id": 444293,
      "options": {
        "legend": {
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single"
        }
      },
      "targets": [
        {
          "expr": "rate(node_disk_read_bytes_total[1m]) / 1024",
          "interval": "",
          "refId": "A"
        }
      ],
      "title": "磁盘读取速率 (KB/s)",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "lineWidth": 2
          },
          "decimals": 2,
          "unit": "KBps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 40
      },
      "id": 444294,
      "options": {
        "legend": {
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single"
        }
      },
      "targets": [
        {
          "expr": "rate(node_disk_written_bytes_total[1m]) / 1024",
          "interval": "",
          "refId": "A"
        }
      ],
      "title": "磁盘写入速率 (KB/s)",
      "type": "timeseries"
    }
  ],
  "preload": false,
  "refresh": "30s",
  "schemaVersion": 41,
  "tags": [
    "system",
    "node_exporter"
  ],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-1h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "Node Exporter 全量监控面板",
  "uid": "node-exporter-custom",
  "version": 1
}
```



### 🧩导入Node Exporter状态模板

```
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "grafana",
          "uid": "-- Grafana --"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": 16,
  "links": [],
  "panels": [
    {
      "datasource": "prometheus",
      "description": "显示 node_exporter 是否在线，up=1 表示目标主机在线，0 表示离线。",
      "fieldConfig": {
        "defaults": {
          "mappings": [
            {
              "options": {
                "0": {
                  "text": "🔴 离线"
                },
                "1": {
                  "text": "🟢 在线"
                }
              },
              "type": "value"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red"
              },
              {
                "color": "green",
                "value": 1
              }
            ]
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "id": 1,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "up{job=\"node_exporter\"}",
          "refId": "A"
        }
      ],
      "title": "🟢 主机在线状态",
      "type": "stat"
    },
    {
      "datasource": "prometheus",
      "description": "显示系统最近一次启动的时间（Unix 时间戳格式）。",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [
            {
              "options": {
                "from": 0,
                "result": {
                  "text": "❌ 异常时间"
                },
                "to": 1000000000
              },
              "type": "range"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red"
              },
              {
                "color": "green",
                "value": 946684800
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 12,
        "x": 0,
        "y": 5
      },
      "id": 2,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "node_boot_time_seconds{job=\"node_exporter\"}",
          "refId": "A"
        }
      ],
      "title": "🔁 系统启动时间",
      "type": "timeseries"
    },
    {
      "datasource": "prometheus",
      "description": "当前系统运行的总时间，单位为秒（当前时间减去启动时间）。",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "green",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              }
            ]
          },
          "unit": "s"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 12,
        "x": 0,
        "y": 10
      },
      "id": 3,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "time() - node_boot_time_seconds{job=\"node_exporter\"}",
          "refId": "A"
        }
      ],
      "title": "⏱️ 主机运行时长",
      "type": "stat"
    },
    {
      "datasource": "prometheus",
      "description": "展示过去 1 天内主机是否发生重启，若值变化为 1 表示发生过一次重启。",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "green",
            "mode": "fixed"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 12,
        "x": 0,
        "y": 15
      },
      "id": 4,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "expr": "changes(node_boot_time_seconds{job=\"node_exporter\"}[1d])",
          "refId": "A"
        }
      ],
      "title": "📉 主机重启趋势",
      "type": "timeseries"
    }
  ],
  "preload": false,
  "refresh": "10s",
  "schemaVersion": 41,
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "Node Exporter 主机状态监控",
  "uid": "node-status",
  "version": 4
}
```



### 🧩导入 JMX Exporter 模板

```
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "grafana",
          "uid": "-- Grafana --"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": 15,
  "links": [],
  "panels": [
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "显示当前 JVM 堆内存的实际使用字节数（heap area）。",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "id": 1,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "ceik6h8omhfr4d"
          },
          "expr": "jvm_memory_bytes_used{area=\"heap\"}",
          "refId": "A"
        }
      ],
      "title": "堆内存使用量（Heap Used）",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "显示 JVM 非堆内存区域的使用字节数，例如方法区、类元数据区等。",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 0
      },
      "id": 2,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "ceik6h8omhfr4d"
          },
          "expr": "jvm_memory_bytes_used{area=\"nonheap\"}",
          "refId": "A"
        }
      ],
      "title": "非堆内存使用量（Non-Heap Used）",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "显示 JVM 垃圾回收器每分钟触发的次数（Copy、MarkSweepCompact等）。",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 8
      },
      "id": 3,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "ceik6h8omhfr4d"
          },
          "expr": "rate(jvm_gc_collection_seconds_count[1m])",
          "refId": "A"
        }
      ],
      "title": "GC 次数（每分钟）",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "展示 JVM 启动至今的总运行时长，单位为秒。",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 8
      },
      "id": 4,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "ceik6h8omhfr4d"
          },
          "expr": "time() - process_start_time_seconds",
          "refId": "A"
        }
      ],
      "title": "JVM 运行时长（秒）",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "展示当前 JVM 中所有活跃线程的总数。",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 16
      },
      "id": 5,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "ceik6h8omhfr4d"
          },
          "expr": "jvm_threads_current",
          "refId": "A"
        }
      ],
      "title": "当前线程数量",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "展示当前 JVM 中后台守护线程的数量。",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 16
      },
      "id": 6,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "ceik6h8omhfr4d"
          },
          "expr": "jvm_threads_daemon",
          "refId": "A"
        }
      ],
      "title": "守护线程数量",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "展示当前 JVM 已加载到内存中的类数量。",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 24
      },
      "id": 7,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "ceik6h8omhfr4d"
          },
          "expr": "jvm_classes_currently_loaded",
          "refId": "A"
        }
      ],
      "title": "已加载类数量",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "显示 Eden Space（年轻代）内存池中当前使用的字节数。",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 24
      },
      "id": 8,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "ceik6h8omhfr4d"
          },
          "expr": "jvm_memory_pool_bytes_used{pool=\"Eden Space\"}",
          "refId": "A"
        }
      ],
      "title": "内存池：Eden Space 使用量",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "ceik6h8omhfr4d"
      },
      "description": "显示 JVM 中 Metaspace（元空间）内存池的使用情况。",
      "fieldConfig": {
        "defaults": {},
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 32
      },
      "id": 9,
      "options": {},
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "ceik6h8omhfr4d"
          },
          "expr": "jvm_memory_pool_bytes_used{pool=\"Metaspace\"}",
          "refId": "A"
        }
      ],
      "title": "内存池：Metaspace 使用量",
      "type": "timeseries"
    }
  ],
  "preload": false,
  "refresh": "5s",
  "schemaVersion": 41,
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "Mall 系统性能监控（JVM 视角）",
  "uid": "90a892ec-37b9-4bc3-b4d3-78b5cacd64a1",
  "version": 2
}
```

###  🚨Grafana模板导入失败排查点

- 在导入 Grafana 仪表盘模板失败或图表无数据时，可按以下维度进行排查：

  #### 🔍 1. 验证指标地址是否可访问

  - 打开以下地址，确认是否能返回完整指标数据：
    - http://129.28.122.208:9100/metrics（Node Exporter）
    - http://129.28.122.208:12345/metrics（JMX Exporter）

  #### 🔍 2. 检查 Prometheus 配置文件

  - 打开 `prometheus.yml`，确认以下内容是否正确：
    - 是否包含上述 IP + 对应端口的抓取配置项（targets）
    - 格式是否正确、缩进无误

  #### 🔍 3. 对比 JSON 模板中的指标名称

  - 导入的 Grafana 模板内，是否使用了当前环境未暴露的指标？
    - 可通过文本编辑器搜索 JSON 内的 `expr:` 字段
    - 与浏览器访问 `/metrics` 返回的内容进行比对

  #### 🔍 4. 检查 JMX Exporter 配置文件

  - 打开 `config.yaml`，确认是否配置了实际存在的 MBean 指标
    - 避免拼写错误或不兼容的 `pattern`

## ✅ 九、 服务器安装 -Node Exporter

### 📖 Node Exporter简介

> **Node Exporter 是 Prometheus 官方提供的系统指标采集工具**，用于在 Linux 系统中暴露主机级别的监控数据。

### 📥 下载 Node Exporter

```
cd /athena/NodeExporter
# 下载
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
# 解压
tar -xzf node_exporter-1.7.0.linux-amd64.tar.gz
# 进入解压目录
cd node_exporter-1.7.0.linux-amd64
#启动 Node Exporter 

```

### ▶️启动 Node Exporter

```
./node_exporter &
```

✅验证访问：http://129.28.122.208:9100/metrics

📌放行端口：可选

```
firewall-cmd --permanent --add-port=9100/tcp
firewall-cmd --reload
```

------

### 🔧 设置Node Exporter开机自启

🔢 第一步：创建 systemd 服务文件：

```
sudo nano /etc/systemd/system/node_exporter.service
```

🔢 第二步：编辑 systemd 服务文件：粘贴以下内容（根据实际安装路径调整）

> 若放在 `/usr/local/bin/` 等目录，也请对应替换 `ExecStart` 路径。

```

[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=nobody
# 修改为你的实际路径
ExecStart=/athena/Node_Exporter/node_exporter-1.7.0.linux-amd64/node_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target

```

🔢 第三步：重新加载 systemd 配置

```
#重新加载 systemd 配置
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
```

🔢 第四步：启动 Node Exporter 服务

```
sudo systemctl start node_exporter
```

🔢 第五步：设置开机自启

```
sudo systemctl enable node_exporter
```

🔍 常用命令检查服务状态

```
# 查看状态
sudo systemctl status node_exporter

# 停止服务
sudo systemctl stop node_exporter

# 重启服务
sudo systemctl restart node_exporter

# 查看监听端口
ss -tuln | grep 9100
```



## ✅ 十、服务器安装 - JMX Exporter（仅Java服务需要）

### 📖 JMX Exporter简介

> **JMX Exporter 是一款用于将 Java 应用中的 JMX 指标转换为 Prometheus 可采集格式的中间件。**

它以 **Java Agent（代理）** 的形式运行，在启动 Java 程序时一并加载，无需改动业务代码，即可暴露 JVM 指标接口供 Prometheus 抓取。

### 📥 下载  JMX Exporter

```
cd /athena/JMX_Exporter
wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.20.0/jmx_prometheus_javaagent-0.20.0.jar
```

### 📁 创建 JMX Exporter 配置文件 `config.yaml`

```
# 📁 创建 JMX Exporter 配置文件 config.yaml

# 新建目录 `config` 用于存放配置文件：位置可以任意。eg:cd /athena/JMX_Exporter

mkdir config
vim config/config.yaml
```

- ✏️编辑配置文件 `config.yaml`

```
startDelaySeconds: 0
ssl: false
lowercaseOutputName: true
lowercaseOutputLabelNames: true

rules:
  # JVM Heap & Non-Heap memory usage
  - pattern: 'java.lang:type=Memory'
    name: jvm_memory_bytes
    type: GAUGE
    attr:
      HeapMemoryUsage.used: heap_used
      HeapMemoryUsage.max: heap_max
      NonHeapMemoryUsage.used: nonheap_used
      NonHeapMemoryUsage.max: nonheap_max

  # JVM MemoryPool usage
  - pattern: 'java.lang:type=MemoryPool,name=(.*)'
    name: jvm_memory_pool_bytes
    type: GAUGE
    labels:
      pool: "$1"
    attr:
      Usage.used: used
      Usage.max: max
      Usage.committed: committed
      Usage.init: init

  # JVM GC collection
  - pattern: 'java.lang:type=GarbageCollector,name=(.*)'
    name: jvm_gc_collection_seconds
    type: SUMMARY
    labels:
      gc: "$1"
    attr:
      CollectionCount: count
      CollectionTime: sum

  # JVM class loading
  - pattern: 'java.lang:type=ClassLoading'
    name: jvm_classes
    type: GAUGE
    attr:
      LoadedClassCount: loaded
      UnloadedClassCount: unloaded

  # JVM threads
  - pattern: 'java.lang:type=Threading'
    name: jvm_threads
    type: GAUGE
    attr:
      ThreadCount: count
      DaemonThreadCount: daemon
      PeakThreadCount: peak
      TotalStartedThreadCount: total_started

  - pattern: 'java.lang:type=Threading'
    name: jvm_threads_state
    type: GAUGE
    attr:
      ThreadCount: value
    labels:
      state: RUNNABLE

  # JVM process uptime
  - pattern: 'java.lang:type=Runtime'
    name: process_uptime_seconds
    type: GAUGE
    attr:
      Uptime: uptime

  # JVM compilation time
  - pattern: 'java.lang:type=Compilation'
    name: jvm_compilation_time_seconds
    type: COUNTER
    attr:
      TotalCompilationTime: total

```



### ▶️启动  JMX Exporter

> 📌 **JMX Exporter 通常作为 Java 应用的 Agent 与服务一同启动，自动监听指定的 `/metrics` 端口，向 Prometheus 暴露 JVM 运行指标。**

- 由于Java服务是开机自启，所以启动 JMX Exporter，可以添加自启文件实现

- ✏️ 修改tuling-admin.service 自启文件内容：

```
# 1. 编辑服务文件
sudo vim /etc/systemd/system/tuling-admin.service
```

**📝修改内容如下：**

```
[Unit]
Description=Tuling Admin Spring Boot Service
After=network.target

[Service]
User=root
WorkingDirectory=/athena/mall
ExecStart=/athena/jdk/jdk1.8.0_371/bin/java -javaagent:/athena/JMX_Exporter/jmx_prometheus_javaagent-0.20.0.jar=12345:/athena/JMX_Exporter/configs/config.yaml -jar /athena/mall/tuling-admin-0.0.1-SNAPSHOT.jar
SuccessExitStatus=143
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=tuling-admin

[Install]
WantedBy=multi-user.target
```

------

🧱 修改 & 重载生效：

```
# 1. 编辑服务文件
sudo vim /etc/systemd/system/tuling-admin.service

# 2. 重新加载 systemd 配置
sudo systemctl daemon-reload

# 3. 重启服务测试是否正常运行
sudo systemctl restart tuling-admin

# 4. 查看状态确认成功
sudo systemctl status tuling-admin

# 5. 验证 JMX Exporter 是否运行
curl http://localhost:12345/metrics
```

```
访问浏览器验证：
若无法访问，检测云服务器是否开放端口
```

------

✅验证访问：http://129.28.122.208:12345/metrics

📌放行端口：可选

```
firewall-cmd --permanent --add-port=12345/tcp
firewall-cmd --reload
```



### 🚨 JMX Exporter 使用状态排查指南

**🧩 步骤 1：确认 Java 启动命令中已挂载 JMX Exporter**

- 确保Java 启动命令包含 `-javaagent` 参数，如下所示：
  📌请根据你的实际路径替换

  ```
  java -javaagent:/athena/JMX_Exporter/jmx_prometheus_javaagent-0.20.0.jar=12345:/athena/JMX_Exporter/configs/config.yaml -jar /athena/mall/tuling-admin-0.0.1-SNAPSHOT.jar
  ```

**🔧 参数说明：**

| 项目                | 示例路径                                                   | 说明                           |
| ------------------- | ---------------------------------------------------------- | ------------------------------ |
| Java 应用 Jar       | `/athena/mall/tuling-admin-0.0.1-SNAPSHOT.jar`             | 你的业务程序                   |
| JMX Exporter Jar 包 | `/athena/JMX_Exporter/jmx_prometheus_javaagent-0.20.0.jar` | JMX Exporter 的核心组件        |
| 配置文件路径        | `/athena/JMX_Exporter/configs/config.yaml`                 | 负责定义导出哪些 JVM 指标      |
| 监听端口            | `12345`                                                    | 暴露指标的 HTTP 端口（自定义） |

**🌐 步骤 2：验证 `/metrics` 是否可访问**

```
访问：http://129.28.122.208:12345/metrics
```

**⚙️ 步骤 3：Prometheus的prometheus.yml是否添加 JMX 抓取目标**

-  `prometheus.yml` 文件中增加如下 job：

```
  - job_name: 'jmx_exporter'
    static_configs:
      - targets: ['129.28.122.208:12345']  # 替换为你 Java 服务开启 JMX Exporter 的端口
```

```
# 重启 Prometheus 服务：
systemctl restart prometheus
```

------

**🔍 步骤 4：在 Prometheus Web UI 验证指标**

- 访问 Prometheus 页面（默认是 http://localhost:9090）：

- 输入 PromQL 查询语句验证，如：

  ```
  jvm_memory_pool_bytes_used
  jvm_classes_loaded
  ```

- 如果能查到并有数据，就是成功了！✅



## ✅ 十一、 服务器安装 -Server Agent

### 📖 Server Agent简介

> **Server Agent** 是配合 JMeter 使用的轻量级服务器性能监控工具，用于在压测过程中实时采集服务器资源数据，如 **CPU 使用率、内存、磁盘、网络** 等。
>
> 它常与 JMeter 插件 **PerfMon Metrics Collector** 联动使用，实现将远程服务器性能指标绘制为可视化图表，便于分析接口性能瓶颈与资源瓶颈的关系。

🧰  JMeter 进行接口压测时，Server Agent 可以收集如下系统级指标：

| 监控内容       | 示例                 |
| -------------- | -------------------- |
| ✅ CPU 使用率   | 每核利用率、整体负载 |
| ✅ 内存使用情况 | 已用、剩余、Swap     |
| ✅ 磁盘 IO      | 读写速度、IO 等待率  |
| ✅ 网络吞吐量   | 上下行流量           |
| ✅ 进程资源消耗 | 可选扩展             |

### 📥 下载 Server Agent

```
cd /athena/ServerAgent
#可下载上传
https://github.com/undera/perfmon-agent/releases/download/2.2.3/ServerAgent-2.2.3.zip
#或者
wget https://download.fastgit.org/undera/perfmon-agent/releases/download/2.2.3/ServerAgent-2.2.3.zip
# 解压
unzip server-agent-3.3.1.zip

cd server-agent
chmod +x startAgent.sh
./startAgent.sh &
```

放行端口：

```
firewall-cmd --permanent --add-port=4444/tcp
firewall-cmd --reload  
```

### ▶️启动  Server Agent

```
cd /athena/ServerAgent
chmod +x startAgent.sh
./startAgent.sh &
```

### 🛠️ 如何使用 Server Agent 配合 JMeter 获取服务器性能指标

🧰JMeter 添加 PerfMon 监听器

1. 打开你的 `.jmx` 脚本
2. 添加监听器：**Backend Listener → PerfMon Metrics Collector**
3. 配置目标服务器 IP 和端口（默认为 `4444`）
4. 选择需要采集的指标，如：
   - CPU
   - Memory
   - Network I/O
   - Disk I/O
5. 执行压测并观察图表:
   - 在 JMeter 启动测试前，确保 Server Agent 正常运行
   - 监听器将实时展示性能趋势图
   - 支持在报告中保留该图表用于分析

🔍 注意事项

- Server Agent 默认监听 `4444` 端口，需放行防火墙
- Server Agent 仅支持被动监听（不主动上报）
- 可与 Prometheus 无冲突共存，但用途不同

------

### 🔧 设置ServerAgent开机自启

🔢 第一步：创建 systemd 服务文件：

```

sudo vim /etc/systemd/system/server-agent.service
```

🔢 第二步：编辑 systemd 服务文件：粘贴以下内容（根据实际安装路径调整）

> 若放在 `/usr/local/bin/` 等目录，也请对应替换 `ExecStart` 路径。

```
[Unit]
Description=JMeter Server Agent for PerfMon Metrics
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/athena/ServerAgent/ServerAgent-2.2.3
ExecStart=/athena/ServerAgent/ServerAgent-2.2.3/startAgent.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target

```

🔢 第三步：重新加载 systemd 配置

```
systemctl daemon-reload

```

🔢 第四步：启动 Node Exporter 服务

```
sudo systemctl start server-agent.service
sudo systemctl restart server-agent.service
```

🔢 第五步：设置开机自启

```
sudo systemctl enable server-agent.service
```

🔍 常用命令检查服务状态

```
# 查看服务运行状态
sudo systemctl status server-agent.service

# 检查监听端口（默认是 4444）
ss -tunlp | grep 4444

```



------

## ✅ 十二、 服务器安装 -JMeter

> **JMeter 是 Apache 基金会开源的一款强大接口性能测试工具**，用于模拟多用户对 Web 服务进行并发请求，评估系统性能。

❓ 你可以用 JMeter 做什么？

- 模拟海量用户并发访问，压测接口的响应时间与稳定性
- 支持 HTTP(S)、WebSocket、JDBC、FTP、SOAP、MQ 等协议
- 配置参数化、断言、逻辑控制器，实现复杂的测试逻辑
- 结合 PerfMon 插件，可收集被测服务器的 CPU、内存等资源指标
- 支持非 GUI 模式运行，适合结合 Jenkins 执行持续压测任务
- 可生成 HTML 报告用于结果分析，也可接入 Allure、Grafana 可视化展示

------

### 📥下载 JMeter 

✅ 前提：已安装 Java 环境（JDK 8 或以上）

```
java -version
```

```
cd /athena/jmeter
wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.5.zip
unzip apache-jmeter-5.5.zip
```

### 📝添加环境变量

```
vim /etc/profile
```

```
export JMETER_HOME=/athena/jmeter/apache-jmeter-5.5
export PATH=$JMETER_HOME/bin:$PATH
```

🔍验证安装成功

```
source /etc/profile
jmeter -v
```

### 🚀 JMeter 压测命令行运行示例

假设你在 `D:\tools\apache-jmeter\bin\` 下运行命令，并把 `login_test.jmx` 放在这里：

```
jmeter -n -t login_test.jmx -l result.jtl -e -o report/

```

执行后将生成：

- `result.jtl` 在当前目录下
- `report/` 报告目录也会出现在当前目录

| 参数                   | 含义                       | 路径说明                                                     |
| ---------------------- | -------------------------- | ------------------------------------------------------------ |
| `-n`                   | 非 GUI 模式运行            | 无需图形界面，适合生产压测                                   |
| `-t /path/to/test.jmx` | 指定 `.jmx` 脚本路径       | 可以是**绝对路径**或**相对路径**，如 `./login_test.jmx` 表示当前路径 |
| `-l result.jtl`        | 保存测试结果到 `.jtl` 文件 | `result.jtl` 会保存在**当前目录**                            |
| `-e -o report/`        | 根据 `.jtl` 生成 HTML 报告 | `report/` 是输出目录，相对当前路径，自动创建                 |





