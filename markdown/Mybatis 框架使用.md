# Mybatis 框架使用

> 使用 Mybatis 之后，我们只需要自己提供 SQL 语句，其他的工作，诸如建立连接，Statement，JDBC 相关异常处理等都交给 Mybatis 来做，我们只需要关注在增删改查等操作层面上，而把技术细节都封装起来了。

## 1 基础部分

### 1.1 导入依赖

```xml
<dependencies>
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.4.6</version>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.47</version>
        </dependency>
</dependencies>
```

### 1.2 初步使用

#### 1.2.1 准备数据库数据

```sql
-- 创建数据库
create database ssm;
use ssm;
-- 创建表
create table category_(
	id int(11) not null auto_increment,
    name varchar(32) default null,
    primary key (id)
) engine=innodb auto_increment=1 default charset=utf8;
-- 插入数据
insert into category_ values(null, 'category1');
insert into category_ values(null, 'category2');
```

#### 1.2.2 代码示例

##### 1.2.2.1 实体类 Category.java

实体类 Category 用于映射表 category_ 的每条数据

```java
package org.gldwolf.pojo;

public class Category {
    private int id;
    private String name;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
```

##### 1.2.2.2 主配置文件 mybatis-config.xml

在 resources 目录下创建 mybatis 的主配置文件 **mybatis-config.xml**。

该配置文件主要提供连接数据库用的**驱动**，**数据库名称**，**编码方式**，**账号密码**：

```xml
<property name="driver" value="com.mysql.jdbc.Driver"/>
<property name="url" value="jdbc:mysql://localhost:3306/ssm?characterEncoding=UTF-8"/>
<property name="username" value="root"/>
<property name="password" value="admin"/>
```

**别名配置**：别名的配置用于帮助 mybatis 自动扫描该包下的所有类，在后续的 resultType 中设置时，不用使用类的完全限定名，只需要写上类名就可以

```xml
<typeAliases>
	<package name="org.gldwolf.pojo"/>
</typeAliases>
```

**sql 语句配置文件 (Category.xml) 的设置**：

```xml
<mapper>
	<mapper resource="org/gldwolf/pojo/Category.xml"/>
</mapper>
```

完整的配置文件：

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!-- 配置别名，用于自动扫描实体类 -->
    <typeAliases>
        <package name="org.gldwolf.pojo"/>
    </typeAliases>
    
    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <!-- 配置连接用的驱动、url、用户名、密码 -->
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/ssm?characterEncoding=UTF-8"/>
                <property name="username" value="xxxxxx"/>
                <property name="password" value="xxxxxx"/>
            </dataSource>
        </environment>
    </environments>
    
    <!-- 指定映射 sql 的配置文件 -->
    <mappers>
        <mapper resource="org/gldwolf/pojo/Category.xml"/>
    </mappers>
</configuration>
```

##### 1.2.2.3 sql 配置文件 Category.xml

在包 org.gldwolf.pojo 下，创建 Category.xml：

**命名空间**：在后续调用 sql 语句时，会用到它里面定义的一条 sql 语句

```xml
namespace="org.gldwolf.pojo"
```

完整的配置如下:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="org.gldwolf.pojo">
    <!-- id 用于唯一标识这条 sql 语句 -->
    <!-- resultType 表示返回值类型，用于将返回的值映射成一个 Category 对象，由于在主配置文件配置了别名（即自动扫描 pojo 包下的类），所以在此处不用写完全限定名 -->
    <select id="listCategory" resultType="Category">
            select * from category_
    </select>
</mapper>
```

##### 1.2.2.4 测试类 TestMybatis.java

```java
package org.gldwolf;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.gldwolf.pojo.Category;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class TestMybatis {

    public static void main(String[] args) throws IOException {
        // 根据配置文件得到连接
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);

        // 根据连接获取 SqlSession 对象
        SqlSession session = sqlSessionFactory.openSession();

        // 通过 session 的 selectList 方法来调用 listCategory 这条 sql 语句
        // listCategory 就是在 Category.xml sql 映射文件中设置的 id
        List<Category> cs = session.selectList("listCategory");
        
        // 查看结果
        for (Category c : cs) {
            System.out.println(c.getName());
        }
    }
}
```

#### 1.2.2.5 基本原理

1. 应用程序通过 mybatis-config.xml 配置文件确定连接的数据库
2. 通过 mybatis-config.xml 配置文件确定 sql 语句映射文件，确定自动扫描的实体类
3. sql 语句返回的数据封装成 Category 实例
4. 把 Category 实例封装在一个 Category 集合中

### 1.3 数据库的增删改查

#### 1.3.1 Category.xml 配置文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="org.gldwolf.pojo">
    <!-- 添加数据 -->
    <insert id="addCategory" parameterType="Category">
    	insert into category_ (name) values (#{name})
    </insert>
    
    <!-- 删除数据 -->
    <delete id="deleteCategory" parameterType="Category">
    	delete from category_ where id = #{id}
    </delete>
    
    <!-- 更新数据 -->
    <update id="updateCategory" parameterType="Category">
    	update category_ set name = #{name} where id = #{id}
    </update>
    
    <!-- 查询数据 -->
    <select id="getCategory" parameterType="_int" resultType="Category">
    	select * from category_ where id = #{id}
    </select>
    
    <!-- 查询所有数据 -->
    <select id="listCategory" resultType="Category">
            select * from category_
    </select>
</mapper>
```

#### 1.3.2 java 代码

##### 1.3.2.1 插入数据

```java
Category c = new Category();
c.setName("新增 Category");
// 插入数据
session.insert("addCategory", c);
session.commit(); // 提交事务
```

##### 1.3.2.2 删除数据

```java
Category c = new Category();
c.setId(6);
// 删除数据
session.delete("deleteCategory", c);
session.commit();
```

##### 1.3.2.3 更新数据

```java
Category c = new Category();
c.setName("这是修改的数据");
c.setId(3);
session.update("updateCategory", c);
session.commit();
```

### 1.4 更多查询语句

#### 1.4.1 模糊查询

```
select * from category_ where name like concat('%',#{0},'%')
```

其中 concat('%',#{0},'%') 是 mysql 的语法，如果是 oracle，则写法如下：

```
select * from category_ where name like '%'||#{0}||'%'
```

**完整的 sql 语句**：

```xml
<!-- 此处的 parameterType 的值是 "String" 或者 "string" 都可 -->
<select id="listCategoryByName" parameterType="string" resultType="Category">
	select * from category_ where name like concat('%',#{0}, '%')
</select>
```

**java 代码：**

```java
// 查询 name 中包含有 "cat" 字符串的数据
List<Category> cis = session.selectList("listCategoryByName", "cat");
System.out.println("---id---|-----name-----|");
for (Category cc : cis) {
    System.out.println("   " + cc.getId() + "    |" + cc.getName());
    System.out.println("--------|--------------|");
}
```

#### 1.4.2 多条件查询

> 对于多条件查询传给 sql 的数据，可以用一个对象，也可以用一个 map 集合来完成

**sql 语句：**

```xml
<select id="listCategoryByIdAndName" parameterType="map" resultType="Category">
	select * from category_ where id > #{id} and name like concat('%',#{name},'%')
</select>
```

**java 代码：**

```java
Map<String, Object> params = new HashMap<>();
params.put("id", 3);
params.put("name", "cat");
List<Category> cs = session.selectList("listCategoryByIdAndName", params);
```





























