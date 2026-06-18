<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campus.express.model.User" %>
<%@ page import="com.campus.express.model.Order" %>
<%@ page import="java.util.List" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Order> orderList = (List<Order>) request.getAttribute("orderList");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单大厅 - 校园快递系统</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="js/main.js"></script>
</head>
<body>

<nav class="navbar">
    <div class="logo">校园快递系统</div>
    <div class="nav-links">
        <a href="index.jsp">首页</a>
        <% if ("student".equals(loginUser.getRole())) { %>
            <a href="addPickupOrder.jsp">发布代取</a>
            <a href="addSendOrder.jsp">发布寄件</a>
            <a href="order?action=myOrders">我的订单</a>
        <% } else if ("runner".equals(loginUser.getRole())) { %>
            <a href="order?action=myReceive">我的接单</a>
        <% } %>
        <span class="user-info"><%= loginUser.getRealName() %> | <a href="user?action=logout">退出</a></span>
    </div>
</nav>

<div class="main-content">
    <div class="card">
        <div class="card-title">订单大厅 - 待接订单</div>
        <p style="color:#888; font-size:14px; margin-bottom:16px;">以下是所有等待代取员接单的订单，您可以在这里浏览和接单。</p>

        <% if (orderList == null || orderList.isEmpty()) { %>
            <p style="color:#999; text-align:center; padding:40px;">暂无待接订单</p>
        <% } else { %>
            <div class="order-cards">
                <% for (Order order : orderList) { %>
                <div class="order-card <%= "寄件".equals(order.getOrderType()) ? "send-order" : "" %>">
                    <div class="order-header">
                        <span class="order-type">
                            <%= "代取".equals(order.getOrderType()) ? "📦" : "📮" %>
                            <%= order.getOrderType() %>订单
                        </span>
                        <span class="status-badge status-pending">待接单</span>
                    </div>
                    <div class="order-info"><span>地点：</span><%= order.getPickupPlace() != null ? order.getPickupPlace() : "-" %></div>
                    <% if (order.getPickupCode() != null && !order.getPickupCode().isEmpty()) { %>
                        <div class="order-info"><span>取件码：</span><%= order.getPickupCode() %></div>
                    <% } %>
                    <div class="order-info"><span>地址：</span><%= order.getAddress() != null ? order.getAddress() : "-" %></div>
                    <div class="order-info"><span>发布人：</span><%= order.getUserName() %></div>
                    <div class="order-info"><span>时间：</span><%= order.getCreateTime() %></div>

                    <div class="order-footer">
                        <span class="order-price">¥<%= order.getPrice() %></span>
                        <div>
                            <a href="order?action=detail&orderId=<%= order.getId() %>" class="btn btn-default btn-sm">详情</a>
                            <% if ("runner".equals(loginUser.getRole())) { %>
                                <button class="btn btn-primary btn-sm" onclick="receiveOrder(<%= order.getId() %>)">立即接单</button>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>
    </div>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
