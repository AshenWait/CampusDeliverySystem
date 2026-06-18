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
    <title>发布代取订单 - 校园快递系统</title>
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
        <h2>发布快递代取订单</h2>
        <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

        <form action="order" method="post">
            <input type="hidden" name="action" value="addPickup">

            <div class="form-group">
                <label>快递点</label>
                <input type="text" name="pickupPlace" class="form-control" required placeholder="如：北门菜鸟驿站">
            </div>

            <div class="form-group">
                <label>取件码</label>
                <input type="text" name="pickupCode" class="form-control" required placeholder="请输入取件码">
            </div>

            <div class="form-group">
                <label>送达地址</label>
                <input type="text" name="address" class="form-control" required placeholder="如：北区1号楼301" value="<%= loginUser.getDormitory() %>">
            </div>

            <div class="form-group">
                <label>订单描述</label>
                <textarea name="description" class="form-control" placeholder="描述一下你的快递物品信息"></textarea>
            </div>

            <div class="form-group">
                <label>服务费用（元）</label>
                <input type="number" name="price" class="form-control" required placeholder="如：5" step="0.1" min="0">
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-primary btn-lg" style="width:100%;">发布代取订单</button>
            </div>
        </form>
    </div>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
