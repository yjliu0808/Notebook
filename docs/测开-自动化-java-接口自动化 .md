# 一、测开/自动化/java/接口自动化 

## 一、REST Assured

### 1、介绍

REST Assured是Java DSL，用于简化对基于HTTP Builder的基于REST的服务的测试。 它支持POST，GET，PUT，DELETE，OPTIONS，PATCH和HEAD请求，可用于验证和验证这些请求的响应。

#### 1.1、maven坐标

```
<dependency>
	<groupId>io.rest-assured</groupId>
	<artifactId>rest-assured</artifactId>
	<version>4.2.0</version>
</dependency>
```

### 2、静态导入

为了有效地使用REST，建议从以下类中静态导入（静态导入可直接调用其它类中的方法）方法：

```
import static io.restassured.RestAssured.*;
import static io.restassured.matcher.RestAssuredMatchers.*;
import static org.hamcrest.Matchers.*;
```

### 3、案例

- 模拟发送post请求：

```java
@Test
    public void  http_post() {
        Response response = given()
                .header("Content-Type", "application/json")
                .body("{\"Content\":\"测试\"}")
                .post("https://cloud.tencent.com/voc/gateway/DescribeRequirements");
        int statusCode = response.statusCode();
        Headers headers =response.headers();
        String body =response.asString();
        System.out.println(body);
    }
```



