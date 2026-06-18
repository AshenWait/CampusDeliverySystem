<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campus.express.model.User" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>修改信息 - 校园快递系统</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="logo">校园快递系统</div>
    <div class="nav-links">
        <a href="index.jsp">首页</a>
        <a href="userCenter.jsp">个人中心</a>
        <span class="user-info"><%= loginUser.getRealName() %> | <a href="user?action=logout">退出</a></span>
    </div>
</nav>

<div class="auth-container">
    <div class="auth-box" style="width:500px;">
        <h2>修改个人信息</h2>
        <% if (msg != null) { %><div class="alert alert-success"><%= msg %></div><% } %>
        <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

        <form action="user" method="post">
            <input type="hidden" name="action" value="update">

            <div class="form-group">
                <label>真实姓名</label>
                <input type="text" name="realName" class="form-control" required value="<%= loginUser.getRealName() %>">
            </div>

            <div class="form-group">
                <label>手机号码</label>
                <input type="text" name="phone" class="form-control" required value="<%= loginUser.getPhone() %>">
            </div>

            <div class="form-group">
                <label>宿舍地址</label>
                <input type="text" name="dormitory" class="form-control" required value="<%= loginUser.getDormitory() %>">
            </div>

            <div class="form-group">
                <label>新密码（不修改请留空）</label>
                <input type="password" name="password" class="form-control" placeholder="留空则不修改密码">
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-primary btn-lg" style="width:100%;">保存修改</button>
            </div>
        </form>
    </div>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
