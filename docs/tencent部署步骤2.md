# 性能测试框架设计

### ✅ 一、整体目标

构建一个**接口级别的性能测试与监控框架**，可实现：

- 压测接口性能（TPS / 响应时间 / 并发能力）
- 监控服务器资源（CPU / 内存 / 网络等）
- 分析 JVM 性能（GC、线程、内存）
- 数据可视化（测试报告 + 实时图表）

------

### ✅ 二、框架选型与模块划分

| 模块           | 工具/技术                       | 用途                                       |
| -------------- | ------------------------------- | ------------------------------------------ |
| 接口压测       | **JMeter** 或 Gatling           | 支持 HTTP(S)、多线程模拟并发、参数化、断言 |
| JVM监控        | **JMX Exporter**                | 采集 JVM 指标（GC、内存、线程）            |
| 系统监控       | **Node Exporter**               | 采集服务器层面的指标（CPU、内存、磁盘）    |
| 资源监控       | **Server Agent**（JMeter 插件） | 图形化展示服务器性能数据（整合进JMeter）   |
| 数据采集与存储 | **Prometheus**                  | 统一采集指标、提供存储与查询能力           |
| 数据可视化     | **Grafana**                     | 自定义仪表盘，展示性能趋势、异常监控       |
| 报告生成       | **Allure + Jenkins**（可选）    | 测试历史报告归档，自动化执行               |
| 调度工具       | **Jenkins / Shell定时任务**     | 定时执行测试计划、触发构建或报警           |

------

### ✅ 三、测试流程设计（推荐）

```
plaintext复制编辑Jenkins 启动任务
    ↓
JMeter 执行接口压测脚本（含登录/注册/查询等接口）
    ↓
测试过程中：
    ↳ PerfMon 采集 CPU、内存等数据（插件）
    ↳ Node Exporter / JMX Exporter → Prometheus → Grafana 监控
    ↓
JMeter 聚合报告 / HTML Report / Allure 报告
    ↓
结果分析 / 性能瓶颈识别 / 提出优化建议
```

------

### ✅ 四、部署建议

| 部署节点             | 安装内容                                |
| -------------------- | --------------------------------------- |
| 测试客户端（压测机） | JMeter、Server Agent、Allure            |
| 被测服务器           | Node Exporter、JMX Exporter（Java项目） |
| 监控服务器（可合并） | Prometheus、Grafana                     |

### `.jmx` 脚本应该运行在 **压测机器** 上！

| 角色             | 机器                                       | 用途                    |
| ---------------- | ------------------------------------------ | ----------------------- |
| 💻 你的本地电脑   | Windows 11                                 | 安装了 JMeter（压测机） |
| 🌐 被测接口服务器 | 远程地址：http://129.28.122.208:8089/login | 提供 API 服务（被测）   |

#### 🚀 理解原理：

`.jmx` 是 **JMeter 的测试计划脚本**，它控制：

- 你要测试哪个接口
- 用多少线程并发
- 请求的频率、参数、断言
- 是否采集监控信息

⚠️ 所以它并不是部署给被测服务器执行的，而是运行在发起测试的机器上，**模拟大量客户端请求** 发向你被测的接口地址（无论是在公网、内网、本机还是远程服务器上）。

那么正确操作是：

1. `.jmx` 脚本放在你本地 JMeter 目录下（压测机）

2. 运行命令：

   ```
   
   jmeter -n -t login_test.jmx -l result.jtl -e -o report/
   ```

3. 脚本中的接口地址就是被测服务器的公网地址

   ```
   
   http://129.28.122.208:8089/login
   ```

4. JMeter 本地会不断发起请求给远程服务器，观察响应时间、吞吐量等性能指标

## ✅ 三、需要安装的工具清单

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

## ✅ 三、分步骤详细安装部署指南

### 🔷 A. 本地压测机（Windows 11）

#### 1️⃣ 安装 JMeter + PerfMon 插件

