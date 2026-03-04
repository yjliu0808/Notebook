# 接口自动化测试pom.xml文件可能用到的依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>  
<project xmlns="http://maven.apache.org/POM/4.0.0"  
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">  
<!-- Maven POM 模型的版本: 项目的模型版本 -->  
<modelVersion>4.0.0</modelVersion>  
  
<!-- 项目的唯一标识符, 由 groupId, artifactId 和 version 组成 -->  
<groupId>com.cn.athena</groupId> <!-- 组织 ID, 一般是组织域名反转 -->  
<artifactId>api_auto_mall</artifactId> <!-- 项目名称 -->  
<version>1.0-SNAPSHOT</version> <!-- 项目的版本 -->  
<packaging>jar</packaging> <!-- 项目打包方式，这里选择的是 JAR 包 -->  
  
<!-- 项目的一些配置属性 -->  
<properties>  
<!-- 编译时使用的 Java 版本 -->  
<maven.compiler.source>8</maven.compiler.source> <!-- 编译源代码使用的 Java 版本 -->  
<maven.compiler.target>8</maven.compiler.target> <!-- 编译后的字节码版本 -->  
<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding> <!-- 设置源码编码为 UTF-8 --></properties>  
  
<!-- 项目的依赖库 -->  
<dependencies>  
  
<!-- Rest-Assured - 用于 API 测试 -->  
<dependency>  
<groupId>io.rest-assured</groupId>  
<artifactId>rest-assured</artifactId>  
<version>5.3.0</version>  
<scope>test</scope> <!-- 这个依赖只在测试阶段使用 -->  
</dependency>  
  
<!-- TestNG - 测试框架 -->  
<dependency>  
<groupId>org.testng</groupId>  
<artifactId>testng</artifactId>  
<version>7.0.0</version>  
<scope>test</scope> <!-- TestNG 用于运行和管理测试用例 -->  
</dependency>  
  
<!-- Allure Rest Assured - 用于生成 Allure 测试报告 -->  
<dependency>  
<groupId>io.qameta.allure</groupId>  
<artifactId>allure-rest-assured</artifactId>  
<version>2.16.0</version>  
<scope>test</scope> <!-- Allure 插件用于与 Rest Assured 集成，生成测试报告 -->  
</dependency>  
  
<!-- Allure TestNG - 用于将 Allure 插件与 TestNG 集成 -->  
<dependency>  
<groupId>io.qameta.allure</groupId>  
<artifactId>allure-testng</artifactId>  
<version>2.16.0</version>  
<scope>test</scope> <!-- 让 TestNG 与 Allure 插件一起工作 -->  
</dependency>  
<!-- Log4j2 API 和 Core --><dependency>  
<groupId>org.apache.logging.log4j</groupId>  
<artifactId>log4j-api</artifactId>  
<version>2.17.0</version>  
</dependency>  
<dependency>  
<groupId>org.apache.logging.log4j</groupId>  
<artifactId>log4j-core</artifactId>  
<version>2.17.0</version>  
</dependency>  
</dependencies>  
  
<!-- 项目构建部分 -->  
<build>  
<plugins>  
  
<!-- Allure Maven 插件 - 用于生成 Allure 测试报告 -->  
<plugin>  
<groupId>io.qameta.allure</groupId>  
<artifactId>allure-maven</artifactId>  
<version>2.11.2</version>  
<executions>  
<execution>  
<phase>test</phase> <!-- 在测试阶段执行 -->  
<goals>  
<goal>serve</goal> <!-- 生成并展示 Allure 报告 -->  
</goals>  
</execution>  
</executions>  
</plugin>  
  
<!-- Surefire 插件 - 用于运行 TestNG 测试 -->  
<plugin>  
<groupId>org.apache.maven.plugins</groupId>  
<artifactId>maven-surefire-plugin</artifactId>  
<version>2.22.1</version>  
<configuration>  
<suiteXmlFiles>  
<!-- 指定 TestNG 测试套件文件 -->  
<suiteXmlFile>src/test/resources/testng.xml</suiteXmlFile> <!-- 确保路径正确 -->  
</suiteXmlFiles>  
<systemProperties>  
<!-- 确保 allure-results 目录正确生成 -->  
<property>  
<name>allure.results.directory</name>  
<value>${project.build.directory}/allure-results</value>  
</property>  
</systemProperties>  
</configuration>  
</plugin>  
  
</plugins>  
</build>  
</project>
```

