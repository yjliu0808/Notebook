### Activiti工作流管理系统API(本地部署)

#### API 说明

```java
请求方法:*POST/GET* 
请求头：content-type: application/json
 
```

```java
返回的数据
{"code": 20000,"message": "操作成功","data": {} }
```

#### 接口名称：新增空白流程模型

```java
调用地址:http://localhost:9528/dev-api/model
HTTP方法:post
请求格式:json
功能详述:新增空白流程模型
调用参数说明:
```

| 名称        | 类型   | 是否必须 | 描述           |
| :---------- | ------ | -------- | -------------- |
| name        | String | 是       | 模型名称(0-20) |
| key         | String | 是       | 标识Key(0-20)  |
| description | String | 否       | 备注(0-30)     |

```java
请求示例1：
{"name":"AAAAAAAAA","key":"AAAAAAAAA","description":"AAAAAAAAAAAAAA"}
响应数据：
{"code":20000,"message":"操作成功","data":"d781ad8f-a71e-11ec-87bc-40b89a76625f"}
```

#### 接口名称：新增空白流程模型查询

```
调用地址:http://localhost:9528/dev-api/model/list
HTTP方法:post
请求格式:json
功能详述:新增空白流程模型查询
调用参数说明:
```

| 名称 | 类型   | 是否必须 | 描述           |
| :--- | ------ | -------- | -------------- |
| name | String | 否       | 模型名称(0-20) |
| key  | String | 否       | 标识Key(0-20)  |

```java
请求示例1：
{"name":"AA"}
响应数据：
{"code":20000,"message":"操作成功","data":{"total":2,"records":[{"updateDate":"2022-03-19 08:52:24","name":"AAAAAAAAA","description":"AAAAAAAAAAAAAA","id":"d781ad8f-a71e-11ec-87bc-40b89a76625f","version":0,"key":"AAAAAAAAA","createDate":"2022-03-19 08:52:24"},{"updateDate":"2022-03-19 08:44:26","name":"AAAA","id":"ba5a690d-a71d-11ec-87bc-40b89a76625f","version":0,"key":"AAAAAAAAAAA","createDate":"2022-03-19 08:44:26"}]}}
```









