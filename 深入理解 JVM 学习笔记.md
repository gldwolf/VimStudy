# 深入理解 JVM 学习笔记

> Date: 09/14/2019 20:50

## 1 Java 技术体系

Java 技术体系可以分为 4 个平台，分别为：

- **Java Card**：支持一些 Java 小程序（Applets）运行在小内存设备（如智能卡）上的平台

- **Java ME** （Micro Edition)：支持 Java 程序运行在移动终端（手机、PAD）上的平台，对 Java API 有所精简，并加入了针对移动终端的支持，这个版本以前称为 J2ME

- **Java SE**（Standard Edition）：支持面向桌面级应用（如 Windows 下的应用程序）的 Java 平台，提供了完整的 Java 核心 API，这个版本以前称为 J2SE

- **Java EE**（Enterprise Edition）：支持使用多层架构的企业应用（  如 ERP、CRM 应用）的 Java 平台，除了提供 Java SE API 外，还对其做了大量的扩充并提供了相关的部署支持:one:，这个版本以前称为 J2EE
- :one:这些扩展一般以 javax.* 作为包名，而以 java.* 为包名的包都是 Java SE API 的核心包，但是由于历史原因，一部分曾经是扩展包的 API 后来变为了核心包，因此核心包中也包含了不少 javax.* 的包名。
#### Sun HotSpot VM

HotSpot VM 是 Sun JDK 和 OpenJDK 中的所带的虚拟机，也是目前使用范围最广的 Java 虚拟机。

本次笔记使用 OpenJDK 进行编译实战。

## 2 Java 内存区域与内存溢出异常

### 2.1 运行时数据区域

> Java 虚拟机在执行 Java 程序的过程中会把它所管理的内存划分为若干个不同的数据区域。

#### 2.1.1 程序计数器

> **程序计数器（Program Counter Register）**是一块较小的内存空间，它可以看作是当前线程所执行的字节码的行号指示器。
>
> 字节码解释器工作时就是通过改变这个计数器的值来选取下一条需要执行的字节码指令，分支、循环、跳转、异常处理、线程恢复等基础功能都需要依赖这个计数器来完成。

由于 Java 虚拟机的多线程是通过线程轮流切换并分配处理器执行时间的方式来实现的，在任何一个确定的时间，一个处理器（对于多核处理器来说是一个内核）都只会执行一条线程中的指令。因此，为了线程切换后能恢复到正确的执行位置，每个线程都需要有一个独立的程序计数器，各个线程之间计数器互不影响，独立存储，所以程序计数器这类内存为“**线程私有**”的内存。

如果线程正在执行的是一个 Java 方法，这个计数器记录的是正在执行的虚拟机字节码指令的地址；如果正在执行的是 Native 方法，那么这个计数器值则为空（Undefined）。此内存区域是唯一一个在 Java 虚拟机规范中没有规定任何OutOfMemoryError 情况的区域。

#### 2.1.2 Java 虚拟机栈

Java 虚拟机栈（Java Virtual Machine Stacks）也是**线程私有**的，它的生命周期与线程相同。

虚拟机栈描述的是 Java 方法执行的内存模型：每个方法在执行的同时都会创建一个栈帧（Stack Frame:one:）用于存储**局部变量表**、**操作数栈**、**动态链接**、**方法出口**等信息。

:one:**栈帧是方法运行时基础的数据结构**。后面会详细讲解。

每一个方法从调用到执行完成的过程，就对应着一个栈帧在虚拟机栈中从入栈到出栈的过程。

局部变量表存放了编译期可知的各种**基本数据类型**（boolean、byte、char、short、int、float、long、double）、**对象引用** （reference 类型，它不等同于对象本身，可能是一个指向对象起始地址的引用指针，也有可能是一个代表对象的句柄或其它与此对象有关的位置）和 **returnAddress 类型**（指向了一条字节码指令的地址）。

其中，64 位升序的 long 和 double 类型的数据会占用 2 个局部变量空间（Slot），其余的数据类型只占用 1 个。

局部变量表所需的内存空间在编译期间完成分配，当进入一个方法时，这个方法需要在帧中分配多大的局部变量空间是完全确定的，在方法运行期间不会改变局部变量表的大小。

