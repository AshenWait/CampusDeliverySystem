<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录 - 校园快递系统</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="logo">校园快递系统</div>
    <div class="nav-links">
        <a href="index.jsp">首页</a>
        <a href="register.jsp">注册</a>
    </div>
</nav>

<div class="auth-container">
    <div class="auth-box">
        <h2>用户登录</h2>

        <% if ("registerSuccess".equals(msg)) { %>
            <div class="alert alert-success">注册成功，请登录。</div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>

        <form action="user" method="post">
            <input type="hidden" name="action" value="login">

            <div class="form-group">
                <label>用户名</label>
                <input type="text" name="username" class="form-control" required placeholder="请输入用户名">
            </div>

            <div class="form-group">
                <label>密码</label>
                <input type="password" name="password" class="form-control" required placeholder="请输入密码">
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-primary btn-lg" style="width:100%;">登 录</button>
            </div>
        </form>

        <div class="form-extra">
            还没有账号？<a href="register.jsp">立即注册</a>
        </div>

        <div class="form-extra" style="margin-top:10px; color:#999; font-size:12px;">
            测试账号：admin/123456（管理员）| student/123456（学生）| runner/123456（代取员）
        </div>
    </div>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
