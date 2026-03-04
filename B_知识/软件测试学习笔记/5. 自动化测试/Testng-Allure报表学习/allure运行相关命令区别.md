常见这几个命令解析：
mvn clean test io.qameta.allure:allure-maven:serve 
mvn clean test allure:serve
或者分开执行：
mvn clean test 
mvn allure:serve
allure serve
allure serve target/allure-results

这些命令看起来很相似，但它们实际上执行的是不同的操作，下面是它们的区别：

1. **`mvn clean test io.qameta.allure:allure-maven:serve`**
   - 这个命令会先执行 `mvn clean`（清理项目）和 `mvn test`（运行测试）。然后，它会直接通过 `allure-maven-plugin` 插件生成并启动 Allure 报告。这是一个一站式命令，执行完测试后会自动启动 Allure 报告的服务。
2. **`mvn clean test allure:serve`**
   - 这个命令首先会执行 `mvn clean` 和 `mvn test`，然后通过 `mvn allure:serve` 启动 Allure 报告。它不会在测试结束后自动生成报告，而是依赖于 `allure-maven-plugin` 在之后运行 `serve` 目标时生成报告。
3. **分开执行：**
   - **`mvn clean test`**
      这个命令只执行测试。它会先清理项目并运行所有的单元测试，但不会生成 Allure 报告。
   - **`mvn allure:serve`**
      在测试执行后，使用这个命令启动 Allure 报告的本地服务，前提是你已经运行过测试并且有生成的 `target/allure-results` 文件夹。如果没有生成报告文件，`serve` 也不会有效。
4. **`allure serve`**
   - 这是 Allure CLI 工具中的命令，不是 Maven 命令。它会启动一个本地服务器来显示报告，前提是你已经有了 `target/allure-results` 目录（包含测试结果文件）。如果没有运行过 `mvn clean test` 或类似命令生成报告，它会失败。
5. **`allure serve target/allure-results`**
   - 这个命令是 `allure serve` 命令的另一种写法。它会指定报告目录 `target/allure-results`，并启动报告的本地服务。你需要确保 `allure-results` 目录存在且包含生成的测试结果文件。

### 总结

- **`mvn clean test io.qameta.allure:allure-maven:serve`**：执行测试并自动生成并启动 Allure 报告。
- **`mvn clean test allure:serve`**：执行测试并通过 `allure:serve` 启动报告，但不会自动生成报告。
- **`allure serve` 或 `allure serve target/allure-results`**：这两个命令都是用来启动报告的本地服务的，但需要先有生成的 Allure 测试结果文件。

如果你想一键完成测试和报告展示，使用 `mvn clean test io.qameta.allure:allure-maven:serve` 是最简便的。