# 🍔 Foodify - Online Food Delivery System

## 🎥 [Project Demonstration](https://drive.google.com/file/d/1Q3R1ix7Jb9jlIptPyTWZYmIMXn2WI2gm/view?usp=drive_link)

> A Java Full Stack Food Delivery Web Application built using Java, JSP, Servlets, JDBC, MySQL, HTML, CSS, Bootstrap 5, and JavaScript.

---

## 📖 How It Works

Foodify is a Java-based full-stack online food delivery web application that connects **Customers**, **Restaurant Owners**, **Delivery Partners**, and **Administrators** through a single platform.

Customers can register and log in securely to browse restaurants, explore food items, add meals to their cart, and place orders. Restaurant owners manage their menus and update order statuses, while delivery partners handle deliveries and update delivery progress. Administrators manage users, restaurants, and monitor the overall system.

The application is built using **Java, JSP, Servlets, JDBC, MySQL, HTML, CSS (Bootstrap 5), and JavaScript**, with secure session management and **BCrypt password encryption**.

---

## ✨ Features

### 👤 Customer

* User Registration & Login
* Login using Username or Email
* Browse Restaurants
* Search Food Items
* Filter & Sort Restaurants
* View Food Details
* Add to Cart
* Update Cart Quantity
* Remove Cart Items
* Place Orders
* View Order History
* Track Order Status
* Manage Profile

### 🍽️ Restaurant Owner

* Secure Login
* Restaurant Dashboard
* Manage Food Categories
* Add Food Items
* Update Food Items
* Delete Food Items
* View Customer Orders
* Accept / Reject Orders
* Update Order Status

### 🚴 Delivery Partner

* Secure Login
* Delivery Dashboard
* View Assigned Orders
* Accept Deliveries
* Update Delivery Status
* Complete Deliveries
* Track Earnings

### 🛡️ Administrator

* Secure Login
* Admin Dashboard
* Approve Restaurant Registrations
* Manage Customers
* Manage Restaurant Owners
* Manage Delivery Partners
* Monitor Orders
* View Platform Statistics

### 🔒 Security

* BCrypt Password Encryption
* Session Management
* Secure Logout
* Custom Error Handling Pages

---

## 🏠 Home Page

The landing page provides quick access to:

* 🍔 Browse Restaurants
* 🔍 Search Food
* 🍽️ Explore Categories
* 🔑 Login
* 📝 Register

---

## 📝 Registration

New users can register by entering:

* Username
* Email
* First Name
* Last Name
* Mobile Number
* Password

Role-specific information:

**Restaurant Owner**

* Restaurant Name
* Restaurant Address

**Delivery Partner**

* Driving License Number

All user details are validated before being securely stored in the MySQL database.

---

## 🔐 Login

Users can log in using:

* Username or Email
* Password

Supported Roles:

* 👤 Customer
* 🍽️ Restaurant Owner
* 🚴 Delivery Partner
* 🛡️ Administrator

---

## 🍽️ Restaurant & Food Catalog

Customers can:

* Browse Restaurants
* Search Food Items
* Filter Restaurants by Cuisine
* Sort Restaurants by Rating, Name, or Delivery Time
* View Restaurant Menus
* View Food Details
* Add Food Items to Cart

---

## 🛒 Shopping Cart

The shopping cart allows customers to:

* Add Food Items
* Update Item Quantity
* Remove Items
* View Total Bill
* Place Orders

The system also prevents ordering food from multiple restaurants in a single cart, ensuring a smooth checkout experience.

---

## 📦 Order Management & Status Tracking

Foodify follows a complete order lifecycle where every user role participates in different stages of the order process.

### Order Workflow

```text
Customer Places Order
        │
        ▼
Pending
        │
        ▼
Restaurant Accepts Order
        │
        ▼
Preparing
        │
        ▼
Ready for Pickup
        │
        ▼
Delivery Partner Accepts Order
        │
        ▼
Out for Delivery
        │
        ▼
Delivered
```

### Order Status Responsibilities