> 简言之：栈帧中存有局部变量表、操作数栈、动态链接、方法出口等，局部变量表中又存有基本数据类型、对象引用、returnAddress 类型数据。

在 Java 虚拟机规范中，对这个区域规定了两种异常的情况：如果线程请求的栈深度大于虚拟机所允许的深度，将抛出 StackOverflowError 异常；如果虚拟机栈可以动态扩展（当前大部分的 Java 虚拟机都可以动态扩展，只是 Java 虚拟机规范中允许固定长度的虚拟机栈），如果扩展到无法申请到足够的内存，就会抛出 OutOfMemoryError 异常。

#### 2.1.3 本地方法栈

本地方法栈（Native Method Stack）与虚拟机栈所发挥的作用是非常相似的，它们之间的区别不过是虚拟机栈为虚拟机执行 Java 方法（也就是字节码）服务，而本地方法栈则为虚拟机使用到的 Native 方法服务。有的虚拟机（譬如 HotSpot 虚拟机）直接把本地方法栈和虚拟机栈合二为一。与虚拟机栈一样，本地方法栈也会抛出 StackOverflowError 和 OutOfMemoryError 异常。

#### 2.1.4 Java 堆

对大多数应用而言，Java 堆（Heap）是 Java 虚拟机所管理的内存中最大的一块区域。Java 堆是被所有线程共享的内存区域，在虚拟机启动时创建。此内存区域的唯一目的就是存放对象实例，**几乎所有对象实例都在这里分配内存**（随着 JIT 编译器的发展与逃逸分析技术的成熟，栈上分配、标量替换优化技术将会使得所有的对象都分配在堆上这一说法渐渐变得不是那么绝对了）。

Java 堆是垃圾收集器管理的主要区域，因此很多时候也被称为 "GC 堆"（Garbage Collected Heap）。从内存回收的角度来看，由于现在的收集器基本都采用分代收集器算法，所以 Java 堆中还可以细分为：新生代和老年代；再细致一点可以分为：Eden 空间、From Survivor 空间、To Survivor 空间等。

从内存分配的角度来看，线程共享的 Java 堆中可能划分出多个线程私有的分配缓冲区（Thread Local Allocation Buffer，TLAB）。

但是无论怎样划分，都与存放内容无关，无论哪个区域，存储的都是对象实例，进一步划分的目的是为了更好地回收内存，或者更快地分配内存。

> 根据 Java 虚拟机规范的规定，Java 堆可以处于物理上还连续的内存空间中，只要是逻辑上是连续的即可。现在主流的虚拟机都是按照可扩展来实现的（通过 `-Xmx` 和 `-Xms` 来控制）。如果在堆中没有内存完成实例分配，并且堆也无法再扩展时，就会抛出 OutOfMemoryError 异常。

#### 2.1.5 方法区

方法区（Method Area）与 Java 堆一样，是各个线程共享的内存区域，它用于存储**已被虚拟机加载的类信息、常量、静态变量、即时编译器编译后的代码**等数据。

虽然 Java 虚拟机规范把方法区描述为堆的一个逻辑部分，但是它有一个别名 —— **Non-Heap（非堆）**，目的应该是与 Java 堆区分开来。

方法区也有可能进行垃圾回收，这一区域进行内存回收的目标主要是对常量池的回收和对类型的卸载。

当方法区无法满足内存分配的需求时，将抛出 OutOfMemoryError 异常。

#### 2.1.6 运行时常量池（final）

**运行时常量池（Runtime Constant Pool）是方法区的一部分**。

Class 文件中除了有类的版本、字段、方法、接口等描述信息外，还有一项信息是常量池（Constant Pool Table），用于存放编译期生成的各种字面量和符号引用，这部分内容将在类加载后进入方法区的运行时常量池中存放。

运行时常量池相对于 Class 文件常量池的一个重要特征是具备动态性，Java 语言并不要求常量一定只有编译期才能产生，也就是并非预置入 Class 文件中常量池的内容才能进入方法区运行时常量池，运行期间也可能将新的常量放入池中，这种特性被开发人员用的利用的比较多的便是 String 类的 intern() 方法。