- 官网下载：https://jmeter.apache.org
- 解压后运行 `bin/jmeter.bat`
- PerfMon 插件已内置于新版 JMeter，无需额外安装

验证：

```
jmeter.bat      # 成功启动 GUI 即可
```

✅ 三、通过命令行运行 `.jmx` 脚本（推荐用于生成报告）

> 命令行执行更轻量、适合定时执行、支持自动生成报告。

### 命令格式：

```
jmeter -n -t mall.jmx -l result.jtl -e -o report/
```

```
jmeter -n -t D:\repository\jmx\api_auto_mall_v1.5test.jmx ^
-l D:\repository\jmx\CUI_api_auto_mall_v1.5test\result.jtl ^
-e -o D:\repository\jmx\CUI_api_auto_mall_v1.5test\report_2025_04_11
```



### 参数说明：

| 参数 | 含义                     |
| ---- | ------------------------ |
| `-n` | 非 GUI 模式运行          |
| `-t` | 测试计划文件路径（.jmx） |
| `-l` | 结果文件输出路径（.jtl） |
| `-e` | 开启 HTML 报告生成功能   |
| `-o` | HTML 报告输出目录        |

------

### ✅ 示例操作步骤：

假设你把文件放在：

- `D:\apache-jmeter-5.6.3\bin\login_test.jmx`

打开 PowerShell 或 cmd，执行：

```
cd D:\apache-jmeter-5.6.3\bin

jmeter -n -t mall.jmx -l result.jtl -e -o report
#这条命令中所有的文件路径（mall.jmx、result.jtl、report/）都是相对于你当前所在的命令行路径（当前目录）。
```

运行成功后会在 `report/` 目录下生成一个 HTML 报告。

用浏览器打开：

```
D:\apache-jmeter-5.6.3\bin\report\index.html
```

## 

#### 2️⃣ 安装 Prometheus

- 下载地址：https://prometheus.io/download

- ## ✅ 一、Prometheus 是什么？你为什么要用它？

  > **Prometheus 是一套开源的监控系统和时序数据库**，它最强的点就是：
  >
  > - 定时去抓你服务器、应用、系统、JVM 的各种指标数据（CPU、内存、GC 等）
  > - 把这些数据保存成时序数据（时间 + 指标值）
  > - 可视化展示（Grafana），或者用它来做告警（CPU > 90% 报警）

  ### ✅ 你的使用目标是：

  > 🧪 在**接口压测过程中**，通过 Prometheus 定时收集你服务器的系统资源（CPU、内存）和 Java 应用的 JVM 指标（GC、线程、内存等），**与 JMeter 的压测数据结合分析性能瓶颈。**

  ------

  ## ✅ 二、Prometheus 的运行方式（核心原理）

  ### 简化过程如下：

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

  ####  Prometheus 监控体系的**原理**：

  ##### ✅ `/metrics` 是 Prometheus 数据采集的“数据入口”

  ### 📌 简单理解就是：

  > **Prometheus 是通过访问 `/metrics` 这个 URL 来获取监控数据的！**

  ##### ✅ 为什么是 `/metrics` 这个路径？

  这是 Prometheus 的 **行业约定**：

   **Prometheus**怎么抓取数据：
  被测服务器需要将抓取信息暴露成 `/metrics`，才可以被抓取，所以，需要安装工具实现暴露。

  ① ❓Node Exporter / JMX Exporter 是干嘛的？**必须安装吗？**

  | 工具          | 安装在哪里？      | 干嘛的？                                         | 必须装吗？                      |
  | ------------- | ----------------- | ------------------------------------------------ | ------------------------------- |
  | Node Exporter | 被测服务器        | 把系统指标（CPU、内存、磁盘等）暴露成 `/metrics` | ✅ 是，想监控系统资源就得装      |
  | JMX Exporter  | Java 程序所在机器 | 把 JVM 运行时信息暴露成 `/metrics`               | ✅ 是，想监控 GC、堆、线程就得装 |

  📌 **它们不会主动发数据，它们只是一个“数据出口”，等 Prometheus 来拉（pull）**

  ------

  ### ② ❓Prometheus 是主动抓，还是别人推过来的？

  ✅ **Prometheus 是主动抓（pull 模式）**！

  ```
  Prometheus 每隔几秒，会按照配置中的 targets:
  → 主动访问 IP:端口/metrics
  → 拉取最新的监控数据
  → 存进自己的时序数据库
  ```

  

  ## ✅ 三、解压后进入目录，编辑 `prometheus.yml`：（最重要的部分）

  ### 一个最基本的结构：

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

  ## 启动 Prometheus：

