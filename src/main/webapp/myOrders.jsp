<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campus.express.model.User" %>
<%@ page import="com.campus.express.model.Order" %>
<%@ page import="com.campus.express.dao.CommentDao" %>
<%@ page import="java.util.List" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Order> orderList = (List<Order>) request.getAttribute("orderList");
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
    CommentDao commentDao = new CommentDao();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的订单 - 校园快递系统</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="js/main.js"></script>
</head>
<body>

<nav class="navbar">
    <div class="logo">校园快递系统</div>
    <div class="nav-links">
        <a href="index.jsp">首页</a>
        <a href="order?action=hall">订单大厅</a>
        <a href="addPickupOrder.jsp">发布代取</a>
        <a href="addSendOrder.jsp">发布寄件</a>
        <span class="user-info"><%= loginUser.getRealName() %> | <a href="user?action=logout">退出</a></span>
    </div>
</nav>

<div class="main-content">
    <div class="card">
        <div class="card-title">我的订单</div>

        <% if (msg != null) { %><div class="alert alert-success"><%= msg %></div><% } %>
        <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

        <% if (orderList == null || orderList.isEmpty()) { %>
            <p style="color:#999; text-align:center; padding:40px;">您还没有订单</p>
        <% } else { %>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>编号</th>
                            <th>类型</th>
                            <th>地点</th>
                            <th>地址</th>
                            <th>费用</th>
                            <th>接单人</th>
                            <th>状态</th>
                            <th>时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Order o : orderList) { %>
                        <tr>
                            <td>#<%= o.getId() %></td>
                            <td><%= o.getOrderType() %></td>
                            <td><%= o.getPickupPlace() != null ? o.getPickupPlace() : "-" %></td>
                            <td><%= o.getAddress() != null ? o.getAddress() : "-" %></td>
                            <td>¥<%= o.getPrice() %></td>
                            <td><%= o.getRunnerName() != null ? o.getRunnerName() : "-" %></td>
                            <td>
                                <span class="status-badge
                                    <%= "待接单".equals(o.getStatus()) ? "status-pending" : "" %>
                                    <%= "已接单".equals(o.getStatus()) ? "status-accepted" : "" %>
                                    <%= "配送中".equals(o.getStatus()) ? "status-delivering" : "" %>
                                    <%= "已完成".equals(o.getStatus()) ? "status-done" : "" %>
                                    <%= "已取消".equals(o.getStatus()) ? "status-cancel" : "" %>
                                "><%= o.getStatus() %></span>
                            </td>
                            <td><%= o.getCreateTime() %></td>
                            <td>
                                <a href="order?action=detail&orderId=<%= o.getId() %>" class="btn btn-default btn-sm">详情</a>
                                <% if ("待接单".equals(o.getStatus())) { %>
                                    <button class="btn btn-danger btn-sm" onclick="cancelOrder(<%= o.getId() %>)">取消</button>
                                <% } %>
                                <% if ("已完成".equals(o.getStatus()) && !commentDao.existsByOrderId(o.getId())) { %>
                                    <a href="comment.jsp?orderId=<%= o.getId() %>&runnerId=<%= o.getRunnerId() %>" class="btn btn-warning btn-sm">评价</a>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
