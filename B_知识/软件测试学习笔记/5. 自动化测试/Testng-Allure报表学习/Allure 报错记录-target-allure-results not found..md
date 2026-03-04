# Allure 报错记录及解决方案

## 错误信息：
在执行 Maven 测试时，出现如下错误：

[ERROR] Directory D:\code\start-java-testng-maven-allure\target\allure-results not found.

## 错误原因：
- Allure Maven 插件默认尝试将测试结果保存到 `target/allure-results` 目录。
- 如果该目录不存在，Allure 插件会抛出错误，提示找不到该目录。
- 由于 Allure 插件 **不会自动创建目录**，需要手动创建该目录或通过配置让 Maven 自动创建。

## 解决方案：

### 1. **通过新建 `allure.properties` 文件**
   您可以通过新建 `allure.properties` 文件来指定 Allure 测试结果的保存目录。此方法不需要在 `pom.xml` 中做任何修改，只需要确保在项目中创建并配置好 `allure.properties` 文件。

#### 步骤：
1. 在项目的 `src/test/resources` 目录下创建 `allure.properties` 文件。
2. 在 `allure.properties` 文件中添加以下内容：
   
   ```properties
   allure.results.directory=target/allure-results

### 2. **通过 `pom.xml` 配置 `systemProperties`**

另一种方式是在 `maven-surefire-plugin` 配置中通过 `systemProperties` 指定 Allure 结果目录。这样无需 `allure.properties` 文件，而是通过 Maven 配置来控制目录。

#### 配置示例：

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>2.22.1</version>
            <configuration>
                <suiteXmlFiles>
                    <suiteXmlFile>testng.xml</suiteXmlFile>
                </suiteXmlFiles>
                <argLine>
                    -Dfile.encoding=UTF-8
                    -javaagent:"${settings.localRepository}/org/aspectj/aspectjweaver/${aspectj.version}/aspectjweaver-${aspectj.version}.jar"
                </argLine>
                <systemProperties>
                    <property>
                        <name>allure.results.directory</name>
                        <value>${project.build.directory}/allure-results</value>
                    </property>
                </systemProperties>
            </configuration>
        </plugin>
    </plugins>
</build>

```

### 总结：

- **错误的根本原因**是 Allure 插件无法找到 `allure-results` 目录。
- **解决方法**：
  - 通过创建 `allure.properties` 文件，并在其中指定 `allure.results.directory` 来控制测试结果的输出路径。
  - 或者通过在 `maven-surefire-plugin` 的 `<configuration>` 中添加 `systemProperties` 来指定 Allure 结果目录。
- **不需要额外的 Allure 插件配置文件**，只需要选择其中一种方式进行配置。
-- **可以同时配置**，并且两者不会冲突。
    
- **优先级**：`maven-surefire-plugin` 中的 `systemProperties` 配置优先于 `allure.properties` 文件中的配置。
    
- **适用场景**：如果您需要灵活的配置或在不同的环境中使用不同的配置，可以同时使用这两种方式。