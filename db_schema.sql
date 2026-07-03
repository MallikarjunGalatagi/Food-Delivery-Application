-- Create database if it does not exist
CREATE DATABASE IF NOT EXISTS food_delivery_db;
USE food_delivery_db;

-- -----------------------------------------------------
-- Table `users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(15) NOT NULL,
  `role` ENUM('ADMIN', 'CUSTOMER', 'RESTAURANT_OWNER', 'DELIVERY_PARTNER') NOT NULL,
  `status` ENUM('PENDING_APPROVAL', 'ACTIVE', 'REJECTED', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `customers` (
  `user_id` INT PRIMARY KEY,
  `loyalty_points` INT DEFAULT 0,
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `restaurants`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `restaurants` (
  `user_id` INT PRIMARY KEY,
  `restaurant_name` VARCHAR(100) NOT NULL,
  `logo_path` VARCHAR(1000) DEFAULT NULL,
  `banner_path` VARCHAR(1000) DEFAULT NULL,
  `cuisine_type` VARCHAR(100) NOT NULL,
  `estimated_delivery_time` INT NOT NULL DEFAULT 30, -- In minutes
  `address` TEXT NOT NULL,
  `rating` DECIMAL(3,2) DEFAULT 0.00,
  `is_active` BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `delivery_partners`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `delivery_partners` (
  `user_id` INT PRIMARY KEY,
  `vehicle_number` VARCHAR(20) NOT NULL,
  `license_number` VARCHAR(50) NOT NULL,
  `is_available` BOOLEAN DEFAULT TRUE,
  `rating` DECIMAL(3,2) DEFAULT 0.00,
  `earnings` DECIMAL(10,2) DEFAULT 0.00,
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `addresses` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `customer_id` INT NOT NULL,
  `address_line1` VARCHAR(255) NOT NULL,
  `address_line2` VARCHAR(255) DEFAULT NULL,
  `city` VARCHAR(100) NOT NULL,
  `state` VARCHAR(100) NOT NULL,
  `postal_code` VARCHAR(10) NOT NULL,
  `is_default` BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (`customer_id`) REFERENCES `customers` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `categories` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `restaurant_id` INT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `description` TEXT DEFAULT NULL,
  FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `food_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `food_items` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `restaurant_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `is_veg` BOOLEAN DEFAULT TRUE,
  `is_available` BOOLEAN DEFAULT TRUE,
  `image_path` VARCHAR(1000) DEFAULT NULL,
  FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `carts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `carts` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `customer_id` INT NOT NULL,
  FOREIGN KEY (`customer_id`) REFERENCES `customers` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `cart_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cart_items` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `cart_id` INT NOT NULL,
  `food_item_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`food_item_id`) REFERENCES `food_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `orders` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `customer_id` INT NOT NULL,
  `restaurant_id` INT NOT NULL,
  `delivery_partner_id` INT DEFAULT NULL,
  `status` ENUM('PLACED', 'ACCEPTED', 'PREPARING', 'READY_FOR_PICKUP', 'PICKED_UP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED') NOT NULL DEFAULT 'PLACED',
  `subtotal` DECIMAL(10,2) NOT NULL,
  `delivery_charge` DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  `tax` DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  `grand_total` DECIMAL(10,2) NOT NULL,
  `address_id` INT NOT NULL,
  `payment_method` ENUM('COD', 'ONLINE') NOT NULL DEFAULT 'COD',
  `payment_status` ENUM('PENDING', 'COMPLETED', 'FAILED') NOT NULL DEFAULT 'PENDING',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`customer_id`) REFERENCES `customers` (`user_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`user_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`delivery_partner_id`) REFERENCES `delivery_partners` (`user_id`) ON DELETE SET NULL,
  FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `order_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `order_items` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT NOT NULL,
  `food_item_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  `price` DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`food_item_id`) REFERENCES `food_items` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `payments` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT NOT NULL,
  `transaction_id` VARCHAR(100) DEFAULT NULL,
  `payment_method` VARCHAR(20) NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `reviews`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reviews` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  `restaurant_id` INT NOT NULL,
  `rating` INT NOT NULL CHECK (`rating` BETWEEN 1 AND 5),
  `review_text` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`customer_id`) REFERENCES `customers` (`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- SEED DATA (Default Password for all: password123 -> $2a$10$eHP/RE2e6etp/4y0V.z5nOvHN6pVt8.tshbNI/CrMPqkzhG.pLmcy)
-- -----------------------------------------------------

