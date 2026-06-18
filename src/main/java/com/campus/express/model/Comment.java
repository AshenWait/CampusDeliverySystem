package com.campus.express.model;

import java.sql.Timestamp;

public class Comment {
    private int id;
    private int orderId;
    private int userId;
    private int runnerId;
    private int score;
    private String content;
    private Timestamp createTime;

    // 联表字段
    private String userName;

    public Comment() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getRunnerId() { return runnerId; }
    public void setRunnerId(int runnerId) { this.runnerId = runnerId; }
    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Timestamp getCreateTime() { return createTime; }
    public void setCreateTime(Timestamp createTime) { this.createTime = createTime; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}
