package com.campus.express.dao;

import com.campus.express.model.Comment;
import com.campus.express.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDao {

    // 添加评价
    public boolean add(Comment comment) {
        String sql = "INSERT INTO comment(order_id, user_id, runner_id, score, content, create_time) VALUES(?,?,?,?,?,NOW())";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, comment.getOrderId());
            pstmt.setInt(2, comment.getUserId());
            pstmt.setInt(3, comment.getRunnerId());
            pstmt.setInt(4, comment.getScore());
            pstmt.setString(5, comment.getContent());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    // 检查订单是否已评价
    public boolean existsByOrderId(int orderId) {
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

    // 根据订单ID查询评价
    public Comment findByOrderId(int orderId) {
        String sql = "SELECT c.*, u.real_name AS user_name FROM comment c LEFT JOIN user u ON c.user_id=u.id WHERE c.order_id=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rowToComment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return null;
    }

    private Comment rowToComment(ResultSet rs) throws SQLException {
        Comment c = new Comment();
        c.setId(rs.getInt("id"));
        c.setOrderId(rs.getInt("order_id"));
        c.setUserId(rs.getInt("user_id"));
        c.setRunnerId(rs.getInt("runner_id"));
        c.setScore(rs.getInt("score"));
        c.setContent(rs.getString("content"));
        c.setCreateTime(rs.getTimestamp("create_time"));
        try { c.setUserName(rs.getString("user_name")); } catch (SQLException e) {}
        return c;
    }
}
