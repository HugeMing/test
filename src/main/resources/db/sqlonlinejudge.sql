/*
 Navicat Premium Data Transfer

 Source Server         : local host
 Source Server Type    : MySQL
 Source Server Version : 80028
 Source Host           : localhost:3306
 Source Schema         : sqlonlinejudge

 Target Server Type    : MySQL
 Target Server Version : 80028
 File Encoding         : 65001

 Date: 10/10/2023 09:40:17
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for data_base
-- ----------------------------
DROP TABLE IF EXISTS `data_base`;
CREATE TABLE `data_base`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '数据库ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '数据库名称',
  `create_table` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '建表语句',
  `test_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '数据插入语句',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of data_base
-- ----------------------------
INSERT INTO `data_base` VALUES (1, '公司系统', 'CREATE TABLE `dept_manager` (\n`dept_no` char(4) NOT NULL,\n`emp_no` int(11) NOT NULL,\n`from_date` date NOT NULL,\n`to_date` date NOT NULL,\nPRIMARY KEY (`emp_no`,`dept_no`));\nCREATE TABLE `employees` (\n`emp_no` int(11) NOT NULL,\n`birth_date` date NOT NULL,\n`first_name` varchar(14) NOT NULL,\n`last_name` varchar(16) NOT NULL,\n`gender` char(1) NOT NULL,\n`hire_date` date NOT NULL,\nPRIMARY KEY (`emp_no`));', 'INSERT INTO dept_manager VALUES(\'d001\',10002,\'1996-08-03\',\'9999-01-01\'); INSERT INTO dept_manager VALUES(\'d002\',10006,\'1990-08-05\',\'9999-01-01\'); INSERT INTO dept_manager VALUES(\'d003\',10005,\'1989-09-12\',\'9999-01-01\'); INSERT INTO dept_manager VALUES(\'d004\',10004,\'1986-12-01\',\'9999-01-01\'); INSERT INTO dept_manager VALUES(\'d005\',10010,\'1996-11-24\',\'2000-06-26\'); INSERT INTO dept_manager VALUES(\'d006\',10010,\'2000-06-26\',\'9999-01-01\'); INSERT INTO employees VALUES(10001,\'1953-09-02\',\'Georgi\',\'Facello\',\'M\',\'1986-06-26\'); INSERT INTO employees VALUES(10002,\'1964-06-02\',\'Bezalel\',\'Simmel\',\'F\',\'1985-11-21\'); INSERT INTO employees VALUES(10003,\'1959-12-03\',\'Parto\',\'Bamford\',\'M\',\'1986-08-28\'); INSERT INTO employees VALUES(10004,\'1954-05-01\',\'Chirstian\',\'Koblick\',\'M\',\'1986-12-01\'); INSERT INTO employees VALUES(10005,\'1955-01-21\',\'Kyoichi\',\'Maliniak\',\'M\',\'1989-09-12\'); INSERT INTO employees VALUES(10006,\'1953-04-20\',\'Anneke\',\'Preusig\',\'F\',\'1989-06-02\'); INSERT INTO employees VALUES(10007,\'1957-05-23\',\'Tzvetan\',\'Zielinski\',\'F\',\'1989-02-10\'); INSERT INTO employees VALUES(10008,\'1958-02-19\',\'Saniya\',\'Kalloufi\',\'M\',\'1994-09-15\'); INSERT INTO employees VALUES(10009,\'1952-04-19\',\'Sumant\',\'Peac\',\'F\',\'1985-02-18\'); INSERT INTO employees VALUES(10010,\'1963-06-01\',\'Duangkaew\',\'Piveteau\',\'F\',\'1989-08-24\'); INSERT INTO employees VALUES(10011,\'1953-11-07\',\'Mary\',\'Sluis\',\'F\',\'1990-01-22\');');

-- ----------------------------
-- Table structure for problem_categories
-- ----------------------------
DROP TABLE IF EXISTS `problem_categories`;
CREATE TABLE `problem_categories`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `start_time` datetime(0) NULL DEFAULT NULL,
  `end_time` datetime(0) NULL DEFAULT NULL,
  `view_after_end` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of problem_categories
-- ----------------------------
INSERT INTO `problem_categories` VALUES (1, '16级 1', '2021-01-01 00:00:00', '2023-02-01 00:00:00', b'1');
INSERT INTO `problem_categories` VALUES (2, '16级 2', '2022-01-01 00:00:00', '2023-02-01 00:00:00', b'1');

-- ----------------------------
-- Table structure for problem_category_permission
-- ----------------------------
DROP TABLE IF EXISTS `problem_category_permission`;
CREATE TABLE `problem_category_permission`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `problem_category_id` int(0) NOT NULL,
  `user_group_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_problem_category_id`(`problem_category_id`) USING BTREE,
  INDEX `FK_user_group_id`(`user_group_id`) USING BTREE,
  CONSTRAINT `FK_problem_category_id` FOREIGN KEY (`problem_category_id`) REFERENCES `problem_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_user_group_id` FOREIGN KEY (`user_group_id`) REFERENCES `sys_user_groups` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '关联题目集ID和用户组ID' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of problem_category_permission
-- ----------------------------
INSERT INTO `problem_category_permission` VALUES (2, 2, 1);
INSERT INTO `problem_category_permission` VALUES (3, 1, 1);

-- ----------------------------
-- Table structure for problem_collections
-- ----------------------------
DROP TABLE IF EXISTS `problem_collections`;
CREATE TABLE `problem_collections`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `category_id` int(0) NOT NULL COMMENT '题目集ID',
  `problem_id` int(0) NOT NULL COMMENT '题目ID',
  `problem_submit` int(0) NOT NULL DEFAULT 0 COMMENT '题目提交数',
  `problem_solved` int(0) NOT NULL DEFAULT 0 COMMENT '题目通过数',
  `problem_score` int(0) NOT NULL DEFAULT 0 COMMENT '题目分值',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `category_id`(`category_id`) USING BTREE,
  INDEX `problem_id`(`problem_id`) USING BTREE,
  CONSTRAINT `problem_collections_ibfk_2` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `problem_collections_ibfk_3` FOREIGN KEY (`category_id`) REFERENCES `problem_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of problem_collections
-- ----------------------------
INSERT INTO `problem_collections` VALUES (1, 1, 1, 8, 8, 0);
INSERT INTO `problem_collections` VALUES (2, 1, 2, 12, 8, 0);
INSERT INTO `problem_collections` VALUES (3, 2, 2, 16, 9, 0);
INSERT INTO `problem_collections` VALUES (4, 2, 3, 14, 6, 0);
INSERT INTO `problem_collections` VALUES (5, 2, 4, 2, 1, 0);

-- ----------------------------
-- Table structure for problems
-- ----------------------------
DROP TABLE IF EXISTS `problems`;
CREATE TABLE `problems`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '题目ID',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '题目标题',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '题目描述',
  `sample_output` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '样例输出',
  `hint` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '提示',
  `answer` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '答案',
  `true_result` tinytext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '正确输出',
  `difficulty` tinyint(0) NOT NULL DEFAULT 1 COMMENT '题目难度',
  `is_update` bit(1) NOT NULL DEFAULT b'0' COMMENT '题目是否是Update/Delete等会对表中记录进行修改的题目',
  `select_after_update` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'Update类题目执行完之后对修改部分的Select语句，用于比对修改的结果是否正确',
  `database_id` int(0) NOT NULL DEFAULT 0 COMMENT '数据库ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_problem_database`(`database_id`) USING BTREE,
  CONSTRAINT `problems_ibfk_1` FOREIGN KEY (`database_id`) REFERENCES `data_base` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of problems
-- ----------------------------
INSERT INTO `problems` VALUES (1, '获取所有非manager的员工emp_no', '获取所有非manager的员工emp_no', '', '', 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', 'E70D8D6AA53A9AF17093C2B01BF2A386', 1, b'0', NULL, 1);
INSERT INTO `problems` VALUES (2, '查找employees表', '查找employees表所有emp_no为奇数，且last_name不为Mary的员工信息，并按照hire_date逆序排列', '', '', 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc', 'CF5A78656EBA8C87F885D99FFC057173', 1, b'0', NULL, 1);
INSERT INTO `problems` VALUES (3, '查找所有员工信息', '<p>查找所有员工信息</p>', '', '', 'SELECT * FROM employees;', '67B0A41F7309B5D1CFB5FAC7786C39FF', 1, b'0', NULL, 1);
INSERT INTO `problems` VALUES (4, '删除Mary', '<p>删除Mary</p>', '', '', 'DELETE FROM employees WHERE first_name=\'Mary\';', 'D751713988987E9331980363E24189CE', 1, b'1', 'SELECT * from employees;', 1);

-- ----------------------------
-- Table structure for solutions
-- ----------------------------
DROP TABLE IF EXISTS `solutions`;
CREATE TABLE `solutions`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '解答ID',
  `uid` int(0) NOT NULL COMMENT '用户ID',
  `pid` int(0) NOT NULL COMMENT '题目ID',
  `pcid` int(0) NOT NULL DEFAULT 1 COMMENT '题目集ID',
  `source_code` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '源代码',
  `submit_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '提交时间',
  `run_error` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '错误信息',
  `result` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结果',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE,
  INDEX `FK_solutions_problem_categories`(`pcid`) USING BTREE,
  CONSTRAINT `FK_solutions_problem_categories` FOREIGN KEY (`pcid`) REFERENCES `problem_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `solutions_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `sys_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `solutions_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `problems` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 135 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of solutions
-- ----------------------------
INSERT INTO `solutions` VALUES (1, 1, 1, 1, 'SELECT * FROM dept_manager', '2019-10-09 09:41:52', NULL, '3');
INSERT INTO `solutions` VALUES (2, 1, 1, 1, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'\norder by hire_date desc', '2019-10-09 09:48:59', NULL, '3');
INSERT INTO `solutions` VALUES (3, 1, 2, 1, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'\norder by hire_date desc', '2019-10-09 09:49:26', NULL, '1');
INSERT INTO `solutions` VALUES (4, 1, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2019-10-09 09:49:43', NULL, '1');
INSERT INTO `solutions` VALUES (5, 1, 1, 1, 'ffff', '2019-10-09 10:04:40', 'near \"ffff\": syntax error', '2');
INSERT INTO `solutions` VALUES (6, 4, 1, 1, 'SELECT * FROM employees;', '2021-11-30 11:29:48', NULL, '4');
INSERT INTO `solutions` VALUES (7, 4, 2, 1, 'SELECT * FROM employees;', '2021-11-30 11:40:27', NULL, '4');
INSERT INTO `solutions` VALUES (8, 4, 2, 1, 'SELECT * FROM employees;', '2021-11-30 11:49:52', NULL, '4');
INSERT INTO `solutions` VALUES (9, 4, 2, 1, 'SELECT * FROM employees;', '2021-11-30 11:51:59', NULL, '4');
INSERT INTO `solutions` VALUES (10, 4, 2, 1, 'SELECT * FROM employees;', '2021-11-30 11:52:00', NULL, '4');
INSERT INTO `solutions` VALUES (11, 4, 2, 1, 'SELECT * FROM employees;', '2021-11-30 11:52:38', NULL, '4');
INSERT INTO `solutions` VALUES (12, 4, 2, 1, 'SELECT * FROM employees;', '2021-11-30 13:43:16', NULL, '4');
INSERT INTO `solutions` VALUES (13, 4, 2, 1, 'SELECT * FROM employees;', '2021-11-30 13:44:41', NULL, '3');
INSERT INTO `solutions` VALUES (14, 4, 2, 1, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc;', '2021-11-30 13:45:21', NULL, '1');
INSERT INTO `solutions` VALUES (15, 4, 2, 1, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc;', '2021-11-30 13:45:36', NULL, '1');
INSERT INTO `solutions` VALUES (16, 4, 1, 1, 'SELECT * FROM employees;', '2021-11-30 13:47:30', NULL, '3');
INSERT INTO `solutions` VALUES (17, 4, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2021-11-30 13:47:34', NULL, '1');
INSERT INTO `solutions` VALUES (18, 4, 2, 1, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc', '2021-11-30 13:48:50', NULL, '1');
INSERT INTO `solutions` VALUES (19, 4, 2, 1, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date', '2021-11-30 13:49:04', NULL, '3');
INSERT INTO `solutions` VALUES (20, 4, 2, 1, 'select * from employees where last_name != \'Mary\' and emp_no % 2 = 1 order by hire_date desc', '2021-11-30 13:49:36', NULL, '1');
INSERT INTO `solutions` VALUES (21, 4, 2, 2, 'select * from employees where last_name != \'Mary\' and emp_no % 2 = 1 order by hire_date desc', '2021-11-30 14:13:43', NULL, '1');
INSERT INTO `solutions` VALUES (22, 4, 2, 1, 'select * from employees where last_name != \'Mary\' and emp_no % 2 = 1 order by hire_date desc', '2021-11-30 18:57:10', NULL, '1');
INSERT INTO `solutions` VALUES (23, 4, 2, 1, 'select * from employees where last_name != \'Mary\' and emp_no % 2 = 1 order by hire_date desc', '2021-11-30 18:57:16', NULL, '1');
INSERT INTO `solutions` VALUES (24, 4, 2, 1, 'select * from employees where last_name != \'Mary\' and emp_no % 2 = 1 order by hire_date desc', '2021-11-30 19:11:02', NULL, '1');
INSERT INTO `solutions` VALUES (25, 4, 2, 1, 'select * from employees where last_name != \'Mary\' and emp_no % 2 = 1 order by hire_date desc', '2021-11-30 19:13:39', NULL, '1');
INSERT INTO `solutions` VALUES (26, 4, 2, 1, 'select * from employees where last_name != \'Mary\' and emp_no % 2 = 1 order by hire_date desc', '2021-11-30 19:15:37', NULL, '1');
INSERT INTO `solutions` VALUES (27, 4, 2, 1, 'select * from employees where last_name != \'Mary\' and emp_no % 2 = 1 order by hire_date desc', '2021-11-30 19:21:01', NULL, '1');
INSERT INTO `solutions` VALUES (28, 4, 2, 1, 'select * from employees where last_name != \'Mary\' and emp_no % 2 = 1 order by hire_date desc', '2021-11-30 19:30:18', NULL, '1');
INSERT INTO `solutions` VALUES (29, 4, 2, 1, 'select * from employees where last_name != \'Mary\' and emp_no % 2 = 1 order by hire_date desc', '2021-11-30 19:35:48', NULL, '1');
INSERT INTO `solutions` VALUES (30, 4, 2, 2, 'select * from employees where last_name != \'Mary\' and emp_no % 2 = 1 order by hire_date desc', '2021-11-30 19:41:36', NULL, '1');
INSERT INTO `solutions` VALUES (31, 4, 2, 2, 'select * from employees where last_name != \'Mary\' and emp_no % 2 = 1 order by hire_date desc', '2021-11-30 19:51:05', NULL, '1');
INSERT INTO `solutions` VALUES (32, 4, 3, 2, 'SELECT * FROM employees;', '2021-12-01 08:59:14', NULL, '1');
INSERT INTO `solutions` VALUES (33, 4, 2, 2, 'select * from employees where last_name != \'Mary\' and emp_no % 2 = 1 order by hire_date desc', '2021-12-01 09:54:08', NULL, '1');
INSERT INTO `solutions` VALUES (34, 4, 3, 2, 'SELECT * FROM employees;', '2021-12-01 09:54:22', NULL, '1');
INSERT INTO `solutions` VALUES (35, 4, 2, 2, 'select * from employees where emp_no % 2 = 1 order by hire_date desc', '2021-12-01 09:54:35', NULL, '1');
INSERT INTO `solutions` VALUES (36, 4, 2, 2, 'select * from employees where emp_no % 2 = 1 order by hire_date desc', '2021-12-01 09:54:53', NULL, '1');
INSERT INTO `solutions` VALUES (37, 4, 2, 2, 'select * from employees', '2021-12-01 09:55:05', NULL, '3');
INSERT INTO `solutions` VALUES (38, 4, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2021-12-01 09:55:22', NULL, '1');
INSERT INTO `solutions` VALUES (39, 4, 3, 2, 'SELECT first_name FROM employees;', '2021-12-01 09:57:13', NULL, '3');
INSERT INTO `solutions` VALUES (40, 4, 2, 1, 'select * from employees where last_name != \'Mary\' order by hire_date desc', '2021-12-01 09:57:56', NULL, '3');
INSERT INTO `solutions` VALUES (41, 4, 2, 2, 'select * from employees', '2021-12-01 11:26:21', NULL, '3');
INSERT INTO `solutions` VALUES (42, 4, 2, 2, 'select * from employees', '2021-12-01 11:38:17', NULL, '4');
INSERT INTO `solutions` VALUES (43, 4, 3, 2, 'SELECT first_name FROM employees;', '2021-12-01 11:39:16', NULL, '4');
INSERT INTO `solutions` VALUES (44, 4, 3, 2, 'SELECT * FROM employees;', '2021-12-01 11:39:37', NULL, '4');
INSERT INTO `solutions` VALUES (45, 4, 3, 2, 'SELECT * FROM employees;', '2021-12-01 11:42:23', NULL, '4');
INSERT INTO `solutions` VALUES (46, 4, 3, 2, 'SELECT * FROM employees;', '2021-12-01 11:45:35', NULL, '4');
INSERT INTO `solutions` VALUES (47, 4, 3, 2, 'SELECT * FROM employees;', '2021-12-01 17:54:13', NULL, '1');
INSERT INTO `solutions` VALUES (48, 4, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2021-12-01 17:54:41', NULL, '1');
INSERT INTO `solutions` VALUES (49, 4, 2, 1, 'select * from employees where last_name != \'Mary\' order by hire_date desc', '2021-12-01 17:54:47', NULL, '3');
INSERT INTO `solutions` VALUES (50, 4, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2021-12-01 17:54:56', NULL, '1');
INSERT INTO `solutions` VALUES (51, 4, 2, 1, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc', '2021-12-01 17:56:31', NULL, '1');
INSERT INTO `solutions` VALUES (52, 4, 2, 2, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc', '2021-12-01 17:56:39', NULL, '1');
INSERT INTO `solutions` VALUES (53, 4, 3, 2, 'SELECT first_name FROM employees;', '2021-12-01 17:58:27', NULL, '3');
INSERT INTO `solutions` VALUES (54, 4, 2, 1, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc', '2021-12-01 19:30:01', NULL, '1');
INSERT INTO `solutions` VALUES (55, 4, 2, 1, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc', '2021-12-01 19:30:03', NULL, '1');
INSERT INTO `solutions` VALUES (56, 4, 2, 2, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc', '2021-12-01 19:30:28', NULL, '1');
INSERT INTO `solutions` VALUES (57, 4, 2, 1, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc', '2021-12-01 19:31:17', NULL, '1');
INSERT INTO `solutions` VALUES (58, 4, 2, 2, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc', '2021-12-01 19:31:23', NULL, '1');
INSERT INTO `solutions` VALUES (59, 4, 2, 1, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc', '2021-12-01 19:31:53', NULL, '1');
INSERT INTO `solutions` VALUES (60, 4, 3, 2, 'SELECT first_name FROM employees;', '2021-12-02 18:16:26', NULL, '3');
INSERT INTO `solutions` VALUES (61, 4, 3, 2, 'SELECT first_name FROM employees;', '2021-12-02 18:16:41', NULL, '3');
INSERT INTO `solutions` VALUES (62, 4, 2, 2, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc', '2021-12-06 17:14:40', NULL, '1');
INSERT INTO `solutions` VALUES (63, 4, 2, 1, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc', '2021-12-29 08:37:22', NULL, '1');
INSERT INTO `solutions` VALUES (101, 4, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2022-04-23 22:05:55', NULL, '1');
INSERT INTO `solutions` VALUES (102, 4, 2, 2, 'select * from employees where emp_no % 2 = 1 and last_name != \'Mary\'order by hire_date desc', '2022-04-23 22:06:19', NULL, '1');
INSERT INTO `solutions` VALUES (103, 4, 2, 2, 'select * from employees where emp_no % 2 = 0 and last_name != \'Mary\'order by hire_date desc', '2022-04-23 22:06:35', NULL, '3');
INSERT INTO `solutions` VALUES (104, 4, 2, 2, 'select * froemployees where emp_no % 2 = 0 and last_name != \'Mary\'order by hire_date desc', '2022-04-23 22:06:43', 'near \"froemployees\": syntax error', '2');
INSERT INTO `solutions` VALUES (105, 4, 2, 1, 'select * from employees where emp_no % 2 !=0 and last_name != \'Mary\'order by hire_date desc', '2022-04-23 22:13:08', NULL, '1');
INSERT INTO `solutions` VALUES (106, 5, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2022-04-23 22:16:29', NULL, '4');
INSERT INTO `solutions` VALUES (107, 4, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2022-04-23 22:16:30', NULL, '1');
INSERT INTO `solutions` VALUES (108, 5, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2022-04-23 22:16:45', NULL, '4');
INSERT INTO `solutions` VALUES (109, 5, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2022-04-23 22:19:42', NULL, '4');
INSERT INTO `solutions` VALUES (110, 5, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2022-04-23 22:23:02', NULL, '4');
INSERT INTO `solutions` VALUES (111, 5, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2022-04-23 22:27:23', NULL, '1');
INSERT INTO `solutions` VALUES (112, 5, 2, 1, 'SELECT * FROM employees', '2022-04-23 22:28:29', NULL, '3');
INSERT INTO `solutions` VALUES (113, 5, 2, 1, 'SELECT * FROM employees', '2022-04-23 22:28:38', NULL, '3');
INSERT INTO `solutions` VALUES (114, 5, 3, 2, 'SELECT * FROM employees', '2022-04-23 22:29:18', NULL, '1');
INSERT INTO `solutions` VALUES (115, 5, 2, 2, 'select * from employees where emp_no % 2 = 0 and last_name != \'Mary\'order by hire_date desc', '2022-04-23 22:30:16', NULL, '3');
INSERT INTO `solutions` VALUES (116, 5, 2, 2, 'select * from employees where emp_no % 2 != 0 and last_name != \'Mary\'order by hire_date desc', '2022-04-23 22:30:24', NULL, '1');
INSERT INTO `solutions` VALUES (121, 4, 4, 2, 'DELETE FROM employees WHERE first_name=\'Mary\'', '2022-05-02 14:42:58', NULL, '3');
INSERT INTO `solutions` VALUES (122, 4, 4, 2, 'DELETE FROM employees WHERE first_name=\'Mary\';', '2022-05-02 14:43:28', NULL, '1');
INSERT INTO `solutions` VALUES (123, 4, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2022-09-30 14:45:47', NULL, '1');
INSERT INTO `solutions` VALUES (124, 4, 1, 1, 'select emp_no from employees where not exists(select 1 from dept_manager where employees.emp_no = dept_manager.emp_no)', '2023-10-05 10:52:33', NULL, '1');
INSERT INTO `solutions` VALUES (125, 4, 3, 2, 'SELECT first_name FROM employees;', '2023-10-05 10:52:47', NULL, '3');
INSERT INTO `solutions` VALUES (126, 4, 3, 2, 'SELECT * FROM employees;', '2023-10-05 10:53:00', NULL, '1');
INSERT INTO `solutions` VALUES (127, 4, 2, 1, 'select * from employees where emp_no % 2 !=0 and last_name != \'Mary\'order by hire_date desc', '2023-10-06 12:23:42', NULL, '1');
INSERT INTO `solutions` VALUES (128, 4, 3, 2, 'SELECT * FROM employees;', '2023-10-06 12:25:54', NULL, '1');
INSERT INTO `solutions` VALUES (129, 4, 3, 2, 'SELECT gender FROM employees;', '2023-10-06 12:26:22', NULL, '3');
INSERT INTO `solutions` VALUES (130, 545, 3, 2, 'SELECT * from employees;', '2023-10-06 12:29:36', NULL, '1');
INSERT INTO `solutions` VALUES (131, 545, 2, 2, 'SELECT * FROM employees;', '2023-10-06 12:48:22', NULL, '3');
INSERT INTO `solutions` VALUES (132, 545, 2, 2, 'SELECT * FROM employees;', '2023-10-06 12:52:14', NULL, '3');
INSERT INTO `solutions` VALUES (133, 4, 3, 2, 'SELECT gender FROM employees;', '2023-10-10 09:37:22', NULL, '3');
INSERT INTO `solutions` VALUES (134, 4, 3, 2, 'SELECT gender FROM employees;', '2023-10-10 09:39:04', NULL, '3');

-- ----------------------------
-- Table structure for sys_admin_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_admin_role`;
CREATE TABLE `sys_admin_role`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '管理员角色ID',
  `a_id` int(0) NOT NULL DEFAULT 0 COMMENT '管理员ID',
  `r_id` int(0) NOT NULL DEFAULT 0 COMMENT '角色ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `a_id`(`a_id`) USING BTREE,
  INDEX `r_id`(`r_id`) USING BTREE,
  CONSTRAINT `sys_admin_role_ibfk_1` FOREIGN KEY (`a_id`) REFERENCES `sys_administrators` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `sys_admin_role_ibfk_2` FOREIGN KEY (`r_id`) REFERENCES `sys_roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sys_admin_role
-- ----------------------------
INSERT INTO `sys_admin_role` VALUES (1, 1, 1);
INSERT INTO `sys_admin_role` VALUES (2, 2, 2);
INSERT INTO `sys_admin_role` VALUES (3, 4, 2);
INSERT INTO `sys_admin_role` VALUES (4, 5, 2);

-- ----------------------------
-- Table structure for sys_administrators
-- ----------------------------
DROP TABLE IF EXISTS `sys_administrators`;
CREATE TABLE `sys_administrators`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '管理员ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '管理员名称\r\n',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '管理员密码',
  `salt` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '盐',
  `status` bit(1) NULL DEFAULT b'1' COMMENT '管理员状态',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sys_administrators
-- ----------------------------
INSERT INTO `sys_administrators` VALUES (1, 'admin', '8315af46b6d38ebdaec05ec05393edd3', 'NOOQnVyN2NI2GD4q/V28', b'1');
INSERT INTO `sys_administrators` VALUES (2, 'sgh', '7078553a2476e9c86ea74234145febef', 'yK5o/VZdWdpJplm+5VVt', b'1');
INSERT INTO `sys_administrators` VALUES (4, 'xdh', '5e831f34f03ac6512acac21206af848c', 's4cqIwFmuoC0OJejOQRB', b'1');
INSERT INTO `sys_administrators` VALUES (5, 'ljq', 'a5e601133d00af2637b71b739e28b9ed', 'l4jipX7kVnrYr1xZhn8L', b'1');

-- ----------------------------
-- Table structure for sys_permissions
-- ----------------------------
DROP TABLE IF EXISTS `sys_permissions`;
CREATE TABLE `sys_permissions`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '权限名称',
  `permission` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '权限详情',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sys_permissions
-- ----------------------------
INSERT INTO `sys_permissions` VALUES (1, '总权限', '*:*');

-- ----------------------------
-- Table structure for sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '角色权限ID',
  `r_id` int(0) NOT NULL DEFAULT 0 COMMENT '角色ID',
  `p_id` int(0) NOT NULL DEFAULT 0 COMMENT '权限ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `r_id`(`r_id`) USING BTREE,
  INDEX `p_id`(`p_id`) USING BTREE,
  CONSTRAINT `sys_role_permission_ibfk_1` FOREIGN KEY (`r_id`) REFERENCES `sys_roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `sys_role_permission_ibfk_2` FOREIGN KEY (`p_id`) REFERENCES `sys_permissions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sys_role_permission
-- ----------------------------
INSERT INTO `sys_role_permission` VALUES (1, 1, 1);

-- ----------------------------
-- Table structure for sys_roles
-- ----------------------------
DROP TABLE IF EXISTS `sys_roles`;
CREATE TABLE `sys_roles`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '角色名',
  `description` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '角色描述',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_name`(`role_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sys_roles
-- ----------------------------
INSERT INTO `sys_roles` VALUES (1, 'admin', '总管理员');
INSERT INTO `sys_roles` VALUES (2, 'teacher', '教师');

-- ----------------------------
-- Table structure for sys_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_groups`;
CREATE TABLE `sys_user_groups`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '用户组ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户组名称',
  PRIMARY KEY (`id`, `name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_groups
-- ----------------------------
INSERT INTO `sys_user_groups` VALUES (1, '计算1614');
INSERT INTO `sys_user_groups` VALUES (66, '2140中队');

-- ----------------------------
-- Table structure for sys_users
-- ----------------------------
DROP TABLE IF EXISTS `sys_users`;
CREATE TABLE `sys_users`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '用户名',
  `student_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '学号',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '邮箱地址',
  `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `salt` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码盐',
  `avatar` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'default.jpg' COMMENT '头像',
  `status` bit(1) NOT NULL DEFAULT b'1' COMMENT '状态,0未激活，1正常，2锁定',
  `group_id` int(0) NULL DEFAULT NULL COMMENT '用户组ID',
  `is_admin` int(0) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE,
  INDEX `group_id`(`group_id`) USING BTREE,
  CONSTRAINT `sys_users_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `sys_user_groups` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 546 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sys_users
-- ----------------------------
INSERT INTO `sys_users` VALUES (1, 'user_sgh', '201621121110', 'sgh@qq.com', '7078553a2476e9c86ea74234145febef', 'yK5o/VZdWdpJplm+5VVt', 'default.jpg', b'1', 1, 1);
INSERT INTO `sys_users` VALUES (2, 'user_xdh', '201621121101', 'xdh@qq.com', 'c51f9c7eba223c36a9e79aef5dbe3dd1', 'stFp0Nc4hYuiLaiN2aNe', 'default.jpg', b'1', 1, 1);
INSERT INTO `sys_users` VALUES (3, 'user_ljq', '201621121108', 'ljq@qq.com', 'd1abfc1dcd61244bed23b54ad3e67142', 'u5EUoEIF0yerJVoQLye8', 'default.jpg', b'1', 1, 1);
INSERT INTO `sys_users` VALUES (4, 'test', '2011456', '1570114789@qq.com', '3e55d7e21c51e2036668c8e0e284458e', 'kY2itgMcqcV7qwXWrsva', 'default.jpg', b'1', 1, 1);
INSERT INTO `sys_users` VALUES (5, 'wwm', '2002', '12@qq.com', '1d09eac285bb81aff475db0cb9c4d5f4', 'CxUmU3FsUkaiWbMEwq3n', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (494, '蒋嘉怡', '20010404', '20010404@ncu.edu.cn', 'a6c3efc65f567d66cac281381f076d65', 'c5QLrXgF5whYyfZQHtZD', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (495, '肖亚轩', '20030605', '20030605@ncu.edu.cn', '64488ddc01c75795a834a38bceb1f78e', 'CvGO9LJ1M4trz8z9tN2q', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (496, '毛佳画', '20030916', '20030916@ncu.edu.cn', '4533d5354328432ab815e38b0f6f9921', 'sbUtDdRdRunXXxSxYHnq', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (497, '杨语', '20030505', '20030505@ncu.edu.cn', '2cd5194e17318763f87e947daff63791', '/i3LCDdgHH6EEDskOOQ5', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (498, '曹佳怡', '20040219', '20040219@ncu.edu.cn', 'bf0f46fc0bda7a3ce7f73a14d7c7861f', 'sI+C2NrCrcYwuvF8KKf1', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (499, '李欣', '20030509', '20030509@ncu.edu.cn', 'e1c96ea6c3ac65f1f9e9083397eae793', '98Ya+OmQ/i0Zj7GTg2xs', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (500, '孟心熠', '20030818', '20030818@ncu.edu.cn', 'e3becc93278f8cec210a0c50be4fd238', 'FQKjp475IsXHvaryHftF', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (501, '李佳芸', '20021021', '20021021@ncu.edu.cn', 'a227edb2b6863a2b6b0c9107093c59d0', 'nK8VFYYRrzaup4QPgpYs', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (502, '吴伟珍', '20030808', '20030808@ncu.edu.cn', '6d3c1ba336445ef6f9eb017aaae5f091', 'Fe7DXLeNS7sO03XNKwrc', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (503, '陈芳芳', '20021116', '20021116@ncu.edu.cn', '43ae76a003ee9a2ca68edf04a80cf1cf', 'KS+5dZ9ntjfZFbSUmAus', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (504, '陈梦阳', '20030114', '20030114@ncu.edu.cn', '42a62404481dd4bfb434da590658b629', 'La8x4Mp9/wwXn2ZlkWxZ', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (505, '张永强', '20010814', '20010814@ncu.edu.cn', '8ec8ebe88a0154e66a8a31ab5e5672fc', '3+ujuqeHhBYvVsx0naaJ', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (506, '谢裕鑫', '20011023', '20011023@ncu.edu.cn', '51ad3bd1629086f31c9d92a578226b7a', 'pQfvt78K2tTnxR/06SFg', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (507, '胡方诚', '20031015', '20031015@ncu.edu.cn', 'fb1cc1ecb5801087a01a2842ff13b322', 'NTlW1qWseoixvQgR22RC', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (508, '杨常星', '20010320', '20010320@ncu.edu.cn', '57fb4466aa8a7b0d286338217c7d914b', '+1fDmj0Lk1+ERY/cA/lQ', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (509, '刘建波', '20020812', '20020812@ncu.edu.cn', 'd95a0d3f99044b657c643d34923c33ea', 'MOLIKpnlgLor4fA3j9be', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (510, '刘郁翔', '20021229', '20021229@ncu.edu.cn', '92dc3db031a9aa4b1727fef1fcf6e0d1', 'cOvUHwVcpGqClHhIkXSe', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (511, '谌天祥', '20021006', '20021006@ncu.edu.cn', 'bef7302db2842acfc498bd3bf6ff0ed7', 'bcUj3O9Fmoz/QJqy678S', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (512, '余扬帆', '20030208', '20030208@ncu.edu.cn', '8977a12140506d1212bb4c692fbf67fb', 'wMsm2UL0PNPDpqtdS4a+', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (513, '欧阳松恒', '20030608', '20030608@ncu.edu.cn', '1b5a4879af7985fa287dbbe18525b202', 'JVgCnPE+E5DI9Gxtl0GA', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (514, '苏钰杰', '20021213', '20021213@ncu.edu.cn', 'ae9bfdcc198711e298f1305759469df0', 'Ln8jAju3lK5tD6yNgh5s', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (515, '刘翰林', '20010729', '20010729@ncu.edu.cn', 'a3d59e4c41928b2a99af77a0b77cd7cc', 'uR6MHfjnxCOKCaUboShH', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (516, '袁国锋', '20020211', '20020211@ncu.edu.cn', '929cb4e688bc0392a390df9775413910', 'eOWAiGNMyLKhfXQ+M6Ne', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (517, '江立楠', '20021225', '20021225@ncu.edu.cn', 'efca9dfcbdf6cc3fdda0a4c0d02d08b3', 'L4eTvjwGbkgVLZgfsjiY', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (518, '施智超', '20030823', '20030823@ncu.edu.cn', '978e1cb390ecefbcfd3ae0c45d9b444e', 'c5XRe2k+kSanrn+pwwN8', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (519, '王加康', '20020629', '20020629@ncu.edu.cn', '3a0f31c710ced3466c2e90e16b12f5e4', 'XSS7ist15iXicKQc8YLN', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (520, '戴立强', '20030302', '20030302@ncu.edu.cn', 'e2c4c64ab1f5524cbd50db655ff1e931', 'fsZjqwvS3er5DOdX2Gd2', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (521, '刘相甫', '20031211', '20031211@ncu.edu.cn', '1da389c5c324e8b30ef1043370664f0a', 'OFLYTLZuSbRuto9FUbyT', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (522, '曾佳彪', '20030301', '20030301@ncu.edu.cn', 'aac6f6b4b6ded34835543474fdae7a83', '1nEgRkni3+l7aDe1DJJ5', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (523, '余乐', '20020527', '20020527@ncu.edu.cn', '2feeb146c1c92965af83ce8ead52841e', 'GJAMvdNzrVBz2FfdAdmW', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (524, '余晓波', '20030327', '20030327@ncu.edu.cn', '15f4721a66042e2b42aa35d9d3f27fdb', 'MNEEezAqA8gSgLfmdzGm', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (525, '吴飞扬', '20030714', '20030714@ncu.edu.cn', 'e1cf904d3744e13f260fc89619b6411f', 'rjguH17VtJ4Plyk8/z+c', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (526, '曹钟霖', '20020415', '20020415@ncu.edu.cn', '8b3e89b821b9cc065643d8d991e7281b', 'jGWvxQRBl129mGk0QE4V', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (527, '陈洪杰', '20021115', '20021115@ncu.edu.cn', '570453cc1828cfe31983186fca3d0815', 'z8gwsyxMtJBIZAjzIaqa', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (528, '郑昊火', '20031029', '20031029@ncu.edu.cn', '81047ac159f2fe8d7f6689f05850bc99', 'pEqCv3co1n9uHzFYQ2aU', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (529, '涂文龙', '20030504', '20030504@ncu.edu.cn', '38dd8bb293cc68d921396552bd3da334', 'PQGEok8MTo1MQzPY/WOS', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (530, '陈弘宇', '20030421', '20030421@ncu.edu.cn', 'f246cc2521821d7f23295fb0af2a9622', 'Ev642Qawbi5gHjbHxtK3', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (531, '戴仕豪', '20030824', '20030824@ncu.edu.cn', '93801ed3bc3b4e0c764200a553d9a173', '9UtrP7wvWhCbHkWswXZR', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (532, '刘彰平', '20020822', '20020822@ncu.edu.cn', 'b25375bba55db56f784d3ec4526d23d1', 'v4zoow4nfObcQxzH5ajP', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (533, '胡康华', '20021125', '20021125@ncu.edu.cn', '03eefc4bef9d3612be2ddd40d84089ab', 'YFacITAABez1ZgjvGpQS', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (534, '葛祎鹏', '20020503', '20020503@ncu.edu.cn', 'dfbfa1ea98b398e73bf5b40ac400f522', 'YrKKT3kzJ2NZHsQXGvyA', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (535, '许航浩', '20020125', '20020125@ncu.edu.cn', '6c1fa31e34078846b26e29b577396488', 'Br2xZNAmupc5RYP3+534', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (536, '肖传富', '20010807', '20010807@ncu.edu.cn', '7903011550b9800bc1f51c3cd9690a03', 'JToj1PfQbqtlNPMjWLn9', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (537, '华万磊', '20030211', '20030211@ncu.edu.cn', 'a4948a3f2467ecd1ab0220d5fab01883', '0qU/SkWLJc+AJZx2PKdc', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (538, '徐铨裕', '20031105', '20031105@ncu.edu.cn', '93143764fe7c9c390e472f13232c15c1', 'zG/e1n6mNGeJxXNM4NuD', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (539, '罗承志', '20000825', '20000825@ncu.edu.cn', 'a4afcae1b10f097ae26af272d9f9ea1b', 'QkctM0MXEqHt+HP13Aip', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (540, '黄炜发', '20010223', '20010223@ncu.edu.cn', 'ddcc1e73f2f4cd31590aff767404fd9d', 'JLNW3oNAESS5h1TLiNS3', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (541, '徐鸿斌', '20021114', '20021114@ncu.edu.cn', '440e8a4fdaec41619b80bb8cb7026d76', '6Q6KTCAoq8dD4VtqMq+2', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (542, '林俊杰', '20020706', '20020706@ncu.edu.cn', '68c6a57679a36a405611c9b77059dcaa', 'Gi6eZ521CMB11WJ1InrB', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (543, '王明远', '20030404', '20030404@ncu.edu.cn', 'af8b9f95cabb83ecff8e048d9e6ff010', 'h2nyaM/OezvzfrvCGBRw', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (544, '方毓凯', '20021224', '20021224@ncu.edu.cn', '8da224d8edeeb46c4ec799b8e590ea50', '0gZ3kQAs6qWhpCmytD00', 'default.jpg', b'1', NULL, 1);
INSERT INTO `sys_users` VALUES (545, 'root', '123456', '1234@qq.com', 'c934373c130bf65574a1720f89901924', 'dD997FIUtQjFCKcS9eWh', 'default.jpg', b'1', NULL, 1);

-- ----------------------------
-- Table structure for upload_images
-- ----------------------------
DROP TABLE IF EXISTS `upload_images`;
CREATE TABLE `upload_images`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `filename` tinytext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `uid` int(0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK__sys_user`(`uid`) USING BTREE,
  CONSTRAINT `FK__sys_user` FOREIGN KEY (`uid`) REFERENCES `sys_administrators` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of upload_images
-- ----------------------------

-- ----------------------------
-- Table structure for user_group_collections
-- ----------------------------
DROP TABLE IF EXISTS `user_group_collections`;
CREATE TABLE `user_group_collections`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL DEFAULT 0,
  `user_group_id` int(0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK__sys_users`(`user_id`) USING BTREE,
  INDEX `FK__sys_user_groups`(`user_group_id`) USING BTREE,
  CONSTRAINT `FK__sys_user_groups` FOREIGN KEY (`user_group_id`) REFERENCES `sys_user_groups` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK__sys_users` FOREIGN KEY (`user_id`) REFERENCES `sys_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 312 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_group_collections
-- ----------------------------
INSERT INTO `user_group_collections` VALUES (2, 4, 1);
INSERT INTO `user_group_collections` VALUES (262, 494, 66);
INSERT INTO `user_group_collections` VALUES (263, 495, 66);
INSERT INTO `user_group_collections` VALUES (264, 496, 66);
INSERT INTO `user_group_collections` VALUES (265, 497, 66);
INSERT INTO `user_group_collections` VALUES (266, 498, 66);
INSERT INTO `user_group_collections` VALUES (267, 499, 66);
INSERT INTO `user_group_collections` VALUES (268, 500, 66);
INSERT INTO `user_group_collections` VALUES (269, 501, 66);
INSERT INTO `user_group_collections` VALUES (270, 502, 66);
INSERT INTO `user_group_collections` VALUES (271, 503, 66);
INSERT INTO `user_group_collections` VALUES (272, 504, 66);
INSERT INTO `user_group_collections` VALUES (273, 505, 66);
INSERT INTO `user_group_collections` VALUES (274, 506, 66);
INSERT INTO `user_group_collections` VALUES (275, 507, 66);
INSERT INTO `user_group_collections` VALUES (276, 508, 66);
INSERT INTO `user_group_collections` VALUES (277, 509, 66);
INSERT INTO `user_group_collections` VALUES (278, 510, 66);
INSERT INTO `user_group_collections` VALUES (279, 511, 66);
INSERT INTO `user_group_collections` VALUES (280, 512, 66);
INSERT INTO `user_group_collections` VALUES (281, 513, 66);
INSERT INTO `user_group_collections` VALUES (282, 514, 66);
INSERT INTO `user_group_collections` VALUES (283, 515, 66);
INSERT INTO `user_group_collections` VALUES (284, 516, 66);
INSERT INTO `user_group_collections` VALUES (285, 517, 66);
INSERT INTO `user_group_collections` VALUES (286, 518, 66);
INSERT INTO `user_group_collections` VALUES (287, 519, 66);
INSERT INTO `user_group_collections` VALUES (288, 520, 66);
INSERT INTO `user_group_collections` VALUES (289, 521, 66);
INSERT INTO `user_group_collections` VALUES (290, 522, 66);
INSERT INTO `user_group_collections` VALUES (291, 523, 66);
INSERT INTO `user_group_collections` VALUES (292, 524, 66);
INSERT INTO `user_group_collections` VALUES (293, 525, 66);
INSERT INTO `user_group_collections` VALUES (294, 526, 66);
INSERT INTO `user_group_collections` VALUES (295, 527, 66);
INSERT INTO `user_group_collections` VALUES (296, 528, 66);
INSERT INTO `user_group_collections` VALUES (297, 529, 66);
INSERT INTO `user_group_collections` VALUES (298, 530, 66);
INSERT INTO `user_group_collections` VALUES (299, 531, 66);
INSERT INTO `user_group_collections` VALUES (300, 532, 66);
INSERT INTO `user_group_collections` VALUES (301, 533, 66);
INSERT INTO `user_group_collections` VALUES (302, 534, 66);
INSERT INTO `user_group_collections` VALUES (303, 535, 66);
INSERT INTO `user_group_collections` VALUES (304, 536, 66);
INSERT INTO `user_group_collections` VALUES (305, 537, 66);
INSERT INTO `user_group_collections` VALUES (306, 538, 66);
INSERT INTO `user_group_collections` VALUES (307, 539, 66);
INSERT INTO `user_group_collections` VALUES (308, 540, 66);
INSERT INTO `user_group_collections` VALUES (309, 541, 66);
INSERT INTO `user_group_collections` VALUES (310, 542, 66);
INSERT INTO `user_group_collections` VALUES (311, 543, 66);
INSERT INTO `user_group_collections` VALUES (312, 544, 66);

-- ----------------------------
-- Table structure for user_problems
-- ----------------------------
DROP TABLE IF EXISTS `user_problems`;
CREATE TABLE `user_problems`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '用户题库ID',
  `uid` int(0) NOT NULL COMMENT '用户ID',
  `pcid` int(0) NOT NULL DEFAULT 10 COMMENT '濡増顭囧ú浼存⒖閸滅瘚',
  `pid` int(0) NOT NULL COMMENT '题目ID',
  `passed` bit(1) NOT NULL COMMENT '用户题目状态（是否通过）',
  `submit` int(0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE,
  INDEX `FK_user_problems_problem_categories`(`pcid`) USING BTREE,
  CONSTRAINT `user_problems_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `sys_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `user_problems_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `problems` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of user_problems
-- ----------------------------
INSERT INTO `user_problems` VALUES (1, 1, 1, 1, b'1', 1);
INSERT INTO `user_problems` VALUES (2, 1, 2, 2, b'1', 12);
INSERT INTO `user_problems` VALUES (8, 4, 1, 2, b'1', 16);
INSERT INTO `user_problems` VALUES (9, 4, 1, 1, b'1', 6);
INSERT INTO `user_problems` VALUES (10, 4, 2, 3, b'1', 10);
INSERT INTO `user_problems` VALUES (11, 5, 1, 1, b'1', 1);
INSERT INTO `user_problems` VALUES (12, 5, 2, 2, b'1', 4);
INSERT INTO `user_problems` VALUES (13, 5, 2, 3, b'1', 1);
INSERT INTO `user_problems` VALUES (14, 4, 2, 4, b'1', 2);
INSERT INTO `user_problems` VALUES (15, 545, 2, 3, b'1', 1);
INSERT INTO `user_problems` VALUES (16, 545, 2, 2, b'0', 2);

SET FOREIGN_KEY_CHECKS = 1;
