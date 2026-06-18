package com.campus.express.servlet;

import com.campus.express.dao.UserDao;
import com.campus.express.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || !"admin".equals(loginUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("deleteUser".equals(action)) {
            deleteUser(request, response);
        }
    }

    /**
     * 删除用户（AJAX）：先检查是否有订单，有则拒绝删除
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        int userId = Integer.parseInt(request.getParameter("userId"));
        User target = userDao.findById(userId);

        if (target == null) {
            out.print("fail:用户不存在");
            return;
        }
        if ("admin".equals(target.getRole())) {
            out.print("fail:不能删除管理员");
            return;
        }
        if (userDao.hasOrders(userId)) {
            out.print("fail:该用户存在订单记录，无法删除");
            return;
        }
        if (userDao.delete(userId)) {
            out.print("success");
        } else {
            out.print("fail:删除失败");
        }
    }
}
