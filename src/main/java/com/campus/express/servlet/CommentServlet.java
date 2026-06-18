package com.campus.express.servlet;

import com.campus.express.dao.CommentDao;
import com.campus.express.model.Comment;
import com.campus.express.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/comment")
public class CommentServlet extends HttpServlet {

    private CommentDao commentDao = new CommentDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            add(request, response);
        }
    }

    /**
     * 添加评价
     */
    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        int runnerId = Integer.parseInt(request.getParameter("runnerId"));
        int score = Integer.parseInt(request.getParameter("score"));
        String content = request.getParameter("content");

        // 检查是否已经评价过（一个订单只允许评价一次）
        if (commentDao.existsByOrderId(orderId)) {
            request.setAttribute("error", "该订单已经评价过了，不能重复评价");
            request.getRequestDispatcher("myOrders.jsp").forward(request, response);
            return;
        }

        Comment comment = new Comment();
        comment.setOrderId(orderId);
        comment.setUserId(loginUser.getId());
        comment.setRunnerId(runnerId);
        comment.setScore(score);
        comment.setContent(content);

        if (commentDao.add(comment)) {
            response.sendRedirect("myOrders.jsp?msg=评价成功，感谢您的反馈！");
        } else {
            request.setAttribute("error", "评价失败，请重试");
            request.getRequestDispatcher("myOrders.jsp").forward(request, response);
        }
    }
}
