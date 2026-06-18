<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campus.express.model.User" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 - 校园快递系统</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="logo">校园快递系统</div>
    <div class="nav-links">
        <a href="index.jsp">首页</a>
        <% if ("student".equals(loginUser.getRole())) { %>
            <a href="order?action=myOrders">我的订单</a>
        <% } else if ("runner".equals(loginUser.getRole())) { %>
            <a href="order?action=myReceive">我的接单</a>
        <% } else if ("admin".equals(loginUser.getRole())) { %>
            <a href="adminIndex.jsp">后台管理</a>
        <% } %>
        <span class="user-info"><%= loginUser.getRealName() %> | <a href="user?action=logout">退出</a></span>
    </div>
</nav>

<div class="main-content">
    <div class="card">
        <div class="card-title">个人中心</div>
        <table>
            <tr><td width="120"><strong>用户名：</strong></td><td><%= loginUser.getUsername() %></td></tr>
            <tr><td><strong>真实姓名：</strong></td><td><%= loginUser.getRealName() %></td></tr>
            <tr><td><strong>手机号码：</strong></td><td><%= loginUser.getPhone() %></td></tr>
            <tr><td><strong>宿舍地址：</strong></td><td><%= loginUser.getDormitory() %></td></tr>
            <tr><td><strong>用户角色：</strong></td><td>
                <% if ("student".equals(loginUser.getRole())) { %>普通学生
                <% } else if ("runner".equals(loginUser.getRole())) { %>代取员
                <% } else if ("admin".equals(loginUser.getRole())) { %>管理员<% } %>
            </td></tr>
            <tr><td><strong>注册时间：</strong></td><td><%= loginUser.getCreateTime() %></td></tr>
        </table>
        <div style="margin-top:20px;">
            <a href="editUser.jsp" class="btn btn-primary">修改个人信息</a>
        </div>
    </div>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
