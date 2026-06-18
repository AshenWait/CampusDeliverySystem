<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campus.express.model.User" %>
<%@ page import="com.campus.express.dao.NoticeDao" %>
<%@ page import="com.campus.express.model.Notice" %>
<%@ page import="java.util.List" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    NoticeDao noticeDao = new NoticeDao();
    List<Notice> noticeList = noticeDao.findLatest(5);

    // 网站访问量统计（application内置对象）
    Integer count = (Integer) application.getAttribute("visitCount");
    if (count == null) {
        count = 1;
    } else {
        count = count + 1;
    }
    application.setAttribute("visitCount", count);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园快递代取与寄件管理系统</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- 顶部导航栏 -->
<nav class="navbar">
    <div class="logo">校园快递系统</div>
    <div class="nav-links">
        <a href="index.jsp">首页</a>
        <a href="notice?action=list">公告</a>
        <a href="order?action=hall">订单大厅</a>
        <% if (loginUser != null) { %>
            <% if ("student".equals(loginUser.getRole())) { %>
                <a href="addPickupOrder.jsp">发布代取</a>
                <a href="addSendOrder.jsp">发布寄件</a>
                <a href="order?action=myOrders">我的订单</a>
                <a href="userCenter.jsp">个人中心</a>
            <% } else if ("runner".equals(loginUser.getRole())) { %>
                <a href="order?action=myReceive">我的接单</a>
                <a href="userCenter.jsp">个人中心</a>
            <% } else if ("admin".equals(loginUser.getRole())) { %>
                <a href="adminIndex.jsp">后台管理</a>
                <a href="userCenter.jsp">个人中心</a>
            <% } %>
            <span class="user-info"><%= loginUser.getRealName() %>，你好 | <a href="user?action=logout">退出</a></span>
        <% } else { %>
            <a href="login.jsp">登录</a>
            <a href="register.jsp">注册</a>
        <% } %>
    </div>
</nav>

<!-- 主内容区 -->
<div class="main-content">

    <!-- 欢迎区 -->
    <div class="hero">
        <h1>校园快递代取与寄件管理系统</h1>
        <p>让快递代取更便捷，让校园生活更轻松</p>
    </div>

    <!-- 快捷入口 -->
    <% if (loginUser != null && "student".equals(loginUser.getRole())) { %>
    <div class="quick-links">
        <a href="addPickupOrder.jsp" class="quick-link">发布代取订单</a>
        <a href="addSendOrder.jsp" class="quick-link">发布寄件订单</a>
        <a href="order?action=myOrders" class="quick-link">查看我的订单</a>
        <a href="order?action=hall" class="quick-link">浏览订单大厅</a>
        <a href="notice?action=list" class="quick-link">查看系统公告</a>
    </div>
    <% } else if (loginUser != null && "runner".equals(loginUser.getRole())) { %>
    <div class="quick-links">
        <a href="order?action=hall" class="quick-link">进入订单大厅</a>
        <a href="order?action=myReceive" class="quick-link">查看我的接单</a>
        <a href="notice?action=list" class="quick-link">查看系统公告</a>
    </div>
    <% } else if (loginUser == null) { %>
    <div class="quick-links">
        <a href="login.jsp" class="quick-link">用户登录</a>
        <a href="register.jsp" class="quick-link">新用户注册</a>
        <a href="order?action=hall" class="quick-link">浏览订单大厅</a>
        <a href="notice?action=list" class="quick-link">查看系统公告</a>
    </div>
    <% } %>

    <!-- 功能特色 -->
    <div class="card">
        <div class="card-title">功能特色</div>
        <div class="features">
            <div class="feature-item">
                <div class="icon">📦</div>
                <h3>快递代取</h3>
                <p>发布代取需求，由代取员帮您取快递送达宿舍</p>
            </div>
            <div class="feature-item">
                <div class="icon">📮</div>
                <h3>快递寄件</h3>
                <p>发布寄件需求，代取员上门取件帮您寄出</p>
            </div>
            <div class="feature-item">
                <div class="icon">🏃</div>
                <h3>代取员接单</h3>
                <p>代取员在订单大厅实时查看并接单</p>
            </div>
            <div class="feature-item">
                <div class="icon">⭐</div>
                <h3>服务评价</h3>
                <p>完成订单后对代取员的服务进行评价</p>
            </div>
        </div>
    </div>

    <!-- 最新公告 -->
    <div class="card">
        <div class="card-title">最新公告</div>
        <% if (noticeList != null && !noticeList.isEmpty()) { %>
            <% for (Notice notice : noticeList) { %>
                <div style="padding: 10px 0; border-bottom: 1px solid #f5f5f5;">
                    <strong><%= notice.getTitle() %></strong>
                    <span style="color: #999; font-size: 12px; margin-left: 10px;"><%= notice.getCreateTime() %></span>
                    <p style="color: #666; font-size: 14px; margin-top: 4px;"><%= notice.getContent() %></p>
                </div>
            <% } %>
        <% } else { %>
            <p style="color: #999;">暂无公告</p>
        <% } %>
    </div>

    <!-- 访问统计 -->
    <div class="text-center" style="color: #999; font-size: 12px; padding: 10px;">
        网站总访问量：<%= application.getAttribute("visitCount") %>
    </div>

</div>

<!-- 页脚 -->
<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026 | 课程设计项目</p>
</div>

</body>
</html>
