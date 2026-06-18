package com.campus.express.dao;

import com.campus.express.model.Order;
import com.campus.express.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {

    /** 订单状态常量 */
    public static final String STATUS_PENDING    = "待接单";
    public static final String STATUS_ACCEPTED   = "已接单";
    public static final String STATUS_DELIVERING = "配送中";
    public static final String STATUS_DONE       = "已完成";
    public static final String STATUS_CANCEL     = "已取消";

    /**
     * 添加代取订单
     */
    public boolean addPickupOrder(Order order) {
        String sql = "INSERT INTO order_info(user_id, order_type, pickup_place, pickup_code, address, description, price, status, create_time) VALUES(?,?,?,?,?,?,?,?,NOW())";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, order.getUserId());
            pstmt.setString(2, order.getOrderType());
            pstmt.setString(3, order.getPickupPlace());
            pstmt.setString(4, order.getPickupCode());
            pstmt.setString(5, order.getAddress());
            pstmt.setString(6, order.getDescription());
            pstmt.setBigDecimal(7, order.getPrice());
            pstmt.setString(8, order.getStatus());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    /**
     * 添加寄件订单
     */
    public boolean addSendOrder(Order order) {
        String sql = "INSERT INTO order_info(user_id, order_type, pickup_place, address, description, price, status, create_time) VALUES(?,?,?,?,?,?,?,NOW())";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, order.getUserId());
            pstmt.setString(2, order.getOrderType());
            pstmt.setString(3, order.getPickupPlace());
            pstmt.setString(4, order.getAddress());
            pstmt.setString(5, order.getDescription());
            pstmt.setBigDecimal(6, order.getPrice());
            pstmt.setString(7, order.getStatus());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    /**
     * 查询订单大厅（所有待接单的订单）
     */
    public List<Order> findHallOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.real_name AS user_name FROM order_info o LEFT JOIN user u ON o.user_id=u.id WHERE o.status='待接单' ORDER BY o.create_time DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(rowToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return list;
    }

    /**
     * 查询某用户发布的所有订单
     */
    public List<Order> findByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.real_name AS runner_name FROM order_info o LEFT JOIN user u ON o.runner_id=u.id WHERE o.user_id=? ORDER BY o.create_time DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(rowToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return list;
    }

    /**
     * 查询代取员接到的所有订单
     */
    public List<Order> findByRunnerId(int runnerId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.real_name AS user_name FROM order_info o LEFT JOIN user u ON o.user_id=u.id WHERE o.runner_id=? ORDER BY o.create_time DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, runnerId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(rowToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return list;
    }

    /**
     * 根据ID查询订单详情（含发布人和接单人姓名）
     */
    public Order findById(int id) {
        String sql = "SELECT o.*, u1.real_name AS user_name, u2.real_name AS runner_name FROM order_info o LEFT JOIN user u1 ON o.user_id=u1.id LEFT JOIN user u2 ON o.runner_id=u2.id WHERE o.id=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rowToOrder(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return null;
    }

    /**
     * 查询所有订单（管理员用）
     */
    public List<Order> findAll() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u1.real_name AS user_name, u2.real_name AS runner_name FROM order_info o LEFT JOIN user u1 ON o.user_id=u1.id LEFT JOIN user u2 ON o.runner_id=u2.id ORDER BY o.create_time DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(rowToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return list;
    }

    /**
     * 代取员接单
     */
    public boolean receiveOrder(int orderId, int runnerId) {
        String sql = "UPDATE order_info SET runner_id=?, status='已接单' WHERE id=? AND status='待接单'";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, runnerId);
            pstmt.setInt(2, orderId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    /**
     * 更新订单状态（只接受合法的状态值）
     */
    public boolean updateStatus(int orderId, String status) {
        // 校验状态是否合法
        if (!STATUS_PENDING.equals(status) && !STATUS_ACCEPTED.equals(status)
                && !STATUS_DELIVERING.equals(status) && !STATUS_DONE.equals(status)
                && !STATUS_CANCEL.equals(status)) {
            return false;
        }
        String sql = "UPDATE order_info SET status=? WHERE id=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    /**
     * 取消订单（仅待接单状态可取消）
     */
    public boolean cancelOrder(int orderId, int userId) {
        String sql = "UPDATE order_info SET status='已取消' WHERE id=? AND user_id=? AND status='待接单'";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    /**
     * 检查订单是否存在评价
     */
    public boolean hasComment(int orderId) {
        String sql = "SELECT COUNT(*) FROM comment WHERE order_id=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return false;
    }

    /**
     * 删除订单（管理员用：如果存在评价则先删评价再删订单）
     */
    public int deleteWithCheck(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 先删除关联的评价
            pstmt = conn.prepareStatement("DELETE FROM comment WHERE order_id=?");
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            pstmt.close();

            // 再删除订单
            pstmt = conn.prepareStatement("DELETE FROM order_info WHERE id=?");
            pstmt.setInt(1, id);
            int result = pstmt.executeUpdate();

            conn.commit();
            return result;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return 0;
    }

    private Order rowToOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setRunnerId(rs.getInt("runner_id"));
        o.setOrderType(rs.getString("order_type"));
        o.setPickupPlace(rs.getString("pickup_place"));
        o.setPickupCode(rs.getString("pickup_code"));
        o.setAddress(rs.getString("address"));
        o.setDescription(rs.getString("description"));
        o.setPrice(rs.getBigDecimal("price"));
        o.setStatus(rs.getString("status"));
        o.setCreateTime(rs.getTimestamp("create_time"));
        try { o.setUserName(rs.getString("user_name")); } catch (SQLException e) {}
        try { o.setRunnerName(rs.getString("runner_name")); } catch (SQLException e) {}
        return o;
    }
}
