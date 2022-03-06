

### 虚拟机可运行的test项目

#### API 说明

```json
请求方法:*POST/GET* 
请求头：Content-Type：application/json;charset=utf-8 
Accept：application/json 
```

```json
返回的数据
{ “code”:0, "msg":"调用成功", "data":{} }
```

#### 接口名称：注册 

```json
调用地址:/app/mobile/api/user/register
HTTP方法:post
请求格式:json
功能详述:注册用户信息
调用参数说明:
```

| 名称     | 类型   | 是否必须 | 描述                                |
| :------- | ------ | -------- | ----------------------------------- |
| mobile   | String | 是       | 用户手机号码                        |
| password | String | 是       | 密码                                |
| platform | String | 是       | 登陆平台(1:ios,2:android,3:windows) |
| username | String | 否       | 用户名                              |
| sex      | Int    | 否       | 用户性别                            |
| age      | Int    | 否       | 用户年龄                            |
| email    | String | 否       | 用户邮箱                            |
| code     | String | 是       | 验证码                              |

```json
请求示例1：
{"mobile":"13246520010","password":"123456","code":"1234","platform":"windows","username":"Athena","sex":0,"age":20,"email":"1234562001@163.com"}
请求示例2：
{"mobile":"13246520015","password":"123456","code":"1234","platform":"windows"}
响应数据：
{"code":0,"msg":"成功调用","data":{"id":160062,"username":"4000002","sex":1,"age":20,"mobile":"13246520015","email":"","gqid":"4000002","money":0.0,"pmoney":100.0,"createtime":1646574889553,"lasttime":1646574889553,"token":"25/EjJrOO6JjeDVVsGs8WQx6oBoniYqFWUvwGnKKy70cpTHtmUbOY7UF4SovuP4pxRU/jxaEwo/fQbjJJq9BrA==","identity":"902b7889999f0399"}}

```

#### 接口名称：登录

```json
调用地址:/app/mobile/api/user/login
HTTP方法:post
请求格式:json
功能详述:用户登录
调用参数说明:
```

| 名称     | 类型   | 是否必须 | 描述                   |
| :------- | ------ | -------- | ---------------------- |
| mobile   | String | 是       | 用户手机号码           |
| gqid     | String | 是       | 手机号或 gqid 其中一个 |
| password | String | 是       | 密码                   |

```json
请求示例1：
{"mobile":"13246520010","password":"123456","gqid":"13246520010"}
请求示例2：
{"mobile":"13246520015","password":"123456","gqid":"4000002"}
响应数据：
{"code":0,"msg":"成功调用","data":{"id":160061,"username":"Athena","sex":0,"age":20,"mobile":"13246520010","email":"1234562001@163.com","gqid":"4000001","money":0.0,"pmoney":100.0,"createtime":1646574796000,"lasttime":1646575383092,"token":"Co3LD577nOpXlQn4DfSLcq75wU1RLALfOMDQMZIe6ZUhdB0ts6uvtJOQJ+/uLdBPxRU/jxaEwo/fQbjJJq9BrA==","identity":"dc3294b90bcfd501"}}


```

