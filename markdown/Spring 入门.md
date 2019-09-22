# Spring 入门

## 1 Spring 体系结构

### 1.1 体系结构

Spring 是模块化的，允许用户选择适用于自己的模块，不必要把剩余部分也引入。

Spring 框架提供了约 20 个模块，可以根据应用程序的要求来使用。

![](static/spring/1.png)

### 1.2 核心容器

核心容器由 spring-core, spring-beans, spring-context, spring-context-support 和 spring-expression（SpEL, Spring 表达式语言，Spring Expression Language）等模块组成，具体细节如下：

- **spring-core** 模块：提供了框架的基本组成部分，包括 IOC 和依赖注入功能。
- **spring-beans** 模块：提供了 BeanFactory，工厂模式的微妙实现，它移除了编码式单例的需要，并且可以把配置和依赖从实际编码逻辑中解耦。
- **context** 模块：建立在由 core 和 beans 模块的基础上，它是一种类似于 JNDI 注册的方式访问对象。Context 模块继承自 Bean 模块，并且添加了国际化（比如使用资源束）、事件传播、资源加载和透明地创建上下文（比如通过 Servelet 容器）等功能。Context 模块也支持 Java EE 功能，比如 EJB、JMX 和远程调用等。ApplicationContext 接口是 Context 模块的焦点。spring-context-support 提供了对第三方库集成到 Spring 上下文的支持，比如缓存（EhCache, Guava, JCache）、邮件（JavaMail）、高度（CommonJ, Quartz）、模板引擎（FreeMarker， JasperReports， Velocity）等。
- **spring-expression** 模块：提供了强大的表达式语言，用于在运行时查询和操作对象图。它是 JSP2.1 规范中定义的统一表达式语言的扩展，支持 set 和 get 属性值、属性赋值、方法调用、访问数组集合及索引的内容、逻辑算术运算、命名变量、通过名字从 Spring IOC 容器检索对象，还支持列表的投影选择以及聚合等。

它们之间的完整依赖关系如下图所示：

![](static/spring/2.png)

### 1.3 数据访问/集成

数据访问/集成层包括 JDBC, ORM, OXM, JMS 和事务处理模块，它们的细节如下：

> JDBC = Java Date Base Connectivity
>
> ORM = Object Relational Mapping
>
> OXM = Object XML Mapping
>
> JMS = Java Message Service

- **JDBC** 模块：提供了 JDBC 抽象层，它消除了冗长的 JDBC 编码和对数据库供应商特定错误代码的解析。
- **ORM** 模块：提供了对流行的对象关系映射  API 的集成，包括 JPA, JDO 和 Hibernate 等。通过此模块可以让这些 ORM 框架和 Spring 的其它功能整合，比如事务管理
- **OXM** 模块：提供了对 OXM 实现的支持，比如 JAXB, Castor, XML Beans, JiBX, XStream 等。
- **JMS** 模块：包含生产（produce）和消费（consume）消息的功能，从 Spring 4.1 开始，集成了 spring-messaging 模块。
- **事务** 模块：为实现特殊接口类及所有的 POJO 支持编程式和声明式事务管理。（注：编程式事务需要自己写 beginTransaction(), commit(), rollback() 等事务管理方法，声明式事务是通过注解或配置由 Spring 自动处理，编程式事务粒度更细） 

### 1.4 Web

Web 层是由 Web, Web-MVC, Web-Socket 和 Web-Portlet 组成，它们的细节如下：

- **Web** 模块：提供面向 Web 的基本功能和面向 Web 的应用上下文，比如多部分（multipart）文件上传功能、使用 Servlet 监听器初始化 IoC 容器等。它还包括 HTTP 客户端以及 Spring 远程调用中与 web 相关的部分。
- **Web-MVC** 模块：为 web 应用提供了模型视图控制（MVC） 和 REST Web 服务的实现。Spring 的 MVC 框架可以使领域模型代码和 web 表单完全地分离，且可以与 Spring 框架的其它所有功能进行集成。
- **Web-Socket** 模块：为 WebSocket-based 提供了支持，而且在 web 应用程序中提供了客户端和服务器端之间通信的两种方式。
- **Web-Portlet** 模块：提供了用于 Portlet 环境的 MVC 实现，并反映了 spring-webmvc 模块的功能。

### 1.5 其它