| User Role            | Responsibilities                                                                                         |
| -------------------- | -------------------------------------------------------------------------------------------------------- |
| 👤 Customer          | Place orders and track the current order status.                                                         |
| 🍽️ Restaurant Owner | Accept or reject orders, prepare food, and mark orders as **Ready for Pickup**.                          |
| 🚴 Delivery Partner  | Accept delivery requests, pick up food, and update the status to **Out for Delivery** and **Delivered**. |
| 🛡️ Administrator    | Monitor all orders, track their progress, and oversee the complete order lifecycle.                      |

---
## 🍽️ Restaurant Owner Dashboard

Restaurant owners can efficiently manage their restaurants through a dedicated dashboard.

Features include:

* Add New Food Items
* Update Existing Food Items
* Delete Food Items
* Manage Food Categories
* View Customer Orders
* Accept or Reject Orders
* Update Order Status
* View Restaurant Dashboard

---

## 🚴 Delivery Partner Dashboard

Delivery partners can manage assigned deliveries through their dashboard.

Features include:

* View Assigned Orders
* Accept Delivery Requests
* Update Delivery Status
* Mark Orders as Delivered
* Track Total Earnings
* View Delivery Dashboard

---

## 🛡️ Admin Dashboard

Administrators have complete control over the platform.

Features include:

* Approve Restaurant Registrations
* Manage Customers
* Manage Restaurant Owners
* Manage Delivery Partners
* Monitor All Orders
* View Platform Statistics
* Manage System Users

---

## 🚪 Logout

When a user clicks **Logout**:

* The current session is securely invalidated.
* The user is redirected to the Home Page.
* Protected pages cannot be accessed without logging in again.

---

## 🛠️ Technologies Used

| Technology       | Purpose                   |
| ---------------- | ------------------------- |
| ☕ Java           | Backend Development       |
| 🌐 JSP           | Dynamic Web Pages         |
| ⚙️ Servlets      | Request Processing        |
| 🗄️ JDBC         | Database Connectivity     |
| 🐬 MySQL         | Database Management       |
| 🎨 HTML5         | Page Structure            |
| 🎨 CSS3          | Styling                   |
| 🎨 Bootstrap 5   | Responsive UI             |
| ✨ JavaScript     | Client-side Functionality |
| 🔒 BCrypt        | Password Encryption       |
| 🚀 Apache Tomcat | Web Application Server    |

---

## 📂 Project Flow

```text
🏠 Home Page
      │
      ▼
📝 User Registration / 🔐 Login
      │
      ▼
✅ User Authentication
      │
      ▼
🍔 Browse Restaurants
      │
      ▼
🍽️ Browse Food Menu
      │
      ▼
🛒 Add Food to Cart
      │
      ▼
📋 Manage Cart
      │
      ▼
✅ Place Order
      │
      ▼
👨‍🍳 Restaurant Accepts Order
      │
      ▼
🍳 Preparing Food
      │
      ▼
📦 Ready for Pickup
      │
      ▼
🚴 Delivery Partner Accepts Order
      │
      ▼
🚚 Out for Delivery
      │
      ▼
📍 Delivered
      │
      ▼
📊 User Dashboard
      │
      ▼
🚪 Logout
```

---

## 🎯 Purpose

This project was developed to learn and implement:

* Java Full Stack Web Development
* JSP and Servlets
* JDBC and MySQL Integration
* Authentication and Authorization
* BCrypt Password Encryption
* Session Management
* CRUD Operations
* Multi-Role Application Development
* Food Ordering Workflow
* Order Management System
* Delivery Management System
* Responsive Web Design using HTML, CSS, Bootstrap, and JavaScript

---

## 🚀 Future Enhancements

* 🔹 Live GPS Tracking for Delivery Partners
* 🔹 Online Payment Gateway Integration
* 🔹 Wishlist Functionality
* 🔹 Order History and Tracking
* 🔹 Customer Reviews and Ratings
* 🔹 Discount Coupons and Promotional Offers
* 🔹 Email Verification
* 🔹 Forgot Password using Email
* 🔹 Push Notifications
* 🔹 REST API Integration
* 🔹 Mobile Application Support