```
prometheus.exe 
```

访问验证：http://localhost:9090



## 二、验证 Prometheus 是否安装完整 + 可采集目标

### 🔍 1. 查看采集目标状态（最关键）

打开 Prometheus 页面：

```
http://localhost:9090/targets
```

你将看到所有配置中的 targets（被抓取的主机）列表。

| job name      | target               | 状态 |
| ------------- | -------------------- | ---- |
| prometheus    | localhost:9090       | ✅ UP |
| node_exporter | 129.28.122.208:9100  | ✅ UP |
| jmx_exporter  | 129.28.122.208:12345 | ✅ UP |

✅ 如果这些目标状态是 `UP`，说明一切正常，采集开始了！

❌ 如果是 `DOWN`，你可以点进去看具体错误信息（例如端口未监听、防火墙没放行、连不上等）。

------

### 🔍 2. 尝试 PromQL 查询，验证数据流

在页面顶部点击 `Graph`，输入以下查询语句：

#### ✅ 系统监控类（Node Exporter）：

```

node_cpu_seconds_total
```

#### ✅ JVM监控类（JMX Exporter）：

```

jvm_memory_bytes_used
```

点击 **“Execute”**，然后切到 “Graph” 标签页看图表折线。

📌 如果有数据（哪怕是平的），说明指标已经在持续采集 ✅

------

### ✅ 测试查询 Prometheus 自身的指标

## ✅ 一、进入查询界面

在浏览器中打开 Prometheus 主页面：

```
http://localhost:9090
```

点击上方的 **[Graph]** 标签页
 在输入框中进行 PromQL 查询，点击 [Execute] 查看结果。

✅ 2. 再试几个经典 PromQL 查询：

| 查询指标             | PromQL                          | 含义                            |
| -------------------- | ------------------------------- | ------------------------------- |
| 当前活跃时间序列数   | `prometheus_tsdb_head_series`   | 多少个活跃监控指标              |
| Prometheus 内存占用  | `process_resident_memory_bytes` | 常驻内存使用量（单位：字节）    |
| 当前抓取成功次数     | `scrape_samples_scraped`        | 每次采集抓到了多少条指标数据    |
| 当前抓取失败目标数量 | `up`                            | 返回 0 表示目标 DOWN，1 表示 UP |

## ✅ 三、判断安装是否“完整”

| 检查项                       | 是否通过 | 说明                          |
| ---------------------------- | -------- | ----------------------------- |
| 能打开 `localhost:9090` 页面 | ✅        | Prometheus 主服务运行正常     |
| `Targets` 页面状态为 `UP`    | ✅        | 能抓到配置的 Node 和 JVM 数据 |
| PromQL 查询能查出指标数据    | ✅        | 指标抓取成功，入库成功        |
| 没有报错日志或启动异常       | ✅        | 安装无误                      |

------

#### 3️⃣ 安装 Grafana

- 官网：https://grafana.com/grafana/download

- 下载zip安装包解压后即可