还有其他一些重要的模块，像 [AOP](https://www.w3cschool.cn/wkspring/izae1h9w.html)，Aspects，Instrumentation，Web 和测试模块，它们的细节如下：

- **AOP** 模块：提供了面向方面的编程实现，允许你定义方法拦截器和切入点对代码进行干净地解耦，从而使实现功能的代码彻底的解耦出来。使用源码级的元数据，可以用类似于.Net属性的方式合并行为信息到代码中。
- **Aspects** 模块：提供了与 **AspectJ** 的集成，这是一个功能强大且成熟的面向切面编程（AOP）框架。
- **Instrumentation** 模块：在一定的应用服务器中提供了类 instrumentation 的支持和类加载器的实现。
- **Messaging** 模块：为 STOMP 提供了支持作为在应用程序中 WebSocket 子协议的使用。它也支持一个注解编程模型，它是为了选路和处理来自 WebSocket 客户端的 STOMP 信息。
- **测试 **模块：支持对具有 JUnit 或 TestNG 框架的 Spring 组件的测试。

## 2 Spring 环境配置

### 2.1 依赖

<img src="static/spring/3.png" style="zoom:50%;" />

### 2. 2 示例

创建一个 MainApp.java 类：

```java
package org.gldwolf;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class MainApp {
    public static void main(String[] args) {
        ApplicationContext context =
                new ClassPathXmlApplicationContext("Beans.xml");
        HelloWorld obj = (HelloWorld) context.getBean("helloWorld");
        obj.getMessage();
    }
}
```

创建一个 HelloWorld.java 的 Bean 类：

```java
package org.gldwolf;

public class HelloWorld {

    private String message;

    public void setMessage(String message){
        this.message  = message;
    }
    public void getMessage(){
        System.out.println("Your Message : " + message);
    }
}
```

创建一个 Beans.xml 配置文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    
    <bean id="helloWorld" class="org.gldwolf.HelloWorld">
        <property name="message" value="Hello World"/>
    </bean>

</beans>
```

## 3 Spring IoC 容器

### 3.1 IoC 容器

Spring 容器是 Spring 框架的核心。容器将创建对象，把它们连接在一块，配置它们，并管理它们的整个生命周期的从创建到销毁。Spring 容器使用依赖注入（DI）来管理组成一个应用程序的组件。这些对象被称为 Spring Beans。

通过读取配置元数据（XML配置文件等）提供的指令，容器知道对哪些对象进行实例化，配置和组装。配置元数据可以通过 **XML**，**Java 注释**或 **Java 代码**来表示。

如下图所示：Spring IoC 容器利用 Java 的 POJO 类和配置元数据来生成完全配置和可执行的系统或应用程序。

![](static\spring\4.jpg)

**IOC 容器**：具有依赖注入功能，它可以创建对象，IOC 容器负责实例化、定位、配置应用程序中的对象及建立这些对象间的依赖。通常 new 一个实例，控制权由程序员控制，而 "控制反转" 是指 new 实例工作不由程序员来做而是交给 Spring 容器来做。在 Spring 中 BeanFactory 是 IOC 容器的实际代表者。

Spring 提供了以下两种不同类型的容器：

| **序号**                    | **容器 & 描述**                                              |
| --------------------------- | ------------------------------------------------------------ |
| **BeanFactory 容器**        | 最简单的窗口，给 DI 提供了基本的支持，它用 org.springframework.beans.factory.BeanFactory 接口来定义。BeanFactory 或者相关的接口，如 BeanFactoryAware，InitializingBean，DisposableBean，在 Spring 中仍然存在，主要目的是向后兼容已经存在的和那些 Spring 整合在一起的第三方框架。 |
| **ApplicationContext 容器** | 该容器添加了更多的企业特定的功能，例如从一个属性谢谢你的爱中解析文本信息的能力，发布应用程序事件给感兴趣的事件监听器的能力。该窗口是由 org.springframework.context.ApplicationContext 接口定义。 |

ApplicationContext 容器包括了 BeanFactory 容器的所有功能，所以一般使用 ApplicationContext 窗口。BeanFactory 仍然可以用于轻量级的应用程序，如移动设备或基于 applet 的应用程序，其中它的数据量的速度是显著的。

#### 3.1.1 Spring BeanFactory 容器

在 Spring  中，有大量对 BeanFactory 接口的实现。其中，最常用的是 **XmlBeanFactory** 类。这个容器从一个 XML 文件中读取配置元数据，由这些元数据来生成一个被配置化的系统或者应用。

示例：

```java
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.ClassPathResource;
public class MainApp {
   public static void main(String[] args) {
      XmlBeanFactory factory = new XmlBeanFactory
                             (new ClassPathResource("Beans.xml"));
      HelloWorld obj = (HelloWorld) factory.getBean("helloWorld");
      obj.getMessage();
   }
}
```

在这段代码中，我们要注意两点：

- 第一步利用框架提供的 XmlBeanFactory API 来生成工厂 bean 以及利用 ClassPathResource() API 去加载路径 CLASSPATH 下可用的 bean 配置文件。XmlBeanFactory API 黄鹂创建并初始化所有的对象，即在配置文件中提到的 bean。
- 第二步利用第一步生成的 bean 工厂对象的 getBean() 方法得到所需要的 bean。这个方法通过配置文件中的 bean ID 来返回一个真正的对象，该对象作为最终使用的对象。一旦得到这个对象，就可以使用这个对象来调用任何方法。

#### 3.1.2 Spriing ApplicationContext 容器

ApplicationContext 是 BeanFactory 的子接口，也被称为 Spring 上下文对象。

ApplicationContext 是 Spring 中较高级的容器，和 BeanFactory 类似，它可以加载配置文件中定义的 bean，将所有的 bean 集中在一起，当有请求的时候就会分配 bean 对象。另外，如上面所说，它还增加企业所需的功能。

经常用的 ApplicationContext 接口的实现：

- FileSystemXmlApplicationContext：该容器从 XML 文件中加载已被定义的 bean。我们需要提供给构造器 XML 文件的完整路径。
- ClassPathXmlApplicationContext：该容器从 XML 文件中加载已被定义的 bean。我们不需要提供 XML 文件的完整路径，只需正确配置 CLASSPATH 环境变量即可，因为容器会从 CLASSPATH 中搜索 bean 的配置文件。
- WebXmlApplicationContext：该容器会在一个 web 应用程序的范围内加载在 XML 文件中已被定义的 bean。

示例：

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;
public class MainApp {
   public static void main(String[] args) {
      ApplicationContext context = new FileSystemXmlApplicationContext
            ("C:/Users/55441/workspace/HelloSpring/src/Beans.xml");
      HelloWorld obj = (HelloWorld) context.getBean("helloWorld");
      obj.getMessage();
   }
}
```

### 3.2 Spring Bean

#### 3.2.1 Spring Bean 的定义

Bean 是构成应用程序的支柱，由 Spring IOC 容器管理。Bean 是一个被实例化、组装并通过 Spring IOC 容器所管理的对象。

Bean 由容器创建，容器需要知道配置元数据：

- 如何创建一个 bean
- bean 的生命周期的详细信息
- bean 的依赖关系

bean 具有如下属性：

|             属性             |                             描述                             |
| :--------------------------: | :----------------------------------------------------------: |
|          **class**           |        这个属性是必须的，指定用来创建 bean 的 bean 类        |
|           **name**           | 这个属性指定唯一的 bean 标识符。在基于 XML 的配置元数据中，可以使用 id 或 name 属性来指定 bean 唯一标识符 |
|          **scope**           |        这个属性指定特定的 bean 定义创建的对象的作用域        |
|     **constructor-arg**      |                      用来注入依赖关系的                      |
|        **properties**        |                      用来注入依赖关系的                      |
|     **autowiring mode**      |                      用来注入依赖关系的                      |
| **lazy-initialization mode** | 延迟初始化的 bean，告知 IOC 容器在它第一次被请求时才会创建这个 bean 的实例 |
|   **initialization 方法**    |      在 bean 的所有属性被容器设置之后，调用这个回调方法      |
|     **destruction 方法**     |         当包含该 bean 的容器被销毁时，使用该回调方法         |

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <!-- A simple bean definition -->
   <bean id="..." class="...">
       <!-- collaborators and configuration for this bean go here -->
   </bean>

   <!-- A bean definition with lazy init set on -->
   <bean id="..." class="..." lazy-init="true">      
	<!-- collaborators and configuration for this bean go here -->
   </bean>

   <!-- A bean definition with initialization method -->
   <bean id="..." class="..." init-method="...">
       <!-- collaborators and configuration for this bean go here -->
   </bean>

   <!-- A bean definition with destruction method -->
   <bean id="..." class="..." destroy-method="...">
       <!-- collaborators and configuration for this bean go here -->
   </bean>

   <!-- more bean definitions go here -->

</beans>
```

##### Bean 与 Spring 容器的关系

![](static/spring/5.jpg)

##### Spring 配置元数据

Spring IOC 容器由实际编写的配置元数据实现解耦。有如下三种方法为 Spring 容器提供配置元数据：

- 基于 XML 的配置文件
- 基于注解的配置
- 基于 Java 的配置

#### 3.2.2 Spring Bean 的作用域

在定义一个 bean 时，必须声明该 bean 的作用域。例如，如果在每次请求的时候，都产生一个新的实例对象，那么就应该声明 bean 的作用域为  **prototype**。同样地，如果要返回同一个实例对象，那么该 bean 的作用域应该设置为 **singleton**。

Spring 框架支持以下 5 个作用域，如果使用 web-aware ApplicationContext 时，只有其中的三个是可用的：

|       作用域       |                             描述                             |
| :----------------: | :----------------------------------------------------------: |
|   **singleton**    | 在 Spring IOC 容器中只有一个 bean 实例，Bean 以单例的方式存在，这个作用域为默认的作用域 |
|   **prototype**    | 每次从容器中得到 Bean 时，都返回一个新的实例，即相当于 new 一个新对象 |
|    **request**     | 每次 HTTP 请求都会创建一个新的 Bean，该作用域仅适用于 WebApplicationContext 环境 |
|    **session**     | 同一个 HTTP Session 共享同一个 Bean 实例，不同的 Session 使用不同的实例对象，仅用于 WebApplicationContext 环境 |
| **global-session** | 一般用于 Portlet 应用环境，该作用域仅适用于 WebApplicationContext 环境 |

##### singleton 作用域：

singleton 是默认的作用域，即当定义 Bean 时，如果没有指定作用域配置项，则 Bean 的作用域默认为 singleton。

**Singleton 是单例类型，就是说在创建容器时就同时自动创建了这个  Bean 对象，不管是否使用，它都存在于容器中，每次获取这个对象时，都返回同一个实例。**如下所示，我们也可以在配置文件中设置作用域的属性为 singleton：

```xml
<!-- A bean definition with singleton scope -->
<bean id="..." class="..." scope="singleton">
    <!-- collaborators and configuration for this bean go here -->
</bean>
```

##### prototype 作用域：

当一个 bean 的作用域为 prototype 时，表示这个 bean 定义对应多个对象实例。每次对该 bean 请求（将其注入到另一个 bean，或者以程序的方式调用容器的 getBean() 方法）时，都会创建一个新的 Bean 实例。

**prototype 是原型类型，它在我们创建容器的时候并没有实例化，而是当我们获取 bean 时才会去创建一个对象，每次请求获取到的对象都是不同的实例对象。**

根据经验：**对有状态的 bean 应该使用 prototype 作用域，而对无状态的 bean 则应该使用 singleton 作用域**。

```xml
<!-- A bean definition with singleton scope -->
<bean id="..." class="..." scope="prototype">
   <!-- collaborators and configuration for this bean go here -->
</bean>
```

#### 3.2.3 Spring Bean 的生命周期

当一个 bean 被实例化时，它可能需要执行一些初始化使它转换成可用状态。同样，当 bean 不再需要，并且从容器中移除时，可能需要做一些清除工作。

为了定义安装和拆卸一个 bean 时的操作，我们只需要声明带有 **init-method** 和 **destroy-method** 参数。

init-method 属性指定一个方法，在实例化 bean 时，立即调用该方法。同样，destroy-method 指定一个方法，只有从容器中移除 bean 之后，才会调用这个方法。

Bean 的生命周期可以表达为：**Bean 的定义—— Bean 的初始化——Bean 的使用——Bean 的销毁**

##### 代码示例：

HelloWorld.java 代码

```java
public class HelloWorld {
   private String message;

   public void setMessage(String message){
      this.message  = message;
   }
   public void getMessage(){
      System.out.println("Your Message : " + message);
   }
   public void init(){
      System.out.println("Bean is going through init.");
   }
   public void destroy(){
      System.out.println("Bean will destroy now.");
   }
}
```

MainApp.java：在这是需要调用 Context 对象的 registerShutdownHook() 方法，它将确保正常关闭，并且调用相关的 destroy 方法。

```java
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
public class MainApp {
   public static void main(String[] args) {
      AbstractApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
      HelloWorld obj = (HelloWorld) context.getBean("helloWorld");
      obj.getMessage();
      context.registerShutdownHook();
   }
}
```

Beans.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <bean id="helloWorld" 
       class="com.tutorialspoint.HelloWorld"
       init-method="init" destroy-method="destroy">
       <property name="message" value="Hello World!"/>
   </bean>

</beans>
```

如果有很多的 Bean 都有相同名称的初始化或者销毁方法，那么我们可以不需要在每一个 bean 上声明初始化方法和销毁方法。框架使用元素中的 **default-init-method** 和 **default-destroy-method** 属性提供了灵活配置这种情况，如下所示：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd"
    default-init-method="init" 
    default-destroy-method="destroy">

   <bean id="..." class="...">
       <!-- collaborators and configuration for this bean go here -->
   </bean>

</beans>
```

#### 3.2.4 Spring Bean 后置处理器

**Bean 后置处理器允许在调用初始化方法前后对 Bean 进行额外的处理。**

BeanPostProcessor 接口定义回调方法，可以实现该方法来提供自己的实例化逻辑，依赖解析逻辑等。也可以在 Spring 容器通过插入一个或多个 BeanPostProcessor 的实现来完成实例化，配置和初始化一个 bean 之后 实现一些自定义逻辑回调方法。

我们可以通过配置多个 BeanPostProcessor 接口，通过设置 BeanPostProcessor 实现的 Ordered 接口提供的 order 属性来控制这些 BeanPostProcessor 接口的执行顺序。

*ApplicationContext 会自动检测由 BeanPostProcessor 接口的实现定义的 Bean，并注册这些 Bean 为后置处理器，然后通过在容器中创建 bean，在适当的时候调用它。*

##### 代码示例：

HelloWorld.java

```java
public class HelloWorld {
   private String message;
   public void setMessage(String message){
      this.message  = message;
   }
   public void getMessage(){
      System.out.println("Your Message : " + message);
   }
   public void init(){
      System.out.println("Bean is going through init.");
   }
   public void destroy(){
      System.out.println("Bean will destroy now.");
   }
}
```

InitHelloWorld.java

```java
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.beans.BeansException;
public class InitHelloWorld implements BeanPostProcessor {
   public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
      System.out.println("BeforeInitialization : " + beanName);
      return bean;  // you can return any other object as well
   }
   public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
      System.out.println("AfterInitialization : " + beanName);
      return bean;  // you can return any other object as well
   }
}
```

MainApp.java：在这是需要调用 Context 对象的 registerShutdownHook() 方法，它将确保正常关闭，并且调用相关的 destroy 方法。

```java
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
public class MainApp {
   public static void main(String[] args) {
      AbstractApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
      HelloWorld obj = (HelloWorld) context.getBean("helloWorld");
      obj.getMessage();
      context.registerShutdownHook();
   }
}
```

Beans.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <bean id="helloWorld" class="com.tutorialspoint.HelloWorld"
       init-method="init" destroy-method="destroy">
       <property name="message" value="Hello World!"/>
   </bean>

   <bean class="com.tutorialspoint.InitHelloWorld" />

</beans>
```

输出结果就如下所示：

```
BeforeInitialization : helloWorld
Bean is going through init.
AfterInitialization : helloWorld
Your Message : Hello World!
Bean will destroy now.
```

#### 3.2.5 Spring Bean 继承

bean 定义可以包含很多的配置信息，包括构造函数的参数，属性值，容器的具体信息，例如初始化方法，静态工厂方法名等等。

子 bean 的定义继承父 bean 定义的配置数据。子定义可以根据需要重写一些值，或者添加其他值。

Spring Bean 定义的继承与 Java 类的继承无关，但是是继承的概念是一样的。

我们可以定义一个父 Bean 作为模板，这样其他子 bean 就可以从父 bean 中继承所需要的配置。

当使用基于 XML 的配置元数据时，通过使用父属性，指定父 bean 作为该属性的值来表明子 bean 的定义。

##### 代码示例：

**Beans.xml**：在该配置文件中我们定义有两个属性 *message1* 和 *message2* 的 “helloWorld” bean。然后，使用 **parent** 属性把 “helloIndia” bean 定义为 “helloWorld” bean 的孩子。这个子 bean 继承 *message2* 的属性，重写 *message1* 的属性，并且引入一个属性 *message3*。

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <bean id="helloWorld" class="com.tutorialspoint.HelloWorld">
      <property name="message1" value="Hello World!"/>
      <property name="message2" value="Hello Second World!"/>
   </bean>

   <bean id="helloIndia" class="com.tutorialspoint.HelloIndia" parent="helloWorld">
      <property name="message1" value="Hello India!"/>
      <property name="message3" value="Namaste India!"/>
   </bean>

</beans>
```

HelloWorld.java:

```java
public class HelloWorld {
   private String message1;
   private String message2;
   public void setMessage1(String message){
      this.message1  = message;
   }
   public void setMessage2(String message){
      this.message2  = message;
   }
   public void getMessage1(){
      System.out.println("World Message1 : " + message1);
   }
   public void getMessage2(){
      System.out.println("World Message2 : " + message2);
   }
}
```

HelloIndis.java:

```java
public class HelloIndia {
   private String message1;
   private String message2;
   private String message3;

   public void setMessage1(String message){
      this.message1  = message;
   }

   public void setMessage2(String message){
      this.message2  = message;
   }

   public void setMessage3(String message){
      this.message3  = message;
   }
   public void getMessage1(){
      System.out.println("India Message1 : " + message1);
   }

   public void getMessage2(){
      System.out.println("India Message2 : " + message2);
   }

   public void getMessage3(){
      System.out.println("India Message3 : " + message3);
   }
}
```

MainApp.java:

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class MainApp {
   public static void main(String[] args) {
      ApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");

      HelloWorld objA = (HelloWorld) context.getBean("helloWorld");

      objA.getMessage1();
      objA.getMessage2();

      HelloIndia objB = (HelloIndia) context.getBean("helloIndia");
      objB.getMessage1();
      objB.getMessage2();
      objB.getMessage3();
   }
}
```

输出结果如下：

```
World Message1 : Hello World!
World Message2 : Hello Second World!
India Message1 : Hello India!
India Message2 : Hello Second World!
India Message3 : Namaste India!
```

可以看出，我们创建 “helloIndia” bean 的同时并没有传递 message2，但是由于 Bean 定义的继承，所以它传递了 message2。

##### 3.2.5.1 Bean 定义模板

