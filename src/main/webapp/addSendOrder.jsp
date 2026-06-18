<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campus.express.model.User" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (!"student".equals(loginUser.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>发布寄件订单 - 校园快递系统</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="logo">校园快递系统</div>
    <div class="nav-links">
        <a href="index.jsp">首页</a>
        <a href="order?action=hall">订单大厅</a>
        <a href="order?action=myOrders">我的订单</a>
        <span class="user-info"><%= loginUser.getRealName() %> | <a href="user?action=logout">退出</a></span>
    </div>
</nav>

<div class="auth-container">
    <div class="auth-box" style="width:550px;">
        <h2>发布寄件订单</h2>
        <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

        <form action="order" method="post">
            <input type="hidden" name="action" value="addSend">

            <div class="form-group">
                <label>寄件地点</label>
                <input type="text" name="pickupPlace" class="form-control" required placeholder="如：北区菜鸟驿站">
            </div>

            <div class="form-group">
                <label>寄件地址（目的地）</label>
                <input type="text" name="address" class="form-control" required placeholder="如：上海市浦东新区XX路XX号">
            </div>

            <div class="form-group">
                <label>物品说明</label>
                <textarea name="description" class="form-control" placeholder="请描述要寄送的物品信息和备注"></textarea>
            </div>

            <div class="form-group">
                <label>服务费用（元）</label>
                <input type="number" name="price" class="form-control" required placeholder="如：10" step="0.1" min="0">
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-primary btn-lg" style="width:100%;">发布寄件订单</button>
            </div>
        </form>
    </div>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
