<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campus.express.model.User" %>
<%@ page import="com.campus.express.model.Order" %>
<%@ page import="com.campus.express.dao.OrderDao" %>
<%@ page import="java.util.List" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (!"admin".equals(loginUser.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }
    OrderDao orderDao = new OrderDao();
    List<Order> orderList = orderDao.findAll();
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单管理 - 校园快递系统</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="js/main.js"></script>
</head>
<body>

<nav class="navbar">
    <div class="logo">校园快递系统 - 管理员后台</div>
    <div class="nav-links">
        <a href="index.jsp">返回首页</a>
        <span class="user-info"><%= loginUser.getRealName() %> | <a href="user?action=logout">退出</a></span>
    </div>
</nav>

<div class="main-content">
    <div class="admin-layout">
        <div class="admin-sidebar">
            <div class="sidebar-title">管理菜单</div>
            <a href="adminIndex.jsp">后台首页</a>
            <a href="userManage.jsp">用户管理</a>
            <a href="orderManage.jsp" class="active">订单管理</a>
            <a href="noticeManage.jsp">公告管理</a>
        </div>

        <div class="admin-content">
            <div class="card">
                <div class="card-title">订单管理</div>
                <% if (msg != null) { %><div class="alert alert-success"><%= msg %></div><% } %>

                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>类型</th>
                                <th>发布人</th>
                                <th>接单人</th>
                                <th>地点</th>
                                <th>费用</th>
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
                                <td><%= o.getUserName() != null ? o.getUserName() : "-" %></td>
                                <td><%= o.getRunnerName() != null ? o.getRunnerName() : "-" %></td>
                                <td><%= o.getPickupPlace() != null ? o.getPickupPlace() : "-" %></td>
                                <td>¥<%= o.getPrice() %></td>
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
                                    <select onchange="if(this.value)updateOrderStatus(<%= o.getId() %>, this.value)" style="padding:4px;font-size:12px;">
                                        <option value="">修改状态</option>
                                        <option value="待接单">待接单</option>
                                        <option value="已接单">已接单</option>
                                        <option value="配送中">配送中</option>
                                        <option value="已完成">已完成</option>
                                        <option value="已取消">已取消</option>
                                    </select>
                                    <button class="btn btn-danger btn-sm" onclick="deleteOrder(<%= o.getId() %>)">删除</button>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
