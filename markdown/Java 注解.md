# Java 注解

## 1 注解的基本概念和分类

### 1.1 注解的基本概念

> Annotation: Java 提供了一种原程序中的元素关联任何信息和任何元数据的途径和方法。

Annotation 是一个接口，程序可以通过反射来获取指定程序元素的 Annotation 对象，然后通过 Annotation 对象来获取注解里面的元数据。

Annotation 是 JDK5.0 及以后版本中引入的概念。

**Annotation 基本规则**：Annotation 不能影响程序代码的执行，无论增加、删除 Annotation，代码都始终如一的执行。

### 1.2 注解分类

#### 1.2.1 按照运行机制分类：

1. **源码注解**：注解只在源码中存在，编译成 .class 文件就不存在了。
2. **编译时注解**：注解在源码和 .class 中都存在。
3. **运行时注解**：在运行阶段还起作用，甚至还会影响运行逻辑的注解

#### 1.2.2 按照注解来源分类：

1. **JDK 自带注解**
2. **第三方注解**
3. **自定义注解**

### 1.3 元数据（Metadata）基本概念和作用

**元数据概念**：即描述数据的数据

**元数据的作用**：

- 编写文档：通过代码里标识的元数据生成文档（比如用 Javadoc  的注释自动生成文档）
- 代码分析：通过代码里标识的元数据对代码进行分析
- 编译检查：通过代码里标识的元数据让编译器能实现基本的编译检查

在 Java 中元数据以标签的形式存在于 Java 代码中，元数据标签的存在并不影响程序代码的编译和执行，它只是用来生成其它的文件或在运行时知道被运行代码的描述信息。

综上所述：

1. 元数据以标签的形式存在于 Java 代码中
2. 元数据描述的信息是类型安全的，即元数据内部的字段都是有明确类型的
3. 元数据需要编译器之外的工具额外的处理用来生成其它的程序部件
4. 元数据可以只存在于 Java 源代码级别，也可以存在于编译之后的 Class 文件内容

## 2 系统注解之标准注解和元注解

### 2.1 标准注解

JDK 中内置三个标准注解，定义在 java.lang 中：

1. **@Override**: 用于修饰此方法重写父类的方法
2. **@Deprecated**: 用于修饰已经过时的方法
3. **@SuppressWarnnings**: 用于通知 Java 编译器禁止特定的编译警告

### 2.2 元注解

元注解的作用就是负责注解其它注解。

Java 定义了 4 个标准的 meta-annotation 类型，它们被用来提供对其它 annotation 类型作说明。4 个元注解如下：

- @Target
- @Retention
- @Documented
- @Inherited

#### 2.2.1 @Target

**作用：用于描述该注解的作用对象（即该注解被用在什么对象上）**

@Target 指明了 Annotation 所修饰的对象范围：Annotation 可被用于 packages、types (类、接口、枚举、Annotation 类型)、类型成员（构造方法、普通方法、成员变量、枚举值）、方法参数和本地变量（如循环变量、catch 参数）。在 Annotation 类型的声明中使用了 @Target 可更加明确其修饰的目标。

**取值：**

- **ElementType.CONSTRUCTOR**：用于描述构造器
- **ElementType.FIELD**：用于描述字段
- **ElementType.LOCAL_VARIABLE**：用于描述局部变量
- **ElementType.METHOD**：用于描述方法
- **ElementType.PACKAGE**：用于描述包
- **ElementType.PARAMETER**：用于描述参数
- **ElementType.TYPE**：用于描述类、接口（包括注解类型）或枚举

#### 2.2.2 @Retention

**作用：表示需要在什么级别保存该注释信息，用于描述注解的生命周期（即被描述的注解在什么范围内有效）**

@Retention 定义了该 Annotation 被保留的时间：某些注解仅出现在源代码中，而被编译器丢弃；另外一些却被编译在 .class 文件中；编译在 .class 文件中的注解可能会被虚拟机忽略，而另一些在 .class 被装载时将被读取（并不会影响 class 的执行，因为注解与 class 在使用上是被分离的）。使用这个元注解可以对注解的生命周期作限制。

