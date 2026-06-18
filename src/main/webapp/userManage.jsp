<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campus.express.model.User" %>
<%@ page import="com.campus.express.dao.UserDao" %>
<%@ page import="java.util.List" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (!"admin".equals(loginUser.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }
    UserDao userDao = new UserDao();
    List<User> userList = userDao.findAll();
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - 校园快递系统</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="js/main.js"></script>
</head>
<body>

<nav class="navbar">
    <div class="logo">校园快递系统 - 管理员后台</div>
    <div class="nav-links">
        <a href="index.jsp">返回首页</a>
        <span class="user-info"><%= loginUser.getRealName() %> | <a href="user?action=logout">退出</a></span>
    </div>
</nav>

<div class="main-content">
    <div class="admin-layout">
        <div class="admin-sidebar">
            <div class="sidebar-title">管理菜单</div>
            <a href="adminIndex.jsp">后台首页</a>
            <a href="userManage.jsp" class="active">用户管理</a>
            <a href="orderManage.jsp">订单管理</a>
            <a href="noticeManage.jsp">公告管理</a>
        </div>

        <div class="admin-content">
            <div class="card">
                <div class="card-title">用户管理</div>
                <% if (msg != null) { %><div class="alert alert-success"><%= msg %></div><% } %>

                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>用户名</th>
                                <th>姓名</th>
                                <th>手机号</th>
                                <th>宿舍</th>
                                <th>角色</th>
                                <th>注册时间</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User u : userList) { %>
                            <tr>
                                <td><%= u.getId() %></td>
                                <td><%= u.getUsername() %></td>
                                <td><%= u.getRealName() %></td>
                                <td><%= u.getPhone() %></td>
                                <td><%= u.getDormitory() %></td>
                                <td>
                                    <% if ("student".equals(u.getRole())) { %>学生
                                    <% } else if ("runner".equals(u.getRole())) { %>代取员
                                    <% } else if ("admin".equals(u.getRole())) { %>管理员<% } %>
                                </td>
                                <td><%= u.getCreateTime() %></td>
                                <td>
                                    <% if (!"admin".equals(u.getRole())) { %>
                                        <button class="btn btn-danger btn-sm" onclick="deleteUser(<%= u.getId() %>)">删除</button>
                                    <% } else { %>
                                        <span style="color:#999;">-</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