当常量池无法再申请到内存时，会抛出 OutOfMemoryError 异常。

#### 2.1.7 直接内存

直接内存（Direct Memory）并不是虚拟机运行时数据区的一部分，也不是 Java 虚拟机规范中定义的内存区域。但是这部分内存也被频繁地使用，并且也可能会导致 OOM 异常。

在 JDK 1.4 中新加入了 NIO（New Input/Output）类，引入了一种基于通道（Channel）与缓冲区（Buffer）的 I/O 方式，它可以使用 Native 函数库直接分配堆外内存，然后通过一个存储在 Java 堆中的 DirectByteBuffer 对象作为这块内存的引用进行操作。这样能在一些场景中显著提高性能，因为避免了在 Java 堆和 Native 堆中来回复制数据。

由于有可能会经常忽略直接内存大小的设置，使得各个内存区域总和大于物理内存限制（包括物理的和操作系统级的限制），从而导致动态扩展时出现 OOM 异常。

### 2.2 HotSpot 虚拟机的对象

#### 2.2.1 对象的创建

1. 虚拟机遇到一条 new 指令时，首先检查这个指令的参数是否能在常量池中定位到一个类的符号引用，并且检查这个符号引用代表的类是否已被加载、解析和初始化过。如果没有，那必须先执行相应的类加载过程。

2. 在类加载检查通过后，接下来虚拟机将为新生对象分配内存。对象所需的内存的大小在类加载完成后便可完全确定，为对象分配空间的任务等同于把一块确定大小的内存从 Java 堆中划分出来。

内存分配方式分为两种：**指针碰撞**（Bump the Pointer）和**空闲列表**（Free List）

- **指针碰撞**：假设内存是绝对规整的，所有用过的内存放在一边，空闲的内存放在另一边，中间放着一个指针作为分界点的指示器，那么分配内存就是把那个指针往空闲的一边移动对象大小的距离，这种方式称为的指针碰撞。
- **空闲列表**：如果 Java 堆中的内存并不是规整的，已使用的内存和空闲的内存相互交错，那就没办法进行简单的进行指针碰撞了，虚拟机就必须维护一个列表，记录上哪些内存块是可用的，在分配的时候从列表中找到一块足够大的内存空间划分给对象实例，并更新列表上的记录，这种分配方式称为空闲列表。

选择哪种分配方式是由内存是否规整决定的，而 Java 堆是否规整又由所采用的垃圾收集器是否带有压缩功能决定。因此，在使用 CMS 这种基于 Mark-Sweep 算法的收集器时，通常采用空闲列表，而在使用 Serial、ParNew 等带有 Compact 过程的收集器时，通常采用空闲列表。

**重要**：在进行内存分配的时候有可能会出现线程不安全的现象，即一个线程在给对象 A 分配了内存后，还没来得及修改指针，此时另一个线程给对象 B 分配了同一个内存区域。

解决这个问题有两种方案：一种是对分配内存空间的动作进行同步处理——实际上虚拟机采用 CAS 配上失败重试的方式保证更新操作的原子性；另一种方式是把内存分配的动作按照线程划分在不同的空间之中进行，即每个线程在 Java 堆中预先分配一小块内存，称为本地线程分配缓冲（Thread Local Allocation Buffer, TLAB）。哪个线程要分配内存，就在自己的 TLAB 上进行分配，只有 TLAB 用完并分配新的 TLAB 时，才需要进行同步锁定。

虚拟机是否使用 TLAB，可以通过 `-XX:+/-UseTLAB` 参数来设定。

3. 内存分配完成后，虚拟机需要将分配到的内存空间都初始化为零值（不包括对象头），如果使用 TLAB，这一工作也可以提前到 TLAB 分配时进行。这一步操作保证了对象的实例字段在 Java 代码中可以不赋初始值就能直接使用，程序能访问到这些字段的数据类型所对应的零值。

