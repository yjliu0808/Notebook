通过restassured发起请求demo

- pom.xml文件配置jar包

  ```xml
   <dependency>
              <groupId>io.rest-assured</groupId>
              <artifactId>rest-assured</artifactId>
              <version>4.2.0</version>
          </dependency>
          <dependency>
              <groupId>org.testng</groupId>
              <artifactId>testng</artifactId>
              <version>7.5</version>
              <scope>test</scope>
          </dependency>
      </dependencies>
  ```

- post请求接口

  ```java
  @Test
      public void  http_post() {
          String bodyData = given()
                          .header("Content-Type", "application/json")
                          .body("{\"Content\":\"测试\"}")
                          .post("https://cloud.tencent.com/voc/gateway/DescribeRequirements").asString();
          System.out.println(bodyData);
      }
  ```

  

