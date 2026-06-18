package com.campus.express.servlet;

import com.campus.express.dao.UserDao;
import com.campus.express.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/user")
public class UserServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            login(request, response);
        } else if ("register".equals(action)) {
            register(request, response);
        } else if ("checkUsername".equals(action)) {
            checkUsername(request, response);
        } else if ("logout".equals(action)) {
            logout(request, response);
        } else if ("update".equals(action)) {
            update(request, response);
        }
    }

    /**
     * 用户登录
     */
    private void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDao.login(username, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", user);
            if ("admin".equals(user.getRole())) {
                response.sendRedirect("adminIndex.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /**
     * 用户注册
     */
    private void register(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String realName = request.getParameter("realName");
        String phone = request.getParameter("phone");
        String dormitory = request.getParameter("dormitory");
        String role = request.getParameter("role");

        if (userDao.existsByUsername(username)) {
            request.setAttribute("error", "用户名已存在");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        User user = new User(username, password, realName, phone, dormitory, role);
        if (userDao.register(user)) {
            response.sendRedirect("login.jsp?msg=registerSuccess");
        } else {
            request.setAttribute("error", "注册失败，请重试");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    /**
     * AJAX 检查用户名是否可用
     */
    private void checkUsername(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();
        if (username == null || username.trim().isEmpty()) {
            out.print("");
        } else if (userDao.existsByUsername(username)) {
            out.print("exists");
        } else {
            out.print("available");
        }
    }

    /**
     * 退出登录
     */
    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        session.invalidate();
        response.sendRedirect("index.jsp");
    }

    /**
     * 更新个人信息
     */
    private void update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        loginUser.setRealName(request.getParameter("realName"));
        loginUser.setPhone(request.getParameter("phone"));
        loginUser.setDormitory(request.getParameter("dormitory"));
        String password = request.getParameter("password");
        if (password != null && !password.trim().isEmpty()) {
            loginUser.setPassword(password);
        }

        if (userDao.update(loginUser)) {
            session.setAttribute("loginUser", loginUser);
            request.setAttribute("msg", "修改成功");
        } else {
            request.setAttribute("error", "修改失败");
        }
        request.getRequestDispatcher("editUser.jsp").forward(request, response);
    }
}