4. 接下来，虚拟机要对对象进行必要设置，例如对象是哪个类的实例、如何才能找到类的元数据信息、对象的 HashCode、对象的 GC 分代年龄等信息。这些信息存放在对象的对象头（Object Header）中。根据虚拟机当前的运行状态不同，如是否启用偏向锁等，对象头会有不同的设置方式。

当上面的工作完成后，从虚拟机的角度来看，一个新的对象已经创建完成了，但是在 Java 程序员的眼中，对象的创建才刚刚开始——**<init>**方法还没有执行，所有的字段都还是零值。

5. 一般来说（由字节码中是否跟随着 invokespecial 指令所决定），执行 new 指令之后会接着执行 <init> 方法，把对象按照我们的意愿进行初始化，这样一个真正的可用对象才算完全创建完成。

#### 2.2.2 对象的内存布局

在 HotSpot 虚拟机中，对象在内存中存储的布局可以分为 3 块区域：对象头（Header）、实例数据（Instance Data）和对齐填充（Padding）。

###### 2.2.2.1 HotSpot 虚拟机的对象头包括两部分：

- 第一部分：用于存储对象自身的运行时数据，如哈希码（HashCode）、GC 分代年龄、锁状态标志、线程持有的锁、偏向线程 ID、偏向时间戳等，这部分数据的长度在 32 位和 64 位虚拟机（未开启压缩指针）中分别为 32bit 和 64bit，官方称为 "Mark Word"。对象需要存储的运行时数据很多，其实已经超过了 32 位、64 位 Bitmap 结构所能记录的限度，但是对象头信息是与对象自身定义的数据无关的额外存储成本。
- 第二部分：是类型指针，即对象指向它的类元数据的指针，虚拟机通过这个指针来确定这个对象是哪个类的实例。但并不是所有的虚拟机实现都必须在对象数据上保留类型指针，换言之，查找对象的元数据信息并不一定要经过对象本身。另外，如果对象是一个 Java 数组，那在对象头中还必须有一块用于记录数组长度的数据，因为虚拟机可以通过普通 Java 对象的元数据确定 Java 对象的大小，但是从数组的元数据中却无法确定数组的大小。

##### 2.2.2.2 实例数据

实例数据是对象真正存储的有效信息，也是在程序代码中所定义的各种类型的字段内容。无论是从父类继承下来的，还是在子类中定义的，都需要记录下来。这部分的存储顺序会受到虚拟机分配策略参数（FieldsAllocationStyle）和字段在 Java 源码中定义顺序的影响。HotSpot 虚拟机默认的根本策略为 longs/doubles、ints、shorts/chars、bytes/booleans、oops（Ordinary Object Pointers），从分配策略中可以看出，相同宽度的字段问题被分配到一起。在满足这个前提条件的情况下，在父类中定义的变量会出现在子类之前。如果 CompactFields 参数值为 true（默认为 true），那么子类之中较窄的变量也可能会插入到父类变量的空隙之中。

##### 2.2.2.3 对齐填充

这一部分并不是必须存在的，也没有特别的含义，它仅仅是起着占位符的作用。由于 HotSpot 虚拟机的自动内存管理系统要求对象起始地址必须是 8 字节的整数倍，换言之，就是对象的大小必须是 8 字节的整数倍。而对象头部分正好是 8 字节的倍数（1 或者 2 倍），因此，当对象实例数据部分没有对齐时，就需要通过对齐填充来补全。

#### 2.2.3 对象的访问定位 

Java 程序需要通过栈上的 reference 数据来操作堆上的具体对象。由于 reference 类型在 Java 虚拟机规范中只规定了一个指向对象的引用，并没有定义这个引用应该通过何种方式去定位，访问堆中的对象的具体公交车，所以对象访问方式也是取决于虚拟机具体的实现。

目前主流的访问方式有两种：**句柄**和**直接指针**

- **句柄**：如果使用句柄访问的话，那么 Java 堆中将会划分出一块内存来作为句柄池，reference 中存储的就是对象的句柄地址，而句柄中包含了对象实例数据与类型数据各自的具体地址信息。

![](images\1.png)

- **直接指针**：reference 中存储的就是对象地址，对象中放置着访问类型数据的相关信息

![](images\2.png)

