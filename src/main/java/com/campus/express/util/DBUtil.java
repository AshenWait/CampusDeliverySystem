package com.campus.express.util;

import java.sql.*;

public class DBUtil {
    // ✅ 请根据你的MySQL配置修改以下信息
    // Docker 中的 MySQL 通过 host.docker.internal 连接
    private static final String URL = "jdbc:mysql://localhost:3306/campus_express?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "123456";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC驱动加载失败，请检查pom.xml中mysql-connector依赖", e);
        }
    }

    /**
     * 获取数据库连接
     * @throws SQLException 连接失败时抛出异常
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }
}
