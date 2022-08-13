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

### 4.项目应用

#### 1.通过restassured发起请求

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
          Response response = given()
                          .header("Content-Type", "application/json")
                          .body("{\"Content\":\"测试\"}")
                          .post("https://cloud.tencent.com/voc/gateway/DescribeRequirements");
          int statusCode = response.statusCode();
          Headers headers =response.headers();
          System.out.println(response.asString());//响应体不调用asString,返回response对象
          System.out.println(statusCode);
          System.out.println(headers);
  ```

- JSONPath断言

  ```java
  @Test
      public void  jsonpathTest() {
          Response response = given()
                  .header("Content-Type", "application/json")
                  .body("{\"Content\":\"测试\"}")
                  .post("https://cloud.tencent.com/voc/gateway/DescribeRequirements");
          String body =response.asString();
          //JSONPath.read(json字符串,jsonpath表达式)
          System.out.println(JSONPath.read(body, "$.code"));
          System.out.println(JSONPath.read(body, "$.msg"));
          System.out.println(JSONPath.read(body, "$.data"));
      }
  ```

- testng- @DataProvider数据驱动

  ```java
  @DataProvider
      public Object[][] allDatas(){
          //多个参数用二维数组，1个参数用一维数组
          Object[][] datas = {{"张三","20"},{"李四","18"},{"王五","25"},{"赵六","30"}};
          return datas;
      }
  
      //1、数据源的数据识别（dataProvider = "allDatas"方法名）
      //2、通过测试方法形参来接受
      @Test(dataProvider = "allDatas")
  
      public void print(String name, String age){
          //多个参数用二维数组，1个参数用一维数组
          System.out.println("获取名字,获取年龄");
          //打印名字
          System.out.println(name);
          System.out.println(age);
      }
  
  ```

  ```java
    @Test(dataProvider = "datas")
      public void  RegisterTest(String url ,String params){
          //注册接口测试
          Map<String,Object> headers = new HashMap<String, Object>();
          headers.put("Content-Type", "application/json");
          String body = HttpUtils.mypost(url,headers,params);
          System.out.println(body);
      }
     @DataProvider
      public Object[][]datas(){
          Object[][] datas ={
                  {"http://192.168.86.135:8080/app/mobile/api/user/register","{\"mobile\":\"67078985788\",\"password\":\"123456\",\"code\":\"1234\",\"platform\":\"windows\"}"},
                  {"http://192.168.86.135:8080/app/mobile/api/user/register","{\"mobile\":\"67078985789\",\"password\":\"123456\",\"code\":\"1234\",\"platform\":\"windows\"}"},
                  {"http://192.168.86.135:8080/app/mobile/api/user/register","{\"mobile\":\"67078985789\",\"password\":\"1234564\",\"code\":\"1234\",\"platform\":\"windows\"}"},
            };
         return datas;
     }
  ```

#### 2.excel文件读取

- easypoiDemo

  ```xml
    <dependency>
              <groupId>cn.afterturn</groupId>
              <artifactId>easypoi-annotation</artifactId>
              <version>4.0.0</version>
          </dependency>
  ```

- excel--映射实体类

  <div align="left"> <img src="pics/java-auto-easypoi.png" width="800"/> </div><br>

  ```java
  @Excel(name="Name接口名称")
      private String name;//特别注意：属性的命名遵循小驼峰
      //生成get/set方法/有参、无参构造方法、toString方法
  ```

  ```java
  @Test
      public static void read() throws Exception {
          //1.加载excel文件
          FileInputStream fis = new FileInputStream("src/test/resources/Athena1.xlsx");//注意是斜杠
          //2.创建easypoi导入参数对象
          ImportParams params = new ImportParams();
          //开始读取的sheet位置,默认为0  
          params.setStartSheetIndex(0);
          //上传表格需要读取的sheet数量,默认为1
          params.setSheetNum(1);
          //3.importExcel(文件流,映射实体类.class,easyPOI导入参数)
          List<CaseInfo> caseinfolist = ExcelImportUtil.importExcel(fis, CaseInfo.class,params);
          for(CaseInfo caseInfo: caseinfolist){
              System.out.println(caseInfo);
          }
          fis.close();
  
      }
  ```

  

  <div align="left"> <img src="pics/java-auto-easypoi-数量.png" width="800"/> </div><br>

- 总结：excel表读取执行顺序eg:

  1. 首先运行loginCase方法，当发现该方式有注解dataProvider时，即执行对应的dataProvider()方法；
  2. dataProvider()方法调用了封装的excel获取数据read()方法；
  3. read()方法将excel数据读取到输入流，然后通过ExcelImportUtil.importExcel()封装到实体类;
  4. 最后将返回实体类对象到注册接口作为请求参数，restassured完成请求。

#### 3.excel文件回写

```java
 public static void backWriteResponseExcel(String  body,int sheetNum,int rowNum,int cellNum) {
        //创建文件流
        FileInputStream fis = null;
        try {
            fis = new FileInputStream(Constants.excel_path);
            Workbook sheets = WorkbookFactory.create(fis);
            //分别或许回写对应的sheet/row/cell
            Sheet sheet = sheets.getSheetAt(sheetNum);
            Row row = sheet.getRow(rowNum);
            //防止空指针异常
            Cell cell  = row.getCell(cellNum,Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
            cell.setCellType(CellType.STRING);
            //回写内容change the cell to a string cell
            cell.setCellValue(body);
            //创建输出流
            FileOutputStream fos = new FileOutputStream(Constants.excel_path);
            sheets.write(fos);
            fis.close();
            fos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
```



#### 4.Testng注解

Testng测试框架支持定义测试套件，达到管理我们测试用例代码的作用，同时这些测试框架提供的一些丰富注解不仅能很方便的控制测试用例的执行顺序来控制整个测试流程，还能为各种测试场景的实现提供支撑。

**(1)常用注解****：**

@Test，用来标记测试方法

@BeforeSuite，适合套件的全局初始化，在整个套件执行前先执行

@BeforeTest，适合Test测试集的初始化，在测试集执行前先执行

@BeforeClass，适合Class测试类的初始化，在测试类被调用时执行

@BeforeMethod，适合测试方法执行前的初始化，在测试方法前先执行

@AfterClass，在测试类之后被调用时执行，作用适合做一些回收资源。

@Parameters：参数化注解，方便实现参数化

@DataProvider：数据提供者，可以用来提供测试用的批量测试数据

**(2)Testng参数化的方式:**

第一种：testng.xml方式，通过在xml文件中配置parameter标签，定义参数名额和属性值。在Java代码中给测试方法通过@parameters注解传递进来，方法形参进行接收.

第一种：dataprovider方式，@DataProvider注解标记数据提供方法，返回Object[][]类型二维数组。在测试方法@test注解中增加dataProvider属性引用数据提供源方法

#### 5.JSONPath断言

```
 @Test
    public void jsonpathDemo() {
        String body = "{\"code\":0,\"msg\":\"\\u767b\\u5f55\\u6210\\u529f\",\"data\":{\"username\":\"admin\",\"role_id\":5,\"token\":\"7ee2af25-4bae-4ec5-a505-8ab956db432b\",\"last_login_time\":1558941483,\"last_ip\":\"127.0.0.1\"},\"time\":1659788928}";
        String jsonpath = "$.data.username";
        Map<String, Object> map = new HashMap<>();
        Object x = JSONPath.read(body, jsonpath);
        if (x != null) {
            map.put("存储匹配结果", x);
        } else {
            System.out.println("null");
        }
        Set<String> keys = map.keySet();
        for (String key : keys) {
            System.out.println(key);
            System.out.println(map.get(key));
        }

    }
```

#### 6.运行testng.xml文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">
<suite name="接口自动化框架Demo">
    <test name="管理员登录">
        <classes>
            <class name="com.cn.cases.AdminLogin">
                <parameter name="startSheetIndex" value="0"></parameter>
            </class>
        </classes>

    </test>
    <test name="新增课程">
        <classes>
            <class name="com.cn.cases.addNewCourse">
                <parameter name="startSheetIndex" value="1"></parameter>
            </class>
        </classes>

    </test>
</suite>
```



#### 其他封装方法Demo

```java
package com.cn.cases;

import com.cn.entiy.ExcelEntity;
import com.cn.updateFile.Constants;
import com.cn.utils.CommonUtils;
import org.apache.log4j.Logger;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Parameters;
import org.testng.annotations.Test;


/**
 * @Author： Athena
 * @Date： 2022/8/6 22:03
 * @Desc： 管理员登录接口用例
 **/
public class AdminLogin {
    //sheet开始索引
    public int startSheetIndex;
    //打印日志
    private Logger logger = Logger.getLogger(AdminLogin.class);
    //数据驱动提供，通过dataProvider的值对应有此注解的方法名log4j.properties
    @BeforeClass
    @Parameters({"startSheetIndex"})
    public void beforeClass(int startSheetIndex) {
        //接受testng.xml中parameters 参数
        this.startSheetIndex = startSheetIndex;
    }
    @Test(dataProvider = "ReadExcelDatas")
    //此处传参类型要和dataProvider提供的数据类型保持一直
    public void adminloginCase(ExcelEntity excelEntity) {
        //参数化配置
        CommonUtils.replaceParams(excelEntity);
        //发起请求
        String url = excelEntity.getUrl();
        String params = excelEntity.getParams();
        String type = excelEntity.getType();
        String body = CommonUtils.EnterRequest(CommonUtils.getDefaulHeaders(), url, params, type);
        logger.info(body);
        //响应结果存储到map集合(传参说明：json 响应体、jsonpath匹配格式、存储key值)
        CommonUtils.responseDatasSave(body, "$.data.token", "api-token");
        //将响应结果回写到excel
        CommonUtils.backWriteResponseExcel(body, startSheetIndex, excelEntity.getCaseId(), Constants.backWriteCellNum_body);
        //断言响应结果
        boolean assertResul = CommonUtils.assertResponseResult(body, excelEntity, logger);
        //将断言结果回写到excel
        String finallyResult = assertResul ? "passed" : "failed";
        CommonUtils.backWriteResponseExcel(finallyResult, startSheetIndex, excelEntity.getCaseId(), Constants.backWriteCellNum_result);
   
    }

    /*
     * @ Author:Athena
     * @ Date 2022/8/6 22:06
     * @ Description //通过Testng的注解@DataProvider提供数据
     * @ Param[]
     * @ return java.lang.Object[]
     **/
    @DataProvider
    public Object[] ReadExcelDatas() {
        Object[] datasArray = CommonUtils.readExcelDatas(startSheetIndex,Constants.sheetNum);
        return datasArray;
    }
}

```



```java
package com.cn.utils;

import cn.afterturn.easypoi.excel.ExcelImportUtil;
import cn.afterturn.easypoi.excel.entity.ImportParams;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.JSONPath;
import com.cn.entiy.ExcelEntity;
import com.cn.updateFile.Constants;
import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.*;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.*;
import static io.restassured.RestAssured.given;

/**
 * @Author： Athena
 * @Date： 2022/8/6 21:08
 * @Desc： 解析excel中的数据到实体类对象
 **/
public class CommonUtils {
    /*
     * @ Author:Athena
     * @ Date 2022/8/6 21:11
     * @ Description //读取excel中的数据封装到实体类
     * @ Param
     * @ return
     **/

    public static Object[] readExcelDatas(int startSheetIndex,int sheetNum) {
        //定义返回的数据变量
        Object[] excelEntityArray = null;
        //1.加载excel文件
        try {
            FileInputStream fis = new FileInputStream(Constants.excel_path);
            //创建easypoi包中的导入对象ImportParams
            ImportParams importParams = new ImportParams();
            //3.设置读取excel中的第几个sheet,从0开始
            importParams.setStartSheetIndex(startSheetIndex);
            //4.读取几个sheet
            importParams.setSheetNum(sheetNum);
            //5.通过easypoi的ExcelImportUtil导入工具(Excel导入数据源IO流映射实体类)返回结果为对应实体类的list集合
            List<ExcelEntity> excelEntityList = ExcelImportUtil.importExcel(fis, ExcelEntity.class, importParams);
            //6.list集合类型转换为一维数组
            excelEntityArray = excelEntityList.toArray();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return excelEntityArray;

    }

    /*
     * @ Author:Athena
     * @ Date 2022/8/6 22:21
     * @ Description //获取请求头
     * @ Param
     * @ return
     **/
    public static Map<String, Object> getDefaulHeaders() {
        Constants.headersMap.put(Constants.contentType, Constants.applicationJson);
        return Constants.headersMap;
    }
    /*
     * @ Author:Athena
     * @ Date 2022/8/6 23:00
     * @ Description //添加其他请求头
     * @ Param 传参解释：headerKey 请求头名称：headerValue 请求头值
     * @ return map
     **/

    public static Map<String, Object> getDefaulHeadersAdd(String headerKey, Object headerValue) {
        //请求头需要其他的参数可合理添加：headerKey:headerValue
        Constants.headersMap.put(headerKey, headerValue);
        return Constants.headersMap;
    }

    /*
     * @ Author:Athena
     * @ Date 2022/8/6 23:02
     * @ Description //发起请求
     * @ Param
     * @ return
     **/
    public static String EnterRequest(Map<String, Object> headers, String url, String params, String type) {
        //定义请求返回响应结果变量 body
        String body = null;
        //判断请求提交类型 type
        if ("get".equals(type)) {
            body = given().headers(headers).get(url).asString();
        } else if ("post".equals(type)) {
            body = given().headers(headers).body(params).post(url).asString();
        } else if ("patch".equals(type)) {
            body = given().headers(headers).body(params).patch(url).asString();
        }if("put".equals(type)){
            body = RestAssured.given().headers(headers)
                    .contentType(ContentType.JSON)
                    .body(params)
                    .put(url).asString();
        }
        return body;
    }
    /*
     * @ Author:Athena
     * @ Date 2022/8/8 18:35
     * @ Description //put请求单独方法
     * @ Param
     * @ return
     **/
    public static String  EnterRequestPut(Map<String, Object> headers, String url, String params, String type ){
      //  String params = "{\"form\":{\"code\":\"TEST89\",\"name\":\"qTEST测1AAA\",\"status\":1}}";
        //定义请求返回响应结果变量 body
        String body = null;
        try {

        } catch (Exception e) {
            e.printStackTrace();
        }
        return  body;
    }
    /*
     * @ Author:Athena
     * @ Date 2022/8/7 0:09
     * @ Description //存储响应结果到map统一管理使用
     * @ Param 响应结果、匹配格式、存放key
     * @ return
     **/
    public static void responseDatasSave(String body, String jsonPath, String key) {
        //1.fastjson包内的JSONPath，匹配传入的json内容和格式，得到值
        Object responseResultValue = JSONPath.read(body, jsonPath);
        //将获取的responseValue存储到map中
        if (responseResultValue != null) {
            Constants.responseResultSave.put(key, responseResultValue);
        }
    }

    /*
     * @ Author:Athena
     * @ Date 2022/8/7 8:40
     * @ Description //将响应结果回写到excel中
     * @ Param body回写内容，sheetNum 回写sheet(0开始) rowNum回写行号(1开始)，cellNum回写列号(0开始)
     * @ return
     **/
    public static void backWriteResponseExcel(String  body,int sheetNum,int rowNum,int cellNum) {
        //创建文件流
        FileInputStream fis = null;
        try {
            fis = new FileInputStream(Constants.excel_path);
            Workbook sheets = WorkbookFactory.create(fis);
            //分别或许回写对应的sheet/row/cell
            Sheet sheet = sheets.getSheetAt(sheetNum);
            Row row = sheet.getRow(rowNum);
            //防止空指针异常
            Cell cell  = row.getCell(cellNum,Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
            cell.setCellType(CellType.STRING);
            //回写内容change the cell to a string cell
            cell.setCellValue(body);
            //创建输出流
            FileOutputStream fos = new FileOutputStream(Constants.excel_path);
            sheets.write(fos);
            fis.close();
            fos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    /*
     * @ Author:Athena
     * @ Date 2022/8/7 14:13
     * @ Description //断言响应结果
     * @ Param
     * @ return
     **/
    public static boolean  assertResponseResult(String body,ExcelEntity excelEntity,Logger logger){
        //定义断言结果 assertResult
        boolean assertResult = true;
        //期望响应结果和实际响应结果比较，格式{"$.code":0}
        //1.获取excel中期望的响应结果
        String expectedReponsejson= excelEntity.getExpectedResult();
        //将期望json转map存储
        Map<String,Object> expectedJsonMap = JSONObject.parseObject(expectedReponsejson,Map.class);
        //2.获取期望结果转map存储后所有keys
        Set<String> expectedKeys = expectedJsonMap.keySet();
        //3.遍历所有的keys,通过key获取value
        for(String expectedKey : expectedKeys){
            //获取期望值
            Object expectedValue = expectedJsonMap.get(expectedKey);
            //获取实际值
            Object actualReponseValue = JSONPath.read(body,expectedKey);
            //断言实际数据和期望数据的比较
            if(!expectedValue.equals(actualReponseValue)){
                assertResult = false;
            }
        }
        if(assertResult){
            logger.info("断言响应结果成功");
        }else {
            logger.info("断言响应结果失败");
        }
        return assertResult;
    }
    /*
     * @ Author:Athena
     * @ Date 2022/8/8 20:49
     * @ Description //请求参数可参数化配置
     * @ Param
     * @ return
     **/
    public static void replaceParams(ExcelEntity excelEntity){
        Random random = new Random();
        //获取excel中得参数
        String excelParams = excelEntity.getParams();
        Map<String,Object> vars = new HashMap<>();
        vars.put("${username}","admin");
        vars.put("${password}","admin123");
        vars.put("${code}","Ttest"+random.nextInt(1000));
        vars.put("${name}","Ttest"+random.nextInt(1000));
        //{"form":{"code":"${code}","name":"${name}","status":1}}
        for(String key : vars.keySet()){
            if (StringUtils.isNotBlank(excelParams)) {
                excelParams = excelParams.replace(key, vars.get(key).toString());
            }
        }
        excelEntity.setParams(excelParams);
    }



}

```

```java
import com.alibaba.fastjson.JSONPath;
import com.cn.entiy.ExcelEntity;
import com.cn.updateFile.Constants;
import com.cn.utils.CommonUtils;
import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.testng.annotations.Test;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * @Author： Athena
 * @Date： 2022/8/6 21:47
 * @Desc： 测试已封装好的方法
 **/
public class testDemo {
    /*
     * @ Author:Athena
     * @ Date 2022/8/6 22:00
     * @ Description //测试解析excel数据封装到实体类对象
     * @ Param[]
     * @ return void
     **/
    @Test
    public void excelReadDemo() {
        Object[] excelArray = CommonUtils.readExcelDatas(0,1);
        for (Object excel : excelArray) {
            System.out.println(excel);
        }
    }

    /*
     * @ Author:Athena
     * @ Date 2022/8/6 22:35
     * @ Description //获取请求头已封装的方法测试
     * @ Param[]
     * @ return void
     **/

    @Test
    public static void getHeadersMap() {
        CommonUtils.getDefaulHeaders();
        Set<String> keys = Constants.headersMap.keySet();
        for (String key : keys) {
            System.out.println(key);
            System.out.println(Constants.headersMap.get(key));
        }

    }

    /*
     * @ Author:Athena
     * @ Date 2022/8/6 22:46
     * @ Description //新添加其他的请求头-测试Demo
     * @ Param  key value格式添加请求头
     * @ return
     **/
    @Test
    public static void getDefaulHeadersAdd() {
        String headerKey = "请求头名称";
        String headervalue = "请求头值";
        CommonUtils.getDefaulHeadersAdd(headerKey, headervalue);
        Set<String> keys = Constants.headersMap.keySet();
        for (String key : keys) {
            System.out.println(key);
            System.out.println(Constants.headersMap.get(key));
        }

    }
    /*
     * @ Author:Athena
     * @ Date 2022/8/7 8:08
     * @ Description //调用发起请求方法Demo测试
     * @ Param
     * @ return
     **/

    @Test
    public static void EnterRequest() {
        ExcelEntity excelEntity = new ExcelEntity();
        Map<String, Object> headers = CommonUtils.getDefaulHeaders();
        String url = "http://ny.testing.thinkworld360.com/gateway/api/system/user/login";
        String params = "{\"username\":\"admin\",\"password\":\"admin123\"}";
        String type = "post";
        String body = CommonUtils.EnterRequest(headers, url, params, type);
        System.out.println(body);
    }

    /*
     * @ Author:Athena
     * @ Date 2022/8/7 8:09
     * @ Description //封装响应结果到map类-demo测试
     * @ Param
     * @ return
     **/
    @Test
    public static void responseDatasSave() {
        String body = "{\"code\":0,\"msg\":\"\\u767b\\u5f55\\u6210\\u529f\",\"data\":{\"username\":\"admin\",\"role_id\":5,\"token\":\"712c54b5-efa8-74a0-2a1c-fd200c145892\",\"last_login_time\":1558941483,\"last_ip\":\"127.0.0.1\"},\"time\":1659802289}";
        String jsonpath = "$.code";
        String key = "code";
        CommonUtils.responseDatasSave(body, jsonpath, key);

        String body1 = "{\"code\":0,\"msg\":\"\\u767b\\u5f55\\u6210\\u529f\",\"data\":{\"username\":\"admin\",\"role_id\":5,\"token\":\"712c54b5-efa8-74a0-2a1c-fd200c145892\",\"last_login_time\":1558941483,\"last_ip\":\"127.0.0.1\"},\"time\":1659802289}";
        String jsonpath1 = "$.data.token";
        String key1 = "token";
        CommonUtils.responseDatasSave(body1, jsonpath1, key1);

        Set<String> keys = Constants.responseResultSave.keySet();
        for (String responseResultkey : keys) {
            System.out.println(Constants.responseResultSave.get(responseResultkey));
        }
    }

    /*
     * @ Author:Athena
     * @ Date 2022/8/7 9:11
     * @ Description //回写响应内容到excel
     * @ Param
     * @ return
     **/
    @Test
    public void backWriteResponseExcel() {
        String body = "回写内容";
        int sheetNum = 0;
        int rowNum = 1;
        int cellNum = 8;
        CommonUtils.backWriteResponseExcel(body, sheetNum, rowNum, cellNum);
    }

    /*
     * @ Author:Athena
     * @ Date 2022/8/7 14:46
     * @ Description // 断言响应结果
     * @ Param
     * @ return
     **/
    @Test
    public void assertResponseResultDemo() {
        String body = "{\"code\":0,\"msg\":\"\\u767b\\u5f55\\u6210\\u529f\",\"data\":{\"username\":\"admin\",\"role_id\":5,\"token\":\"7ee2af25-4bae-4ec5-a505-8ab956db432b\",\"last_login_time\":1558941483,\"last_ip\":\"127.0.0.1\"},\"time\":1659788928}";
        ExcelEntity excelEntity = new ExcelEntity();
        Logger logger = Logger.getLogger(testDemo.class);
        String expectedReponsejson = excelEntity.getExpectedResult();
        String expectedJson = "{\"$.code\":0,\"$.data.username\":\"admin\"}";
        excelEntity.setExpectedResult(expectedJson);
        boolean assertResult = CommonUtils.assertResponseResult(body, excelEntity, logger);

    }

    /*
     * @ Author:Athena
     * @ Date 2022/8/7 16:53
     * @ Description //JSONPath的常用方法Demo
     * @ Param
     * @ return
     **/
    @Test
    public void jsonpathDemo() {
        String body = "{\"code\":0,\"msg\":\"\\u767b\\u5f55\\u6210\\u529f\",\"data\":{\"username\":\"admin\",\"role_id\":5,\"token\":\"7ee2af25-4bae-4ec5-a505-8ab956db432b\",\"last_login_time\":1558941483,\"last_ip\":\"127.0.0.1\"},\"time\":1659788928}";
        String jsonpath = "$.data.username";
        Map<String, Object> map = new HashMap<>();
        Object x = JSONPath.read(body, jsonpath);
        if (x != null) {
            map.put("存储匹配结果", x);
        } else {
            System.out.println("null");
        }
        Set<String> keys = map.keySet();
        for (String key : keys) {
            System.out.println(key);
            System.out.println(map.get(key));
        }

    }
    /*
     * @ Author:Athena
     * @ Date 2022/8/8 16:38
     * @ Description //测试新增课程Case类发起请求成功Demo
     * @ Param
     * @ return
     **/
    @Test
    public void addNewCourceDemo(){
        Map<String, Object> headers = CommonUtils.getDefaulHeaders();
        String url = "http://ny.testing.thinkworld360.com/gateway/api/system/user/login";
        String params = "{\"username\":\"admin\",\"password\":\"admin123\"}";
        String type = "post";
        String body = CommonUtils.EnterRequest(headers, url, params, type);
        CommonUtils.responseDatasSave(body, "$.data.token", "${token}");
        System.out.println("登录："+body);

        //准备请求头数据
        //登录时存储token得key
        String heaserKey = "${token}";
        //通过key或者token值存入请求头
        Object headerValue = Constants.responseResultSave.get(heaserKey);
        Constants.headersMap.put("api-token", headerValue);
        String requestBody = "{\"form\":{\"code\":\"test12dgas\",\"name\":\"testgf2g5\",\"status\":1}}";
        String response = null;
        try {
            response = RestAssured.given().headers(Constants.headersMap)
                    .contentType(ContentType.JSON)
                    .body(requestBody)
                    .put("http://ny.testing.thinkworld360.com/gateway/api/information/course/save").asString();
        } catch (Exception e) {
            e.printStackTrace();
        }System.out.println("新增课程："+response);

    }
    /*
     * @ Author:Athena
     * @ Date 2022/8/8 19:07
     * @ Description //网上资料接口  发送put请求demo
     * @ Param
     * @ return
     **/

    @Test
    public void updateUser() {
        RestAssured.baseURI = "https://reqres.in/api";
        String requestBody = "{\n"
                + "    \"name\": \"Adam\",\n"
                + "    \"job\": \"Java Developer\"\n"
                + "}";

        Response response = null;
        try {
            response = RestAssured.given()
                    .contentType(ContentType.JSON)
                    .body(requestBody)
                    .put("/users/114");
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("Response :" + response.asString());
        System.out.println("Status Code :" + response.getStatusCode());
        System.out.println("Does Reponse contains 'Chris'? :" + response.asString().contains("Chris"));

    }
    /*
     * @ Author:Athena
     * @ Date 2022/8/8 21:07
     * @ Description //字符串替换Demo
     * @ Param
     * @ return
     **/
    @Test
    public void strReplace(){
        Map<String,Object> vars = new HashMap<>();
        vars.put("${username}","admin");
        vars.put("${password}","admin123");
        String excelParams = "{\"username\":\"${username}\",\"password\":\"${password}\"}";
        for(String key : vars.keySet()){
            if (StringUtils.isNotBlank(excelParams)) {
                excelParams = excelParams.replace(key, vars.get(key).toString());
            }
        }
        System.out.println(excelParams);
    }

}

```