创建一个 Bean 定义模板，用于被其它子 bean 定义。在定义一个 Bean 定义模板时，**不应该指定类的属性**，而**应该指定带 true 值的 abstract 属性**，如下所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <bean id="beanTeamplate" abstract="true">
      <property name="message1" value="Hello World!"/>
      <property name="message2" value="Hello Second World!"/>
      <property name="message3" value="Namaste India!"/>
   </bean>

   <bean id="helloIndia" class="com.tutorialspoint.HelloIndia" parent="beanTeamplate">
      <property name="message1" value="Hello India!"/>
      <property name="message3" value="Namaste India!"/>
   </bean>
    
</beans>
```

父 Bean 自身不能被实例化，因为它是不完整的，而且它也被明确的标记为抽象的。当定义一个抽象的  bean 时，它仅仅作为一个纯粹的模板 bean 定义来使用，充当子定义的父定义使用。

## 4 Spring 依赖注入

Spring 框架的核心功能之一就是通过依赖注入的方式来管理 Bean 之间的依赖关系。

> 每个基于应用程序的 Java 都有几个对象，这些对象一起工作来呈现出终端用户所看到的工作的应用程序。当编写一个复杂的 Java 应用程序时，应用程序烟台冰轮应该尽可能独立于其他 Java 类来增加这些类重用的可能性，并且在做单元测试时，测试独立于其他类的独立性。

依赖注入（有时称为布线）有助于把这些类粘合在一起，同时保持它们的独立性。

假设有一个包含文本编辑器组件的应用程序，并且想要提供拼写检查。标准代码如下：

```java
public class TextEditor {
   private SpellChecker spellChecker;  
   public TextEditor() {
      spellChecker = new SpellChecker();
   }
}
```

如果使用控制反转的场景中，我们会这样做：

```java
public class TextEditor {
   private SpellChecker spellChecker;
   public TextEditor(SpellChecker spellChecker) {
      this.spellChecker = spellChecker;
   }
}
```

这样，TestEditor 就不用关心 SpellChecker 的实现。SpellChecker 将会独立实现，并且在 TextEditor 实例化的时候将提供给 TextEditor，整个过程是由 Spring 框架控制。

在这里，我们已经从 TextEditor 中删除了全面的控制权（自己创建依赖的类），并且把它保存到了其它的地方（即 XML 配置文件），且依赖关系（即 SpellChecker 类）通过类构造函数被注入到了 TextEditor 类中。因此，控制流通过依赖注入（DI）已经 "反转"，因为已经将依赖关系委托到了外部系统中。

依赖注入的第二种方法是通过 TextEditor 类的 **Setter** 方法。

因此 ，DI 主要有两种变体：

|                依赖注入类型                |                             描述                             |
| :----------------------------------------: | :----------------------------------------------------------: |
| **Constructor-based dependency injection** | 当容器调用带有多个参数的构造方法时，实现基于构造函数的 DI，每个参数代表在其它类中的一个依赖关系 |
|   **Setter-based dependency injection**    | 基于 setter 方法的 DI 是通过在调用无参数的构造方法或无参数的静态工厂方法实例化 bean 之后 窗口调用 beans 的 setter 方法来实现 |

我们可以混合使用基于构造方法和基于 setter 方法的依赖注入，**如果有强依赖关系的话适合选用构造方法的方式，如果是可选依赖关系的话，则建议使用 setter 的方式**。

对象不查找它的依赖关系，也不知道依赖关系的位置或类，这一切是由 Spring 框架控制的。

### 4.1 Spring 基于构造函数的依赖注入

当容器调用带有一组参数的类构造函数时，基于构造函数的 DI 就完成了，其中每个参数代表一个对其他类的依赖。

**示例**：

下面的例子显示了一个类 TextEditor，只能用构造函数注入来实现依赖注入。

TestEditor.java

```java
public class TextEditor {
   private SpellChecker spellChecker;
   public TextEditor(SpellChecker spellChecker) {
      System.out.println("Inside TextEditor constructor." );
      this.spellChecker = spellChecker;
   }
   public void spellCheck() {
      spellChecker.checkSpelling();
   }
}
```

SpellChecker.java（即 TextEditor 的依赖类）：

```java
public class SpellChecker {
   public SpellChecker(){
      System.out.println("Inside SpellChecker constructor." );
   }
   public void checkSpelling() {
      System.out.println("Inside checkSpelling." );
   } 
}
```

MainApp.java

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
public class MainApp {
   public static void main(String[] args) {
      ApplicationContext context = 
             new ClassPathXmlApplicationContext("Beans.xml");
      TextEditor te = (TextEditor) context.getBean("textEditor");
      te.spellCheck();
   }
}
```

Beans.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <!-- Definition for textEditor bean -->
   <bean id="textEditor" class="com.tutorialspoint.TextEditor">
      <constructor-arg ref="spellChecker"/>
   </bean>

   <!-- Definition for spellChecker bean -->
   <bean id="spellChecker" class="com.tutorialspoint.SpellChecker">
   </bean>

</beans>
```

如果程序运行顺利，将会得到如下输出结果：

```
Inside SpellChecker constructor.
Inside TextEditor constructor.
Inside checkSpelling.
```

#### 4.1.1 构造函数参数解析

如果存在不止一个构造参数时，当把参数传递给构造函数时，可能会存在歧义。要解决这个问题，那么构造函数的参数在 bean 定义中的顺序就是把这些参数提供给适当的构造函数。例如：

Foo.java

```java
package x.y;

public class Foo {
   public Foo(Bar bar, Baz baz) {
      // ...
   }
}
```

则使用如下的 Beans.xml 配置文件：

```xml
<beans>
   <bean id="foo" class="x.y.Foo">
      <constructor-arg ref="bar"/>
      <constructor-arg ref="baz"/>
   </bean>

   <bean id="bar" class="x.y.Bar"/>
   <bean id="baz" class="x.y.Baz"/>
</beans>
```

又例如：

```java
package x.y;
public class Foo {
    public Foo(int year, String name) {
        // ...
    }
}
```

如果使用 type 属性显式地指定了构造函数参数的类型，容器也可以使用与简单类型匹配的类型。

Beans.xml

```xml
<beans>

   <bean id="exampleBean" class="examples.ExampleBean">
      <constructor-arg type="int" value="2001"/>
      <constructor-arg type="java.lang.String" value="Zara"/>
   </bean>

</beans>
```

**最好使用如下传递构造函数参数的方式**：使用 index 属性来显式地指定构造函数参数的索引。下面是基于索引为 0 的例子：

```xml
<beans>

   <bean id="exampleBean" class="examples.ExampleBean">
      <constructor-arg index="0" value="2001"/>
      <constructor-arg index="1" value="Zara"/>
   </bean>

</beans>
```

最后，如果想要向一个对象传递一个引用类型的参数，需要使用标签的 ref 属性，如果想要直接传递值，可以使用上面提到 type + value 或者 index + value 的方式进行传参。

### 4.2 Spring 基于设值函数（setter）的依赖注入

当容器调用一个无参的构造函数或一个无参的静态 factory 方法来初始化 bean 后，通过容器在 bean 上调用 setter 方法，基于设值函数的 DI 就完成了。

**示例**：

下述的例子表明了一个类 TextEditor 只能使用纯粹的基于设值函数的注入来实现依赖注入。

**TextEditor.java**

```java
public class TextEditor {
   private SpellChecker spellChecker;
   // a setter method to inject the dependency.
   public void setSpellChecker(SpellChecker spellChecker) {
      System.out.println("Inside setSpellChecker." );
      this.spellChecker = spellChecker;
   }
   // a getter method to return spellChecker
   public SpellChecker getSpellChecker() {
      return spellChecker;
   }
   public void spellCheck() {
      spellChecker.checkSpelling();
   }
}
```

在这里，需要检查设值函数方法的名称转换。要设置一个变量 spellChecher，使用 setSpellChecker() 方法，该方法与 Java POJO 类非常相似。

**SpellChecker.java**

```java
public class SpellChecker {
   public SpellChecker(){
      System.out.println("Inside SpellChecker constructor." );
   }
   public void checkSpelling() {
      System.out.println("Inside checkSpelling." );
   }  
}
```

**MainApp.java**

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
public class MainApp {
   public static void main(String[] args) {
      ApplicationContext context = 
             new ClassPathXmlApplicationContext("Beans.xml");
      TextEditor te = (TextEditor) context.getBean("textEditor");
      te.spellCheck();
   }
}
```

**Beans.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <!-- Definition for textEditor bean -->
   <bean id="textEditor" class="com.tutorialspoint.TextEditor">
      <property name="spellChecker" ref="spellChecker"/>
   </bean>

   <!-- Definition for spellChecker bean -->
   <bean id="spellChecker" class="com.tutorialspoint.SpellChecker">
   </bean>

</beans>
```

如果程序运行顺利，则会显示如下消息：

```
Inside SpellChecker constructor.
Inside setSpellChecker.
Inside checkSpelling.
```

#### 4.2.1 基于构造函数注入和基于设值函数注入区别：

唯一区别就在于**基于构造函数注入中，我们使用的 <bean> 标签中的 <constructor-arg> 元素，而在基于设值函数的注入中，我们使用的是 <bean> 标签中的 <property> 元素。**

此外，还要注意，如果要把一个引用传递给一个对象，需要使用标签中的 ref 属性，而如果要直接传递一个值，那么应该使用 value 属性。

#### 4.2.2 使用 p-namespace 实现 XML 配置

如果有许多的设值函数，那么在 XML 配置文件中使用 p-namespace 是非常方便的。

**标准的 XML 配置文件**：

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <bean id="john-classic" class="com.example.Person">
      <property name="name" value="John Doe"/>
      <property name="spouse" ref="jane"/>
   </bean>

   <bean name="jane" class="com.example.Person">
      <property name="name" value="John Doe"/>
   </bean>

</beans>
```

上述的 XML 配置文件可以使用 p-namespace 以一种更简洁的方式书写：

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:p="http://www.springframework.org/schema/p"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <bean id="john-classic" class="com.example.Person"
      p:name="John Doe"
      p:spouse-ref="jane"/>
   </bean>

   <bean name="jane" class="com.example.Person"
      p:name="John Doe"/>
   </bean>

</beans>
```

**-ref** 表明这不是一个直接的值，而是对另一个 bean 的引用 。

### 4.3 Spring 内部 Beans 注入

> 在 bean 内部的 bean 称为内部 bean

如下所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <bean id="outerBean" class="...">
      <property name="target">
         <bean id="innerBean" class="..."/>
      </property>
   </bean>

</beans>

```

内部 bean 使用示例：

**TextEditor.java**:

```java
public class TextEditor {
   private SpellChecker spellChecker;
   // a setter method to inject the dependency.
   public void setSpellChecker(SpellChecker spellChecker) {
      System.out.println("Inside setSpellChecker." );
      this.spellChecker = spellChecker;
   }  
   // a getter method to return spellChecker
   public SpellChecker getSpellChecker() {
      return spellChecker;
   }
   public void spellCheck() {
      spellChecker.checkSpelling();
   }
}
```

**SpellChecker.java**:

```java
public class SpellChecker {
   public SpellChecker(){
      System.out.println("Inside SpellChecker constructor." );
   }
   public void checkSpelling(){
      System.out.println("Inside checkSpelling." );
   }   
}
```

**MainApp.java**:

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
public class MainApp {
   public static void main(String[] args) {
      ApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
      TextEditor te = (TextEditor) context.getBean("textEditor");
      te.spellCheck();
   }
}
```

下面使用 **内部 bean** 为基于 setter 注入进行配置的 **Beans.xml** 文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <!-- Definition for textEditor bean using inner bean -->
   <bean id="textEditor" class="com.tutorialspoint.TextEditor">
      <property name="spellChecker">
         <bean id="spellChecker" class="com.tutorialspoint.SpellChecker"/>
       </property>
   </bean>

</beans>
```

