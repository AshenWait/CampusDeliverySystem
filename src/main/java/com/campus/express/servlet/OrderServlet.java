package com.campus.express.servlet;

import com.campus.express.dao.OrderDao;
import com.campus.express.model.Order;
import com.campus.express.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    private OrderDao orderDao = new OrderDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("addPickup".equals(action)) {
            addPickup(request, response);
        } else if ("addSend".equals(action)) {
            addSend(request, response);
        } else if ("hall".equals(action)) {
            hall(request, response);
        } else if ("detail".equals(action)) {
            detail(request, response);
        } else if ("receive".equals(action)) {
            receive(request, response);
        } else if ("myOrders".equals(action)) {
            myOrders(request, response);
        } else if ("myReceive".equals(action)) {
            myReceive(request, response);
        } else if ("cancel".equals(action)) {
            cancel(request, response);
        } else if ("updateStatus".equals(action)) {
            updateStatus(request, response);
        } else if ("delete".equals(action)) {
            delete(request, response);
        }
    }

    /**
     * 发布代取订单
     */
    private void addPickup(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) { response.sendRedirect("login.jsp"); return; }
        if (!"student".equals(loginUser.getRole())) { response.sendRedirect("index.jsp"); return; }

        Order order = new Order();
        order.setUserId(loginUser.getId());
        order.setOrderType("代取");
        order.setPickupPlace(request.getParameter("pickupPlace"));
        order.setPickupCode(request.getParameter("pickupCode"));
        order.setAddress(request.getParameter("address"));
        order.setDescription(request.getParameter("description"));
        order.setPrice(new BigDecimal(request.getParameter("price")));
        order.setStatus(OrderDao.STATUS_PENDING);

        if (orderDao.addPickupOrder(order)) {
            response.sendRedirect("myOrders.jsp?msg=发布成功");
        } else {
            request.setAttribute("error", "发布失败");
            request.getRequestDispatcher("addPickupOrder.jsp").forward(request, response);
        }
    }

    /**
     * 发布寄件订单
     */
    private void addSend(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) { response.sendRedirect("login.jsp"); return; }
        if (!"student".equals(loginUser.getRole())) { response.sendRedirect("index.jsp"); return; }

        Order order = new Order();
        order.setUserId(loginUser.getId());
        order.setOrderType("寄件");
        order.setPickupPlace(request.getParameter("pickupPlace"));
        order.setAddress(request.getParameter("address"));
        order.setDescription(request.getParameter("description"));
        order.setPrice(new BigDecimal(request.getParameter("price")));
        order.setStatus(OrderDao.STATUS_PENDING);

        if (orderDao.addSendOrder(order)) {
            response.sendRedirect("myOrders.jsp?msg=发布成功");
        } else {
            request.setAttribute("error", "发布失败");
            request.getRequestDispatcher("addSendOrder.jsp").forward(request, response);
        }
    }

    /**
     * 订单大厅
     */
    private void hall(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) { response.sendRedirect("login.jsp"); return; }

        List<Order> orderList = orderDao.findHallOrders();
        request.setAttribute("orderList", orderList);
        request.getRequestDispatcher("orderHall.jsp").forward(request, response);
    }

    /**
     * 订单详情
     */
    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        Order order = orderDao.findById(orderId);
        if (order != null) {
            request.setAttribute("order", order);
            request.getRequestDispatcher("orderDetail.jsp").forward(request, response);
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    /**
     * AJAX 异步接单
     */
    private void receive(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (loginUser == null || !"runner".equals(loginUser.getRole())) {
            out.print("fail");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        if (orderDao.receiveOrder(orderId, loginUser.getId())) {
            out.print("success");
        } else {
            out.print("fail");
        }
    }

    /**
     * 我的订单
     */
    private void myOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) { response.sendRedirect("login.jsp"); return; }

        List<Order> orderList = orderDao.findByUserId(loginUser.getId());
        request.setAttribute("orderList", orderList);
        request.getRequestDispatcher("myOrders.jsp").forward(request, response);
    }

    /**
     * 我的接单
     */
    private void myReceive(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) { response.sendRedirect("login.jsp"); return; }

        List<Order> orderList = orderDao.findByRunnerId(loginUser.getId());
        request.setAttribute("orderList", orderList);
        request.getRequestDispatcher("myReceiveOrders.jsp").forward(request, response);
    }

    /**
     * 取消订单
     */
    private void cancel(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) { response.sendRedirect("login.jsp"); return; }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        if (orderDao.cancelOrder(orderId, loginUser.getId())) {
            response.sendRedirect("myOrders.jsp?msg=取消成功");
        } else {
            response.sendRedirect("myOrders.jsp?error=取消失败");
        }
    }

    /**
     * 更新订单状态（普通请求 + AJAX均可）
     */
    private void updateStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) { response.sendRedirect("login.jsp"); return; }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");
        String role = loginUser.getRole();
        boolean ok = false;

        if ("runner".equals(role)) {
            Order order = orderDao.findById(orderId);
            if (order != null && order.getRunnerId() == loginUser.getId()) {
                ok = orderDao.updateStatus(orderId, status);
            }
        } else if ("admin".equals(role)) {
            ok = orderDao.updateStatus(orderId, status);
        }

        if (ok) {
            String ref = request.getHeader("Referer");
            if (ref != null) {
                response.sendRedirect(ref);
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            response.sendRedirect("index.jsp?error=操作失败");
        }
    }

    /**
     * AJAX 删除订单（管理员）：若有评价则级联删除
     */
    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (loginUser == null || !"admin".equals(loginUser.getRole())) {
            out.print("fail:无权限");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        int rows = orderDao.deleteWithCheck(orderId);
        if (rows > 0) {
            out.print("success");
        } else {
            out.print("fail:删除失败");
        }
    }
}
