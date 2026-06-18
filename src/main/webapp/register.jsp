<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 校园快递系统</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="js/main.js"></script>
</head>
<body>

<nav class="navbar">
    <div class="logo">校园快递系统</div>
    <div class="nav-links">
        <a href="index.jsp">首页</a>
        <a href="login.jsp">登录</a>
    </div>
</nav>

<div class="auth-container">
    <div class="auth-box">
        <h2>用户注册</h2>

        <% if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>

        <form action="user" method="post">
            <input type="hidden" name="action" value="register">

            <div class="form-group">
                <label>用户名</label>
                <input type="text" id="username" name="username" class="form-control" required placeholder="请输入用户名" onblur="checkUsername()">
                <div id="usernameTip" class="inline-tip"></div>
            </div>

            <div class="form-group">
                <label>密码</label>
                <input type="password" name="password" class="form-control" required placeholder="请输入密码">
            </div>

            <div class="form-group">
                <label>真实姓名</label>
                <input type="text" name="realName" class="form-control" required placeholder="请输入真实姓名">
            </div>

            <div class="form-group">
                <label>手机号码</label>
                <input type="text" name="phone" class="form-control" required placeholder="请输入手机号">
            </div>

            <div class="form-group">
                <label>宿舍地址</label>
                <input type="text" name="dormitory" class="form-control" required placeholder="如：北区1号楼301">
            </div>

            <div class="form-group">
                <label>用户角色</label>
                <select name="role" class="form-control" required>
                    <option value="student">普通学生</option>
                    <option value="runner">代取员</option>
                </select>
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-primary btn-lg" style="width:100%;">注 册</button>
            </div>
        </form>

        <div class="form-extra">
            已有账号？<a href="login.jsp">立即登录</a>
        </div>
    </div>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
