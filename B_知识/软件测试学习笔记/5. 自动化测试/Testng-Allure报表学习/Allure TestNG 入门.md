# Allure TestNG 入门

[![Allure TestNG 最新版本](https://img.shields.io/maven-central/v/io.qameta.allure/allure-testng?style=flat)](https://mvnrepository.com/artifact/io.qameta.allure/allure-testng)

[使用Allure Report](https://allurereport.org/docs/)和[TestNG](https://testng.org/)测试生成美观的HTML报告。

![Allure 报告 TestNG 示例](https://allurereport.org/images/java/testng/example.png)

信息

[请访问github.com/allure-examples](https://github.com/orgs/allure-examples/repositories?q=visibility%3Apublic+archived%3Afalse+topic%3Aexample+topic%3Atestng)查看示例项目，了解 Allure TestNG 的实际应用。

## 设置

命令将[Allure](https://allurereport.org/)集成到现有的**TestNG**项目中，您需要：

1. 将 Allure 依赖项添加到您的项目中。
2. 配置AspectJ`@Step`和`@Attachment`注解支持。[[Allure 报告与 AspectJ 的关系]]
3. 指定一个位置用于存储 Allure 的结果搜索。
### 添加 Allure 依赖项

```xml
<properties>
    <!-- 定义 Allure 的版本，通过 allure.version 属性 -->
    <!-- allure.version 变量将用于指定所有 Allure 相关依赖的版本 -->
    <allure.version>2.29.0</allure.version>
</properties>

<!-- 依赖管理部分：使用 Allure BOM 确保所有依赖使用统一的版本 -->
<dependencyManagement>
    <dependencies>
        <!-- 引入 allure-bom，用于集中管理所有 Allure 相关的依赖版本 -->
        <!-- BOM（Bill of Materials）是一个 Maven 管理依赖版本的机制 -->
        <dependency>
            <groupId>io.qameta.allure</groupId>
            <artifactId>allure-bom</artifactId>
            <!-- 使用前面定义的 allure.version 来动态引入 Allure 的版本 -->
            <version>${allure.version}</version>
            <!-- 使用 POM 类型作为依赖类型，因为它是一个依赖管理 BOM 文件 -->
            <type>pom</type>
            <!-- 使用 import scope 表示这个依赖只在依赖管理中使用，不会作为实际依赖包含到项目中 -->
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>

<!-- 项目依赖部分：添加 Allure 的具体插件依赖 -->
<dependencies>
    <!-- 引入 Allure TestNG 插件，确保可以在 TestNG 测试中生成 Allure 报告 -->
    <dependency>
        <groupId>io.qameta.allure</groupId>
        <artifactId>allure-testng</artifactId>
        <!-- scope 设置为 test，表示这个依赖只在测试阶段使用 -->
        <scope>test</scope>
    </dependency>
</dependencies>

```

### 配置AspectJ

`@Step`Allure 利用 AspectJ 来实现断言和注解的功能`@Attachment`。此外，一些框架集成（例如[allure-assertj](https://mvnrepository.com/artifact/io.qameta.allure/allure-assertj)）也依赖于 AspectJ 集成才能正常运行。

```xml
<!-- 定义 AspectJ 的版本 -->
<properties>
    <!-- 通过 properties 定义 AspectJ 的版本，以便在整个 POM 文件中引用 -->
    <aspectj.version>1.9.20.1</aspectj.version>
</properties>

<!-- 将以下选项添加到 maven-surefire-plugin 配置中 -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.1.2</version> <!-- 配置 maven-surefire-plugin 插件的版本 -->

    <configuration>
        <argLine>
            <!-- 使用 -javaagent 参数将 AspectJ 的 Weaver 加载到 JVM 中 -->
            <!-- -javaagent 用于在 JVM 启动时加载 AspectJ Weaver，这样它就能在运行时修改字节码，启用 AOP（面向切面编程） -->
            <!-- ${settings.localRepository} 是 Maven 本地仓库路径的变量，它会指向您本地存储的所有 Maven 依赖 -->
            <!-- aspectjweaver-${aspectj.version}.jar 是 AspectJ Weaver 的核心 JAR 文件，负责字节码增强和切面注入 -->
            <argLine>
                -javaagent:"${settings.localRepository}/org/aspectj/aspectjweaver/${aspectj.version}/aspectjweaver-${aspectj.version}.jar"
            </argLine>
        </argLine>
    </configuration>

    <!-- 在插件的 dependencies 部分添加 AspectJ Weaver 依赖，确保该插件在执行时能正常工作 -->
    <dependencies>
        <dependency>
            <!-- 引入 AspectJ Weaver 库，它负责在 JVM 中对字节码进行修改和增强 -->
            <!-- AspectJ Weaver 是 AspectJ 的核心组件，能够将切面编织到 Java 类中 -->
            <groupId>org.aspectj</groupId>
            <artifactId>aspectjweaver</artifactId>
            <!-- 使用 ${aspectj.version} 来确保版本统一 -->
            <version>${aspectj.version}</version>
        </dependency>
    </dependencies>
</plugin>

```

### 指定 Allure 结果结果

默认情况下，Allure 但是粘贴测试结果保存在项目根目录中。，建议将测试结果存储在构建输出目录中。

要进行此配置，请创建一个`allure.properties`文件并将其放置在项目的测试资源目录中，该目录通常位于`src/test/resources`：

```properties
allure.results.directory=target/allure-results
```

### 运行测试

运行TestNG测试的方式与平时运行测试的方式相同。例如：

对于Maven：

```
mvn clean test
```

测试运行结束后，Allure 会收集测试执行数据并将其存储在`allure-results`指定目录中。之后，您可以使用 Allure 的报告工具根据这些结果生成 HTML 报告。

### 报告生成

最后，将测试结果转换为 HTML 报告。这可以通过以下两个命令完成：

- `allure generate`处理结果测试放置 HTML 报告保存到指定`allure-report`目录。要查看报告，请使用该`allure open`命令。

  如果您需要保存报告以供将来参考或与同事共享，请使用此命令。

- `allure serve`该命令会生成与之前相同的报告`allure generate`，但将其放入临时目录，并启动一个本地 Web 服务器，该服务器配置为显示此目录的内容。然后，该命令会自动在 Web 浏览器中打开报告的主页面。

  如果您需要自行查看报告而不需要保存，请使用此命令。

## 编程测试

Allure TestNG 不仅可以收集 TestNG 标准功能提供的数据，还提供额外的功能，帮助您编写更优质的测试。本节上利用 TestNG 和 Allure TestNG 的功能来改进测试的最显着方法。

使用Allure TestNG，您可以：

- 提供[描述、链接和其他元数据](https://allurereport.org/docs/testng/#specify-description-links-and-other-metadata)，
- [将测试组织](https://allurereport.org/docs/testng/#organize-tests)形成体系结构，
- 将短路测试更小、更容易理解的[测试步骤](https://allurereport.org/docs/testng/#divide-a-test-into-steps)，
- 描述运行[参数化测试](https://allurereport.org/docs/testng/#describe-parametrized-tests)时使用的参数，
- 让测试在执行过程中保存[屏幕截图和其他文件](https://allurereport.org/docs/testng/#attach-screenshots-and-other-files)，
- 通过测试计划文件[选择要运行的测试，](https://allurereport.org/docs/testng/#select-tests-via-a-test-plan-file)
- 为整个测试报告提供各种[环境信息。](https://allurereport.org/docs/testng/#environment-information)

### 指定描述、链接和其他元数据

您可以为每次测试添加大量[元数据，](https://allurereport.org/docs/gettingstarted-readability/#description-links-and-other-metadata)以便将其显示在报告中。更多详情请参阅[参考资料。](https://allurereport.org/docs/testng-reference/#metadata)

每个元数据字段，有两种赋值方式：一种是在测试方法之前添加注解，另一种是在测试方法内部调用方法。第二种方式称为“动态赋值”，因为它允许在运行时构造字符串和其他值，然后再提交给方法。但是请注意，强烈建议分配所有元数据。否则，测试可能会在所有元数据设置完成失败，这会影响测试报告之前的权限性。

```java
import io.qameta.allure.Description;
import io.qameta.allure.Issue;
import io.qameta.allure.Link;
import io.qameta.allure.Owner;
import io.qameta.allure.Severity;
import io.qameta.allure.TmsLink;
import org.testng.annotations.Test;

import static io.qameta.allure.SeverityLevel.*;

public class TestMyWebsite {

    @Test
    @Description("This test attempts to log into the website using a login and a password. Fails if any error happens.\n\nNote that this test does not test 2-Factor Authentication.")
    @Severity(CRITICAL)
    @Owner("John Doe")
    @Link(name = "Website", url = "https://dev.example.com/")
    @Issue("AUTH-123")
    @TmsLink("TMS-456")
    public void testAuthentication() {
        // ...
    }
}
```



### 组织测试

如[“改进测试报告导航”一文所述，Allure 支持多种方式将测试组织成层级结构。Allure TestNG 提供了一些函数，可以通过添加注解或“动态”（与](https://allurereport.org/docs/gettingstarted-navigation/)[元数据字段](https://allurereport.org/docs/testng/#specify-description-links-and-other-metadata)相同）的方式将相关字段分配给测试。

要指定测试在[基于行为的层次结构](https://allurereport.org/docs/gettingstarted-navigation/#behavior-based-hierarchy)中的位置：

```java
import io.qameta.allure.Epic;
import io.qameta.allure.Feature;
import io.qameta.allure.Story;
import org.testng.annotations.Test;

public class TestMyWebsite {

    @Test
    @Epic("Web interface")
    @Feature("Essential features")
    @Story("Authentication")
    public void testAuthentication() {
        // ...
    }
}
```

要指定测试在[基于套件的层次结构](https://allurereport.org/docs/gettingstarted-navigation/#suite-based-hierarchy)中的位置：

```java
import io.qameta.allure.Allure;
import org.testng.annotations.Test;

public class TestMyWebsite {

    @Test
    public void testAuthentication() {
        Allure.label("parentSuite" ,"Tests for web interface");
        Allure.suite("Tests for essential features");
        Allure.label("subSuite", "Tests for authentication");
        // ...
    }
}
```

测试在[基于包的层次结构](https://allurereport.org/docs/gettingstarted-navigation/#package-based-hierarchy)中的位置由声明它们的类的完全限定名称定义，常见的前缀显示为父包。

### 将测试分成几个步骤

Allure TestNG 提供了三种[创建步骤和子步骤](https://allurereport.org/docs/steps/)的方法：“带注释的步骤”、“lambda 步骤”和“空操作步骤”，请参阅[参考资料](https://allurereport.org/docs/testng-reference/#test-steps)。

```java
import io.qameta.allure.Step;
import org.testng.annotations.Test;

public class TestMyWebsite {

    @Test
    public void testAuthentication() {
        step1();
        step2();
    }

    @Step("Step 1")
    public void step1() {
        subStep1();
        subStep2();
    }

    @Step("Sub-step 1")
    public void subStep1() {
        // ...
    }

    @Step("Sub-step 2")
    public void subStep2() {
        // ...
    }

    @Step("Step 2")
    public void step2() {
        // ...
    }
}
```

### 描述参数化测试

[Allure TestNG 为 TestNG 的参数化测试](https://testng.org/#_parameters)提供完全支持。

更多示例请参见[参考资料。](https://allurereport.org/docs/testng-reference/#parametrized-tests)

```java
import org.testng.annotations.Parameters;
import org.testng.annotations.Test;

public class TestMyWebsite {

    @Test
    @Parameters({"Login", "Password"})
    public void testAuthentication(String login, String password) {
        // ...
    }
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">

<suite name="Test my website">

    <test name="Test authentication with login">
        <parameter name="Login" value="johndoe"/>
        <parameter name="Password" value="qwerty"/>
        <classes>
            <class name="com.example.TestMyWebsite"/>
        </classes>
    </test>

    <test name="Test authentication with email">
        <parameter name="Login" value="johndoe@example.com"/>
        <parameter name="Password" value="qwerty"/>
        <classes>
            <class name="com.example.TestMyWebsite"/>
        </classes>
    </test>

</suite>
```

### 附上屏幕截图和其他文件

您可以[将任何类型的文件附加](https://allurereport.org/docs/attachments/)到您的 Allure 报告中。例如，一种常见的使报告更易于理解的方法是附加特定位置的用户界面屏幕截图。

Allure TestNG 提供了多种创建附件的方法，既可以从现有文件创建附件，也可以动态生成附件，请参阅[参考文档](https://allurereport.org/docs/testng-reference/#attachments)。

```java
import io.qameta.allure.Allure;
import org.testng.annotations.Test;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;

public class TestMyWebsite {

    @Test
    public void testAuthentication() throws IOException {
        // ...
        Allure.attachment("data.txt", "This is the file content.");
        try (InputStream is = Files.newInputStream(Paths.get("/path/img.png"))) {
            Allure.attachment("image.png", is);
        }
    }
}
```

### 通过测试计划文件选择测试

如果`ALLURE_TESTPLAN_PATH`定义了环境变量并指向一个现有文件，TestNG 将只运行该文件中列出的测试。

以下是根据名为“”的文件运行测试的示例`testplan.json`：

```
export ALLURE_TESTPLAN_PATH=testplan.json
./gradlew test
```

### 环境信息

在报告的主页上，您可以收集有关测试执行环境的各种信息。

例如，用它来记录操作系统和 Java 版本是个好主意。这有助于未来的读者调查仅在特定环境下才能重现的错误。

![Allure 报告环境小部件](https://allurereport.org/images/java/environment_info.png)

要提供环境信息，请在运行测试后将一个名为 `environment.yml` 的文件放入目录`environment.properties`中。请参阅[环境文件](https://allurereport.org/docs/how-it-works-environment-file/)`allure-results`示例。

请注意，此功能适用于报告中所有测试中都不会改变的属性。如果某些属性在不同的测试中可能不同，请考虑使用[参数化测试](https://allurereport.org/docs/testng-reference/#parametrized-tests)。