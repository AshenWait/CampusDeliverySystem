-- ============================================
-- 校园快递代取与寄件管理系统 数据库脚本
-- 数据库名：campus_express
-- ============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS campus_express DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE campus_express;

-- ============================================
-- 1. 用户表 user
-- ============================================
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS order_info;
DROP TABLE IF EXISTS notice;
DROP TABLE IF EXISTS user;

CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    real_name VARCHAR(50),
    phone VARCHAR(20),
    dormitory VARCHAR(100),
    role VARCHAR(20) NOT NULL COMMENT '用户角色：student、runner、admin',
    create_time DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================
-- 2. 订单表 order_info
-- ============================================
CREATE TABLE order_info (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL COMMENT '发布订单的学生编号',
    runner_id INT DEFAULT 0 COMMENT '接单代取员编号，0表示未接单',
    order_type VARCHAR(20) NOT NULL COMMENT '订单类型：代取、寄件',
    pickup_place VARCHAR(100) COMMENT '快递点或寄件地点',
    pickup_code VARCHAR(50) COMMENT '取件码，寄件订单可为空',
    address VARCHAR(100) COMMENT '送达地址或寄件地址',
    description TEXT COMMENT '订单描述',
    price DECIMAL(10,2) COMMENT '服务费用',
    status VARCHAR(20) NOT NULL DEFAULT '待接单' COMMENT '订单状态：待接单、已接单、配送中、已完成、已取消',
    create_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================
-- 3. 公告表 notice
-- ============================================
CREATE TABLE notice (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    content TEXT,
    create_time DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================
-- 4. 评价表 comment
-- ============================================
CREATE TABLE comment (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL COMMENT '订单编号',
    user_id INT NOT NULL COMMENT '评价用户编号',
    runner_id INT NOT NULL COMMENT '被评价代取员编号',
    score INT COMMENT '评分 1-5',
    content TEXT COMMENT '评价内容',
    create_time DATETIME,
    FOREIGN KEY (order_id) REFERENCES order_info(id),
    FOREIGN KEY (user_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================
-- 插入测试数据
-- ============================================

-- 测试用户
INSERT INTO user(username, password, real_name, phone, dormitory, role, create_time) VALUES
('admin', '123456', '系统管理员', '13800000000', '行政楼101', 'admin', NOW()),
('student', '123456', '张三', '13811111111', '北区1号楼301', 'student', NOW()),
('student2', '123456', '李四', '13822222222', '南区2号楼502', 'student', NOW()),
('runner', '123456', '王五代取员', '13833333333', '东区3号楼101', 'runner', NOW()),
('runner2', '123456', '赵六代取员', '13844444444', '西区4号楼202', 'runner', NOW());

-- 测试公告
INSERT INTO notice(title, content, create_time) VALUES
('系统上线通知', '校园快递代取与寄件管理系统正式上线！欢迎同学们使用。如有问题请联系管理员。', NOW()),
('代取服务时间调整', '即日起，代取服务时间调整为每天 9:00 - 21:00，请同学们合理安排下单时间。', NOW()),
('寄件优惠活动', '本月寄件全部享受8折优惠！快来找代取员帮忙寄件吧！', DATE_ADD(NOW(), INTERVAL -2 DAY));

-- 测试订单（student 发布的）
INSERT INTO order_info(user_id, runner_id, order_type, pickup_place, pickup_code, address, description, price, status, create_time) VALUES
(2, 0, '代取', '北门菜鸟驿站', 'ABC-1234', '北区1号楼301', '一个小包裹，请轻拿轻放', 5.00, '待接单', NOW()),
(2, 4, '代取', '南门京东快递点', 'JD-5678', '北区1号楼301', '买了一本书', 3.00, '已接单', DATE_ADD(NOW(), INTERVAL -1 HOUR)),
(2, 4, '代取', '东门顺丰快递点', 'SF-9012', '北区1号楼301', '电子产品，请小心', 8.00, '已完成', DATE_ADD(NOW(), INTERVAL -1 DAY)),
(2, 0, '寄件', '北区菜鸟驿站', '', '上海市浦东新区', '寄一些衣服回家', 10.00, '待接单', NOW()),
(3, 0, '代取', '西门邮政快递点', 'YZ-3456', '南区2号楼502', '一个快递文件', 4.00, '待接单', DATE_ADD(NOW(), INTERVAL -30 MINUTE)),
(3, 4, '寄件', '南区快递服务中心', '', '北京市海淀区', '寄送学习资料', 12.00, '配送中', DATE_ADD(NOW(), INTERVAL -2 HOUR)),
(2, 0, '代取', '北门菜鸟驿站', 'ABC-7890', '北区1号楼301', '日常用品', 5.00, '已取消', DATE_ADD(NOW(), INTERVAL -3 DAY));