这两种对象访问方式各有优势：使用句柄最大的好处是 reference 中存储的是稳定的句柄地址，在对象被移动（垃圾收集时移动对象是非常普遍的行为）时只会改变句柄中的实例数据指针，而 reference 本身不需要修改。使用直接指针访问的好处是速度更快，它节省了一次指针定位的时间开销，由于对象的访问在 Java 中非常频繁，因此此类开销积少成多后也是一项非常可观的执行成本。

HotSpot 使用直接指针的方式进行对象访问。

### 2.3 实战：OutOfMemoryError 异常

除了程序计数器外，虚拟机内存的其他几个运行时区域都有发生 OOM 异常的可能 。

#### 2.3.1 Java 堆溢出

```java
/**
 * 堆溢出异常
 * VM Args: -Xms20m -Xmx20m -XX:+HeapDumpOnOutOfMemoryError
 * @author Gldwolf
 */
public class HeapOOM {
    static class OOMObject {

    }

    public static void main(String[] args) {
        List<OOMObject> list = new ArrayList<OOMObject>();

        while (true) {
            list.add(new OOMObject());
        }
    }
}
```

#### 2.3.2 虚拟机栈和本地方法栈溢出

由于在 HotSpot 虚拟机中并不区分虚拟机栈和本地方法栈，因此，对于 HotSpot 而言，虽然 `-Xoss` 参数（设置本地方法栈大小）存在，但实际上是无效的，栈容量只由 `-Xss` 参数设定。

关于虚拟机栈和本地方法栈，有两种异常：

- 如果线程请求的栈深度大于虚拟机所允许的最大深度，将抛出 StackOverflowError 异常
- 如果虚拟机在扩展栈时无法申请到足够的内存空间，则抛出 OutOfMemoryError 异常

```java
/**
 * VM Args: -Xss128k
 */
public class JavaVMStackSOF {
    private int stackLength = 1;

    public void stackLeak() {
        stackLength++;
        stackLeak();
    }

    public static void main(String[] args) throws Throwable {
        JavaVMStackSOF oom = new JavaVMStackSOF();
        try {
            oom.stackLeak();
        } catch (Throwable e) {
            System.out.println("Stack length: " + oom.stackLength);
            throw e;
        }
    }
}
```

#### 2.3.3 方法区内存溢出



#### 2.3.4 直接内存溢出

```java
import sun.misc.Unsafe;

import java.lang.reflect.Field;

/**
 * VM Args: -Xmx20m -XX:MaxDirectMemorySize=10m
 */
public class DirectMemoryOOM {
    private static final int _1MB = 1024 * 1024;

    public static void main(String[] args) throws IllegalAccessException {
        Field unsafeField = Unsafe.class.getDeclaredFields()[0];
        unsafeField.setAccessible(true);
        Unsafe unsafe = (Unsafe) unsafeField.get(null);
        while (true) {
            unsafe.allocateMemory(_1MB);
        }
    }
}
```

## 3 垃圾收集器与内存分配策略

### 3.1 垃圾收集器

#### 3.1.1 引用计数器

引用计算算法的缺陷：对象 objA 和对象 objB 都有字段 instance，赋值令 objA.instance = objB，令 objB.instance = objA，除此之外 ，这两个对象再无其它引用 ，这将导致它们的引用都不为 0，于是，引用计数算法将无法通知 GC 收集器来回收它们。

```java
/**
 * testGC() 方法执行后，objA 和 objB 会不会被 GC 呢？
 */
public class ReferenceCountingGC {

    public Object instance = null;

    private static final int _1MB = 1024 * 1024;

    /*
        这个成员属性的唯一意义就是占用点内存，以便能在 GC 日志中看清楚是否被回收过
     */
    private byte[] bigSize = new byte[2 * _1MB];

    public static void main(String[] args) {
        ReferenceCountingGC objA = new ReferenceCountingGC();
        ReferenceCountingGC objB = new ReferenceCountingGC();
        objA.instance = objB;
        objB.instance = objA;

        objA = null;
        objB = null;

        // 假设在这行发生 GC 操作，看看两个对象能否被回收
        System.gc();
    }
}
```





















