如果程序运行成功，会输出如下消息：

```
Inside SpellChecker constructor.
Inside setSpellChecker.
Inside checkSpelling.
```

### 4.4 Spring 集合注入

我们可以使用 value 属性来配置基本的数据类型和 <property> 标签的 ref 属性来配置引用类型，但这两种情况都是处理只有一个值的情况。

如果想传递多个值，如 Java Collection 类型 List、Set、Map 和 Properties，那么应该使用 Spring 提供了如下四种类型的集合的配置元素：

|     元素     |                          描述                           |
| :----------: | :-----------------------------------------------------: |
| **\<list>**  |                 如注入一列值，允许重复                  |
|  **\<set>**  |                        不能重复                         |
|  **\<map>**  |   可以用来注入键-值对的集合，其中键和值可以是任何类型   |
| **\<props>** | 可以用来注入键-值对的集合，其中键和值都必须是字符串类型 |

我们可以使用 \<list> 或 \<set> 来连接任何 `java.util.Collection` 的实现或数组。

我们可能会遇到如下两种情况：

- 传递集合中直接的值
- 传递一个 bean 的引用作为集合的元素

#### 代码示例：

**JavaCollection.java**

```java
import java.util.*;
public class JavaCollection {
   List addressList;
   Set  addressSet;
   Map  addressMap;
   Properties addressProp;
   // a setter method to set List
   public void setAddressList(List addressList) {
      this.addressList = addressList;
   }
   // prints and returns all the elements of the list.
   public List getAddressList() {
      System.out.println("List Elements :"  + addressList);
      return addressList;
   }
   // a setter method to set Set
   public void setAddressSet(Set addressSet) {
      this.addressSet = addressSet;
   }
   // prints and returns all the elements of the Set.
   public Set getAddressSet() {
      System.out.println("Set Elements :"  + addressSet);
      return addressSet;
   }
   // a setter method to set Map
   public void setAddressMap(Map addressMap) {
      this.addressMap = addressMap;
   }  
   // prints and returns all the elements of the Map.
   public Map getAddressMap() {
      System.out.println("Map Elements :"  + addressMap);
      return addressMap;
   }
   // a setter method to set Property
   public void setAddressProp(Properties addressProp) {
      this.addressProp = addressProp;
   } 
   // prints and returns all the elements of the Property.
   public Properties getAddressProp() {
      System.out.println("Property Elements :"  + addressProp);
      return addressProp;
   }
}
```

**MainApp.java**

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
public class MainApp {
   public static void main(String[] args) {
      ApplicationContext context = 
             new ClassPathXmlApplicationContext("Beans.xml");
      JavaCollection jc=(JavaCollection)context.getBean("javaCollection");
      jc.getAddressList();
      jc.getAddressSet();
      jc.getAddressMap();
      jc.getAddressProp();
   }
}
```

**Beans.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <!-- Definition for javaCollection -->
   <bean id="javaCollection" class="com.tutorialspoint.JavaCollection">

      <!-- results in a setAddressList(java.util.List) call -->
      <property name="addressList">
         <list>
            <value>INDIA</value>
            <value>Pakistan</value>
            <value>USA</value>
            <value>USA</value>
         </list>
      </property>

      <!-- results in a setAddressSet(java.util.Set) call -->
      <property name="addressSet">
         <set>
            <value>INDIA</value>
            <value>Pakistan</value>
            <value>USA</value>
            <value>USA</value>
        </set>
      </property>

      <!-- results in a setAddressMap(java.util.Map) call -->
      <property name="addressMap">
         <map>
            <entry key="1" value="INDIA"/>
            <entry key="2" value="Pakistan"/>
            <entry key="3" value="USA"/>
            <entry key="4" value="USA"/>
         </map>
      </property>

      <!-- results in a setAddressProp(java.util.Properties) call -->
      <property name="addressProp">
         <props>
            <prop key="one">INDIA</prop>
            <prop key="two">Pakistan</prop>
            <prop key="three">USA</prop>
            <prop key="four">USA</prop>
         </props>
      </property>

   </bean>

</beans>
```

如果程序运行成功，则会输出如下消息：

```
List Elements :[INDIA, Pakistan, USA, USA]
Set Elements :[INDIA, Pakistan, USA]
Map Elements :{1=INDIA, 2=Pakistan, 3=USA, 4=USA}
Property Elements :{two=Pakistan, one=INDIA, three=USA, four=USA}
```

#### 4.4.1 注入 Bean 引用 

下面的 Bean 定义是演示如何注入 bean 的引用作为集合的元素：

**Beans.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <!-- Bean Definition to handle references and values -->
   <bean id="..." class="...">

      <!-- Passing bean reference  for java.util.List -->
      <property name="addressList">
         <list>
            <ref bean="address1"/>
            <ref bean="address2"/>
            <value>Pakistan</value>
         </list>
      </property>

      <!-- Passing bean reference  for java.util.Set -->
      <property name="addressSet">
         <set>
            <ref bean="address1"/>
            <ref bean="address2"/>
            <value>Pakistan</value>
         </set>
      </property>

      <!-- Passing bean reference  for java.util.Map -->
      <property name="addressMap">
         <map>
            <entry key="one" value="INDIA"/>
            <entry key ="two" value-ref="address1"/>
            <entry key ="three" value-ref="address2"/>
         </map>
      </property>

   </bean>

</beans>
```

为了使用上面的注入方式，需要定义 setter 方法。

#### 4.4.2 注入 null 和空字符串的值

如果需要传递一个空字符串作为值，可以使用如下的方式：

```xml
<bean id="..." class="exampleBean">
   <property name="email" value=""/>
</bean>
```

如果需要传递一个 null 值，那么使用如下方式：

```xml
<bean id="..." class="exampleBean">
   <property name="email"><null/></property>
</bean>
```

## 5 Spring Beans 自动装配

Spring 容器可以在不使用 \<constructor-arg> 和 \<property> 元素的情况下自动装配 beans，这有助于减少编写一个很大的 XML 配置文件。

**自动装配模式**

下面的自动装配模式可以用于指示 Spring 容器为使用自动装配进行依赖注入。可以使用 \<bean> 元素的 **autowire** 属性为一个 bean 定义指定自动装配模式。

|      模式       |                             描述                             |
| :-------------: | :----------------------------------------------------------: |
|     **no**      |                 默认设置，意味着没有自动装配                 |
|   **byName**    | 根据属性名自动装配。在 bean 的自动装配属性为 byName 时，尝试匹配，并且将它的属性与配置文件中被定义为相同名称的 beans 的属性进行连接 |
|   **byType**    | 由属性数据类型自动装配。在 bean 的自动装配属性为 byType 时，如果它的类型匹配配置文件中的一个确切的 bean 名称时，它将尝试匹配和连接属性的类型。如果存在不止一个这样的 bean，则会抛出一个异常 |
| **constructor** | 类似于 byType，但该类型适用于构造函数参数类型。如果在容器中没有一个构造函数参数类型的 bean，则抛出异常 |
| **autodetect**  | Spring 首先尝试通过 constructor 使用自动装配来连接，如果不成功，则尝试使用 byType 来自动装配 |

可以使用 byType 或者 constructor 自动装配模式来连接数组和其他类型的集合。

**自动装配的局限性**

当自动装配始终在同一个项目中使用时，效果最好。如果通常不使用自动装配，它可能会使开发人员混淆的使用它来连接只有一个或两个的 bean 定义。不过，自动装配可以显著的减少需要指定的属性或构造器参数，但是在使用之前应该考虑到自动装配的局限性和缺点：

|     限制     | 描述                                                         |
| :----------: | ------------------------------------------------------------ |
| 重写的可能性 | 可以使用总是重写自动装配的 \<constructor-arg> 和 \<property> 设置来指定依赖关系 |
| 原始数据类型 | 不能自动装配所谓的简单类型，包括基本类型，字符串和类         |
|  混乱的本质  | **自动装配不如显式装配精确，所以如果可能的话尽量使用显式装配** |

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

自动装配后面再完善

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## 6 Spring 基于注解的配置

我们可以使用注解来配置依赖注入而不是采用 XML 来配置一个 bean。

可以使用相关类、方法或字段声明的注解，将 bean 配置移动到组件类本身。

默认情况下在 Spring 容器中是不开启注解配置的，因此，在使用基于注解配置之前 ，需要在 Spring 配置文件中启用它：

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
    http://www.springframework.org/schema/context
    http://www.springframework.org/schema/context/spring-context-3.0.xsd">

   <context:annotation-config/>
   <!-- bean definitions go here -->

</beans>
```

设置完成后，就可以用注解来配置代码了，表明 Spring 应该自动将值赋给属性、方法和构造函数。

下面是几个重要的注解：

|           注解            |                             描述                             |
| :-----------------------: | :----------------------------------------------------------: |
|       **@Required**       |                应用于 bean 属性的 setter 方法                |
|      **@Autowired**       | 应用于 bean 属性的 setter 方法、非 setter 方法、构造函数和属性 |
|      **@Qualifier**       | 通过指定确切的 bean，@Autowired 和 @Qualifier 注解可以用来删除混乱 ？？？（尚不明确是什么意思，待研究） |
| **JSR-250 Annotatations** | Spring 支持 JSR-250 的基础注解，其中包括了 @Resource、@PostConstruct 和 @PreDestroy 注解 |

### 6.1 Spring @Required 注解

@Required 注解应用于 bean 属性的 setter 方法，它表明被注解的这个  bean 的那个属性在配置时必须放在 XML 配置文件中，否则容器就会抛出一个 BeanInitialzationException 异常。

**代码示例**：

**Student.java**

```java
import org.springframework.beans.factory.annotation.Required;
public class Student {
   private Integer age;
   private String name;
   @Required
   public void setAge(Integer age) {
      this.age = age;
   }
   public Integer getAge() {
      return age;
   }
   @Required
   public void setName(String name) {
      this.name = name;
   }
   public String getName() {
      return name;
   }
}
```

**MainApp.java**

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
public class MainApp {
   public static void main(String[] args) {
      ApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
      Student student = (Student) context.getBean("student");
      System.out.println("Name : " + student.getName() );
      System.out.println("Age : " + student.getAge() );
   }
}
```

**Beans.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
    http://www.springframework.org/schema/context
    http://www.springframework.org/schema/context/spring-context-3.0.xsd">

   <context:annotation-config/>

   <!-- Definition for student bean -->
   <bean id="student" class="com.tutorialspoint.Student">
      <property name="name"  value="Zara" />

      <!-- try without passing age and check the result -->
      <!-- property name="age"  value="11"-->
   </bean>

</beans>
```

上面的配置文件注释了 name 属性的配置，如果运行程序则会报错：

```
Property 'age' is required for bean 'student'
```

### 6.2 @Autowired 注解

@Autowired 注解在对哪里和如何完成属性与值的连接提供了更多的细微地控制。

@Autowired 注解可以在 setter 方法中被用于自动注入。

#### 6.2.1 setter 方法中的 @Autowired 

当 Spring 遇到一个在 setter 方法中使用 @Autowired 注解时，它会在方法中执行 byType 自动装配。

代码示例（在 setter 方法上使用 @Autowired 注解的方式）：**此时就可以不用在 XML 配置文件中配置 \<property> 的方式来装配属性的值**

**TextEditor.java**

```java
import org.springframework.beans.factory.annotation.Autowired;
public class TextEditor {
   private SpellChecker spellChecker;
   
    @Autowired
   public void setSpellChecker( SpellChecker spellChecker ){
      this.spellChecker = spellChecker;
   }
   public SpellChecker getSpellChecker( ) {
      return spellChecker;
   }
   public void spellCheck() {
      spellChecker.checkSpelling();
   }
}
```

**SpellChecker.java**

