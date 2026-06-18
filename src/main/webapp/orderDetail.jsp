<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campus.express.model.User" %>
<%@ page import="com.campus.express.model.Order" %>
<%@ page import="com.campus.express.model.Comment" %>
<%@ page import="com.campus.express.dao.CommentDao" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Order order = (Order) request.getAttribute("order");
    if (order == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    CommentDao commentDao = new CommentDao();
    Comment comment = commentDao.findByOrderId(order.getId());
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单详情 - 校园快递系统</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="logo">校园快递系统</div>
    <div class="nav-links">
        <a href="index.jsp">首页</a>
        <a href="order?action=hall">订单大厅</a>
        <% if ("student".equals(loginUser.getRole())) { %>
            <a href="order?action=myOrders">我的订单</a>
        <% } else if ("runner".equals(loginUser.getRole())) { %>
            <a href="order?action=myReceive">我的接单</a>
        <% } %>
        <span class="user-info"><%= loginUser.getRealName() %> | <a href="user?action=logout">退出</a></span>
    </div>
</nav>

<div class="main-content">
    <div class="card">
        <div class="card-title">订单详情 #<%= order.getId() %></div>

        <table>
            <tr><td width="120"><strong>订单类型：</strong></td><td><%= order.getOrderType() %></td></tr>
            <tr><td><strong>快递点/地点：</strong></td><td><%= order.getPickupPlace() != null ? order.getPickupPlace() : "-" %></td></tr>
            <% if (order.getPickupCode() != null && !order.getPickupCode().isEmpty()) { %>
                <tr><td><strong>取件码：</strong></td><td><%= order.getPickupCode() %></td></tr>
            <% } %>
            <tr><td><strong>地址：</strong></td><td><%= order.getAddress() != null ? order.getAddress() : "-" %></td></tr>
            <tr><td><strong>描述：</strong></td><td><%= order.getDescription() != null ? order.getDescription() : "-" %></td></tr>
            <tr><td><strong>服务费用：</strong></td><td style="color:#ff4d4f;font-weight:600;">¥<%= order.getPrice() %></td></tr>
            <tr><td><strong>发布人：</strong></td><td><%= order.getUserName() != null ? order.getUserName() : "-" %></td></tr>
            <tr><td><strong>接单人：</strong></td><td><%= order.getRunnerName() != null ? order.getRunnerName() : "未接单" %></td></tr>
            <tr><td><strong>订单状态：</strong></td><td>
                <% String status = order.getStatus(); %>
                <span class="status-badge
                    <%= "待接单".equals(status) ? "status-pending" : "" %>
                    <%= "已接单".equals(status) ? "status-accepted" : "" %>
                    <%= "配送中".equals(status) ? "status-delivering" : "" %>
                    <%= "已完成".equals(status) ? "status-done" : "" %>
                    <%= "已取消".equals(status) ? "status-cancel" : "" %>
                "><%= status %></span>
            </td></tr>
            <tr><td><strong>创建时间：</strong></td><td><%= order.getCreateTime() %></td></tr>
        </table>

        <div style="margin-top:20px;">
            <a href="javascript:history.back()" class="btn btn-default">返回</a>
            <% if ("runner".equals(loginUser.getRole()) && "已接单".equals(order.getStatus()) && order.getRunnerId() == loginUser.getId()) { %>
                <a href="order?action=updateStatus&orderId=<%= order.getId() %>&status=配送中" class="btn btn-warning">开始配送</a>
            <% } %>
            <% if ("runner".equals(loginUser.getRole()) && "配送中".equals(order.getStatus()) && order.getRunnerId() == loginUser.getId()) { %>
                <a href="order?action=updateStatus&orderId=<%= order.getId() %>&status=已完成" class="btn btn-success">标记完成</a>
            <% } %>
        </div>
    </div>

    <!-- 评价信息 -->
    <% if (comment != null) { %>
    <div class="card">
        <div class="card-title">订单评价</div>
        <table>
            <tr><td width="120"><strong>评价人：</strong></td><td><%= comment.getUserName() %></td></tr>
            <tr><td><strong>评分：</strong></td>
                <td>
                    <% for (int i = 1; i <= 5; i++) { %>
                        <%= i <= comment.getScore() ? "★" : "☆" %>
                    <% } %>
                </td>
            </tr>
            <tr><td><strong>评价内容：</strong></td><td><%= comment.getContent() %></td></tr>
            <tr><td><strong>评价时间：</strong></td><td><%= comment.getCreateTime() %></td></tr>
        </table>
    </div>
    <% } %>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
