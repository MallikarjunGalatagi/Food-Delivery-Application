# Foodify: Professional Online Food Delivery System

Foodify is a premium, commercial-grade, responsive online food delivery system built using Java 21, JSP, Servlets, JDBC, MySQL, HikariCP, and OpenPDF. The application strictly follows the MVC (Model-View-Controller) architecture, separation of concerns, and the DAO (Data Access Object) design pattern.

---

## 🌟 Key Features

### 👨‍💻 Roles & Access Control
- **Customer:** Browse active restaurants, search/filter dishes (veg/non-veg, cuisines), add to cart, manage profile, select delivery address, place order (COD / Online), track live order status, view order history, and download PDF invoices.
- **Restaurant Owner:** Dashboard analytics (revenue, today's orders, menu item count), CRUD categories and menu items, toggle sold-out availability, accept/reject incoming orders, transition kitchen status, and review customer ratings.
- **Delivery Partner (Rider):** View delivery jobs ready at nearby counters, accept assignments, update delivery routes, check cash collections (COD), and review earnings summaries.
- **System Admin:** Platform dashboard (global revenue, user count, order logs), approve/reject new restaurant partner registrations, and manage customer, owner, and rider directories.

---

## 🛠️ Technology Stack
- **Backend:** Java 21, Jakarta Servlet 6.0, JSTL 3.0
- **Database:** MySQL 8+, HikariCP (Connection Pool)
- **PDF Engine:** OpenPDF (PDF Generation)
- **Security:** jBCrypt (Password Hashing)
- **Frontend:** Bootstrap 5, Font Awesome 6 (Icons), Vanilla CSS3, Vanilla JS
- **Server:** Apache Tomcat 10+
- **Build Tool:** Maven

---

## 📁 File Structure & MVC Layout
```
Food Delivery Application/
│
├── db_schema.sql                  # MySQL script with table setups and pre-hashed seed data
├── pom.xml                        # Maven dependency configuration
│
└── src/
    └── main/
        ├── java/
        │   ├── model/             # Java Models (Composition and encapsulation)
        │   ├── dao/               # JDBC Data Access Layer (DAO Pattern)
        │   ├── controller/        # Servlets (Authentication, Customer, Store, Rider, Admin)
        │   ├── filter/            # AuthFilter (Session and URL Guards)
        │   └── util/              # DBConnection (HikariCP Pool Utility)
        │
        ├── resources/
        │   └── db.properties      # Database parameters configuration
        │
        └── webapp/
            ├── css/               # styles.css (Global design system)
            ├── common/            # JSP layouts (Header, Navbar, Footer, About, Contact, Error)
            ├── auth/              # JSP files for Auth (Login, Register, Reset)
            ├── customer/          # JSP files for Customer (Dashboard, Browse, Cart, Checkout, Track)
            ├── restaurant/        # JSP files for Owners (Dashboard, Menu, Orders, Profile, Reviews)
            ├── delivery/          # JSP files for Riders (Dashboard)
            ├── admin/             # JSP files for Admin (Dashboard, Approvals, Directories)
            └── WEB-INF/
                └── web.xml        # Web application configuration
```

---

## 🚀 Setup & Local Execution

### 1. Database Setup
1. Open your MySQL client or shell.
2. Execute the [db_schema.sql](file:///d:/project/Food%20Delivery%20Appication/db_schema.sql) file to create the tables and seed default users.
3. Configure database properties:
   - Open [db.properties](file:///d:/project/Food%20Delivery%20Appication/src/main/resources/db.properties).
   - Set the `db.username` and `db.password` to match your local MySQL credentials.

### 2. IDE Import (Recommended & Efficient)
The project uses Maven, which resolves dependencies automatically:
- **IntelliJ IDEA:** Click *File -> Open*, select the project root folder. Click *Import Changes* or let the IDE detect the `pom.xml` configuration. IntelliJ automatically configures the project context.
- **Eclipse IDE:** Click *File -> Import -> Maven -> Existing Maven Projects*, choose the root folder, and click finish.

### 3. Deploying to Apache Tomcat
1. Compile and package the project:
   ```bash
   mvn clean package
   ```
2. Copy `target/food-delivery-app.war` into the `webapps/` folder of your Apache Tomcat server.
3. Start Tomcat. The application runs at: `http://localhost:8080/food-delivery-app/`

---

## 🔑 Seeding Accounts
All seed accounts use the default password: **`password123`**
- **Admin Console:** `admin@foodify.com`
- **Customer:** `john@gmail.com`
- **Active Store Owner:** `owner.pizza@foodify.com` (Bella Italia Pizza)
- **Pending Store Owner:** `owner.sushi@foodify.com` (Sakura Sushi Bar)
- **Delivery Rider:** `rider.sam@foodify.com`