```java
public class SpellChecker {
   public SpellChecker(){
      System.out.println("Inside SpellChecker constructor." );
   }
   public void checkSpelling(){
      System.out.println("Inside checkSpelling." );
   }  
}
```

**MainApp.java**

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
public class MainApp {
   public static void main(String[] args) {
      ApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
      TextEditor te = (TextEditor) context.getBean("textEditor");
      te.spellCheck();
   }
}
```

**Beans.xml**

```java
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
    http://www.springframework.org/schema/context
    http://www.springframework.org/schema/context/spring-context-3.0.xsd">

   <context:annotation-config/>

   <!-- Definition for textEditor bean without constructor-arg  -->
   <bean id="textEditor" class="com.tutorialspoint.TextEditor">
   </bean>

   <!-- Definition for spellChecker bean -->
   <bean id="spellChecker" class="com.tutorialspoint.SpellChecker">
   </bean>

</beans>
```

如果运行成功，则会输出如下的消息：

```
Inside SpellChecker constructor.
Inside checkSpelling.
```

#### 6.2.2 属性中的 @Autowired

我们可以在属性中使用 **@Autowired** 注解来省去设置 setter 方法。

当使用自动装配时，Spring 会将这些传递过来的值或者引用自动装配给被注解的属性。如果使用 @Autowired 注解，则代码就会变成如下的方式：

**TextEditor.java**

```java
import org.springframework.beans.factory.annotation.Autowired;
public class TextEditor {
   @Autowired
   private SpellChecker spellChecker;
   public TextEditor() {
      System.out.println("Inside TextEditor constructor." );
   }  
   public SpellChecker getSpellChecker( ){
      return spellChecker;
   }  
   public void spellCheck(){
      spellChecker.checkSpelling();
   }
}
```

**Beans.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
    http://www.springframework.org/schema/context
    http://www.springframework.org/schema/context/spring-context-3.0.xsd">

   <context:annotation-config/>

   <!-- Definition for textEditor bean -->
   <bean id="textEditor" class="com.tutorialspoint.TextEditor">
   </bean>

   <!-- Definition for spellChecker bean -->
   <bean id="spellChecker" class="com.tutorialspoint.SpellChecker">
   </bean>

</beans>
```

如果程序执行成功，则可以输出如下消息：

```
Inside SpellChecker constructor.
Inside TextEditor constructor.
Inside checkSpelling.
```

#### 6.2.3 构造函数中的 @Autowired

我们也可以在构造函数中使用 @Autowired。在一个构造函数中使用 @Autowired 说明当创建 bean时，即使在 XML 文件中没有配置这个属性，那么这个属性也会被自动装配。

示例：

**TextEditor.java**

```java
import org.springframework.beans.factory.annotation.Autowired;
public class TextEditor {
   private SpellChecker spellChecker;
   @Autowired
   public TextEditor(SpellChecker spellChecker){
      System.out.println("Inside TextEditor constructor." );
      this.spellChecker = spellChecker;
   }
   public void spellCheck(){
      spellChecker.checkSpelling();
   }
}
```

**Beans.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
    http://www.springframework.org/schema/context
    http://www.springframework.org/schema/context/spring-context-3.0.xsd">

   <context:annotation-config/>

   <!-- 这个 bean 定义中并没有定义构造函数的参数 -->
   <bean id="textEditor" class="com.tutorialspoint.TextEditor">
   </bean>

   <!-- Definition for spellChecker bean -->
   <bean id="spellChecker" class="com.tutorialspoint.SpellChecker">
   </bean>

</beans>
```

如果上述程序运行成功，将会输出以下消息：

```
Inside SpellChecker constructor.
Inside TextEditor constructor.
Inside checkSpelling.
```

#### 6.2.4 @Autowired 中的（required=false）选项

默认情况下，@Autowired 注解意味着依赖是必须的，它类似于 @Required 注解，我们也可以使用 @Autowired 的（required=false）选项关闭默认行为。

下面的示例中，对于 name 属性必须设置一个值，而 age 可以不用传递任何参数：

```java
import org.springframework.beans.factory.annotation.Autowired;
public class Student {
   private Integer age;
   private String name;
   @Autowired(required=false)
   public void setAge(Integer age) {
      this.age = age;
   }  
   public Integer getAge() {
      return age;
   }
   @Autowired
   public void setName(String name) {
      this.name = name;
   }   
   public String getName() {
      return name;
   }
}
```

### 6.3 @Qualifier 注解

可能会有这样一种情况，当创建多个具有相同类型的 bean 时，并且想要指定确切的 bean 对属性进行装配，这时，可以使用 @Qualifier 注解和 @Autowired 注解通过指定哪个 bean 会被装配，以消除混淆情况。

示例：

**Student.java**

```java
public class Student {
   private Integer age;
   private String name;
   public void setAge(Integer age) {
      this.age = age;
   }   
   public Integer getAge() {
      return age;
   }
   public void setName(String name) {
      this.name = name;
   }  
   public String getName() {
      return name;
   }
}
```

**Profile.java**

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
public class Profile {
   @Autowired
   @Qualifier("student1")
   private Student student;
   public Profile(){
      System.out.println("Inside Profile constructor." );
   }
   public void printAge() {
      System.out.println("Age : " + student.getAge() );
   }
   public void printName() {
      System.out.println("Name : " + student.getName() );
   }
}
```

**MainApp.java**

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
public class MainApp {
   public static void main(String[] args) {
      ApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
      Profile profile = (Profile) context.getBean("profile");
      profile.printAge();
      profile.printName();
   }
}
```

**Beans.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
    http://www.springframework.org/schema/context
    http://www.springframework.org/schema/context/spring-context-3.0.xsd">

   <context:annotation-config/>

   <!-- Definition for profile bean -->
   <bean id="profile" class="com.tutorialspoint.Profile">
   </bean>

   <!-- Definition for student1 bean -->
   <bean id="student1" class="com.tutorialspoint.Student">
      <property name="name"  value="Zara" />
      <property name="age"  value="11"/>
   </bean>

   <!-- Definition for student2 bean -->
   <bean id="student2" class="com.tutorialspoint.Student">
      <property name="name"  value="Nuha" />
      <property name="age"  value="2"/>
   </bean>

</beans>
```

如果程序运行成功，则可以得到如下消息：

```
Inside Profile constructor.
Age : 11
Name : Zara
```

### 6.4 Spring JSR-250 注解

Spring 还使用基于 JSR-250 注解，它包括 @PostConstruct、@PreDestroy 和 @Resource 注解。

++++++++++++++++++++++++++++++++++

后面再看

++++

### 6.5 Spring 基于 Java 的配置

基于 Java 的配置，可以在不用配置 XML 的情况下编写大多数的 Spring。

#### 6.5.1 @Configuration 和 @Bean 注解

**@Configuration** 注解一个类，表明这个类是一个**配置类**，可以作为 Spring IOC 容器的 bean 定义的来源。

**@Bean** 注解表明被注解的方法返回一个对象，**该对象应该被注册为 Spring 应用程序上下文中的 bean。**

简单的示例如下：

```java
import org.springframework.context.annotation.*;
@Configuration
public class HelloWorldConfig {
   @Bean 
   public HelloWorld helloWorld(){
      return new HelloWorld();
   }
}
```

**上面的代码等同于下面的 XML 配置：**

```xml
<beans>
   <bean id="helloWorld" class="com.tutorialspoint.HelloWorld" />
</beans>
```

在这里，带有 @Bean 注解的方法名称作为 bean 的 id，它创建并返回实际的 bean。

这个配置类可以声明多个 @Bean，一旦定义了配置类，就可以使用 AnnotationConfigApplicationContext 来加载并把它们提供给 Spring 容器，如下所示：

```java
public static void main(String[] args) {
   ApplicationContext ctx = 
   new AnnotationConfigApplicationContext(HelloWorldConfig.class); 
   HelloWorld helloWorld = ctx.getBean(HelloWorld.class);
   helloWorld.setMessage("Hello World!");
   helloWorld.getMessage();
}
```

我们可以加载各种配置类，如下所示：

```java
public static void main(String[] args) {
    AnnotationConfigApplicationContext ctx = new ApplicationConfigApplicationContext();
    ctx.register(AppConfig.class, OtherConfig.class);
  	ctx.register(AdditionalConfig.class);
    ctx.refresh();
    MyService myService = ctx.getBean(MyService.class);
    myService.doStuff();
}
```

**示例**：

**HelloWorldConfig.java**

```java
import org.springframework.context.annotation.*;
@Configuration
public class HelloWorldConfig {
   @Bean 
   public HelloWorld helloWorld(){
      return new HelloWorld();
   }
}
```

**HelloWorld.java**

```java
public class HelloWorld {
   private String message;

   public void setMessage(String message){
      this.message  = message;
   }

   public void getMessage(){
      System.out.println("Your Message : " + message);
   }
}
```

**MainApp.java**

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.*;

public class MainApp {
   public static void main(String[] args) {
      ApplicationContext ctx = 
      new AnnotationConfigApplicationContext(HelloWorldConfig.class);

      HelloWorld helloWorld = ctx.getBean(HelloWorld.class);

      helloWorld.setMessage("Hello World!");
      helloWorld.getMessage();
   }
}
```

如果程序正常运行，则会输出以下消息：

```
Your Message: Hello World!
```

#### 6.5.2 注入 Bean 的依赖性

当 @Bean 依赖对方时，表达这种依赖性非常简单，只要有一个 bean 方法调用另一个，如下所示：

```java
import org.springframework.context.annotation.*;
@Configuration
public class AppConfig {
   @Bean
   public Foo foo() {
      return new Foo(bar()); // 依赖于调用 bar() 方法的返回值
   }
   @Bean
   public Bar bar() {
      return new Bar();
   }
}
```

上面的代码中，foo Bean 通过构造函数注入来生成实例对象。

**代码示例**：

**TextEditorConfig.java**

```java
import org.springframework.context.annotation.*;
@Configuration
public class TextEditorConfig {
   @Bean 
   public TextEditor textEditor(){
      return new TextEditor( spellChecker() );
   }
   @Bean 
   public SpellChecker spellChecker(){
      return new SpellChecker( );
   }
}
```

**TextEditor.java**

```java
public class TextEditor {
   private SpellChecker spellChecker;
   public TextEditor(SpellChecker spellChecker){
      System.out.println("Inside TextEditor constructor." );
      this.spellChecker = spellChecker;
   }
   public void spellCheck(){
      spellChecker.checkSpelling();
   }
}
```

**SpellChecker.java**

```java
public class SpellChecker {
   public SpellChecker(){
      System.out.println("Inside SpellChecker constructor." );
   }
   public void checkSpelling(){
      System.out.println("Inside checkSpelling." );
   }
}
```

**MainApp.java**

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.*;

public class MainApp {
   public static void main(String[] args) {
      ApplicationContext ctx = 
      new AnnotationConfigApplicationContext(TextEditorConfig.class);

      TextEditor te = ctx.getBean(TextEditor.class);

      te.spellCheck();
   }
}
```

如果程序运行正常，可以得到如下输出结果：

```
Inside SpellChecker constructor.
Inside TextEditor constructor.
Inside checkSpelling.
```

#### 6.5.3 @Import 注解

@Import 注解允许从另一个配置类中加载 @Bean 定义。如下所示：

```java
@Configuration
public class ConfigA {
    @Bean
    public A a() {
        return new A();
    }
}
```

我们可以在另一个 Bean 配置类中导入上述的 Bean 声明，如下所示：

```java
@Configuration
@Import(ConfigA.class)
public class ConfigB {
   @Bean
   public B a() {
      return new A(); 
   }
}
```

现在，当实例化上下文时，不需要同时指定两个配置类（ConfigA.class 和 ConfigB.class），只有 ConfigB 类需要提供，如下所示：