- 启动 Grafana 服务

  cmd进入 `grafana\bin\` 目录，执行：

  ```
  cd "D:\install\static install\grafana-v11.6.0\bin"
  
  .\grafana-server.exe --homepath=.. --config=..\conf\defaults.ini
  
  ```

- 安装后访问：http://localhost:3000

- 无法访问一般可以重新下载解压，可能过程丢包了导致。

- 默认账号密码：`admin / admin`

### 📋 Grafana 菜单结构中英文对照表（Markdown）

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

## ✅ 第一步：登录 Grafana 后台

- 打开浏览器，访问：http://localhost:3000
- 默认账号密码：`admin / admin`
- 首次登录会提示修改密码

------

## ✅ 第二步：添加数据源（Data Source）

1. 左侧菜单 → 点击 **Connections > Data sources**

2. 选择你使用的数据源类型，比如：

   - **Prometheus**（常用于监控）

3. 点击右上角 **"Add new data source"**

4. 填写连接配置（URL、认证信息等）

   ✅ Prometheus 数据源配置 - 示例填写及中文解释

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

5. 点击 **“Save & Test”** 测试是否连接成功

   ### 🔍 **查看保存的数据源位置：**

   #### **1. 左侧边栏导航 → Connections（连接） → Data sources（数据源）**

------

## ✅ 第三步：创建仪表盘（Dashboard）

1. 左侧菜单 → 点击 **Dashboards > New Dashboard**

2. 点击 **`Add visualization`** 来添加一个可视化面板

3. 在 **Query** 区域选择你刚刚添加的数据源**选择数据源**
    左侧点击 **“Data source”** 下拉框，选择你刚添加的 `prometheus`。

4. 🔍 Query Options 设置说明与建议

   | 配置项名称          | 示例值 | 中文说明                            | 配置目的与建议使用场景                                       |
   | ------------------- | ------ | ----------------------------------- | ------------------------------------------------------------ |
   | **Max data points** | 500    | 最大数据点数                        | 控制图表中最多显示多少个点，防止页面卡顿。自动与面板宽度挂钩，建议保持默认。 |
   | **Min interval**    | 15s    | 最小时间间隔                        | 限制 Grafana 查询时使用的最小粒度，避免抓取过于频繁导致 Prometheus 压力过大。 一般设置为 Prometheus 的 `scrape_interval` 一致。 |
   | **Interval**        | 30s    | 实际查询时间间隔                    | 由 Grafana 计算出的最终采样间隔（用于 PromQL 中的 `rate(x[__interval__])`）。一般自动计算。 |
   | **Relative time**   | 1h     | 面板相对时间范围（如仅看最近1小时） | 覆盖整个 dashboard 的全局时间选择器，只针对当前面板有效。 适合展示“最近1小时 CPU 使用率”等。 |
   | **Time shift**      | 1d     | 时间偏移，如向前或向后偏移时间      | 示例：`1d` 表示显示“昨天的数据”。常用于对比图，例如今天 vs 昨天的负载趋势。 也可以用 `7d` 查看一周前同一时间的数据。 |

5. 🔍 **Query Inspector 是什么？**

   > Query Inspector 是用来 **查看查询请求和响应详情** 的调试面板，可以帮助你分析图表为什么没有数据、请求是否成功、查询是否高效等。

6. 🔍Grafana 中最核心的 **查询编辑器（Query Editor）**

   ### 🧩 📊 查询 Prometheus 数据并可视化 —— 你在图表中看到的线、图、表，就是从这里定义出来的！

   ------

   ## ✅ 图解说明（对照你看到的部分）

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

   ### ✅ **新手入门推荐用法：最简可视化图表配置（点选即可，无需写代码）**

   | 区域             | 参数名称                 | 示例 / 建议填写                   | 说明                                          |
   | ---------------- | ------------------------ | --------------------------------- | --------------------------------------------- |
   | A 区块（数据源） | 数据源名称               | `Prometheus`                      | 默认会自动选择你配置的数据源                  |
   | Metric           | 选择指标（必填）         | `node_cpu_seconds_total`          | Prometheus 中的一个时间序列指标               |
   | Label filters    | 指定标签过滤条件（可选） | `{mode="user"}` 或 `{job="node"}` | 过滤只查看某种标签数据，如 CPU 的 `user` 模式 |
   | Operations       | 应用函数（建议）         | `rate(...)`, `sum(...)`           | 选择运算函数，如 `rate()` 看增长速率          |
   | Legend           | 图例显示文字             | `用户CPU使用率`                   | 图表下方显示的文字，便于识别                  |
   | Format           | 图表数据格式             | `Time series`（默认）             | 时间序列数据                                  |
   | Type             | 查询类型                 | `Range`（默认）                   | 范围查询，拉取一段时间的数据                  |

   ------

   ### 🎯 **操作流程（快速上手）**

   1. 点击左侧 **Dashboards > New → New Dashboard**
   2. 点击 **Add visualization**
   3. 默认进入 Query Editor，有一个 A 区块 + Prometheus
   4. 选择一个常见指标，如：
      - `node_memory_MemAvailable_bytes`
      - `node_cpu_seconds_total`
   5. 添加 label filter（可选）：
      - `mode="idle"` 或 `instance="localhost:9100"`
   6. 选择操作函数（如 `rate(...)`）→ 自动包裹 Metric
   7. 设置图例（Legend）：比如 `CPU空闲率`
   8. 上方时间选择器设置为 `Last 1 hour` 或 `Last 5 minutes`
   9. 图表立刻展示，点击右上角 **Apply** 应用保存！

   ------

   ### 🖼 示例效果（你能看到什么）

   - 折线图显示了最近 1 小时内用户态 CPU 使用率的变化；
   - 鼠标悬停在图上，会显示具体时间点对应的值；
   - 图表下方的图例如“用户CPU使用率”方便识别数据线。

------





#### ✅ 2. 添加可视化面板（Visualization Panels）

点击页面上的「**Add visualization**」，开始添加图表，比如：

| 面板标题          | 指标 / 查询语句                                              | 图表类型           |
| ----------------- | ------------------------------------------------------------ | ------------------ |
| CPU 使用率        | `100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)` | Time series 折线图 |
| 内存使用率        | `node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes` | Gauge 或 Bar       |
| 磁盘读写速率      | `rate(node_disk_read_bytes_total[1m])` / `rate(node_disk_written_bytes_total[1m])` | Bar Chart          |
| 网络流入/流出速率 | `rate(node_network_receive_bytes_total[1m])` / `rate(node_network_transmit_bytes_total[1m])` | Time series 折线图 |

------

#### ✅ 3. 保存仪表盘

- 点击右上角「**Save dashboard**」💾；
- 输入名称、描述后保存即可。

=======================================================================================



### 🔷 B. 服务器（CentOS Stream）

#### 1️⃣ 安装 Node Exporter

```
# 下载并启动
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar -xzf node_exporter-1.7.0.linux-amd64.tar.gz
cd node_exporter-1.7.0.linux-amd64
#最简单的启动 Node Exporter 的方式之一
./node_exporter &
```

验证访问：http://129.28.122.208:9100/metrics

放行端口：

```
firewall-cmd --permanent --add-port=9100/tcp
firewall-cmd --reload
```

------

## Node Exporter 设置开机自启步骤（systemd 方式）

### 🔧 第一步：创建 systemd 服务文件

```

