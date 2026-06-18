<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campus.express.model.User" %>
<%@ page import="com.campus.express.model.Notice" %>
<%@ page import="com.campus.express.dao.NoticeDao" %>
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
    NoticeDao noticeDao = new NoticeDao();
    List<Notice> noticeList = noticeDao.findAll();
    String msg = request.getParameter("msg");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告管理 - 校园快递系统</title>
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
            <a href="orderManage.jsp">订单管理</a>
            <a href="noticeManage.jsp" class="active">公告管理</a>
        </div>

        <div class="admin-content">
            <!-- 添加公告 -->
            <div class="card">
                <div class="card-title">发布新公告</div>
                <% if (msg != null) { %><div class="alert alert-success"><%= msg %></div><% } %>
                <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>
                <form action="notice" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="form-group">
                        <label>公告标题</label>
                        <input type="text" name="title" class="form-control" required placeholder="请输入公告标题">
                    </div>
                    <div class="form-group">
                        <label>公告内容</label>
                        <textarea name="content" class="form-control" rows="3" required placeholder="请输入公告内容"></textarea>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">发布公告</button>
                    </div>
                </form>
            </div>

            <!-- 公告列表 -->
            <div class="card">
                <div class="card-title">公告列表</div>
                <% if (noticeList == null || noticeList.isEmpty()) { %>
                    <p style="color:#999;">暂无公告</p>
                <% } else { %>
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>标题</th>
                                    <th>内容</th>
                                    <th>发布时间</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Notice n : noticeList) { %>
                                <tr>
                                    <td><%= n.getId() %></td>
                                    <td><%= n.getTitle() %></td>
                                    <td><%= n.getContent().length() > 30 ? n.getContent().substring(0, 30) + "..." : n.getContent() %></td>
                                    <td><%= n.getCreateTime() %></td>
                                    <td>
                                        <button class="btn btn-warning btn-sm" onclick="showEditNotice(<%= n.getId() %>, '<%= n.getTitle() %>', '<%= n.getContent().replace("'", "\\'") %>')">修改</button>
                                        <button class="btn btn-danger btn-sm" onclick="deleteNotice(<%= n.getId() %>)">删除</button>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- 修改公告弹窗 -->
<div id="editModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:2000; justify-content:center; align-items:center;">
    <div style="background:#fff; border-radius:8px; padding:30px; width:500px; max-width:90%;">
        <h3 style="margin-bottom:20px;">修改公告</h3>
        <form action="notice" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="editId">
            <div class="form-group">
                <label>标题</label>
                <input type="text" name="title" id="editTitle" class="form-control" required>
            </div>
            <div class="form-group">
                <label>内容</label>
                <textarea name="content" id="editContent" class="form-control" rows="4" required></textarea>
            </div>
            <div class="form-group">
                <button type="submit" class="btn btn-primary">保存修改</button>
                <button type="button" class="btn btn-default" onclick="document.getElementById('editModal').style.display='none'">取消</button>
            </div>
        </form>
    </div>
</div>

<script>
function showEditNotice(id, title, content) {
    document.getElementById('editId').value = id;
    document.getElementById('editTitle').value = title;
    document.getElementById('editContent').value = content;
    document.getElementById('editModal').style.display = 'flex';
}
</script>

<div class="footer">
    <p>校园快递代取与寄件管理系统 &copy; 2026</p>
</div>

</body>
</html>