```java
public static void main(String[] args) {
   ApplicationContext ctx = 
   new AnnotationConfigApplicationContext(ConfigB.class);
   // now both beans A and B will be available...
   A a = ctx.getBean(A.class);
   B b = ctx.getBean(B.class);
}
```

#### 6.5.4 生命周期回调

@Bean 注解支持指定任意的初始化和销毁的回调方法，就像在 \<bean> 元素中 Spring 的 XML 的初始化方法和销毁方法的属性：

```java
public class Foo {
   public void init() {
      // initialization logic
   }
   public void cleanup() {
      // destruction logic
   }
}

@Configuration
public class AppConfig {
   @Bean(initMethod = "init", destroyMethod = "cleanup" ) // 初始化调用 init()，销毁时调用 cleanup()
   public Foo foo() {
      return new Foo();
   }
}
```

指定 Bean 的作用范围（scope）：

默认范围是单实例（singleton），但是你可以重写带有 @Scope 注解的该方法，如下所示：

```java
@Configuration
public class AppConfig {
   @Bean
   @Scope("prototype")
   public Foo foo() {
      return new Foo();
   }
}
```

### 6.6 Spring 中的事件处理

Spring 的核心是 ApplicationContext，它负责管理 beans 的完整生命周期。当加载 beans 时，ApplicationContext 发布某些类型的事件。例如，当上下文启动时，ContextStartedEvent 发布，当上下文停止时，ContextStoppedEvent 事件发布。

通过 ApplicationEvent 类和 ApplicationListener 接口来提供在 ApplicationContext 中处理事件。如果一个 bean 实现了 ApplicationListener，那么每次 ApplicationEvent 被发布到 ApplicationContext 上，则会通知这个 bean。

Spring 提供了以下的标准事件：

|      Spring 内置事件      |                             描述                             |
| :-----------------------: | :----------------------------------------------------------: |
| **ContextRefreshedEvent** | ApplicationContext 被初始化或刷新时，该事件被发布。也可以在 ConfigurableApplicationContext 接口中使用 refresh() 方法来触发 |
|  **ContextStartedEvent**  | 当使用 ConfigurableApplicationContext 接口中的 start() 方法启动 ApplicationContext 时，该事件被发布。我们可以在这个事件被发布后去查询数据库，或者重启任何停止的应用程序 |
|  **ContextStoppedEvent**  | 当使用 ConfigurableApplicationContext 接口中的 stop() 方法停止 ApplicationContext 时，发布这个事件。我们可以在接收到这个事件后做必要的清理工作 |
|  **ContextClosedEvent**   | 当使用 ConfigurableApplicationContext 接口中的 close() 方法关闭 ApplicationContext 时，该事件被发布。一个已关闭的上下文对象到达生命周期末端，它将不能被刷新或重启 |
|  **RequestHandledEvent**  | 这是一个 web-specific 事件，告诉所有的 bean HTTP 请求已经被服务 |

由于 Spring 的事件处理是单线程的，所以，如果一个事件被发布，除非所有的接收者都收到该消息，否则该进程将会阻塞，并且流程将不会继续。因此，如果要使用事件处理，应当注意这一点。

#### 6.6.1 监听上下文事件

为了监听上下文事件，一个 bean 应该实现 **ApplicationListener** 接口，这个接口只有一个 **onApplicationEvent()** 方法。

示例：

**HelloWorld.java**

```java
public class HelloWorld {
   private String message;
   public void setMessage(String message){
      this.message  = message;
   }
   public void getMessage(){
      System.out.println("Your Message : " + message);
   }
}
```

**CStartEventHandler.java**

```java
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextStartedEvent;
public class CStartEventHandler 
   implements ApplicationListener<ContextStartedEvent>{
   public void onApplicationEvent(ContextStartedEvent event) {
      System.out.println("ContextStartedEvent Received");
   }
}
```

**CStopEventHandler.java**

```java
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextStoppedEvent;
public class CStopEventHandler 
   implements ApplicationListener<ContextStoppedEvent>{
   public void onApplicationEvent(ContextStoppedEvent event) {
      System.out.println("ContextStoppedEvent Received");
   }
}
```

**MainApp.java**

```java
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class MainApp {
   public static void main(String[] args) {
      ConfigurableApplicationContext context = 
      new ClassPathXmlApplicationContext("Beans.xml");

      // Let us raise a start event.
      context.start();

      HelloWorld obj = (HelloWorld) context.getBean("helloWorld");

      obj.getMessage();

      // Let us raise a stop event.
      context.stop();
   }
}
```

**Beans.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <bean id="helloWorld" class="com.tutorialspoint.HelloWorld">
      <property name="message" value="Hello World!"/>
   </bean>

   <bean id="cStartEventHandler" 
         class="com.tutorialspoint.CStartEventHandler"/>

   <bean id="cStopEventHandler" 
         class="com.tutorialspoint.CStopEventHandler"/>

</beans>
```

如果上述代码运行成功，则会返回如下结果：

```
ContextStartedEvent Received
Your Message : Hello World!
ContextStoppedEvent Received
```

### 6.7 Spring 中的自定义事件(后续整理)

Spring 中的自定义事件一般分为如下几步：

1. 通过扩展 **ApplicationEvent**,创建一个事件类 CustomEvent。这个类必须定义一个默认的构造函数，它应该从 ApplicationEvent 类中继承的构造函数。
2. 一旦定义事件类，你可以从任何类中发布它，假定 EventClassPublisher 实现了 ApplicationEventPublisherAware。你还需要在 XML 配置文件中声明这个类作为一个 bean，之所以容器可以识别 bean 作为事件发布者，是因为它实现了 ApplicationEventPublisherAware 接口。

## 7 Spring AOP

> Spring 框架的一个关键组件是面向切面编程（AOP）框架。面向切面编程需要把程序逻辑分解成不同的部分，称为关注点。跨一个应用程序的多个点的功能被称为**横切关注点**，这些横切关注点在概念上独立于应用程序的业务逻辑。比如：日志记录、审计、声明式事务、安全性和缓存等。

依赖注入帮助我们对应用程序对象相互解耦，而 AOP 可以帮助我们从它们所影响的对象中对横切关注点解耦。

**AOP 术语**（待整理）：

|      项       |                             描述                             |
| :-----------: | :----------------------------------------------------------: |
|    Aspect     | 一个模块具有一组提供横切需求的 APIs。例如，一个日志模块为了记录日志将被 AOP 方面调用。应用程序可以拥有任意数量的方面，这取决于需求。 |
|  Join point   | 在你的应用程序中它代表一个点，你可以在插件 AOP 方面。你也能说，它是在实际的应用程序中，其中一个操作将使用 Spring AOP 框架。 |
|    Advice     | 这是实际行动之前或之后执行的方法。这是在程序执行期间通过 Spring AOP 框架实际被调用的代码。 |
|   Pointcut    | 这是一组一个或多个连接点，通知应该被执行。你可以使用表达式或模式指定切入点正如我们将在 AOP 的例子中看到的。 |
| Introduction  |           引用允许你添加新方法或属性到现有的类中。           |
| Target object | 被一个或者多个方面所通知的对象，这个对象永远是一个被代理对象。也称为被通知对象。 |
|    Weaving    | Weaving 把方面连接到其它的应用程序类型或者对象上，并创建一个被通知的对象。这些可以在编译时，类加载时和运行时完成。 |

**通知的类型**

Spring 切面可以使用如下五种通知工作：

|      通知      |                             描述                             |
| :------------: | :----------------------------------------------------------: |
|    前置通知    |                在一个方法执行之前，执行通知。                |
|    后置通知    |         在一个方法执行之后，不考虑其结果，执行通知。         |
|   返回后通知   |   在一个方法执行之后，只有在方法成功完成时，才能执行通知。   |
| 抛出异常后通知 | 在一个方法执行之后，只有在方法退出抛出异常时，才能执行通知。 |
|    环绕通知    |             在建议方法调用之前和之后，执行通知。             |

**实现自定义切面**

Spring 支持 **@AspectJ annotation style** 的方法和基于模式的方法来实现自定义切面。

| 方法                 | 描述                                                |
| -------------------- | --------------------------------------------------- |
| **XML Schema based** | 切面是使用常规类以及基于配置的 XML 来实现的         |
| **@AspectJ based**   | @AspectJ 引用一种声明切面的风格作为常规 Java 类注解 |

### 7.1 Spring 中基于 AOP 的 XML 架构

为了使用 AOP 命名空间标签，需要导入 spring-aop 架构，如下所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:aop="http://www.springframework.org/schema/aop"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd 
    http://www.springframework.org/schema/aop 
    http://www.springframework.org/schema/aop/spring-aop-3.0.xsd ">

   <!-- bean definition & AOP specific configuration -->

</beans>
```

此外，还需要在 CLASSPATH 中使用以下 AspectJ 依赖：

- aspectjrt.jar
- aspectjweaver.jar
- aspectj.jar
- aopalliance.jar

#### 7.1.1 声明一个 aspect

一个 aspect 是使用标签声明的，依赖的 bean 是使用 ref 属性引用的，如下所示：

```xml
<aop:config>
    <aop:aspect id="myAspect" ref="aBean">
   ...
   </aop:aspect>
</aop:config>
<bean id="aBean" class="...">
...
</bean>
```

在这里，"aBean" 将会被配置和依赖注入。

#### 7.1.2 声明一个切入点

在处理基于配置的 XML 架构时，切入点将会按照如下所示定义：

```xml
<aop:config>
   <aop:aspect id="myAspect" ref="aBean">
   <aop:pointcut id="businessService"
      expression="execution(* com.xyz.myapp.service.*.*(..))"/>
   ...
   </aop:aspect>
</aop:config>
<bean id="aBean" class="...">
...
</bean>
```

**使用示例**：下面的示例定义了一个名为 "businessService" 的切入点，该切入点将与 com.tutorialspoint 包下的 Student 类中的 getName() 方法相匹配：

```xml
<aop:config>
   <aop:aspect id="myAspect" ref="aBean">
   <aop:pointcut id="businessService"
      expression="execution(* com.tutorialspoint.Student.getName(..))"/>
   ...
   </aop:aspect>
</aop:config>
<bean id="aBean" class="...">
...
</bean>
```

#### 7.1.3 声明建议

我们可以使用 \<aop:{ADVICE NAME}> 元素在一个配置中声明一个建议中任何一个，如下所示：

```xml
<aop:config>
   <aop:aspect id="myAspect" ref="aBean">
      <aop:pointcut id="businessService"
         expression="execution(* com.xyz.myapp.service.*.*(..))"/>
      <!-- a before advice definition -->
      <aop:before pointcut-ref="businessService" 
         method="doRequiredTask"/>
      <!-- an after advice definition -->
      <aop:after pointcut-ref="businessService" 
         method="doRequiredTask"/>
      <!-- an after-returning advice definition -->
      <!--The doRequiredTask method must have parameter named retVal -->
      <aop:after-returning pointcut-ref="businessService"
         returning="retVal"
         method="doRequiredTask"/>
      <!-- an after-throwing advice definition -->
      <!--The doRequiredTask method must have parameter named ex -->
      <aop:after-throwing pointcut-ref="businessService"
         throwing="ex"
         method="doRequiredTask"/>
      <!-- an around advice definition -->
      <aop:around pointcut-ref="businessService" 
         method="doRequiredTask"/>
   ...
   </aop:aspect>
</aop:config>
<bean id="aBean" class="...">
...
</bean>
```

我们可以对不同的建议使用相同的 doRequiredTask 或者不同的方法。这些方法将会作为 aspect 模块的一部分来定义。

#### 7.1.4 基于 XML 架构的 AOP 示例

**Logging.java**：