sudo nano /etc/systemd/system/node_exporter.service
```

粘贴以下内容（根据实际安装路径调整）：

```
startDelaySeconds: 0
ssl: false
lowercaseOutputName: true
lowercaseOutputLabelNames: true
rules:
  - pattern: 'java.lang:type=MemoryPool,name=(.*)'
    name: jvm_memory_pool_usage
    type: GAUGE
    labels:
      pool: "$1"
    attr:
      Usage.used: used
      Usage.max: max

```

> 🔁 若你放在 `/usr/local/bin/` 等目录，也请对应替换 `ExecStart` 路径。

------

### ✅ 第二步：重新加载 systemd 配置

```
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
```

------

### ✅ 第三步：启动 Node Exporter 服务

```

sudo systemctl start node_exporter
```

------

### ✅ 第四步：设置开机自启

```

sudo systemctl enable node_exporter
```

------

### 🔍 常用命令检查服务状态

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

------

## ✅ 验证 JMX Exporter 使用是否成功（完整流程）

### ✅ 步骤 1：确认应用是否正确启动了 JMX Exporter Agent

#### 查看启动命令是否包含以下内容：

```
java -javaagent:/athena/JMX_Exporter/jmx_prometheus_javaagent-0.20.0.jar=12345:/athena/JMX_Exporter/configs/config.yaml -jar /athena/mall/tuling-admin-0.0.1-SNAPSHOT.jar


