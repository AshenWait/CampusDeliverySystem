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
    String orderId = request.getParameter("orderId");
    String runnerId = request.getParameter("runnerId");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单评价 - 校园快递系统</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="logo">校园快递系统</div>
    <div class="nav-links">
        <a href="index.jsp">首页</a>
        <a href="order?action=myOrders">我的订单</a>
        <span class="user-info"><%= loginUser.getRealName() %> | <a href="user?action=logout">退出</a></span>
    </div>
</nav>

<div class="auth-container">
    <div class="auth-box" style="width:500px;">
        <h2>订单评价</h2>
        <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

        <form action="comment" method="post">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="orderId" value="<%= orderId %>">
            <input type="hidden" name="runnerId" value="<%= runnerId %>">

            <div class="form-group">
                <label>评分</label>
                <div class="star-rating">
                    <input type="radio" id="star5" name="score" value="5"><label for="star5">★</label>
                    <input type="radio" id="star4" name="score" value="4"><label for="star4">★</label>
                    <input type="radio" id="star3" name="score" value="3"><label for="star3">★</label>
                    <input type="radio" id="star2" name="score" value="2"><label for="star2">★</label>
                    <input type="radio" id="star1" name="score" value="1" checked><label for="star1">★</label>
                </div>
            </div>

            <div class="form-group">
                <label>评价内容</label>
                <textarea name="content" class="form-control" rows="4" placeholder="请描述您对本次服务的评价"></textarea>
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-primary btn-lg" style="width:100%;">提交评价</button>
            </div>
        </form>
    </div>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
