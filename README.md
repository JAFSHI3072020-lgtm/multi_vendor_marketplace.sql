# 🛒 Multi-Vendor SaaS Marketplace with Warehouse & Returns System

## 📌 Project Overview

This project is a database design and implementation of a **Multi-Vendor SaaS Marketplace** system.  
It supports vendor subscriptions, warehouse management, product variations, stock tracking, orders, payments, and return management.

The system is designed using:

- ERD (Entity Relationship Diagram)
- Relational Schema
- SQL (DDL, DML, DQL, Advanced Queries)

---

## 🚀 Features

### 👤 Vendor Management
- Vendor registration
- Subscription plan management
- Revenue tracking
- Account status control

### 🏬 Warehouse Management
- Multiple warehouses per vendor
- Stock tracking per warehouse
- Capacity management

### 📦 Product Management
- Products belong to one vendor
- Multiple product variations (Size, Color)
- SKU unique constraint
- Category support (M:N relationship)

### 🛍 Order Management
- Multiple items per order
- Order status tracking
- Payment (1:1 relationship)
- Return request system

---

## 🗂 Database Modules

- SubscriptionPlan
- Vendor
- Warehouse
- Product
- ProductVariation
- Category
- ProductCategory
- Customer
- Orders
- OrderItem
- Payment
- ReturnRequest
- WarehouseStock

---

## 🧩 ERD Design

The ERD diagram includes:

- Primary Keys (PK)
- Foreign Keys (FK)
- 1:1 relationships
- 1:N relationships
- M:N relationships using junction tables

📎 ERD file included in repository.

---

## 🛠 Technologies Used

- MySQL
- SQL
- DBML (for ERD design)
- VS Code

---

## 📜 SQL Implementation

The SQL file includes:

- Table creation (DDL)
- Data insertion (DML)
- Update and Delete operations
- Query operations (DQL)
- Advanced SQL (CTE, Ranking, Aggregation)

---

## 📊 Advanced Queries Implemented

- Total revenue per vendor
- Top 5 best-selling product variations
- Monthly sales summary
- Vendors exceeding product listing limit
- Vendor ranking using CTE

---

## 🎯 Learning Outcomes

- Database normalization
- ERD design
- Relational schema conversion
- Foreign key relationships
- Composite primary keys
- Query optimization
- Real-world marketplace modeling

---

## 👩‍💻 Author

**Shimu (CSE Student)**  
Computer Science & Engineering  
IUBAT  

---

## 📌 How to Use

1. Import the SQL file into MySQL.
2. Execute the script.
3. Run queries to test functionality.

---

## ⭐ License

This project is for academic and learning purposes.
