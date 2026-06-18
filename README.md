# 校园快递代取与寄件管理系统

基于 JSP + Servlet + JDBC + MySQL 的校园快递代取与寄件管理系统。

## 技术栈

- JSP（JavaServer Pages）
- Servlet 4.0
- JDBC（MySQL Connector 8.0）
- MySQL 5.7+
- HTML + CSS + JavaScript
- AJAX 异步请求
- Apache Tomcat 8.5+

## 开发环境

- JDK 8 或 JDK 11
- Apache Tomcat 8.5 或 9
- MySQL 5.7 或 8.0
- IntelliJ IDEA 或 Eclipse
- Maven 3.6+

## 项目导入

### IntelliJ IDEA

1. File → Open → 选择本项目根目录
2. 等待 Maven 依赖下载完成
3. 配置 Tomcat（Run → Edit Configurations → Add Tomcat Server → Local）
4. 将项目部署到 Tomcat

### Eclipse

1. File → Import → Maven → Existing Maven Projects
2. 选择本项目根目录
3. 等待 Maven 依赖下载完成
4. 右键项目 → Run As → Run on Server

## 数据库配置

### 1. 导入 SQL 文件

使用 MySQL 客户端执行项目中的 `sql/campus_express.sql` 文件：

```bash
# 方式一：命令行导入
mysql -u root -p < sql/campus_express.sql

# 方式二：登录 MySQL 后执行
source /项目路径/sql/campus_express.sql;
```

### 2. 修改数据库连接信息

编辑 `src/main/java/com/campus/express/util/DBUtil.java` 文件：

```java
private static final String URL = "jdbc:mysql://localhost:3306/campus_express?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
private static final String USERNAME = "root";   // 修改为你的MySQL用户名
private static final String PASSWORD = "123456";  // 修改为你的MySQL密码
```

## 运行说明

1. 启动 MySQL 服务
2. 确保已执行 SQL 文件完成数据库初始化
3. 在 IDE 中启动 Tomcat
4. 打开浏览器访问：`http://localhost:8080/CampusDeliverySystem/`

## 测试账号

| 用户名 | 密码 | 角色 |
|--------|------|------|
| admin | 123456 | 管理员 |
| student | 123456 | 普通学生 |
| student2 | 123456 | 普通学生 |
| runner | 123456 | 代取员 |
| runner2 | 123456 | 代取员 |

## 系统功能

### 普通学生
- 注册/登录账号
- 修改个人信息
- 发布快递代取订单
- 发布寄件订单
- 查看自己的订单
- 取消未接单订单
- 查看订单详情
- 对已完成订单进行评价

### 代取员
- 登录系统
- 浏览订单大厅
- 异步接单（AJAX）
- 查看已接订单
- 修改订单状态（已接单→配送中→已完成）

### 管理员
- 登录后台
- 查看/删除用户
- 查看/删除/修改订单
- 发布/修改/删除公告

## 页面列表

共 17 个页面

### 前台页面（13个）
1. index.jsp - 首页
2. login.jsp - 登录页面
3. register.jsp - 注册页面
4. userCenter.jsp - 个人中心
5. editUser.jsp - 修改个人信息
6. addPickupOrder.jsp - 发布代取订单
7. addSendOrder.jsp - 发布寄件订单
8. orderHall.jsp - 订单大厅
9. orderDetail.jsp - 订单详情
10. myOrders.jsp - 我的订单
11. myReceiveOrders.jsp - 我的接单
12. comment.jsp - 评价订单
13. noticeList.jsp - 公告列表

### 后台页面（4个）
14. adminIndex.jsp - 后台首页
15. userManage.jsp - 用户管理
16. orderManage.jsp - 订单管理
17. noticeManage.jsp - 公告管理

## 课程知识点体现

1. **JSP 内置对象**
   - request：获取表单数据和请求参数
   - response：页面重定向（sendRedirect）
   - session：保存登录用户信息
   - application：统计网站访问量
   - out：页面输出

2. **Servlet**
   - UserServlet：用户登录、注册、信息修改
   - OrderServlet：订单的增删改查和状态变更
   - NoticeServlet：公告管理
   - CommentServlet：评价管理
   - AdminServlet：管理员功能

3. **AJAX 异步消息**
   - 注册时异步检测用户名是否存在
   - 订单大厅异步接单
   - 管理员异步删除订单和用户
   - 异步修改订单状态

4. **JDBC + MySQL**
   - DBUtil 数据库连接工具类
   - DAO 层负责数据访问
   - 完整的增删改查操作

## 目录结构

```
CampusDeliverySystem
├── pom.xml
├── README.md
├── sql/
│   └── campus_express.sql
└── src/
    └── main/
        ├── java/com/campus/express/
        │   ├── model/
        │   │   ├── User.java
        │   │   ├── Order.java
        │   │   ├── Notice.java
        │   │   └── Comment.java
        │   ├── dao/
        │   │   ├── UserDao.java
        │   │   ├── OrderDao.java
        │   │   ├── NoticeDao.java
        │   │   └── CommentDao.java
        │   ├── servlet/
        │   │   ├── UserServlet.java
        │   │   ├── OrderServlet.java
        │   │   ├── NoticeServlet.java
        │   │   ├── CommentServlet.java
        │   │   └── AdminServlet.java
        │   └── util/
        │       └── DBUtil.java
        └── webapp/
            ├── css/
            │   └── style.css
            ├── js/
            │   └── main.js
            ├── WEB-INF/
            │   └── web.xml
            ├── index.jsp
            ├── login.jsp
            ├── register.jsp
            ├── userCenter.jsp
            ├── editUser.jsp
            ├── addPickupOrder.jsp
            ├── addSendOrder.jsp
            ├── orderHall.jsp
            ├── orderDetail.jsp
            ├── myOrders.jsp
            ├── myReceiveOrders.jsp
            ├── comment.jsp
            ├── noticeList.jsp
            ├── adminIndex.jsp
            ├── userManage.jsp
            ├── orderManage.jsp
            └── noticeManage.jsp
```