**取值：**

- **RetentionPolicy.SOURCE**：在源文件中有效（即源文件保留）
- **RetentionPolicy.CLASS**：在 .class 文件中有效（即 .class 保留）
- **RetentionPolicy.RUNTIME**：在运行时有效（即运行时保留）

#### 2.2.3 @Documented

@Documented 用于描述其它类型的注解应该作为被标注的程序成员的公共 API ，因此可以被例如 javadoc 此类的工具文档化。Documented 是一个标记注解，没有成员。

#### 2.2.4 @Inherited

@Inherited 元注解是一个标记注解，@Inherited 阐述了某个被标注的类型是被继承的。如果一个使用了  @Inherited 修饰的注解类型被用于一个 class，则这个注解将被用于该类的子类。

**Note**: @Inherited 注解类型是被标注过的类的子类所继承。而类并不会从它所实现的接口继承 Annotation，方法也并不从它所重载的方法继承 Annotation。 

当 @Inherited 注解类型标注的注解的 Retention 是 RetentionPolicy.RUNTIME，则反射 API 增强了这种继承性。如果我们使用 java.lang.reflect 去查询一个 @Inherited annotation 类型的注解时，反射代码检查将展开工作：检查 class 及其父类，进到发现指定的 annotation 类型被发现，或者到达类继承结构的顶层。

## 3 自定义注解和注解的使用

**定义注解的格式**：

```java
public @interface 注解名 {
    定义体
}
```

**注解参数支持的数据类型：**

- 所有基本数据类型（int, float, boolean, byte, double, char, long, short)
- String 类型
- Class 类型
- enum 类型
- Annotation 类型
- 以上所有类型的数组

**使用注解的语法：**

```java
@<注解名>(<成员名1> = <value1>, <成员名2> = <value2>, ...)
```

**自定义注解和使用注解的注意事项：**

1. 使用 @interface 关键字定义注解
2. 成员以无参无异常方式声明
3. default 为成员指定一个默认值
4. 成员类型是受限的，合法的类型包括上面的[注解参数支持的数据类型]()
5. 如果注解只有一个成员，成员名字必须取名为 value()，在使用时可以忽略成员名和赋值号（=）
6. 注解类可以没有成员，没有成员的注解称为标志注解

## 4 解析注解

**基本概念：**通过反射获取类，函数或者成员上的运行时注解信息，从而实现动态控制程序运行的逻辑。

java.lang.reflect 包下主要包含一些实现反射功能的工具类，扩充了读取运行时注解信息的能力。当一个注解类型被定义为运行时注解后，该注解才能是运行时可见的，当 .class 文件被装载时，保存在 .class 文件中的注解才会被虚拟机读取。

AnnotatedElement 接口是所有程序元素（Class, Method 和 Constructor) 的父接口，所以程序通过反射获取了某个类的 AnnotatedElement 对象之后，程序就可以调用该对象的如下四个方法来访问 Annotation 信息：

```java
方法1：<T extends Annotation> T getAnnotation(Class<T> annotationClass)：返回该程序元素上是否包含指定类型的注解，如果该类型注解不存在，则返回 null
方法2：Annotation[] getAnnotations()：返回该程序元素上存在的所有注解组成的数组
方法3：boolean isAnnotationPresent(Class<? extends Annotation> annotationClass)：判断该程序元素上是否包含指定类型的注解，存在则返回 true, 否则返回 false
方法4：Annotation[] getDeclareAnnotations()：返回直接存在于此元素上的所有注解。与此接口中的其他方法不同，该方法将忽略继承的注解。（如果没有注解直接存在于此元素上，则返回长度为零的数组）。
```

下面我们来看个例子，模拟查询数据库：













































![脑图](static\脑图.png)









