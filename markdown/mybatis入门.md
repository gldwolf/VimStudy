# MyBatis 入门

## 动态 SQL

MyBatis 采用功能强大的基于 OGNL 的表达式:

- if 
- choose (when, otherwise)
- trim (where, set)
- foreach

### if

示例：

```xml
<select id="findActiveBlogWithTitleLike"
     resultType="Blog">
  SELECT * FROM BLOG
  WHERE state = ‘ACTIVE’
  <if test="title != null">
    AND title like #{title}
  </if>
</select>
```

这条语句提供了一种可选的查找文本的功能。如果没有传入 "title"，那么所有处于 "ACTIVE" 状态的 BLOG 都会返回；反之，若传入了 "title"，那么就会对 "title" 一列进行模糊查询并返回 BLOG 结果。

如果希望通过 "title" 和 "author" 两个参数来进行搜索，只要加入另一个条件即可：

```xml
<select id="findActiveBlogLike"
     resultType="Blog">
  SELECT * FROM BLOG WHERE state = ‘ACTIVE’
  <if test="title != null">
    AND title like #{title}
  </if>
  <if test="author != null and author.name != null">
    AND author_name like #{author.name}
  </if>
</select>
```

### choose, when, otherwise

如果我们不想应用所有的条件语句，而是只想从中选择其中一项。针对这种情况，我们可以使用 choose 元素，类似于 java 中的 switch 语句。

还是上面的例子，但是这次变为提供了 "title" 就按 "title" 查找，提供了 "author" 就按 "author" 查找，若两者都没有提供，就返回所有符合条件的 BLOG。

```xml
<select id="findActiveBlogLike"
     resultType="Blog">
  SELECT * FROM BLOG WHERE state = ‘ACTIVE’
  <choose>
    <when test="title != null">
      AND title like #{title}
    </when>
    <when test="author != null and author.name != null">
      AND author_name like #{author.name}
    </when>
    <otherwise>
      AND featured = 1
    </otherwise>
  </choose>
</select>
```

### trim, where, set

看看如下的语句会发生什么情况：

```xml
<select id="findActiveBlogLike"
     resultType="Blog">
  SELECT * FROM BLOG
  WHERE
  <if test="state != null">
    state = #{state}
  </if>
  <if test="title != null">
    AND title like #{title}
  </if>
  <if test="author != null and author.name != null">
    AND author_name like #{author.name}
  </if>
</select>
```

如果这些条件都没有能够匹配上，最终这条 SQL 会变成这样：

```sql
SELECT * FROM BLOG WHERE
```

这样会导致查询失败。如果仅仅第二个条件匹配，SQL 语句会变成这样：

```sql
SELECT * FROM BLOG
WEHRE
AND title LIKE "someTitle"
```

这也会导致查询失败，我们可以使用下面的方式来进行处理：

```xml
<select id="findActiveBlogLike"
     resultType="Blog">
  SELECT * FROM BLOG
  <where>
    <if test="state != null">
         state = #{state}
    </if>
    <if test="title != null">
        AND title like #{title}
    </if>
    <if test="author != null and author.name != null">
        AND author_name like #{author.name}
    </if>
  </where>
</select>
```

where 元素只会在至少有一个子元素的条件返回 SQL 子句的情况下才会去插入 "WHERE" 子句。而且，若语句的开头为 "AND" 或 "OR"，where 元素也会将它们去除。

如果 where 元素没有正常执行，我们可以通过自定义 trim 元素来定制 where 元素的功能。比如，和 where 元素等价的自定义 trim 元素为：

```xml
<trim prefix="WHERE" prefixOverrides="AND |OR ">
  ...
</trim>
```

prefixOverrides 属性会忽略通过管道分隔的文本序列（注意：空格也是必要的）。它的作用是移除所有指定在 prefixOverrides 属性中的内容，并且插入 prefix 属性中指定的内容。

类似的用于动态更新语句的解决方案是 set，set 元素可以用于动态包含需要更新的列，而舍去其它的。比如：

```xml
<update id="updateAuthorIfNecessary">
  update Author
    <set>
      <if test="username != null">username=#{username},</if>
      <if test="password != null">password=#{password},</if>
      <if test="email != null">email=#{email},</if>
      <if test="bio != null">bio=#{bio}</if>
    </set>
  where id=#{id}
</update>
```

这里，set 元素会动态前置 SET 关键字，同时也会删掉无关的逗号，因为用了条件语句之后，很可能会在生成的 SQL 语句的后面留下这些逗号（因为用的是 "if" 元素，若最后一个 "if" 没有匹配上而前面的匹配上，SQL 语句的最后会有一个逗号遗留）。

set 元素等价的自定义 trim 元素：

```xml
<trim prefix="SET" suffixOverrides=",">
  ...
</trim>
```

这里，我们删去的是后缀值，同时添加了前缀值。

### foreach

动态 SQL 的另外一个常用的操作是对一个集合进行遍历，常常是在构建 IN 条件语句的时候。比如：

```xml
<select id="selectPostIn" resultType="domain.blog.Post">
  SELECT *
  FROM POST P
  WHERE ID in
  <foreach item="item" index="index" collection="list"
      open="(" separator="," close=")">
        #{item}
  </foreach>
</select>
```

foreach 元素的功能非常强大，它允许你指定一个集合，声明可以在元素体内使用的集合项（item）和索引（index）变量。它也允许你指定开头与结尾的字符串以及在迭代结果之间放置分隔符。

**注意**： 你可以将任何可迭代对象（如 List、Set 等）、Map 对象或者数组对象传递给 *foreach* 作为集合参数。当使用可迭代对象或者数组时，index 是当前迭代的次数，item 的值是本次迭代获取的元素。当使用 Map 对象（或者 Map.Entry 对象的集合）时，index 是键，item 是值。

### Script

动态 SQL 也可以使用注解，示例：

```java
@Update({"<script>",
         "update Author",
         "  <set>",
         "    <if test='username != null'>username=#{username},</if>",
         "    <if test='password != null'>password=#{password},</if>",
         "    <if test='email != null'>email=#{email},</if>",
         "    <if test='bio != null'>bio=#{bio}</if>",
         "  </set>",
         "where id=#{id}",
         "</script>"})
void updateAuthorValues(Author author);
```

### bind

bind 元素可以从 OGNL 表达式中创建一个变量并将其绑定到上下文。比如：

```xml
<select id="selectBlogsLike" resultType="Blog">
  <bind name="pattern" value="'%' + _parameter.getTitle() + '%'" />
  SELECT * FROM BLOG
  WHERE title LIKE #{pattern}
</select>
```



