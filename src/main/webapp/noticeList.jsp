<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campus.express.model.User" %>
<%@ page import="com.campus.express.model.Notice" %>
<%@ page import="java.util.List" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    List<Notice> noticeList = (List<Notice>) request.getAttribute("noticeList");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告列表 - 校园快递系统</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="logo">校园快递系统</div>
    <div class="nav-links">
        <a href="index.jsp">首页</a>
        <% if (loginUser != null) { %>
            <% if ("student".equals(loginUser.getRole())) { %>
                <a href="order?action=myOrders">我的订单</a>
            <% } else if ("runner".equals(loginUser.getRole())) { %>
                <a href="order?action=myReceive">我的接单</a>
            <% } else if ("admin".equals(loginUser.getRole())) { %>
                <a href="adminIndex.jsp">后台管理</a>
            <% } %>
            <span class="user-info"><%= loginUser.getRealName() %> | <a href="user?action=logout">退出</a></span>
        <% } else { %>
            <a href="login.jsp">登录</a>
        <% } %>
    </div>
</nav>

<div class="main-content">
    <div class="card">
        <div class="card-title">系统公告</div>

        <% if (noticeList == null || noticeList.isEmpty()) { %>
            <p style="color:#999; text-align:center; padding:40px;">暂无公告</p>
        <% } else { %>
            <% for (Notice notice : noticeList) { %>
                <div style="padding: 16px 0; border-bottom: 1px solid #f5f5f5;">
                    <h3 style="color:#001529; margin-bottom:8px;"><%= notice.getTitle() %></h3>
                    <p style="color:#666; font-size:14px;"><%= notice.getContent() %></p>
                    <span style="color:#999; font-size:12px;"><%= notice.getCreateTime() %></span>
                </div>
            <% } %>
        <% } %>
    </div>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