```java
package com.tutorialspoint;
public class Logging {
   /** 
    * This is the method which I would like to execute
    * before a selected method execution.
    */
   public void beforeAdvice(){
      System.out.println("Going to setup student profile.");
   }
   /** 
    * This is the method which I would like to execute
    * after a selected method execution.
    */
   public void afterAdvice(){
      System.out.println("Student profile has been setup.");
   }
   /** 
    * This is the method which I would like to execute
    * when any method returns.
    */
   public void afterReturningAdvice(Object retVal){
      System.out.println("Returning:" + retVal.toString() );
   }
   /**
    * This is the method which I would like to execute
    * if there is an exception raised.
    */
   public void AfterThrowingAdvice(IllegalArgumentException ex){
      System.out.println("There has been an exception: " + ex.toString());   
   }  
```

**Student.java**

```java
package com.tutorialspoint;
public class Student {
   private Integer age;
   private String name;
   public void setAge(Integer age) {
      this.age = age;
   }
   public Integer getAge() {
      System.out.println("Age : " + age );
      return age;
   }
   public void setName(String name) {
      this.name = name;
   }
   public String getName() {
      System.out.println("Name : " + name );
      return name;
   }  
   public void printThrowException(){
       System.out.println("Exception raised");
       throw new IllegalArgumentException();
   }
}
```

**MainApp.java**

```java
package com.tutorialspoint;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
public class MainApp {
   public static void main(String[] args) {
      ApplicationContext context = 
             new ClassPathXmlApplicationContext("Beans.xml");
      Student student = (Student) context.getBean("student");
      student.getName();
      student.getAge();      
      student.printThrowException();
   }
}
```

**Beans.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:aop="http://www.springframework.org/schema/aop"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd 
    http://www.springframework.org/schema/aop 
    http://www.springframework.org/schema/aop/spring-aop-3.0.xsd ">

   <aop:config>
      <aop:aspect id="log" ref="logging">
          <!-- 该切入点将与 tutorialspoint 包下的所有方法的所有类相匹配 -->
         <aop:pointcut id="selectAll" 
         expression="execution(* com.tutorialspoint.*.*(..))"/>
         <aop:before pointcut-ref="selectAll" method="beforeAdvice"/>
         <aop:after pointcut-ref="selectAll" method="afterAdvice"/>
         <aop:after-returning pointcut-ref="selectAll" 
                              returning="retVal"
                              method="afterReturningAdvice"/>
         <aop:after-throwing pointcut-ref="selectAll" 
                             throwing="ex"
                             method="AfterThrowingAdvice"/>
      </aop:aspect>
   </aop:config>

   <!-- Definition for student bean -->
   <bean id="student" class="com.tutorialspoint.Student">
      <property name="name"  value="Zara" />
      <property name="age"  value="11"/>      
   </bean>

   <!-- Definition for logging aspect -->
   <bean id="logging" class="com.tutorialspoint.Logging"/> 

</beans>
```

如果上述代码执行成功，则会输出如下内容：

```
Going to setup student profile.
Name : Zara
Student profile has been setup.
Returning:Zara
Going to setup student profile.
Age : 11
Student profile has been setup.
Returning:11
Going to setup student profile.
Exception raised
Student profile has been setup.
There has been an exception: java.lang.IllegalArgumentException
.....
other exception content
```

上述的 Beans.xml 配置文件中配置的切入点对应 tutorialspoint 包下的所有类的所有方法。我们可以通过使用真实类和方法名来替换切入点定义中的星号（*）来指定切入点的方法的执行范围。如下所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:aop="http://www.springframework.org/schema/aop"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd 
    http://www.springframework.org/schema/aop 
    http://www.springframework.org/schema/aop/spring-aop-3.0.xsd ">

   <aop:config>
   <aop:aspect id="log" ref="logging">
      <aop:pointcut id="selectAll" 
      expression="execution(* com.tutorialspoint.Student.getName(..))"/>
      <aop:before pointcut-ref="selectAll" method="beforeAdvice"/>
      <aop:after pointcut-ref="selectAll" method="afterAdvice"/>
   </aop:aspect>
   </aop:config>

   <!-- Definition for student bean -->
   <bean id="student" class="com.tutorialspoint.Student">
      <property name="name"  value="Zara" />
      <property name="age"  value="11"/>      
   </bean>

   <!-- Definition for logging aspect -->
   <bean id="logging" class="com.tutorialspoint.Logging"/> 

</beans>
```

更改后的程序将会输出如下结果：

```
Going to setup student profile.
Name : Zara
Student profile has been setup.
Age : 11
Exception raised
.....
other exception content
```

### 7.2 Spring 中基于 AOP 的 @AspectJ

@AspectJ 是作为 Java 注解的普通的 Java 类，它指的是声明 aspects 的一种风格。

可以通过在 XML 配置文件中添加以下元素，使得 @AspectJ 可用：

```xml
<aop:aspectj-autoproxy/>
```

可能还需要添加以下依赖：

- aspectjrt.jar
- aspectjweaver.jar
- aspectj.jar
- aopalliance.jar

#### 7.2.1 声明一个 aspect 类

Aspects 类和其他任何普通的 bean 一样，除了它们会用 @AspectJ 注解之外，如下所示：

```java
package org.xyz;
import org.aspectj.lang.annotation.Aspect;
@Aspect
public class AspectModule {
}
```

这个 bean 要在 XML 中按照如下的方式进行配置，就和其他的普通的 bean 一样：

```xml
<bean id="myAspect" class="org.xyz.AspectModule">
   <!-- configure properties of aspect here as normal -->
</bean>
```

#### 7.2.2 声明一个切入点

在处理基于 @AspectJ 注解配置的架构时，切入点的声明有两个部分：

- 一个切入点表达式决定了要操作的类或者方法
- 一个切入点标签包含一个名称和任意数量的参数。

**示例**：下面示例中定义了一个名为 "businessService" 的切入点，该切入点将与 com.xyz.myapp.service 包下的类中可用的每一个方法相匹配：

```java
import org.aspectj.lang.annotation.Pointcut;
@Pointcut("execution(* com.xyz.myapp.service.*.*(..))") // expression 
private void businessService() {}  // signature
```

下面的示例中定义了一个名为 "getName" 的切入点，该切入点将与 com.tutorialspoint 包下的 Student 类中的 getName() 方法相匹配：

```java
import org.aspectj.lang.annotation.Pointcut;
@Pointcut("execution(* com.tutorialspoint.Student.getName(..))") 
private void getname() {}
```

#### 7.2.3 声明建议

可以使用 @{ADVICE-NAME} 注解声明五个建议中的任意一个，如下所示，这在是假设已经定义了一个 businessService() 的前提下：

```java
@Before("businessService()")
public void doBeforeTask(){
 ...
}
@After("businessService()")
public void doAfterTask(){
 ...
}
@AfterReturning(pointcut = "businessService()", returning="retVal")
public void doAfterReturnningTask(Object retVal){
  // you can intercept retVal here.
  ...
}
@AfterThrowing(pointcut = "businessService()", throwing="ex")
public void doAfterThrowingTask(Exception ex){
  // you can intercept thrown exception here.
  ...
}
@Around("businessService()")
public void doAroundTask(){
 ...
}
```

我们也可以在添加建议的时候指定要处理的对象，如下所示：

```java
@Before("execution(* com.xyz.myapp.service.*.*(..))")
public doBeforeTask(){
 ...
}
```

#### 7.2.4 基于 @AspectJ 的 AOP 示例

**Logging.java**

```java
package com.tutorialspoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Around;
@Aspect
public class Logging {
   /** Following is the definition for a pointcut to select
    *  all the methods available. So advice will be called
    *  for all the methods.
    */
   @Pointcut("execution(* com.tutorialspoint.*.*(..))")
   private void selectAll(){}
   /** 
    * This is the method which I would like to execute
    * before a selected method execution.
    */
   @Before("selectAll()")
   public void beforeAdvice(){
      System.out.println("Going to setup student profile.");
   }
   /** 
    * This is the method which I would like to execute
    * after a selected method execution.
    */
   @After("selectAll()")
   public void afterAdvice(){
      System.out.println("Student profile has been setup.");
   }
   /** 
    * This is the method which I would like to execute
    * when any method returns.
    */
   @AfterReturning(pointcut = "selectAll()", returning="retVal")
   public void afterReturningAdvice(Object retVal){
      System.out.println("Returning:" + retVal.toString() );
   }
   /**
    * This is the method which I would like to execute
    * if there is an exception raised by any method.
    */
   @AfterThrowing(pointcut = "selectAll()", throwing = "ex")
   public void AfterThrowingAdvice(IllegalArgumentException ex){
      System.out.println("There has been an exception: " + ex.toString());   
   }  
}
```

**Student.java**

```java
package com.tutorialspoint;
public class Student {
   private Integer age;
   private String name;
   public void setAge(Integer age) {
      this.age = age;
   }
   public Integer getAge() {
      System.out.println("Age : " + age );
      return age;
   }
   public void setName(String name) {
      this.name = name;
   }
   public String getName() {
      System.out.println("Name : " + name );
      return name;
   }
   public void printThrowException(){
      System.out.println("Exception raised");
      throw new IllegalArgumentException();
   }
}
```

**MainApp.java**

```java
package com.tutorialspoint;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
public class MainApp {
   public static void main(String[] args) {
      ApplicationContext context = 
             new ClassPathXmlApplicationContext("Beans.xml");
      Student student = (Student) context.getBean("student");
      student.getName();
      student.getAge();     
      student.printThrowException();
   }
}
```

**Beans.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:aop="http://www.springframework.org/schema/aop"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd 
    http://www.springframework.org/schema/aop 
    http://www.springframework.org/schema/aop/spring-aop-3.0.xsd ">

    <aop:aspectj-autoproxy/>

   <!-- Definition for student bean -->
   <bean id="student" class="com.tutorialspoint.Student">
      <property name="name"  value="Zara" />
      <property name="age"  value="11"/>      
   </bean>

   <!-- Definition for logging aspect -->
   <bean id="logging" class="com.tutorialspoint.Logging"/> 

</beans>
```

如果程序运行成功，将会得到如下输出结果：

```
Going to setup student profile.
Name : Zara
Student profile has been setup.
Returning:Zara
Going to setup student profile.
Age : 11
Student profile has been setup.
Returning:11
Going to setup student profile.
Exception raised
Student profile has been setup.
There has been an exception: java.lang.IllegalArgumentException
.....
other exception content
```

## 8 Spring JDBC 框架（后面再整理）



## 9 Spring 事务管理（后面再整理）



## 10 Spring Web MVC 框架

Spring web MVC 框架提供了 "**模型-视图-控制**" 的体系结构和可以用来开发灵活、松散耦合的 **web 应用程序的组件**。

- **模型（Model)**：封装了应用程序数据，并且通常它们由 POJO 组成
- **视图（View）**：主要用于呈现模型数据，并且通常它生成客户端的浏览器可以解释的 HTML 输出
- **控制器（Controller）**：主要用于处理用户请求，并且构建合适的模型，并将其传递到视图呈现

**DispatcherServlet**

Spring Web 模型-视图-控制 （MVC）框架是围绕 DispatcherServlet 设计的，DispatcherServlet 用来处理所有的 HTTP 请求和响应。Spring Web MVC DispatcherServlet 的请求处理的工作流程如下图所示：

![](static/spring/6.png)

下面是对应于 DispatcherServlet 传入 HTTP 请求的事件序列：

1. 收到一个 HTTP 请求后，DispatcherServlet 根据 HandlerMapping 来选择并且调用适用的控制器处理请求
2. 控制器接收请求后，并根据请求使用的 GET 或 POST 方法来调用适当的 service 方法。service 方法将设置基于定义的业务逻辑的模型数据，并返回视图名称到 DispatcherServlet 中
3. DispatcherServlet 会从 ViewResolver 中为请求检索定义视图
4. 一旦确定视图后，DispatcherServlet 将把模型数据传递给视图，最后显现在浏览器中

上面所提到的所有组件，即 **HandlerMapping、Controller 和 ViewResolver 是 WebApplicationContext 的一部分**，而 WebApplicationContext 是带有一些对 web 应用程序必要的额外特性的 ApplicationContext 的扩展。

**需求的配置**

需要映射我们想让 DispatcherServlet 处理的请求，通过使用在 **web.xml** 文件中的一个 URL 映射。下面是一个显式声明和映射 HelloWeb DispathcerServlet 的示例：

web.xml 文件将被保留在应用程序的 WebContent/WEB-INF 目录下。

在初始化 HelloWeb DispatcherServlet 时，该框架将尝试加载位于应用程序的 WebContent/WEB-INF 目录中文件名为 `[servlet-name]-servlet.xml` 的应用程序内容。在这个例子中，配置文件为 `HelloWeb-servlet.xml`。

接下来，标签表明哪些 URLs 将被 DispatcherServlet 处理。这里所有以 `.jsp` 结束的 HTTP 请求将由 HelloWeb DispatcherServlet 处理。

如果不使用默认文件名 `[servlet-name]-servlet.xml` 和默认的位置 WebContent/WEB-INF，我们可以通过在 web.xml 文件中添加 servlet 监听器 ContextLoaderListener 自定义该文件名和文件位置，如下所示：

```xml
<web-app...>