-- 1. Insert Admins
INSERT INTO `users` (`id`, `email`, `password`, `first_name`, `last_name`, `phone`, `role`, `status`) VALUES
(1, 'admin', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Super', 'Admin', '9999999999', 'ADMIN', 'ACTIVE');

-- 2. Insert Customers
INSERT INTO `users` (`id`, `email`, `password`, `first_name`, `last_name`, `phone`, `role`, `status`) VALUES
(2, 'customer1', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'John', 'Doe', '9876543210', 'CUSTOMER', 'ACTIVE'),
(3, 'customer2', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Jane', 'Smith', '9876543211', 'CUSTOMER', 'ACTIVE');

INSERT INTO `customers` (`user_id`, `loyalty_points`) VALUES
(2, 50),
(3, 120);

-- 3. Insert Addresses
INSERT INTO `addresses` (`id`, `customer_id`, `address_line1`, `address_line2`, `city`, `state`, `postal_code`, `is_default`) VALUES
(1, 2, 'Flat 101, Sunrise Apartments', 'Baker Street', 'Mumbai', 'Maharashtra', '400001', 1),
(2, 2, 'Office Block B, Tech Park', 'Bandra', 'Mumbai', 'Maharashtra', '400051', 0),
(3, 3, 'Villa 45, Green Meadows', 'Richmond Road', 'Bangalore', 'Karnataka', '560001', 1);

-- 4. Insert Restaurant Owners (10 total owners)
INSERT INTO `users` (`id`, `email`, `password`, `first_name`, `last_name`, `phone`, `role`, `status`) VALUES
(4, 'owner1', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Mario', 'Rossi', '9888877777', 'RESTAURANT_OWNER', 'ACTIVE'),
(5, 'owner2', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Bob', 'Burger', '9888877776', 'RESTAURANT_OWNER', 'ACTIVE'),
(6, 'owner3', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Ken', 'Tanaka', '9888877775', 'RESTAURANT_OWNER', 'PENDING_APPROVAL'),
(9, 'owner4', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Li', 'Wei', '9888877774', 'RESTAURANT_OWNER', 'ACTIVE'),
(10, 'owner5', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Carlos', 'Garcia', '9888877773', 'RESTAURANT_OWNER', 'ACTIVE'),
(11, 'owner6', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Rajesh', 'Kumar', '9888877772', 'RESTAURANT_OWNER', 'ACTIVE'),
(12, 'owner7', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Sarah', 'Connor', '9888877771', 'RESTAURANT_OWNER', 'ACTIVE'),
(13, 'owner8', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Elena', 'Petrova', '9888877770', 'RESTAURANT_OWNER', 'ACTIVE'),
(14, 'owner9', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Sophie', 'Dubois', '9888877769', 'RESTAURANT_OWNER', 'ACTIVE'),
(15, 'owner10', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Colonel', 'Sanders', '9888877768', 'RESTAURANT_OWNER', 'ACTIVE');

-- Insert Restaurant outlets (Using high-quality Unsplash image URLs)
INSERT INTO `restaurants` (`user_id`, `restaurant_name`, `logo_path`, `banner_path`, `cuisine_type`, `estimated_delivery_time`, `address`, `rating`) VALUES
(4, 'Bella Italia Pizza', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=100&h=100&fit=crop', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&h=400&fit=crop', 'Italian, Pizza', 25, '12 Corso Roma, Sector 4, Mumbai', 4.5),
(5, 'Bobs Premium Burgers', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=100&h=100&fit=crop', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&h=400&fit=crop', 'American, Fast Food', 35, '45 Wall Street, Cyber Hub, Bangalore', 4.2),
(6, 'Sakura Sushi Bar', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=100&h=100&fit=crop', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=600&h=400&fit=crop', 'Japanese, Sushi', 45, '78 Tokyo Lane, MG Road, Pune', 0.0),
(9, 'Golden Dragon Chinese', 'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=100&h=100&fit=crop', 'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=600&h=400&fit=crop', 'Chinese, Asian', 30, '88 Lotus Plaza, Linking Road, Mumbai', 4.1),
(10, 'Taco Fiesta', 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=100&h=100&fit=crop', 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&h=400&fit=crop', 'Mexican, Tex-Mex', 20, '22 Sombrero Avenue, Sector 15, Gurgaon', 4.4),
(11, 'Spicy Curry House', 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=100&h=100&fit=crop', 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=600&h=400&fit=crop', 'Indian, Mughlai', 40, '102 Taj Colony, T-Nagar, Chennai', 4.6),
(12, 'SubWay Express', 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=100&h=100&fit=crop', 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=600&h=400&fit=crop', 'Healthy, Sandwiches', 15, '5 Metro Mall, Park Street, Kolkata', 4.0),
(13, 'Green Salad Co', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=100&h=100&fit=crop', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&h=400&fit=crop', 'Healthy, Salads', 25, '34 Avocados Lane, Indiranagar, Bangalore', 4.3),
(14, 'Sweet Treats Cafe', 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=100&h=100&fit=crop', 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&h=400&fit=crop', 'Desserts, Bakery', 15, '12 Macarons Street, Jubilee Hills, Hyderabad', 4.7),
(15, 'Crispy Fried Chicken', 'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=100&h=100&fit=crop', 'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=600&h=400&fit=crop', 'American, Fried Chicken', 30, '77 Drumsticks Lane, Salt Lake, Kolkata', 4.2);

-- 5. Insert Delivery Partners
INSERT INTO `users` (`id`, `email`, `password`, `first_name`, `last_name`, `phone`, `role`, `status`) VALUES
(7, 'rider1', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Sam', 'Rider', '9555555555', 'DELIVERY_PARTNER', 'ACTIVE'),
(8, 'rider2', '$2a$10$U/AuA1VXXgFsxp6YvmP2fOqdSvXvxBkMdm/s7fxFR6BMZHGrIMKZ6', 'Alex', 'Rider', '9555555556', 'DELIVERY_PARTNER', 'ACTIVE');

INSERT INTO `delivery_partners` (`user_id`, `vehicle_number`, `license_number`, `is_available`, `rating`, `earnings`) VALUES
(7, 'MH-01-AB-1234', 'DL-98765432101', 1, 4.8, 120.00),
(8, 'KA-03-XY-9876', 'DL-98765432102', 1, 4.5, 0.00);

-- 6. Insert Categories
INSERT INTO `categories` (`id`, `restaurant_id`, `name`, `description`) VALUES
(1, 4, 'Classic Pizzas', 'Handcrafted traditional wood-fired pizzas'),
(2, 4, 'Sides & Starters', 'Perfect accompaniments to your pizza'),
(3, 5, 'Gourmet Burgers', '100% prime beef and chicken gourmet burgers'),
(4, 5, 'Beverages & Milkshakes', 'Refreshing drinks and signature milkshakes'),
(5, 6, 'Maki Roll', 'Traditional vinegar-flavored rice wrapped in seaweed'),
(6, 6, 'Nigiri Sushi', 'Hand-pressed sushi toppings over seasoned rice'),
(7, 9, 'Dim Sums & Dumplings', 'Bite-sized steamed or fried dumplings'),
(8, 9, 'Main Course Bowls', 'Traditional noodles and rice meals'),
(9, 10, 'Tacos & Quesadillas', 'Crispy corn and soft flour loaded tacos'),
(10, 10, 'Tex-Mex Appetizers', 'Loaded nachos and churro drops'),
(11, 11, 'Tandoori Delicacies', 'Clay oven baked appetizers and breads'),
(12, 11, 'Curries & Biryanis', 'Slow-cooked aromatic masalas'),
(13, 12, 'Fresh Subs', 'Customized sub sandwiches with dynamic veggies'),
(14, 12, 'Healthy Sides', 'Baked potato wedges and cookies'),
(15, 13, 'Gourmet Salads', 'Fresh organic leaves with delicious dressings'),
(16, 13, 'Cold-Pressed Juices', '100% organic fruit extract juices'),
(17, 14, 'Premium Cakes & Pastries', 'Custom layered baker items'),
(18, 14, 'Espresso Bars', 'Rich arabica brew beverages'),
(19, 15, 'Bucket Dinners', 'Family packs of signature fried chicken'),
(20, 15, 'Dipper Bowls', 'Crispy popcorn chicken with spicy dip sauce');

-- 7. Insert Food Items (10 per restaurant, using real unsplash food URLs)

-- Restaurant 4 (Bella Italia Pizza)
INSERT INTO `food_items` (`id`, `restaurant_id`, `category_id`, `name`, `description`, `price`, `is_veg`, `is_available`, `image_path`) VALUES
(1, 4, 1, 'Margherita Pizza', 'Classic tomato sauce, fresh mozzarella, basil, and extra virgin olive oil', 249.00, 1, 1, 'https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=400&h=300&fit=crop'),
(2, 4, 1, 'Pepperoni Feast Pizza', 'Double pepperoni, loaded with mozzarella and signature pizza sauce', 349.00, 0, 1, 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400&h=300&fit=crop'),
(3, 4, 2, 'Garlic Breadsticks', 'Baked fresh with garlic butter and herbs, served with marinara dip', 129.00, 1, 1, 'https://images.unsplash.com/photo-1544982503-9f984c14501a?w=400&h=300&fit=crop'),
(7, 4, 1, 'Four Cheese Pizza', 'Mozzarella, parmesan, gorgonzola, and ricotta blended over light sauce', 399.00, 1, 1, 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400&h=300&fit=crop'),
(8, 4, 1, 'Spicy Diavola Pizza', 'Spicy salami, jalapeños, red onions, and hot chili oil drizzle', 379.00, 0, 1, 'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=400&h=300&fit=crop'),
(9, 4, 1, 'BBQ Chicken Pizza', 'Grilled chicken slices, smoky BBQ base, bell peppers, and fresh cilantro', 389.00, 0, 1, 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=300&fit=crop'),
(10, 4, 2, 'Bruschetta Romana', 'Toasted crusty bread topped with marinated tomatoes, garlic, and balsamic glaze', 149.00, 1, 1, 'https://images.unsplash.com/photo-1572656631137-7935297eff55?w=400&h=300&fit=crop'),(11, 4, 2, 'Loaded Cheese Fries', 'Crispy fries smothered in warm cheese sauce and jalapeño slices', 179.00, 1, 1, 'https://images.unsplash.com/photo-1585109649139-366815a0d713?w=400&h=300&fit=crop'),
(12, 4, 2, 'Mozzarella Sticks', 'Crumbed sticks of gooey cheese fried golden, served with marinara', 169.00, 1, 1, 'https://images.unsplash.com/photo-1608897013039-887f21d8c804?w=400&h=300&fit=crop'),
(13, 4, 2, 'Truffle Mushroom Bruschetta', 'Creamy sautéed mushrooms with white truffle oil on grilled sourdough', 199.00, 1, 1, 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400&h=300&fit=crop');

-- Restaurant 5 (Bobs Premium Burgers)
INSERT INTO `food_items` (`id`, `restaurant_id`, `category_id`, `name`, `description`, `price`, `is_veg`, `is_available`, `image_path`) VALUES
(4, 5, 3, 'Signature Bacon Cheeseburger', 'Angus beef patty, crispy bacon, cheddar, lettuce, tomato, and Bob\'s secret sauce', 299.00, 0, 1, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop'),
(5, 5, 3, 'Crispy Veggie Deluxe Burger', 'Spicy vegetable patty, melted cheese, jalapenos, and chipotle mayo', 199.00, 1, 1, 'https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?w=400&h=300&fit=crop'),
(6, 5, 4, 'Classic Oreo Milkshake', 'Creamy vanilla ice cream blended with crushed Oreo cookies and chocolate drizzle', 149.00, 1, 1, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400&h=300&fit=crop'),
(14, 5, 3, 'Double Smash Burger', 'Two thin beef patties, double American cheese, grilled onions, pickles, and mustard', 329.00, 0, 1, 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?w=400&h=300&fit=crop'),
(15, 5, 3, 'Avocado Turkey Burger', 'Lean turkey patty, smashed fresh avocado, Swiss cheese, and herb aioli', 289.00, 0, 1, 'https://images.unsplash.com/photo-1512152272829-e3139592d56f?w=400&h=300&fit=crop'),
(16, 5, 3, 'Spicy Zinger Chicken Burger', 'Crispy chicken breast fillet tossed in buffalo sauce, shredded lettuce, and mayo', 249.00, 0, 1, 'https://images.unsplash.com/photo-1625813506062-0aeb1d7a094b?w=400&h=300&fit=crop'),
(17, 5, 4, 'Chocolate Fudge Shake', 'Rich cocoa fudge blended with malt milk and dark chocolate chips', 139.00, 1, 1, 'https://images.unsplash.com/photo-1579954115545-a95591f28bfc?w=400&h=300&fit=crop'),
(18, 5, 4, 'Salted Caramel Milkshake', 'Creamy vanilla base with signature sea salt caramel swirl and whipped topping', 149.00, 1, 1, 'https://images.unsplash.com/photo-1541658016709-82535e94bc69?w=400&h=300&fit=crop'),
(19, 5, 4, 'Strawberry Bliss Smoothie', 'Fresh strawberries, greek yogurt, and wild honey blend', 159.00, 1, 1, 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=400&h=300&fit=crop'),
(20, 5, 4, 'Fresh Mint Mojito', 'Crushed fresh mint leaves, lime juice, brown sugar, and carbonated water', 119.00, 1, 1, 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=400&h=300&fit=crop');

-- Restaurant 6 (Sakura Sushi Bar)
INSERT INTO `food_items` (`id`, `restaurant_id`, `category_id`, `name`, `description`, `price`, `is_veg`, `is_available`, `image_path`) VALUES
(21, 6, 5, 'California Maki Roll', 'Avocado, cucumber, crab stick, rolled in seasoned sushi rice with orange tobiko', 299.00, 0, 1, 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400&h=300&fit=crop'),
(22, 6, 5, 'Spicy Salmon Maki Roll', 'Fresh raw salmon, spicy sriracha mayo, green onions, and tempura flakes', 349.00, 0, 1, 'https://images.unsplash.com/photo-1611143669185-af224c5e3252?w=400&h=300&fit=crop'),
(23, 6, 5, 'Dragon Eel Maki Roll', 'Grilled eel and cucumber wrapped with thinly sliced avocado, topped with unagi glaze', 449.00, 0, 1, 'https://images.unsplash.com/photo-1617196034796-73dfa7b1fd56?w=400&h=300&fit=crop'),
(24, 6, 5, 'Crunchy Tempura Maki Roll', 'Crispy fried shrimp tempura, cucumber, sesame seeds, and sweet soy reduction', 329.00, 0, 1, 'https://images.unsplash.com/photo-1553621042-f6e147245754?w=400&h=300&fit=crop'),
(25, 6, 5, 'Vegan Avocado Maki Roll', 'Rich creamy avocado slices, cucumber, carrot, and toasted sesame seeds', 249.00, 1, 1, 'https://images.unsplash.com/photo-1583623025817-d180a2221d0a?w=400&h=300&fit=crop'),
(26, 6, 6, 'Maguro Nigiri (Tuna)', 'Slices of premium yellowfin raw tuna hand-pressed over blocks of seasoned rice', 199.00, 0, 1, 'https://images.unsplash.com/photo-1607301401259-dfb1a4577076?w=400&h=300&fit=crop'),
(27, 6, 6, 'Sake Nigiri (Salmon)', 'Rich salmon slices pressed over sushi rice, served with wasabi paste', 199.00, 0, 1, 'https://images.unsplash.com/photo-1534482421-64566f976cfa?w=400&h=300&fit=crop'),
(28, 6, 6, 'Ebi Nigiri (Shrimp)', 'Butterflied cooked sweet shrimp over blocks of seasoned sushi rice', 179.00, 0, 1, 'https://images.unsplash.com/photo-1563612116625-3012372fccce?w=400&h=300&fit=crop'),
(29, 6, 6, 'Tamago Nigiri (Sweet Egg)', 'Japanese folded sweet omelet secured over rice with a band of nori seaweed', 149.00, 1, 1, 'https://images.unsplash.com/photo-1558985250-27a406d64cb3?w=400&h=300&fit=crop'),
(30, 6, 6, 'Unagi Nigiri (Grilled Eel)', 'Barbecued fresh water eel over seasoned rice, brushed with sweet glaze', 249.00, 0, 1, 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400&h=300&fit=crop');

-- Restaurant 9 (Golden Dragon Chinese)
INSERT INTO `food_items` (`id`, `restaurant_id`, `category_id`, `name`, `description`, `price`, `is_veg`, `is_available`, `image_path`) VALUES
(31, 9, 7, 'Steamed Chicken Dim Sum', 'Tender minced chicken seasoned with sesame oil and ginger in thin flour wrap', 189.00, 0, 1, 'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=400&h=300&fit=crop'),
(32, 9, 7, 'Crystal Veg Dumplings', 'Translucent wraps loaded with chopped cabbage, water chestnut, and mushrooms', 169.00, 1, 1, 'https://images.unsplash.com/photo-1541832676-9b763b0239ab?w=400&h=300&fit=crop'),
(33, 9, 7, 'Chili Cheese Wontons', 'Crispy fried wonton bags filled with spiced cream cheese and green chilies', 179.00, 1, 1, 'https://images.unsplash.com/photo-1541832676-9b763b0239ab?w=400&h=300&fit=crop'),
(34, 9, 7, 'Crispy Spring Rolls', 'Stuffed with julienned vegetables and bean threads, fried crisp, sweet chili dip', 149.00, 1, 1, 'https://images.unsplash.com/photo-1544025162-d76694265947?w=400&h=300&fit=crop'),
(35, 9, 8, 'Schezwan Fried Rice (Veg)', 'Wok-tossed rice with assorted vegetables in hot garlic Schezwan seasoning', 219.00, 1, 1, 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=300&fit=crop'),
(36, 9, 8, 'Hakka Noodles (Chicken)', 'Wheat noodles tossed with shredded chicken, bell peppers, cabbage, and soy sauce', 239.00, 0, 1, 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400&h=300&fit=crop'),
(37, 9, 8, 'Kung Pao Chicken Bowl', 'Stir-fried chicken chunks with roasted peanuts, celery, and dried red chilies over rice', 279.00, 0, 1, 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=400&h=300&fit=crop'),
(38, 9, 8, 'Mapo Tofu Hotpot (Veg)', 'Tofu cubes simmered in a spicy, aromatic chili bean sauce with green peas', 249.00, 1, 1, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=300&fit=crop'),
(39, 9, 8, 'Manchurian Chicken Bowl', 'Batter-fried chicken tossed in thick garlic, ginger, cilantro, and dark soy broth', 269.00, 0, 1, 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&h=300&fit=crop'),
(40, 9, 8, 'Triple Schezwan Rice Bowl', 'Layered combination of fried rice, crispy fried noodles, and hot schezwan sauce', 299.00, 1, 1, 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=400&h=300&fit=crop');

-- Restaurant 10 (Taco Fiesta)
INSERT INTO `food_items` (`id`, `restaurant_id`, `category_id`, `name`, `description`, `price`, `is_veg`, `is_available`, `image_path`) VALUES
(41, 10, 9, 'Classic Chicken Taco', 'Soft corn tortilla, seasoned grilled chicken, shredded lettuce, pico de gallo, and cheddar', 119.00, 0, 1, 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=300&fit=crop'),
(42, 10, 9, 'Smoky Pork Quesadilla', 'Pulled pork carnitas, Monterey jack cheese, griddled inside a flour tortilla, salsa verde', 229.00, 0, 1, 'https://images.unsplash.com/photo-1599974579688-8dbdd335c77f?w=400&h=300&fit=crop'),
(43, 10, 9, 'Crispy Fish Taco', 'Beer-battered white fish, shredded red cabbage, chipotle crema, cilantro', 139.00, 0, 1, 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400&h=300&fit=crop'),
(44, 10, 9, 'Frijoles & Avocado Taco (Veg)', 'Seasoned black beans, creamy avocado slices, cotija cheese, roasted corn salsa', 99.00, 1, 1, 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=300&fit=crop'),
(45, 10, 9, 'Cheese Quesadilla Combo', 'Triple blend melted cheese tortilla served with guacamole and sour cream cups', 189.00, 1, 1, 'https://images.unsplash.com/photo-1618449840665-9ed506d73a34?w=400&h=300&fit=crop'),
(46, 10, 10, 'Fiesta Loaded Nachos', 'Warm tortilla chips smothered in warm cheese sauce, black beans, jalapeños, guacamole', 249.00, 1, 1, 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=400&h=300&fit=crop'),
(47, 10, 10, 'Stuffed Jalapeno Poppers', 'Crispy breaded jalapenos stuffed with spiced cream cheese, served with sweet salsa', 179.00, 1, 1, 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?w=400&h=300&fit=crop'),
(48, 10, 10, 'Mexican Street Corn (Elote)', 'Grilled corn on the cob brushed with mayonnaise, chili powder, and cotija cheese', 129.00, 1, 1, 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=400&h=300&fit=crop'),
(49, 10, 10, 'Cinnamon Churros (3 Pcs)', 'Always crispy cinnamon loaded dough sticks served with chocolate fudge dipping cup', 149.00, 1, 1, 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=400&h=300&fit=crop'),
(50, 10, 10, 'Tres Leches Cupcake', 'Light sponge cake soaked in three kinds of milk, topped with vanilla whipped cream', 119.00, 1, 1, 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=300&fit=crop');

-- Restaurant 11 (Spicy Curry House)
INSERT INTO `food_items` (`id`, `restaurant_id`, `category_id`, `name`, `description`, `price`, `is_veg`, `is_available`, `image_path`) VALUES
(51, 11, 11, 'Paneer Tikka Angare', 'Cottage cheese chunks marinated in spiced yogurt and grilled over clay tandoor', 249.00, 1, 1, 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=400&h=300&fit=crop'),
(52, 11, 11, 'Murgh Malai Tikka', 'Boneless chicken cubes marinated in cream, cheese, and cardamom, chargrilled', 289.00, 0, 1, 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=400&h=300&fit=crop'),
(53, 11, 11, 'Butter Garlic Naan', 'Leavened clay oven flatbread brushed with chopped garlic and butter', 69.00, 1, 1, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=400&h=300&fit=crop'),
(54, 11, 11, 'Tandoori Roti', 'Whole wheat flatbread baked on the walls of clay tandoor oven', 29.00, 1, 1, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400&h=300&fit=crop'),
(55, 11, 12, 'Paneer Butter Masala', 'Soft cottage cheese cubes simmered in rich creamy tomato and butter gravy', 299.00, 1, 1, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400&h=300&fit=crop'),
(56, 11, 12, 'Delhi Style Butter Chicken', 'Chargrilled chicken tikka cooked in creamy tomato, butter, and dried fenugreek sauce', 349.00, 0, 1, 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=400&h=300&fit=crop'),
(57, 11, 12, 'Dal Makhani (Slow Cooked)', 'Black lentils and kidney beans simmered overnight with butter and fresh cream', 239.00, 1, 1, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=300&fit=crop'),
(58, 11, 12, 'Aromatic Veg Biryani', 'Fragrant basmati rice layered with vegetables, saffron, and biryani spices, raita cup', 279.00, 1, 1, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=400&h=300&fit=crop'),
(59, 11, 12, 'Royal Chicken Dum Biryani', 'Basmati rice cooked dum style with marinated chicken, fried onions, and mint leaves', 329.00, 0, 1, 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?w=400&h=300&fit=crop'),
(60, 11, 12, 'Kadai Chicken', 'Chicken cooked with freshly ground kadai spices, onions, and bell peppers in thick sauce', 319.00, 0, 1, 'https://images.unsplash.com/photo-1626132647523-66f5bf380027?w=400&h=300&fit=crop');

-- Restaurant 12 (SubWay Express)
INSERT INTO `food_items` (`id`, `restaurant_id`, `category_id`, `name`, `description`, `price`, `is_veg`, `is_available`, `image_path`) VALUES
(61, 12, 13, 'Classic Italian BMT Sub', 'Salami, pepperoni, and black forest ham with lettuce, tomato, cucumber on multigrain', 189.00, 0, 1, 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=400&h=300&fit=crop'),
(62, 12, 13, 'Roasted Chicken Breast Sub', 'Tender oven-roasted chicken breast fillet with honey mustard and fresh lettuce', 199.00, 0, 1, 'https://images.unsplash.com/photo-1550507992-eb63ffee0847?w=400&h=300&fit=crop'),
(63, 12, 13, 'Paneer Tikka Premium Sub', 'Marinated paneer chunks grilled, served with mint mayonnaise and vegetables', 179.00, 1, 1, 'https://images.unsplash.com/photo-1550507992-eb63ffee0847?w=400&h=300&fit=crop'),
(64, 12, 13, 'Veggie Delite Sub', 'Crunchy combination of lettuce, tomatoes, green peppers, black olives on wheat bread', 149.00, 1, 1, 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=400&h=300&fit=crop'),
(65, 12, 13, 'Tuna Mayo & Dill Sub', 'Flaked wild tuna mixed with mayonnaise, dill pickles, and chopped red onions', 209.00, 0, 1, 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=400&h=300&fit=crop'),
(66, 12, 14, 'Baked Potato Wedges', 'Crispy skin-on potato wedges seasoned with herbs and baked golden', 99.00, 1, 1, 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&h=300&fit=crop'),
(67, 12, 14, 'Double Chocolate Chip Cookie', 'Chewy bakery cookie loaded with dark and milk chocolate chips', 59.00, 1, 1, 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=400&h=300&fit=crop'),
(68, 12, 14, 'Oatmeal Raisin Cookie', 'Sweet cinnamon oatmeal cookie loaded with premium sun-dried raisins', 59.00, 1, 1, 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=400&h=300&fit=crop'),
(69, 12, 14, 'Macaroni Pasta Salad', 'Chilled elbow macaroni tossed with light mayonnaise, diced carrots, and peas', 119.00, 1, 1, 'https://images.unsplash.com/photo-1546548970-71785318a17b?w=400&h=300&fit=crop'),
(70, 12, 14, 'Baked Cheese Tortilla Chips', 'Crispy baked tortilla chips served with dynamic salsa dip', 89.00, 1, 1, 'https://images.unsplash.com/photo-1518047601542-79f18c655718?w=400&h=300&fit=crop');

-- Restaurant 13 (Green Salad Co)
INSERT INTO `food_items` (`id`, `restaurant_id`, `category_id`, `name`, `description`, `price`, `is_veg`, `is_available`, `image_path`) VALUES
(71, 13, 15, 'Mediterranean Quinoa Salad', 'Boiled organic quinoa, cherry tomatoes, cucumbers, black olives, feta, lemon dressing', 249.00, 1, 1, 'https://images.unsplash.com/photo-1505576399279-565b52d4ac71?w=400&h=300&fit=crop'),
(72, 13, 15, 'Classic Caesar Salad (Veg)', 'Crispy romaine lettuce, herb croutons, parmesan cheese shavings, eggless Caesar dressing', 219.00, 1, 1, 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=400&h=300&fit=crop'),
(73, 13, 15, 'Grilled Chicken Avocado Salad', 'Sliced chicken breast, avocado, mixed field greens, honey dijon vinaigrette', 279.00, 0, 1, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=300&fit=crop'),
(74, 13, 15, 'Thai Peanut Noodle Salad', 'Cold noodles, julienned bell peppers, carrots, edamame, and zesty peanut butter dressing', 239.00, 1, 1, 'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?w=400&h=300&fit=crop'),
(75, 13, 15, 'Fruit & Nut Summer Salad', 'Baby spinach, fresh strawberries, apples, goat cheese, glazed walnuts, balsamic dressing', 259.00, 1, 1, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=300&fit=crop'),
(76, 13, 16, 'Pure Orange Juice (Cold Pressed)', '100% pure extracted orange juice, no added sugar or preservatives', 129.00, 1, 1, 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&h=300&fit=crop'),
(77, 13, 16, 'Detox Green Juice', 'Freshly pressed cucumber, celery, green apple, kale, ginger, and lime', 149.00, 1, 1, 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400&h=300&fit=crop'),
(78, 13, 16, 'Red Beet Energizer', 'Pressed beetroot, carrot, red apple, ginger, and lemon extract', 139.00, 1, 1, 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=400&h=300&fit=crop'),
(79, 13, 16, 'Watermelon Mint Splash', 'Cold-pressed fresh watermelon juice infused with organic mint extract', 119.00, 1, 1, 'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?w=400&h=300&fit=crop'),
(80, 13, 16, 'Coconut Aloe Water', 'Organic tender coconut water blended with pure aloe vera gel extract', 99.00, 1, 1, 'https://images.unsplash.com/photo-1553530979-7ee52a2670c4?w=400&h=300&fit=crop');

-- Restaurant 14 (Sweet Treats Cafe)
INSERT INTO `food_items` (`id`, `restaurant_id`, `category_id`, `name`, `description`, `price`, `is_veg`, `is_available`, `image_path`) VALUES
(81, 14, 17, 'Red Velvet Slice (Premium)', 'Crimson chocolate sponge layers with signature vanilla cream cheese frosting', 159.00, 1, 1, 'https://images.unsplash.com/photo-1616541823729-00fe0aacd32c?w=400&h=300&fit=crop'),
(82, 14, 17, 'Fudge Belgian Cake Slice', 'Dense chocolate cake layered with rich dark chocolate ganache', 149.00, 1, 1, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&h=300&fit=crop'),
(83, 14, 17, 'Classic New York Cheesecake', 'Rich and dense baked cream cheese filling over buttery graham cracker crust', 179.00, 1, 1, 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=400&h=300&fit=crop'),
(84, 14, 17, 'French Macarons Box (4 Pcs)', 'Assortment of vanilla, pistachio, chocolate, and raspberry almond shells', 199.00, 1, 1, 'https://images.unsplash.com/photo-1569864358642-9d1684040f43?w=400&h=300&fit=crop'),
(85, 14, 17, 'Warm Blueberry Muffin', 'Soft buttery muffin loaded with blue huckleberries, served warm', 99.00, 1, 1, 'https://images.unsplash.com/photo-1607958996333-41aef7caefaa?w=400&h=300&fit=crop'),
(86, 14, 18, 'Hot Cappuccino (Arabica)', 'Rich espresso double shot topped with steamed milk microfoam, cocoa dust', 119.00, 1, 1, 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400&h=300&fit=crop'),
(87, 14, 18, 'Classic Iced Latte', 'Chilled milk over double shot espresso, sweetened with light cane sugar syrup', 129.00, 1, 1, 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=400&h=300&fit=crop'),
(88, 14, 18, 'Hazelnut Cold Brew', '24-hour steep cold brew coffee infused with roasted hazelnut flavouring', 139.00, 1, 1, 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&h=300&fit=crop'),
(89, 14, 18, 'Gourmet Hot Chocolate', 'Thick dark melted chocolate whisked with hot cream and marshmallow drops', 149.00, 1, 1, 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400&h=300&fit=crop'),
(90, 14, 18, 'Irish Cream Espresso', 'Double ristretto blended with non-alcoholic Irish cream liqueur extract', 129.00, 1, 1, 'https://images.unsplash.com/photo-1550617931-e17a7b70dce2?w=400&h=300&fit=crop');

-- Restaurant 15 (Crispy Fried Chicken)
INSERT INTO `food_items` (`id`, `restaurant_id`, `category_id`, `name`, `description`, `price`, `is_veg`, `is_available`, `image_path`) VALUES
(91, 15, 19, 'Golden Crispy Bucket (8 Pcs)', 'Classic recipe drumsticks and wings fried golden crisp, served with honey mayo', 499.00, 0, 1, 'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=400&h=300&fit=crop'),
(92, 15, 19, 'Hot & Spicy Chicken Bucket (8 Pcs)', 'Double-dredged chicken in cajun spices and cayenne pepper batter, fried crisp', 529.00, 0, 1, 'https://images.unsplash.com/photo-1627662236973-4f8259fa2441?w=400&h=300&fit=crop'),
(93, 15, 19, 'Chicken Tenders Meal Box (6 Pcs)', 'Crispy hand-breaded chicken breast strips served with dipping honey mustard', 279.00, 0, 1, 'https://images.unsplash.com/photo-1562967914-608f82629710?w=400&h=300&fit=crop'),
(94, 15, 19, 'Smoky Grilled Wings Box (10 Pcs)', 'Chargrilled chicken wings tossed in rich chipotle and molasses BBQ glaze', 319.00, 0, 1, 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=400&h=300&fit=crop'),
(95, 15, 19, 'Ranch Chicken Strips Combo', 'Fried chicken breast strips dusted with powdered buttermilk ranch seasoning', 289.00, 0, 1, 'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=400&h=300&fit=crop'),
(96, 15, 20, 'Crispy Popcorn Chicken Bowl', 'Bite-sized chicken breast nuggets fried crispy, seasoned with lemon pepper', 189.00, 0, 1, 'https://images.unsplash.com/photo-1562967914-608f82629710?w=400&h=300&fit=crop'),
(97, 15, 20, 'Sweet Chili Popcorn Bowl', 'Popcorn chicken chunks tossed in sweet Thai chili glaze and sesame seeds', 199.00, 0, 1, 'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=400&h=300&fit=crop'),
(98, 15, 20, 'Golden Nuggets Box (10 Pcs)', 'Traditional chicken nuggets fried crispy, served with garlic dip cup', 169.00, 0, 1, 'https://images.unsplash.com/photo-1562967914-608f82629710?w=400&h=300&fit=crop'),
(99, 15, 20, 'Onion Rings Basket', 'Sweet yellow onion slices double coated in breadcrumbs and fried, ranch dip', 129.00, 1, 1, 'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?w=400&h=300&fit=crop'),
(100, 15, 20, 'Fries with Cajun Seasoning', 'Crispy skin-on potato fries dusted in hot Louisiana cajun herbs', 119.00, 1, 1, 'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=400&h=300&fit=crop');

-- 8. Create Customer Cart
INSERT INTO `carts` (`id`, `customer_id`) VALUES
(1, 2),
(2, 3);

-- -----------------------------------------------------
-- Performance Optimization Indexes
-- -----------------------------------------------------
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_restaurants_active ON restaurants(is_active);
CREATE INDEX idx_food_items_restaurant ON food_items(restaurant_id);
CREATE INDEX idx_food_items_category ON food_items(category_id);
CREATE INDEX idx_cart_items_cart ON cart_items(cart_id);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_restaurant ON orders(restaurant_id);
CREATE INDEX idx_orders_rider ON orders(delivery_partner_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_reviews_restaurant ON reviews(restaurant_id);
