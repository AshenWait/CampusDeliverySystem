package com.campus.express.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String username;
    private String password;
    private String realName;
    private String phone;
    private String dormitory;
    private String role;
    private Timestamp createTime;

    public User() {}

    public User(String username, String password, String realName, String phone, String dormitory, String role) {
        this.username = username;
        this.password = password;
        this.realName = realName;
        this.phone = phone;
        this.dormitory = dormitory;
        this.role = role;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getRealName() { return realName; }
    public void setRealName(String realName) { this.realName = realName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getDormitory() { return dormitory; }
    public void setDormitory(String dormitory) { this.dormitory = dormitory; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public Timestamp getCreateTime() { return createTime; }
    public void setCreateTime(Timestamp createTime) { this.createTime = createTime; }
}