....
<context-param>
   <param-name>contextConfigLocation</param-name>
   <param-value>/WEB-INF/HelloWeb-servlet.xml</param-value>
</context-param>
<listener>
   <listener-class>
      org.springframework.web.context.ContextLoaderListener
   </listener-class>
</listener>
</web-app>
```

HelloWeb-servlet.xml 文件，该文件位于 web 应用程序的 WebContent/WEB-INF 目录下：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
   xmlns:context="http://www.springframework.org/schema/context"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="
   http://www.springframework.org/schema/beans
   http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
   http://www.springframework.org/schema/context 
   http://www.springframework.org/schema/context/spring-context-3.0.xsd">

   <context:component-scan base-package="com.tutorialspoint" />

   <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
      <property name="prefix" value="/WEB-INF/jsp/" />
      <property name="suffix" value=".jsp" />
   </bean>

</beans>
```

以下是关于 HelloWeb-servlet.xml 文件的一些要点：

- **`[servlet-name]-servlet.xml` 文件**：用于创建 bean 定义，重新定义在全局范围内具有相同名称的任何已定义的 bean
- **\<context:component-scan> 标签**：用于激活 Spring MVC 注解扫描功能，该功能允许使用注解，如 @Controller 和 @RequestMapping 等
- **InternalResourceViewResolver**：使用定义的规则来解决视图名称。按照上述定义的规则，一个名称为 hello 的逻辑视图将发送给位于 `/WEB-INF/jsp/hello.jsp` 中实现的视图。

**定义控制器**

DispatcherServlet 发送请求到控制器中执行特定的功能。@Controller 注解表明被注解的这个类是一个控制器。@RequestMapping 注解用于映射 URL 到整个类或一个特定的处理方法。

```java
@Controller
@RequestMapping("/hello")
public class HelloController{
   @RequestMapping(method = RequestMethod.GET)
   public String printHello(ModelMap model) {
      model.addAttribute("message", "Hello Spring MVC Framework!");
      return "hello";
   }
}
```

**@Controller** 注解定义该类为一个 Spring MVC 控制器。在这里，第一次使用的 **@RequestMapping** 表明在该控制器中处理的所有方法都是相对于 **/hello** 路径而言的。**@RequestMapping(method = RequestMehtod.GET)** 用于声明 pringHello() 方法作为控制器的默认 service 方法来处理 HTTP GET 请求。**我们可以在相同的 URL 中定义其它方法来处理任何 POST 请求**。

上面的代码用另一种方式来编写控制器，如下所示：

```java
@Controller
public class HelloController{
   @RequestMapping(value = "/hello", method = RequestMethod.GET)
   public String printHello(ModelMap model) {
      model.addAttribute("message", "Hello Spring MVC Framework!");
      return "hello";
   }
}
```

**value** 属性表明这个方法要处理哪个 URL 映射，**method** 属性定义了 service 方法来处理的是什么类型的 HTTP 请求。关于上面定义的控制器，有如下几个要点要注意：

- 在 service 方法（例如上面的 pringHello() 方法）中定义需要的业务处理逻辑。

- 基于定义的业务逻辑，在这个方法中创建一个模型。可以设置不同的模型属性，这些属性将被视图访问并显示最终的结果。这个示例中创建了一个带有属性 "message" 的模型。
- 一个定义的 service 方法可以返回一个包含视图名称的字符串，用于呈现该模型。这个示例返回 "hello" 作为逻辑视图的名称。

**创建 JSP 视图**

对于不同的表示层技术，Spring  MVC 支持许多类型的视图。包括 JSP、HTML、PDF、Excel 工作表、XML、Velocity 模板、XSLT、JSON、Atom 和 RSS 提要、JasperReports 等。

最常用的是利用 JSTL 编写 JSP 模板。下面我们在 /WEB-INF/hello/hello.jsp 中编写一个简单的 hello 视图：

```jsp
<html>
   <head>
   <title>Hello Spring MVC</title>
   </head>
   <body>
   <h2>${message}</h2>
   </body>
</html>
```

其中，${message} 是我们在控制器内部设置的属性。

下面是各种例子。

### 10.1 Spring MVC Hello World 例子

**HelloController.java**

```java
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.ui.ModelMap;

@Controller
@RequestMapping("/hello")
public class HelloController { 
   @RequestMapping(method = RequestMethod.GET)
   public String printHello(ModelMap model) {
      model.addAttribute("message", "Hello Spring MVC Framework!");
      return "hello";
   }
}
```

**web.xml**

```xml
<web-app id="WebApp_ID" version="2.4"
   xmlns="http://java.sun.com/xml/ns/j2ee" 
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee 
   http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd">

   <display-name>Spring MVC Application</display-name>

   <servlet>
      <servlet-name>HelloWeb</servlet-name>
      <servlet-class>
         org.springframework.web.servlet.DispatcherServlet
      </servlet-class>
      <load-on-startup>1</load-on-startup>
   </servlet>

   <servlet-mapping>
      <servlet-name>HelloWeb</servlet-name>
      <url-pattern>/</url-pattern>
   </servlet-mapping>

</web-app>
```

**HelloWeb-servlet.xml**

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
   xmlns:context="http://www.springframework.org/schema/context"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="
   http://www.springframework.org/schema/beans     
   http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
   http://www.springframework.org/schema/context 
   http://www.springframework.org/schema/context/spring-context-3.0.xsd">

   <context:component-scan base-package="com.tutorialspoint" />

   <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
      <property name="prefix" value="/WEB-INF/jsp/" />
      <property name="suffix" value=".jsp" />
   </bean>

</beans>
```

**hello.jsp**

```jsp
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
    <head>
        <title>Hello World</title>
    </head>
    <body>
       <h2>${message}</h2>
    </body>
</html>
```

web 应用程序的依赖（放入到 WebContent/WEB-INF/lib 目录中）：

- commons-logging-x.y.z.jar
- org.springframework.asm-x.y.z.jar
- org.springframework.beans-x.y.z.jar
- org.springframework.context-x.y.z.jar
- org.springframework.core-x.y.z.jar
- org.springframework.expression-x.y.z.jar
- org.springframework.web.servlet-x.y.z.jar
- org.springframework.web-x.y.z.jar
- spring-web.jar

### 10.2 Spring MVC 表单处理例子

下面的例子中，使用了 Spring 的 Web MVC 框架的 HTML 表单。

**Student.java**

```java
package com.tutorialspoint;

public class Student {
   private Integer age;
   private String name;
   private Integer id;
   public void setAge(Integer age) {
      this.age = age;
   }
   public Integer getAge() {
      return age;
   }
   public void setName(String name) {
      this.name = name;
   }
   public String getName() {
      return name;
   }
   public void setId(Integer id) {
      this.id = id;
   }
   public Integer getId() {
      return id;
   }
}
```

**StudentController.java**

```java
package com.tutorialspoint;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.ui.ModelMap;
@Controller
public class StudentController {
   @RequestMapping(value = "/student", method = RequestMethod.GET)
   public ModelAndView student() {
      return new ModelAndView("student", "command", new Student());
   }   
   @RequestMapping(value = "/addStudent", method = RequestMethod.POST)
   public String addStudent(@ModelAttribute("SpringWeb")Student student, 
   ModelMap model) {
      model.addAttribute("name", student.getName());
      model.addAttribute("age", student.getAge());
      model.addAttribute("id", student.getId());      
      return "result";
   }
}
```

在这里，第一个 service 方法 student()，我们已经在名称为 "command" 的 ModelAndView 对象中传递了一个新的 Student 对象，因为 Spring 框架需要一个名称为 "command" 的模型对象。所以，当 student() 方法被调用时，它返回一个 student.jsp 视图。

其中 "student" 为视图名，"command" 为模型名，new Student() 为模型里存储的数据。**模型封装了数据，视图用于展示模型中的数据**。

第二个 service 方法 addStudent() 将调用 HelloWeb/addStudent URL 中的 POST 方法。程序会根据请求提供的信息创建模型对象。最后一个 "result" 视图会从 service 方法中返回，这将会呈现一个 result.jsp

**web.xml**

```xml
<web-app id="WebApp_ID" version="2.4"
    xmlns="http://java.sun.com/xml/ns/j2ee" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee 
    http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd">

    <display-name>Spring MVC Form Handling</display-name>

    <servlet>
        <servlet-name>HelloWeb</servlet-name>
        <servlet-class>
           org.springframework.web.servlet.DispatcherServlet
        </servlet-class>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>HelloWeb</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>

</web-app>
```

**HelloWeb-servlet.xml**

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
   xmlns:context="http://www.springframework.org/schema/context"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="
   http://www.springframework.org/schema/beans     
   http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
   http://www.springframework.org/schema/context 
   http://www.springframework.org/schema/context/spring-context-3.0.xsd">

   <context:component-scan base-package="com.tutorialspoint" />

   <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
      <property name="prefix" value="/WEB-INF/jsp/" />
      <property name="suffix" value=".jsp" />
   </bean>

</beans>
```

**student.jsp**

```jsp
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
<head>
    <title>Spring MVC Form Handling</title>
</head>
<body>

<h2>Student Information</h2>
<form:form method="POST" action="/HelloWeb/addStudent">
   <table>
    <tr>
        <td><form:label path="name">Name</form:label></td>
        <td><form:input path="name" /></td>
    </tr>
    <tr>
        <td><form:label path="age">Age</form:label></td>
        <td><form:input path="age" /></td>
    </tr>
    <tr>
        <td><form:label path="id">id</form:label></td>
        <td><form:input path="id" /></td>
    </tr>
    <tr>
        <td colspan="2">
            <input type="submit" value="Submit"/>
        </td>
    </tr>
</table>  
</form:form>
</body>
</html>
```

**result.jsp**

```jsp
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
<head>
    <title>Spring MVC Form Handling</title>
</head>
<body>

<h2>Submitted Student Information</h2>
   <table>
    <tr>
        <td>Name</td>
        <td>${name}</td>
    </tr>
    <tr>
        <td>Age</td>
        <td>${age}</td>
    </tr>
    <tr>
        <td>ID</td>
        <td>${id}</td>
    </tr>
</table>  
</body>
</html>
```

下面是使用的依赖（放入 **WebContent/WEB-INF/lib** 目录中）：

- commons-logging-x.y.z.jar
- org.springframework.asm-x.y.z.jar
- org.springframework.beans-x.y.z.jar
- org.springframework.context-x.y.z.jar
- org.springframework.core-x.y.z.jar
- org.springframework.expression-x.y.z.jar
- org.springframework.web.servlet-x.y.z.jar
- org.springframework.web-x.y.z.jar
- spring-web.jar







