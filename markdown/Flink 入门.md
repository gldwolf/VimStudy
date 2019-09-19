# Flink 入门

## 1 概念

### 1.1 编程模型

#### 数据流编程模型

##### Level of Abstraction (抽象级别)

Flink 提供不同的抽象级别来开发 streaming/batch 应用。

![](static\flink\1.png)

- 最低阶的抽象简单的提供了一个有状态的流（**stateful streaming**）。通过 **Process Function** 嵌入到的 DataStream API 中。它允许用户自由地从一个或多个流中处理事件，并使用一致的容错状态（use consistent fault tolerant state）。此外，用户可以注册事件时间和处理时间回调。允许程序实现复杂的计算。

- 事实上，大多数的应用程序不需要上面所说的低阶的抽象，而是使用 **Core APIs** 来进行编程，比如 DataStream API (有限流/无限流) 和 DataSet API（有界限数据集）。这些 API 提供了数据处理的常用组件，比如用户自定义的各种转换、关联、聚合、窗口、状态等。这些 API 中的数据类型在不同的编程语言中用不同的类代表。

  DataStream API 整合了低阶的处理函数，使对具体的操作转换为低阶的抽象成为可能。DataSet API 为有限数据集提供了额外的原语，例如：loops/iterations。
  
- Table API 是一个以表为中心的声明式 DSL，可以动态的修改改中的数据（when representing streams）。Table API 遵循（扩展的）关系模型：有一个 schema 与表关联（类似于关系型数据库中的表），API 提供了类似的找工作，比如 select，project, join, group-by，聚合（aggregate）操作等。Table API 程序声明式地定义了逻辑操作应该做什么而不是指定具体的操作代表的外观。把 Table API 想象成是通过用户自定义的