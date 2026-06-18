<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campus.express.model.User" %>
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
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员后台 - 校园快递系统</title>
    <link rel="stylesheet" href="css/style.css">
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
        <!-- 左侧菜单 -->
        <div class="admin-sidebar">
            <div class="sidebar-title">管理菜单</div>
            <a href="adminIndex.jsp" class="active">后台首页</a>
            <a href="userManage.jsp">用户管理</a>
            <a href="orderManage.jsp">订单管理</a>
            <a href="noticeManage.jsp">公告管理</a>
        </div>

        <!-- 右侧内容 -->
        <div class="admin-content">
            <div class="card">
                <div class="card-title">欢迎进入管理员后台</div>
                <p style="font-size:15px; color:#555; line-height:2;">
                    管理员，<strong><%= loginUser.getRealName() %></strong>，您好！<br><br>
                    您可以使用左侧菜单进行以下管理操作：<br><br>
                    1. <strong>用户管理</strong> - 查看所有用户、删除异常用户<br>
                    2. <strong>订单管理</strong> - 查看所有订单、修改订单状态、删除异常订单<br>
                    3. <strong>公告管理</strong> - 发布、修改、删除系统公告
                </p>
            </div>

            <!-- 快捷入口 -->
            <div class="quick-links">
                <a href="userManage.jsp" class="quick-link">用户管理</a>
                <a href="orderManage.jsp" class="quick-link">订单管理</a>
                <a href="noticeManage.jsp" class="quick-link">公告管理</a>
            </div>
        </div>
    </div>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