```

请根据你的实际路径替换：

- `/opt/myapp/myapp.jar` → 你的 Java 应用
- `/opt/myapp/jmx_prometheus_javaagent-0.20.0.jar` → JMX Exporter 的 jar 路径
- `/opt/myapp/config/config.yaml` → 你的配置文件路径
- `12345` → 任意未被占用的端口号（Prometheus 将通过它抓取 metrics）

------

### ✅ 步骤 2：使用浏览器 访问 `/metrics` 页面

```

http://129.28.122.208:12345/metrics
```

如果看到一堆以 `jvm_`、`process_` 开头的指标，就说明 JMX Exporter 已成功挂载并运行。

------

### ✅ 步骤 3：Prometheus 配置中添加抓取目标

在 `prometheus.yml` 文件中增加如下 job：

```
yaml复制编辑scrape_configs:
  - job_name: 'my-java-app'
    static_configs:
      - targets: ['<服务器IP>:12345']
```

然后重启 Prometheus 服务：

```
bash


复制编辑
systemctl restart prometheus
```

------

### ✅ 步骤 4：在 Prometheus Web UI 验证

访问你的 Prometheus 页面（默认是 http://localhost:9090）：

- 输入 `jvm_memory_pool_usage_used` 或 `jvm_classes_loaded` 等关键字
- 如果能查到并有数据，就是成功了！

#### 2️⃣ 安装 JMX Exporter（仅Java服务需要）

```
 cd /athena/JMX_Exporter
wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.20.0/jmx_prometheus_javaagent-0.20.0.jar
```

```
# 新建 config.yaml 文件
mkdir  config
vim config/config.yaml
```

创建配置文件 `config.yaml`：

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

JMX Exporter 就能跟着你的 Java 服务一起 **开机自启并监听 `/metrics` 端口**。

## ✅ 修改tuling-admin.service 自启文件内容：

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

## 🧱 修改 & 重载生效：

```
bash复制编辑# 1. 编辑服务文件
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
访问浏览器验证：http://129.28.122.208:12345/metrics
若无法访问，检测云服务器是否开放端口
```

------

### 补充需要在Grafana 导入仪表板（面板）的json

[Node Exporter 主机状态监控](http://localhost:3000/d/node-status/8ec2f7a)

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

[Node Exporter 主机性能监控](http://localhost:3000/d/beikdv5i9beo0b/38913b3)

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
  "description": "本仪表盘用于展示通过 Node Exporter 收集的主机级系统指标，包括 CPU 使用率、内存占用、磁盘读写、网络流量等。\n数据来源于部署在各服务器的 Node Exporter 实例，Prometheus 每 15 秒抓取一次。",
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": 1,
  "links": [],
  "panels": [
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
          "editorMode": "code",
          "expr": "100 - (avg by(instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
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
      "description": "\t(1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100\t真实可用内存比总内存占比",
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
          "editorMode": "code",
          "expr": "100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "内存使用率（%）",
      "type": "timeseries"
    },
    {
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 16
      },
      "id": 2,
      "panels": [],
      "title": "T1",
      "type": "row"
    }
  ],
  "preload": false,
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
  "title": "Node Exporter 主机性能监控",
  "uid": "beikdv5i9beo0b",
  "version": 14
}
```

