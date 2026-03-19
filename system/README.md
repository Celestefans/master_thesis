# 一体化引导式图像超分系统

这是一个用于学术论文演示的图像超分辨率系统前端原型。

## 目录结构

- `app.py`: Flask 后端入口
- `templates/`: HTML 模板
- `static/`: 静态资源 (CSS, JS, Images)

## 技术栈 (Technology Stack)

### 前端 (Frontend)
- **HTML5 / CSS3**: 页面结构与样式
- **Bootstrap 5 (v5.3.0)**: 响应式 UI 框架，用于布局、导航栏、卡片和表格
- **JavaScript (ES6+)**: 处理 DOM 操作、事件监听、模拟加载动画
- **Bootstrap Icons (v1.10.0)**: 字体图标库

### 后端 (Backend)
- **Python (v3.10+)**: 核心编程语言
- **Flask (v3.0.0)**: 轻量级 Web 应用框架
- **Jinja2**: 模板引擎，用于动态渲染 HTML

---

## 数据库设计 (Database Schema)

虽然本演示系统使用 Mock 数据（内存模拟），但在真实业务场景下，推荐使用关系型数据库（如 PostgreSQL 或 MySQL）。以下是设计的核心表结构：

### 1. 用户表 (`users`)
存储系统用户的基本信息及认证凭据。

| 字段名 | 类型 | 描述 | 备注 |
| :--- | :--- | :--- | :--- |
| `id` | INT | 用户唯一标识 | Primary Key, Auto Increment |
| `username` | VARCHAR(50) | 用户名 | Unique |
| `email` | VARCHAR(100) | 邮箱地址 | Unique |
| `password_hash` | VARCHAR(255) | 密码哈希值 | 安全存储 |
| `created_at` | TIMESTAMP | 注册时间 | Default CURRENT_TIMESTAMP |
| `last_login` | TIMESTAMP | 最后登录时间 | |

### 2. 任务批次表 (`task_batches`)
以目录为单位记录批量处理任务及其聚合状态。

| 字段名 | 类型 | 描述 | 备注 |
| :--- | :--- | :--- | :--- |
| `batch_id` | VARCHAR(64) | 批次号 | Primary Key (e.g. BATCH-20231027-001) |
| `user_id` | INT | 创建用户 | Foreign Key -> users.id |
| `source_directory` | VARCHAR(512) | 源文件目录 | 原始图像存放路径 |
| `target_directory` | VARCHAR(512) | 目标输出目录 | 处理结果存放路径 |
| `task_type` | VARCHAR(20) | 任务类型 | Enum: 'pansharpening', 'depth', 'mri' |
| `scale_factor` | VARCHAR(10) | 缩放倍率 | '2x', '4x', '8x', '16x' |
| `start_time` | DATETIME | 任务开始时间 | |
| `end_time` | DATETIME | 任务结束时间 | |
| `status` | VARCHAR(20) | 批次状态 | 'Processing', 'Completed', 'Failed', 'Partial' |
| `avg_psnr` | FLOAT | 平均PSNR | 该批次所有图片的平均指标 |
| `avg_ssim` | FLOAT | 平均SSIM | 该批次所有图片的平均指标 |

### 3. 系统日志表 (`system_logs`)
用于审计和追踪系统批量操作或异常。

| 字段名 | 类型 | 描述 | 备注 |
| :--- | :--- | :--- | :--- |
| `id` | BIGINT | 日志ID | Primary Key |
| `user_id` | INT | 操作用户 | Foreign Key -> users.id |
| `action` | VARCHAR(50) | 操作动作 | 'Login', 'Batch_Upload', 'Download' |
| `ip_address` | VARCHAR(45) | 客户端IP | |
| `timestamp` | TIMESTAMP | 发生时间 | |

---

## 运行方法

1. 安装依赖:
   ```bash
   pip install -r requirements.txt
   ```

2. 启动应用:
   ```bash
   python app.py
   ```

3. 访问: `http://127.0.0.1:5001`
