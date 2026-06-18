package com.campus.express.servlet;

import com.campus.express.dao.NoticeDao;
import com.campus.express.model.Notice;
import com.campus.express.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/notice")
public class NoticeServlet extends HttpServlet {

    private NoticeDao noticeDao = new NoticeDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            add(request, response);
        } else if ("update".equals(action)) {
            update(request, response);
        } else if ("delete".equals(action)) {
            delete(request, response);
        } else if ("list".equals(action)) {
            list(request, response);
        }
    }

    /**
     * 添加公告（管理员）
     */
    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || !"admin".equals(loginUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        Notice notice = new Notice(title, content);

        if (noticeDao.add(notice)) {
            response.sendRedirect("noticeManage.jsp?msg=添加成功");
        } else {
            request.setAttribute("error", "添加失败");
            request.getRequestDispatcher("noticeManage.jsp").forward(request, response);
        }
    }

    /**
     * 更新公告（管理员）
     */
    private void update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || !"admin".equals(loginUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        Notice notice = new Notice(title, content);
        notice.setId(id);

        if (noticeDao.update(notice)) {
            response.sendRedirect("noticeManage.jsp?msg=修改成功");
        } else {
            request.setAttribute("error", "修改失败");
            request.getRequestDispatcher("noticeManage.jsp").forward(request, response);
        }
    }

    /**
     * 删除公告（管理员）
     */
    private void delete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || !"admin".equals(loginUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        noticeDao.delete(id);
        response.sendRedirect("noticeManage.jsp?msg=删除成功");
    }

    /**
     * 公告列表（所有用户可查看）
     */
    private void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Notice> noticeList = noticeDao.findAll();
        request.setAttribute("noticeList", noticeList);
        request.getRequestDispatcher("noticeList.jsp").forward(request, response);
    }
}