[Mall 系统性能监控（JVM 视角）](http://localhost:3000/d/90a892ec-37b9-4bc3-b4d3-78b5cacd64a1/4323227)

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















#### 3️⃣ 安装 Server Agent

✅ **监控服务器的系统资源使用情况**，并把这些数据发送到 JMeter（配合插件）进行实时性能分析🔧 Server Agent 通常与 **JMeter + PerfMon Metrics Collector 插件** 一起使用。

当你使用 JMeter 进行接口压测时，Server Agent 可以收集如下系统级指标：

| 监控内容       | 示例                 |
| -------------- | -------------------- |
| ✅ CPU 使用率   | 每核利用率、整体负载 |
| ✅ 内存使用情况 | 已用、剩余、Swap     |
| ✅ 磁盘 IO      | 读写速度、IO 等待率  |
| ✅ 网络吞吐量   | 上下行流量           |
| ✅ 进程资源消耗 | 可选扩展             |

```
cd /athena/ServerAgent
#可下载上传
https://github.com/undera/perfmon-agent/releases/download/2.2.3/ServerAgent-2.2.3.zip
#或者
wget https://download.fastgit.org/undera/perfmon-agent/releases/download/2.2.3/ServerAgent-2.2.3.zip

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

在 JMeter 添加 `PerfMon Metrics Collector` → Host 填 `129.28.122.208` → Port `4444`

## ✅ 二、设置ServerAgent开启自启

### 📌 创建 systemd 服务文件：

```

sudo vim /etc/systemd/system/server-agent.service
```

### 📋 写入以下内容（请按你实际路径修改）：

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

⚠️ 注意：`ExecStart` 中用了 `java -jar` 启动形式，而不是 `./startAgent.sh`，这样更标准。

------

## ✅ 三、重新加载并启动服务

```
systemctl daemon-reload
sudo systemctl enable server-agent.service
sudo systemctl start server-agent.service
sudo systemctl restart server-agent.service
```

------

## ✅ 四、验证是否生效

```
# 检查服务状态
sudo systemctl status server-agent.service

# 检查端口监听（默认 4444）
ss -tunlp | grep 4444
```



------

### 补充：服务器安装jmeter

## ✅ CentOS 安装 Apache JMeter 5.5 步骤（命令版）

------

### 📌 第 1 步：安装 Java 环境

| JMeter 版本 | 支持的 Java 版本           |
| ----------- | -------------------------- |
| 5.5         | ✅ Java 8 → Java 17（推荐） |

```

java -version
```

------

### 📌 第 2 步：下载 JMeter 5.5

```
cd /athena/jmeter
wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.5.zip
unzip apache-jmeter-5.5.zip
```

------

### 📌 第3 步：添加环境变量（可选）

编辑环境变量配置：

```
vim /etc/profile
```

写入内容：

```
export JMETER_HOME=/athena/jmeter/apache-jmeter-5.5
export PATH=$JMETER_HOME/bin:$PATH
```

------

### 📌 第 4 步：验证安装成功

```
source /etc/profile
jmeter -v
```



## ✅ 使用方式示例

------

### 👉 非 GUI 模式（生产压测）：

```
jmeter -n -t /path/to/test.jmx -l result.jtl -e -o report/
```

- `-n`：非图形模式
- `-t`：压测脚本路径
- `-l`：结果输出（.jtl）
- `-e -o`：生成 HTML 报告到 `report/` 目录

### 补充服务器配置 SSH 拉取 GitHub 仓库代码

你的 Git 仓库地址为：

 `git@github.com:yjliu0808/TESTCICD.git`

------

## 🔧 第一步：设置 Git 用户信息

```
git config --global user.name "yjliu0808"
git config --global user.email "yjliu0808@163.com"
```

------

## 🔧 第二步：生成 SSH 密钥对

```

ssh-keygen -t rsa -b 4096 -C "yjliu0808@163.com"
```

**提示：**

- 连续 3 次按 Enter 即可，默认生成：
  - 私钥：`~/.ssh/id_rsa`
  - 公钥：`~/.ssh/id_rsa.pub`

------

## 🔧 第三步：复制公钥并添加到 GitHub

```
cat ~/.ssh/id_rsa.pub
```

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJ194D9MMwRap6W/Vg3kddFMsz1C+gcp2OmvDkQjzXMfKWy4sUQys+OnFP07RL935BEeylss1MkadZSH8oKK0J18eFT5UOQE0TuGWDkytnnO3aij90ZMg1wgyzMMDv2OwkV+X37q+xGzyMV/aT3LoMNyVQmSt4jw3dukpKVNBFSaAqwyQYtUW/fF6h5MSYYWOGZ02Pf/ea+UgWMS3W2sVUsR9phNW8ArljVTlCtOUXqELvtHkJ3RFXl/gLDaAC+YmfWvnHUCdE1ISRyIXNxPk7oa+bDV7k3HgD5GoMrI77oNIyPiVRW75cGCYbncS7/rlKM6+RBzUq97vIyuq7e+LxY8QTs87o0nCvF9BsxLzxFeAcgesOkEZGAzQtfxXU7wqFw+7LByuGvPpiH3+8NLpyzZgBUJYWPKR6y9m0j+4n36mtPDYDqhtwiBU1W7KvGshnyIUbJuki738UZi/ytRXd5NAs6BZNOjp8RLQPDEH7Ryqz7y35qs4f6lnTddW5koxC6sCMFhsTOIkZIN6B6cYAaNi7szcfJk6nrhTGZg5M+AaqiPNIigqHDRWKQf1eBs56A3CSD6WImL/QFs1L0V1JBWfHgPNTnI1dKWVC7loc5cN5BvgPqWUuFhsgLraKsp4LHKGo+SbonYf7/kErbqiEuB70JM69ecFydE6qjXKFQQ== yjliu0808@163.com
```

复制输出内容，到 GitHub 网站执行：

1. 打开 GitHub → 右上角头像 → Settings
2. 左侧栏点击「SSH and GPG keys」→ 点右上角绿色按钮 `New SSH key`
3. 填：
   - **Title**: Jenkins SSH
   - **Key**: 粘贴上一步复制的内容
4. 点保存 ✅

------

## 🔧 第四步：测试 SSH 连通性

```

ssh -T git@github.com
```

如果你看到以下内容说明成功：

```

Hi yjliu0808! You've successfully authenticated, but GitHub does not provide shell access.
```

------

## 🔧 第五步：将私钥添加到 Jenkins 凭据

1. 进入 Jenkins：
    `Jenkins > Manage Jenkins > Credentials > Global > Add Credentials`
2. 添加信息如下：

| 字段        | 示例说明                              |
| ----------- | ------------------------------------- |
| Kind        | SSH Username with private key         |
| Username    | `git`（固定）                         |
| Private Key | `Enter directly`，然后粘贴私钥内容    |
| 私钥内容    | 执行 `cat ~/.ssh/id_rsa` 复制完整粘贴 |
| ID（可选）  | `github-ssh-key`（你记得住就行）      |
| Description | `GitHub SSH Key for TESTCICD`         |

------

## 🔧 第六步：修改 Jenkins 项目配置

打开你的 Jenkins 项目配置，设置为：

| 配置项           | 填写内容                                     |
| ---------------- | -------------------------------------------- |
| Repository URL   | `git@github.com:yjliu0808/TESTCICD.git`      |
| Credentials      | 选择刚刚添加的 SSH 凭据（如 github-ssh-key） |
| Branch Specifier | `*/main`                                     |
| Script Path      | `Jenkinsfile`（默认即可）                    |

------

## ✅ 第七步：点击构建验证

点击 `Build Now` → 成功拉代码说明配置完成！



## ✅ 四、完整测试流程

1. 保证所有服务都正常启动（Exporters、Server Agent）
2. 本地 JMeter GUI 或命令行运行 `.jmx` 脚本（测试 login、search 等接口）
3. PerfMon 收集资源曲线
4. Prometheus 收集 Exporter 指标
5. Grafana 展示系统资源 & JVM 性能趋势
6. JMeter 生成 HTML 报告
7. （可选）结合 Jenkins 定时触发执行