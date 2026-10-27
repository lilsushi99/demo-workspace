-- ============================================================================
-- WORKSPACE MANAGEMENT ERP - DEMO DATABASE SCHEMA & AUTHORITATIVE SEED DATA
-- Engine: SQLite / MySQL Compatible Export
-- Target Totals: 2 Branches, 4 Staff Members, 5 Expense Categories,
--                33 Unique Customers, 104 Bookings, 36 Expenses
-- ============================================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS import_batches;
DROP TABLE IF EXISTS file_uploads;
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS system_notifications;
DROP TABLE IF EXISTS ai_messages;
DROP TABLE IF EXISTS ai_conversations;
DROP TABLE IF EXISTS payroll_records;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS facility_analytics;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS booking_items;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS client_communications;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS expense_categories;
DROP TABLE IF EXISTS facilities;
DROP TABLE IF EXISTS branches;
DROP TABLE IF EXISTS profile_settings;
DROP TABLE IF EXISTS business_settings;
DROP TABLE IF EXISTS user_roles_permissions;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  phone VARCHAR(50) DEFAULT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('Director', 'Manager', 'Receptionist', 'Accountant') NOT NULL DEFAULT 'Receptionist',
  branch_id VARCHAR(50) DEFAULT NULL,
  branch VARCHAR(100) NOT NULL DEFAULT 'All Branches',
  status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
  profile_photo LONGTEXT DEFAULT NULL,
  last_login DATETIME DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE user_roles_permissions (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  role VARCHAR(50) NOT NULL UNIQUE,
  permissions JSON NOT NULL,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE business_settings (
  id INT NOT NULL DEFAULT 1 PRIMARY KEY,
  business_name VARCHAR(150) NOT NULL DEFAULT 'Nexus Workspace ERP',
  director_name VARCHAR(100) DEFAULT 'Dominion Adebayo',
  director_photo LONGTEXT DEFAULT NULL,
  business_logo LONGTEXT DEFAULT NULL,
  primary_color VARCHAR(20) NOT NULL DEFAULT '#1C64FF',
  currency VARCHAR(50) NOT NULL DEFAULT 'NGN (₦)',
  timezone VARCHAR(50) NOT NULL DEFAULT 'Africa/Lagos',
  address TEXT DEFAULT 'Plot 14 Admiralty Way, Lekki Phase 1 & 24 Commercial Ave, Sabo, Yaba, Lagos',
  phone VARCHAR(50) DEFAULT '+234 803 200 1101',
  email VARCHAR(150) DEFAULT 'admin@gmail.com',
  website VARCHAR(150) DEFAULT 'https://nexusworkspace.ng',
  language VARCHAR(50) NOT NULL DEFAULT 'English (Default)',
  tax_rate DECIMAL(5,2) NOT NULL DEFAULT 7.50,
  invoice_prefix VARCHAR(20) NOT NULL DEFAULT 'INV',
  booking_prefix VARCHAR(20) NOT NULL DEFAULT 'BK',
  client_prefix VARCHAR(20) NOT NULL DEFAULT 'CL',
  expense_prefix VARCHAR(20) NOT NULL DEFAULT 'EXP',
  category_prefix VARCHAR(20) NOT NULL DEFAULT 'EC',
  branch_code VARCHAR(20) NOT NULL DEFAULT 'HVH',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE profile_settings (
  id INT NOT NULL DEFAULT 1 PRIMARY KEY,
  user_id VARCHAR(50) DEFAULT 'USR-001',
  full_name VARCHAR(100) NOT NULL DEFAULT 'Dominion Adebayo',
  email VARCHAR(150) NOT NULL DEFAULT 'admin@gmail.com',
  phone VARCHAR(50) DEFAULT '+234 803 200 1101',
  profile_photo LONGTEXT DEFAULT NULL,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE branches (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  branch_code VARCHAR(20) DEFAULT NULL,
  name VARCHAR(100) NOT NULL,
  location TEXT DEFAULT NULL,
  state VARCHAR(100) DEFAULT NULL,
  status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
  created_date DATE NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE facilities (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  branch_id VARCHAR(50) NOT NULL,
  branch_name VARCHAR(100) NOT NULL,
  default_price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  capacity INT NOT NULL DEFAULT 5,
  status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
  description TEXT DEFAULT NULL,
  created_date DATE NOT NULL DEFAULT '2025-01-15',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE expense_categories (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  category_ref VARCHAR(50) DEFAULT NULL,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT DEFAULT NULL,
  status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
  color VARCHAR(20) DEFAULT '#3B82F6',
  created_date DATE NOT NULL DEFAULT '2025-01-10',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE clients (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  client_ref VARCHAR(50) DEFAULT NULL,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(50) NOT NULL,
  email VARCHAR(150) DEFAULT NULL,
  company VARCHAR(150) DEFAULT NULL,
  status ENUM('Active', 'Inactive', 'VIP', 'Expiring Soon', 'Expired') NOT NULL DEFAULT 'Active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE bookings (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  booking_ref VARCHAR(50) DEFAULT NULL,
  date DATE NOT NULL,
  start_time TIME DEFAULT '09:00:00',
  end_time TIME DEFAULT '17:00:00',
  client_id VARCHAR(50) NOT NULL,
  client_name VARCHAR(150) NOT NULL,
  phone VARCHAR(50) NOT NULL,
  email VARCHAR(150) DEFAULT NULL,
  branch_id VARCHAR(50) DEFAULT NULL,
  branch VARCHAR(100) NOT NULL,
  facility_id VARCHAR(50) DEFAULT NULL,
  facility VARCHAR(100) NOT NULL,
  days_count INT NOT NULL DEFAULT 1,
  time_duration VARCHAR(100) NOT NULL DEFAULT '09:00 AM - 05:00 PM',
  amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  payment_method ENUM('Cash', 'Wire Transfer', 'Credit Card', 'Corporate Billing', 'POS Terminal') NOT NULL DEFAULT 'Wire Transfer',
  days_used INT NOT NULL DEFAULT 0,
  days_left INT NOT NULL DEFAULT 0,
  status ENUM('Active', 'Upcoming', 'Expired', 'Cancelled') NOT NULL DEFAULT 'Active',
  created_by VARCHAR(50) DEFAULT 'USR-001',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE booking_items (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  booking_id VARCHAR(50) NOT NULL,
  item_name VARCHAR(150) NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  total_price DECIMAL(12,2) NOT NULL
);
CREATE TABLE subscriptions (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  booking_id VARCHAR(50) DEFAULT NULL,
  client_id VARCHAR(50) NOT NULL,
  facility_id VARCHAR(50) DEFAULT NULL,
  facility_name VARCHAR(100) DEFAULT NULL,
  branch_id VARCHAR(50) DEFAULT NULL,
  branch_name VARCHAR(100) DEFAULT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  days_count INT NOT NULL DEFAULT 30,
  days_used INT NOT NULL DEFAULT 0,
  days_remaining INT NOT NULL DEFAULT 30,
  amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  payment_method VARCHAR(50) NOT NULL DEFAULT 'Credit Card',
  status ENUM('Active', 'Expiring Soon', 'Expired', 'Cancelled') NOT NULL DEFAULT 'Active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE expenses (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  expense_ref VARCHAR(50) DEFAULT NULL,
  name VARCHAR(200) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  date DATE NOT NULL,
  branch_id VARCHAR(50) DEFAULT NULL,
  branch VARCHAR(100) NOT NULL,
  category_id VARCHAR(50) DEFAULT NULL,
  category VARCHAR(100) NOT NULL,
  description TEXT DEFAULT NULL,
  status ENUM('Paid', 'Approved', 'Pending', 'Rejected') NOT NULL DEFAULT 'Paid',
  created_by VARCHAR(100) NOT NULL DEFAULT 'Dominion Adebayo',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE payments (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  reference VARCHAR(100) NOT NULL UNIQUE,
  booking_id VARCHAR(50) DEFAULT NULL,
  client_id VARCHAR(50) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  payment_method VARCHAR(50) NOT NULL,
  payment_date DATE NOT NULL,
  status ENUM('Completed', 'Pending', 'Failed', 'Refunded') NOT NULL DEFAULT 'Completed',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE employees (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  user_id VARCHAR(50) DEFAULT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(150) DEFAULT NULL,
  phone VARCHAR(50) DEFAULT NULL,
  department VARCHAR(100) DEFAULT 'Operations',
  position VARCHAR(100) DEFAULT 'Staff',
  branch_id VARCHAR(50) DEFAULT NULL,
  branch_name VARCHAR(100) DEFAULT 'Main Branch',
  hire_date DATE DEFAULT NULL,
  employment_status ENUM('Full-time', 'Part-time', 'Contract', 'Inactive') NOT NULL DEFAULT 'Full-time',
  salary_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE payroll_records (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  employee_id VARCHAR(50) NOT NULL,
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  gross_salary DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  deductions DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  net_salary DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  payment_status ENUM('Pending', 'Paid', 'Processing') NOT NULL DEFAULT 'Pending',
  payment_date DATE DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE client_communications (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  client_id VARCHAR(50) NOT NULL,
  user_id VARCHAR(50) DEFAULT NULL,
  type ENUM('Email', 'SMS', 'Call', 'Meeting', 'Note') NOT NULL DEFAULT 'Note',
  subject VARCHAR(255) DEFAULT NULL,
  summary TEXT NOT NULL,
  direction ENUM('Inbound', 'Outbound') NOT NULL DEFAULT 'Outbound',
  status VARCHAR(50) NOT NULL DEFAULT 'Logged',
  logged_by VARCHAR(100) DEFAULT NULL,
  sent_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE system_notifications (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(50) DEFAULT NULL,
  title VARCHAR(200) NOT NULL,
  message TEXT NOT NULL,
  type ENUM('info', 'warning', 'success', 'danger') NOT NULL DEFAULT 'info',
  is_read TINYINT(1) NOT NULL DEFAULT 0,
  related_entity VARCHAR(50) DEFAULT NULL,
  related_entity_id VARCHAR(50) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE audit_logs (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user VARCHAR(100) NOT NULL,
  action VARCHAR(100) NOT NULL,
  ip_address VARCHAR(50) DEFAULT '127.0.0.1',
  entity VARCHAR(100) DEFAULT NULL,
  entity_id VARCHAR(100) DEFAULT NULL,
  previous_value JSON DEFAULT NULL,
  new_value JSON DEFAULT NULL,
  timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE import_batches (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  file_name VARCHAR(255) NOT NULL,
  uploaded_by VARCHAR(100) DEFAULT 'Admin',
  total_rows INT NOT NULL DEFAULT 0,
  imported_rows INT NOT NULL DEFAULT 0,
  failed_rows INT NOT NULL DEFAULT 0,
  status ENUM('Pending', 'Completed', 'Failed') NOT NULL DEFAULT 'Completed',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE facility_analytics (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  facility_id VARCHAR(50) NOT NULL,
  facility_name VARCHAR(100) NOT NULL,
  branch_name VARCHAR(100) NOT NULL,
  period VARCHAR(20) NOT NULL,
  total_bookings INT NOT NULL DEFAULT 0,
  total_revenue DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  occupancy_rate DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_fac_per (facility_id, period)
);
CREATE TABLE ai_conversations (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  session_id VARCHAR(100) NOT NULL,
  user_id VARCHAR(50) DEFAULT NULL,
  title VARCHAR(255) DEFAULT 'AI Chat Session',
  prompt TEXT DEFAULT NULL,
  response TEXT DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE ai_messages (
  id VARCHAR(100) NOT NULL PRIMARY KEY,
  conversation_id VARCHAR(100) NOT NULL DEFAULT 'default',
  sender VARCHAR(50) NOT NULL,
  text TEXT NOT NULL,
  timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 1. USERS & STAFF MEMBERS (EXACTLY 4 STAFF RECORDS)
-- Roles: Director (admin@gmail.com / Admin@123), Manager, Front Desk, Accountant
-- ============================================================================
INSERT INTO users (id, name, email, phone, password_hash, role, branch_id, branch, status, created_at) VALUES ('USR-001', 'Dominion Adebayo', 'admin@gmail.com', '+234 803 200 1101', '$2b$10$ZTD6sn9SCCBFIO7t3UbkdOW09RGrZ6y4fFMSQ.bbGcSxNZYzXRa16', 'Director', 'BR-001', 'All Branches', 'Active', '2025-01-01 08:00:00');
INSERT INTO users (id, name, email, phone, password_hash, role, branch_id, branch, status, created_at) VALUES ('USR-002', 'Chioma Okonkwo', 'chioma.okonkwo@workspace.ng', '+234 802 334 5566', '$2b$10$ZTD6sn9SCCBFIO7t3UbkdOW09RGrZ6y4fFMSQ.bbGcSxNZYzXRa16', 'Manager', 'BR-001', 'Hive Hub', 'Active', '2025-01-01 08:00:00');
INSERT INTO users (id, name, email, phone, password_hash, role, branch_id, branch, status, created_at) VALUES ('USR-003', 'Amara Nwosu', 'amara.nwosu@workspace.ng', '+234 814 556 7788', '$2b$10$ZTD6sn9SCCBFIO7t3UbkdOW09RGrZ6y4fFMSQ.bbGcSxNZYzXRa16', 'Receptionist', 'BR-002', 'Art and Tech Hub', 'Active', '2025-01-01 08:00:00');
INSERT INTO users (id, name, email, phone, password_hash, role, branch_id, branch, status, created_at) VALUES ('USR-004', 'Ibrahim Danjuma', 'ibrahim.danjuma@workspace.ng', '+234 809 667 8899', '$2b$10$ZTD6sn9SCCBFIO7t3UbkdOW09RGrZ6y4fFMSQ.bbGcSxNZYzXRa16', 'Accountant', 'BR-001', 'All Branches', 'Active', '2025-01-01 08:00:00');

-- 2. User Roles Permissions Matrix
INSERT INTO user_roles_permissions (role, permissions) VALUES
('Director', '{"crm": true, "reports": true, "expenses": true, "settings": true, "dashboard": true, "dailyLogger": true, "administration": true, "facilityRecords": true}'),
('Manager', '{"crm": true, "reports": true, "expenses": true, "settings": false, "dashboard": true, "dailyLogger": true, "administration": true, "facilityRecords": true}'),
('Receptionist', '{"crm": true, "reports": false, "expenses": false, "settings": false, "dashboard": true, "dailyLogger": true, "administration": false, "facilityRecords": true}'),
('Accountant', '{"crm": false, "reports": true, "expenses": true, "settings": false, "dashboard": true, "dailyLogger": false, "administration": false, "facilityRecords": true}');

-- 3. Business Settings & Profile
INSERT INTO business_settings (id, business_name, director_name, business_logo, currency, timezone, address, phone, email, website, language, tax_rate, invoice_prefix, booking_prefix, client_prefix, expense_prefix, category_prefix, branch_code) VALUES
(1, 'Nexus Workspace ERP', 'Dominion Adebayo', NULL, 'NGN (₦)', 'Africa/Lagos', 'Plot 14 Admiralty Way, Lekki Phase 1 & 24 Commercial Ave, Sabo, Yaba, Lagos', '+234 803 200 1101', 'admin@gmail.com', 'https://nexusworkspace.ng', 'English (Default)', 7.50, 'INV', 'BK', 'CL', 'EXP', 'EC', 'HVH');
INSERT INTO profile_settings (id, user_id, full_name, email, phone, profile_photo) VALUES
(1, 'USR-001', 'Dominion Adebayo', 'admin@gmail.com', '+234 803 200 1101', NULL);

-- ============================================================================
-- 4. BRANCHES (EXACTLY 2 BRANCHES)
-- 1. Hive Hub
-- 2. Art and Tech Hub
-- ============================================================================
INSERT INTO branches (id, branch_code, name, location, state, status, created_date) VALUES ('BR-001', 'HVH', 'Hive Hub', 'Plot 14 Admiralty Way, Lekki Phase 1, Lagos', 'Lagos', 'Active', '2025-01-15');
INSERT INTO branches (id, branch_code, name, location, state, status, created_date) VALUES ('BR-002', 'ATH', 'Art and Tech Hub', '24 Commercial Avenue, Sabo, Yaba, Lagos', 'Lagos', 'Active', '2025-02-01');

-- ============================================================================
-- 5. FACILITIES (8 FACILITIES ACROSS THE 2 BRANCHES)
-- ============================================================================
INSERT INTO facilities (id, name, branch_id, branch_name, default_price, capacity, status, description, created_date) VALUES ('FAC-001', 'Hot Desk Zone', 'BR-001', 'Hive Hub', 5000, 25, 'Active', 'Open-plan ergonomic flex desks with dedicated high-speed Starlink broadband and power backup.', '2025-01-16');
INSERT INTO facilities (id, name, branch_id, branch_name, default_price, capacity, status, description, created_date) VALUES ('FAC-002', 'Dedicated Workstation', 'BR-001', 'Hive Hub', 12500, 12, 'Active', 'Permanent reserved desk with lockable storage pedestal in a quiet productivity zone.', '2025-01-16');
INSERT INTO facilities (id, name, branch_id, branch_name, default_price, capacity, status, description, created_date) VALUES ('FAC-003', 'Executive Private Suite', 'BR-001', 'Hive Hub', 45000, 4, 'Active', 'Enclosed soundproofed 4-person executive office suite with biometric door access.', '2025-01-16');
INSERT INTO facilities (id, name, branch_id, branch_name, default_price, capacity, status, description, created_date) VALUES ('FAC-004', 'Collaborative Meeting Room', 'BR-001', 'Hive Hub', 20000, 8, 'Active', '8-seater presentation conference room equipped with 4K display and smart video soundbar.', '2025-01-16');
INSERT INTO facilities (id, name, branch_id, branch_name, default_price, capacity, status, description, created_date) VALUES ('FAC-005', 'Creative Open Desk', 'BR-002', 'Art and Tech Hub', 4500, 30, 'Active', 'Vibrant shared workstations with natural lighting and direct cafe breakout space.', '2025-01-16');
INSERT INTO facilities (id, name, branch_id, branch_name, default_price, capacity, status, description, created_date) VALUES ('FAC-006', 'Private Studio Office', 'BR-002', 'Art and Tech Hub', 40000, 6, 'Active', 'Furnished 6-person studio suite tailored for digital agencies and tech development pods.', '2025-01-16');
INSERT INTO facilities (id, name, branch_id, branch_name, default_price, capacity, status, description, created_date) VALUES ('FAC-007', 'Podcast & Audio Lab', 'BR-002', 'Art and Tech Hub', 25000, 3, 'Active', 'Acoustically isolated broadcast booth with Shure SM7B mics and Rodecaster Pro console.', '2025-01-16');
INSERT INTO facilities (id, name, branch_id, branch_name, default_price, capacity, status, description, created_date) VALUES ('FAC-008', 'Tech Conference Hall', 'BR-002', 'Art and Tech Hub', 60000, 15, 'Active', 'Multi-purpose 15-seater conference hall with laser projector, wireless mics, and PA system.', '2025-01-16');

-- ============================================================================
-- 6. EXPENSE CATEGORIES (EXACTLY 5 ONE-WORD CATEGORIES)
-- Utilities, Hygiene, Equipment, Maintenance, Marketing
-- ============================================================================
INSERT INTO expense_categories (id, category_ref, name, description, status, color, created_date) VALUES ('CAT-001', 'EC-001', 'Utilities', 'Starlink subscription, MTN internet subscription, water supply, and recurring utility bills.', 'Active', '#3B82F6', '2025-01-10');
INSERT INTO expense_categories (id, category_ref, name, description, status, color, created_date) VALUES ('CAT-002', 'EC-002', 'Hygiene', 'Toilet rolls, toiletries, air fresheners, fragrance diffusers, and cleaning-related consumables.', 'Active', '#10B981', '2025-01-10');
INSERT INTO expense_categories (id, category_ref, name, description, status, color, created_date) VALUES ('CAT-003', 'EC-003', 'Equipment', 'Extension sockets, power strips, and other small workspace equipment used to power laptops and devices.', 'Active', '#8B5CF6', '2025-01-10');
INSERT INTO expense_categories (id, category_ref, name, description, status, color, created_date) VALUES ('CAT-004', 'EC-004', 'Maintenance', 'AC servicing and repairs, electrical repairs, socket repairs, plumbing, and general facility maintenance.', 'Active', '#F59E0B', '2025-01-10');
INSERT INTO expense_categories (id, category_ref, name, description, status, color, created_date) VALUES ('CAT-005', 'EC-005', 'Marketing', 'Banner printing, promotional materials, advertising, and workspace publicity.', 'Active', '#EC4899', '2025-01-10');

-- ============================================================================
-- 7. CUSTOMERS (EXACTLY 33 UNIQUE NIGERIAN CUSTOMERS)
-- ============================================================================
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-001', 'CL-REF-001', 'Babatunde Adeyemi', '+234 803 111 2233', 'babatunde.adeyemi@paystackalumni.ng', 'Paystack Alumni Ventures', 'VIP', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-002', 'CL-REF-002', 'Chioma Okoli', '+234 802 222 3344', 'chioma.okoli@koracreative.ng', 'Kora Creative Studios', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-003', 'CL-REF-003', 'Olumide Bakare', '+234 814 333 4455', 'olumide.bakare@venturesplatform.ng', 'Ventures Platform Capital', 'VIP', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-004', 'CL-REF-004', 'Amina Ibrahim', '+234 809 444 5566', 'amina.ibrahim@savannahagri.ng', 'Savannah AgriTech Solutions', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-005', 'CL-REF-005', 'Chukwuemeka Eze', '+234 805 555 6677', 'c.eze@monopartners.ng', 'Mono Finance Partners', 'VIP', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-006', 'CL-REF-006', 'Folake Adeleke', '+234 818 666 7788', 'folake.adeleke@brass-studio.africa', 'Brass Studio Africa', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-007', 'CL-REF-007', 'Temitope Ogunleye', '+234 807 777 8899', 'temitope.ogunleye@designguild.ng', 'Flutterwave Design Guild', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-008', 'CL-REF-008', 'Zainab Bello', '+234 811 888 9900', 'zainab.bello@wealthlabs.ng', 'Piggyvest Wealth Labs', 'VIP', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-009', 'CL-REF-009', 'Ifeanyi Nwosu', '+234 813 999 0011', 'ifeanyi.nwosu@risevestlabs.ng', 'Risevest Engineering Hub', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-010', 'CL-REF-010', 'Ngozi Adeleke', '+234 816 111 0022', 'ngozi.adeleke@zikokomedia.ng', 'Zikoko Digital Media', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-011', 'CL-REF-011', 'Dapo Osinowo', '+234 802 345 6789', 'dapo.osinowo@edenlifeops.ng', 'Eden Life Operations', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-012', 'CL-REF-012', 'Halima Danjuma', '+234 803 456 7890', 'halima.danjuma@heliumrecords.ng', 'Helium Health Records', 'VIP', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-013', 'CL-REF-013', 'Kelechi Onyekwelu', '+234 805 567 8901', 'kelechi@cowrywisegrowth.ng', 'Cowrywise Growth Agency', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-014', 'CL-REF-014', 'Simisola Fashola', '+234 807 678 9012', 'simisola.fashola@altschoolafrica.ng', 'AltSchool Africa Fellows', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-015', 'CL-REF-015', 'Obinna Nnamani', '+234 809 789 0123', 'obinna.nnamani@reliancehealth.ng', 'Reliance Health Consult', 'VIP', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-016', 'CL-REF-016', 'Aisha Mohammed', '+234 810 890 1234', 'aisha.mohammed@stearsdata.ng', 'Stears Intelligence', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-017', 'CL-REF-017', 'Femi Balogun', '+234 812 901 2345', 'femi.balogun@techcabal.ng', 'TechCabal Editorial', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-018', 'CL-REF-018', 'Blessing Jumbo', '+234 814 012 3456', 'blessing.jumbo@investbamboo.ng', 'Bamboo Investment Partners', 'VIP', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-019', 'CL-REF-019', 'Tobi Alabi', '+234 816 123 4567', 'tobi.alabi@nombaservices.ng', 'Nomba Merchant Services', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-020', 'CL-REF-020', 'Mariam Abubakar', '+234 818 234 5678', 'mariam.abubakar@seamlesshr.ng', 'SeamlessHR People Advisory', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-021', 'CL-REF-021', 'Chinedu Obi', '+234 803 345 6781', 'chinedu.obi@tradedepot.ng', 'TradeDepot Supply Chain', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-022', 'CL-REF-022', 'Ronke Awolowo', '+234 802 456 7892', 'ronke.awolowo@kudastrategy.ng', 'Kuda Banking Strategy', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-023', 'CL-REF-023', 'Uche Okoye', '+234 805 567 8903', 'uche.okoye@autochek.ng', 'Autochek Mobility Ventures', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-024', 'CL-REF-024', 'Fatima Sanusi', '+234 807 678 9014', 'fatima.sanusi@termiisolutions.ng', 'Termii Telecom Solutions', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-025', 'CL-REF-025', 'Kunle Ajayi', '+234 809 789 0125', 'kunle.ajayi@moniepointnetwork.ng', 'TeamApt Moniepoint Network', 'VIP', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-026', 'CL-REF-026', 'Efe Omoworare', '+234 810 890 1236', 'efe.omoworare@patriciabrand.ng', 'Patricia Brand Strategy', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-027', 'CL-REF-027', 'Hadiza Aliyu', '+234 812 901 2347', 'hadiza.aliyu@vendeasefoods.ng', 'Vendease Food Procurement', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-028', 'CL-REF-028', 'Nonso Madu', '+234 814 012 3458', 'nonso.madu@lemfiremit.ng', 'LemFi Diaspora Remittance', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-029', 'CL-REF-029', 'Yetunde Oladipo', '+234 816 123 4569', 'yetunde.oladipo@moovefleet.ng', 'Moove Global Fleet', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-030', 'CL-REF-030', 'Tariro Akindele', '+234 818 234 5670', 'tariro.akindele@chowdeckfleet.ng', 'Chowdeck Logistics Fleet', 'Active', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-031', 'CL-REF-031', 'Osas Ighodaro', '+234 803 345 6782', 'osas.ighodaro@getanchor.ng', 'Anchor Banking Infrastructure', 'Expiring Soon', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-032', 'CL-REF-032', 'Nkechi Nwankwo', '+234 802 456 7893', 'nkechi.nwankwo@remedialhealth.ng', 'Remedial Health Logistics', 'Expired', '2026-04-15 09:00:00');
INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('CL-033', 'CL-REF-033', 'Yusuf Garba', '+234 805 567 8904', 'yusuf.garba@sabidistribution.ng', 'Sabi B2B Distribution', 'Active', '2026-04-15 09:00:00');

-- ============================================================================
-- 8. BOOKINGS (EXACTLY 104 BELIEVABLE BOOKINGS LINKED TO THE 33 CUSTOMERS)
-- ============================================================================
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-001', 'BK-REF-001', '2026-05-04', '09:00:00', '17:00:00', 'CL-001', 'Babatunde Adeyemi', '+234 803 111 2233', 'babatunde.adeyemi@paystackalumni.ng', 'BR-001', 'Hive Hub', 'FAC-001', 'Hot Desk Zone', 1, '09:00 AM - 05:00 PM', 5000, 'Wire Transfer', 1, 0, 'Expired', 'USR-001', '2026-05-04 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-001', 'Hot Desk Zone Pass (1 Day)', 5000, 1, 5000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-001', 'REF-PAY-2026-001', 'BK-2026-001', 'CL-001', 5000, 'Wire Transfer', '2026-05-04', 'Completed', '2026-05-04 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-002', 'BK-REF-002', '2026-05-08', '09:00:00', '17:00:00', 'CL-002', 'Chioma Okoli', '+234 802 222 3344', 'chioma.okoli@koracreative.ng', 'BR-001', 'Hive Hub', 'FAC-002', 'Dedicated Workstation', 10, '08:00 AM - 06:00 PM', 125000, 'POS Terminal', 10, 0, 'Expired', 'USR-001', '2026-05-08 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-002', 'Dedicated Workstation Pass (10 Days)', 12500, 10, 125000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-002', 'REF-PAY-2026-002', 'BK-2026-002', 'CL-002', 125000, 'POS Terminal', '2026-05-08', 'Completed', '2026-05-08 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-003', 'BK-REF-003', '2026-05-12', '09:00:00', '17:00:00', 'CL-003', 'Olumide Bakare', '+234 814 333 4455', 'olumide.bakare@venturesplatform.ng', 'BR-001', 'Hive Hub', 'FAC-003', 'Executive Private Suite', 10, '10:00 AM - 04:00 PM', 450000, 'Cash', 10, 0, 'Expired', 'USR-001', '2026-05-12 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-003', 'Executive Private Suite Pass (10 Days)', 45000, 10, 450000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-003', 'REF-PAY-2026-003', 'BK-2026-003', 'CL-003', 450000, 'Cash', '2026-05-12', 'Completed', '2026-05-12 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-004', 'BK-REF-004', '2026-05-15', '09:00:00', '17:00:00', 'CL-004', 'Amina Ibrahim', '+234 809 444 5566', 'amina.ibrahim@savannahagri.ng', 'BR-001', 'Hive Hub', 'FAC-004', 'Collaborative Meeting Room', 1, '09:00 AM - 01:00 PM', 20000, 'Credit Card', 1, 0, 'Expired', 'USR-001', '2026-05-15 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-004', 'Collaborative Meeting Room Pass (1 Day)', 20000, 1, 20000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-004', 'REF-PAY-2026-004', 'BK-2026-004', 'CL-004', 20000, 'Credit Card', '2026-05-15', 'Completed', '2026-05-15 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-005', 'BK-REF-005', '2026-05-19', '09:00:00', '17:00:00', 'CL-005', 'Chukwuemeka Eze', '+234 805 555 6677', 'c.eze@monopartners.ng', 'BR-002', 'Art and Tech Hub', 'FAC-005', 'Creative Open Desk', 20, '01:00 PM - 06:00 PM', 90000, 'Corporate Billing', 20, 0, 'Expired', 'USR-001', '2026-05-19 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-005', 'Creative Open Desk Pass (20 Days)', 4500, 20, 90000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-005', 'REF-PAY-2026-005', 'BK-2026-005', 'CL-005', 90000, 'Corporate Billing', '2026-05-19', 'Completed', '2026-05-19 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-006', 'BK-REF-006', '2026-05-22', '09:00:00', '17:00:00', 'CL-006', 'Folake Adeleke', '+234 818 666 7788', 'folake.adeleke@brass-studio.africa', 'BR-002', 'Art and Tech Hub', 'FAC-006', 'Private Studio Office', 10, '09:00 AM - 05:00 PM', 400000, 'Wire Transfer', 10, 0, 'Expired', 'USR-001', '2026-05-22 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-006', 'Private Studio Office Pass (10 Days)', 40000, 10, 400000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-006', 'REF-PAY-2026-006', 'BK-2026-006', 'CL-006', 400000, 'Wire Transfer', '2026-05-22', 'Completed', '2026-05-22 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-007', 'BK-REF-007', '2026-05-26', '09:00:00', '17:00:00', 'CL-007', 'Temitope Ogunleye', '+234 807 777 8899', 'temitope.ogunleye@designguild.ng', 'BR-002', 'Art and Tech Hub', 'FAC-007', 'Podcast & Audio Lab', 10, '08:00 AM - 06:00 PM', 250000, 'POS Terminal', 10, 0, 'Expired', 'USR-001', '2026-05-26 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-007', 'Podcast & Audio Lab Pass (10 Days)', 25000, 10, 250000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-007', 'REF-PAY-2026-007', 'BK-2026-007', 'CL-007', 250000, 'POS Terminal', '2026-05-26', 'Completed', '2026-05-26 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-008', 'BK-REF-008', '2026-05-29', '09:00:00', '17:00:00', 'CL-008', 'Zainab Bello', '+234 811 888 9900', 'zainab.bello@wealthlabs.ng', 'BR-002', 'Art and Tech Hub', 'FAC-008', 'Tech Conference Hall', 2, '10:00 AM - 04:00 PM', 120000, 'Cash', 2, 0, 'Expired', 'USR-001', '2026-05-29 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-008', 'Tech Conference Hall Pass (2 Days)', 60000, 2, 120000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-008', 'REF-PAY-2026-008', 'BK-2026-008', 'CL-008', 120000, 'Cash', '2026-05-29', 'Completed', '2026-05-29 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-009', 'BK-REF-009', '2026-06-02', '09:00:00', '17:00:00', 'CL-009', 'Ifeanyi Nwosu', '+234 813 999 0011', 'ifeanyi.nwosu@risevestlabs.ng', 'BR-001', 'Hive Hub', 'FAC-001', 'Hot Desk Zone', 10, '09:00 AM - 01:00 PM', 50000, 'Credit Card', 10, 0, 'Expired', 'USR-001', '2026-06-02 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-009', 'Hot Desk Zone Pass (10 Days)', 5000, 10, 50000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-009', 'REF-PAY-2026-009', 'BK-2026-009', 'CL-009', 50000, 'Credit Card', '2026-06-02', 'Completed', '2026-06-02 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-010', 'BK-REF-010', '2026-06-05', '09:00:00', '17:00:00', 'CL-010', 'Ngozi Adeleke', '+234 816 111 0022', 'ngozi.adeleke@zikokomedia.ng', 'BR-001', 'Hive Hub', 'FAC-002', 'Dedicated Workstation', 10, '01:00 PM - 06:00 PM', 125000, 'Corporate Billing', 10, 0, 'Expired', 'USR-001', '2026-06-05 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-010', 'Dedicated Workstation Pass (10 Days)', 12500, 10, 125000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-010', 'REF-PAY-2026-010', 'BK-2026-010', 'CL-010', 125000, 'Corporate Billing', '2026-06-05', 'Completed', '2026-06-05 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-011', 'BK-REF-011', '2026-06-08', '09:00:00', '17:00:00', 'CL-011', 'Dapo Osinowo', '+234 802 345 6789', 'dapo.osinowo@edenlifeops.ng', 'BR-001', 'Hive Hub', 'FAC-003', 'Executive Private Suite', 10, '09:00 AM - 05:00 PM', 450000, 'Wire Transfer', 10, 0, 'Expired', 'USR-001', '2026-06-08 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-011', 'Executive Private Suite Pass (10 Days)', 45000, 10, 450000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-011', 'REF-PAY-2026-011', 'BK-2026-011', 'CL-011', 450000, 'Wire Transfer', '2026-06-08', 'Completed', '2026-06-08 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-012', 'BK-REF-012', '2026-06-11', '09:00:00', '17:00:00', 'CL-012', 'Halima Danjuma', '+234 803 456 7890', 'halima.danjuma@heliumrecords.ng', 'BR-001', 'Hive Hub', 'FAC-004', 'Collaborative Meeting Room', 3, '08:00 AM - 06:00 PM', 60000, 'POS Terminal', 3, 0, 'Expired', 'USR-001', '2026-06-11 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-012', 'Collaborative Meeting Room Pass (3 Days)', 20000, 3, 60000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-012', 'REF-PAY-2026-012', 'BK-2026-012', 'CL-012', 60000, 'POS Terminal', '2026-06-11', 'Completed', '2026-06-11 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-013', 'BK-REF-013', '2026-06-15', '09:00:00', '17:00:00', 'CL-013', 'Kelechi Onyekwelu', '+234 805 567 8901', 'kelechi@cowrywisegrowth.ng', 'BR-002', 'Art and Tech Hub', 'FAC-005', 'Creative Open Desk', 5, '10:00 AM - 04:00 PM', 22500, 'Cash', 5, 0, 'Expired', 'USR-001', '2026-06-15 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-013', 'Creative Open Desk Pass (5 Days)', 4500, 5, 22500);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-013', 'REF-PAY-2026-013', 'BK-2026-013', 'CL-013', 22500, 'Cash', '2026-06-15', 'Completed', '2026-06-15 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-014', 'BK-REF-014', '2026-06-18', '09:00:00', '17:00:00', 'CL-014', 'Simisola Fashola', '+234 807 678 9012', 'simisola.fashola@altschoolafrica.ng', 'BR-002', 'Art and Tech Hub', 'FAC-006', 'Private Studio Office', 10, '09:00 AM - 01:00 PM', 400000, 'Credit Card', 10, 0, 'Expired', 'USR-001', '2026-06-18 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-014', 'Private Studio Office Pass (10 Days)', 40000, 10, 400000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-014', 'REF-PAY-2026-014', 'BK-2026-014', 'CL-014', 400000, 'Credit Card', '2026-06-18', 'Completed', '2026-06-18 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-015', 'BK-REF-015', '2026-06-22', '09:00:00', '17:00:00', 'CL-015', 'Obinna Nnamani', '+234 809 789 0123', 'obinna.nnamani@reliancehealth.ng', 'BR-002', 'Art and Tech Hub', 'FAC-007', 'Podcast & Audio Lab', 10, '01:00 PM - 06:00 PM', 250000, 'Corporate Billing', 10, 0, 'Expired', 'USR-001', '2026-06-22 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-015', 'Podcast & Audio Lab Pass (10 Days)', 25000, 10, 250000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-015', 'REF-PAY-2026-015', 'BK-2026-015', 'CL-015', 250000, 'Corporate Billing', '2026-06-22', 'Completed', '2026-06-22 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-016', 'BK-REF-016', '2026-06-25', '09:00:00', '17:00:00', 'CL-016', 'Aisha Mohammed', '+234 810 890 1234', 'aisha.mohammed@stearsdata.ng', 'BR-002', 'Art and Tech Hub', 'FAC-008', 'Tech Conference Hall', 1, '09:00 AM - 05:00 PM', 60000, 'Wire Transfer', 1, 0, 'Expired', 'USR-001', '2026-06-25 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-016', 'Tech Conference Hall Pass (1 Day)', 60000, 1, 60000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-016', 'REF-PAY-2026-016', 'BK-2026-016', 'CL-016', 60000, 'Wire Transfer', '2026-06-25', 'Completed', '2026-06-25 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-017', 'BK-REF-017', '2026-06-29', '09:00:00', '17:00:00', 'CL-017', 'Femi Balogun', '+234 812 901 2345', 'femi.balogun@techcabal.ng', 'BR-001', 'Hive Hub', 'FAC-001', 'Hot Desk Zone', 2, '08:00 AM - 06:00 PM', 10000, 'POS Terminal', 2, 0, 'Expired', 'USR-001', '2026-06-29 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-017', 'Hot Desk Zone Pass (2 Days)', 5000, 2, 10000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-017', 'REF-PAY-2026-017', 'BK-2026-017', 'CL-017', 10000, 'POS Terminal', '2026-06-29', 'Completed', '2026-06-29 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-018', 'BK-REF-018', '2026-06-30', '09:00:00', '17:00:00', 'CL-018', 'Blessing Jumbo', '+234 814 012 3456', 'blessing.jumbo@investbamboo.ng', 'BR-001', 'Hive Hub', 'FAC-002', 'Dedicated Workstation', 10, '10:00 AM - 04:00 PM', 125000, 'Cash', 0, 0, 'Cancelled', 'USR-001', '2026-06-30 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-018', 'Dedicated Workstation Pass (10 Days)', 12500, 10, 125000);
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-019', 'BK-REF-019', '2026-07-02', '09:00:00', '17:00:00', 'CL-019', 'Tobi Alabi', '+234 816 123 4567', 'tobi.alabi@nombaservices.ng', 'BR-001', 'Hive Hub', 'FAC-003', 'Executive Private Suite', 10, '09:00 AM - 01:00 PM', 450000, 'Credit Card', 10, 0, 'Expired', 'USR-001', '2026-07-02 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-019', 'Executive Private Suite Pass (10 Days)', 45000, 10, 450000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-019', 'REF-PAY-2026-019', 'BK-2026-019', 'CL-019', 450000, 'Credit Card', '2026-07-02', 'Completed', '2026-07-02 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-020', 'BK-REF-020', '2026-07-06', '09:00:00', '17:00:00', 'CL-020', 'Mariam Abubakar', '+234 818 234 5678', 'mariam.abubakar@seamlesshr.ng', 'BR-001', 'Hive Hub', 'FAC-004', 'Collaborative Meeting Room', 2, '01:00 PM - 06:00 PM', 40000, 'Corporate Billing', 2, 0, 'Expired', 'USR-001', '2026-07-06 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-020', 'Collaborative Meeting Room Pass (2 Days)', 20000, 2, 40000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-020', 'REF-PAY-2026-020', 'BK-2026-020', 'CL-020', 40000, 'Corporate Billing', '2026-07-06', 'Completed', '2026-07-06 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-021', 'BK-REF-021', '2026-07-09', '09:00:00', '17:00:00', 'CL-021', 'Chinedu Obi', '+234 803 345 6781', 'chinedu.obi@tradedepot.ng', 'BR-002', 'Art and Tech Hub', 'FAC-005', 'Creative Open Desk', 1, '09:00 AM - 05:00 PM', 4500, 'Wire Transfer', 1, 0, 'Expired', 'USR-001', '2026-07-09 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-021', 'Creative Open Desk Pass (1 Day)', 4500, 1, 4500);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-021', 'REF-PAY-2026-021', 'BK-2026-021', 'CL-021', 4500, 'Wire Transfer', '2026-07-09', 'Completed', '2026-07-09 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-022', 'BK-REF-022', '2026-07-13', '09:00:00', '17:00:00', 'CL-022', 'Ronke Awolowo', '+234 802 456 7892', 'ronke.awolowo@kudastrategy.ng', 'BR-002', 'Art and Tech Hub', 'FAC-006', 'Private Studio Office', 10, '08:00 AM - 06:00 PM', 400000, 'POS Terminal', 10, 0, 'Expired', 'USR-001', '2026-07-13 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-022', 'Private Studio Office Pass (10 Days)', 40000, 10, 400000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-022', 'REF-PAY-2026-022', 'BK-2026-022', 'CL-022', 400000, 'POS Terminal', '2026-07-13', 'Completed', '2026-07-13 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-023', 'BK-REF-023', '2026-07-16', '09:00:00', '17:00:00', 'CL-023', 'Uche Okoye', '+234 805 567 8903', 'uche.okoye@autochek.ng', 'BR-002', 'Art and Tech Hub', 'FAC-007', 'Podcast & Audio Lab', 10, '10:00 AM - 04:00 PM', 250000, 'Cash', 10, 0, 'Expired', 'USR-001', '2026-07-16 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-023', 'Podcast & Audio Lab Pass (10 Days)', 25000, 10, 250000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-023', 'REF-PAY-2026-023', 'BK-2026-023', 'CL-023', 250000, 'Cash', '2026-07-16', 'Completed', '2026-07-16 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-024', 'BK-REF-024', '2026-07-20', '09:00:00', '17:00:00', 'CL-024', 'Fatima Sanusi', '+234 807 678 9014', 'fatima.sanusi@termiisolutions.ng', 'BR-002', 'Art and Tech Hub', 'FAC-008', 'Tech Conference Hall', 3, '09:00 AM - 01:00 PM', 180000, 'Credit Card', 3, 0, 'Expired', 'USR-001', '2026-07-20 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-024', 'Tech Conference Hall Pass (3 Days)', 60000, 3, 180000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-024', 'REF-PAY-2026-024', 'BK-2026-024', 'CL-024', 180000, 'Credit Card', '2026-07-20', 'Completed', '2026-07-20 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-025', 'BK-REF-025', '2026-07-23', '09:00:00', '17:00:00', 'CL-025', 'Kunle Ajayi', '+234 809 789 0125', 'kunle.ajayi@moniepointnetwork.ng', 'BR-001', 'Hive Hub', 'FAC-001', 'Hot Desk Zone', 20, '01:00 PM - 06:00 PM', 100000, 'Corporate Billing', 20, 0, 'Expired', 'USR-001', '2026-07-23 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-025', 'Hot Desk Zone Pass (20 Days)', 5000, 20, 100000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-025', 'REF-PAY-2026-025', 'BK-2026-025', 'CL-025', 100000, 'Corporate Billing', '2026-07-23', 'Completed', '2026-07-23 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-026', 'BK-REF-026', '2026-07-27', '09:00:00', '17:00:00', 'CL-026', 'Efe Omoworare', '+234 810 890 1236', 'efe.omoworare@patriciabrand.ng', 'BR-001', 'Hive Hub', 'FAC-002', 'Dedicated Workstation', 10, '09:00 AM - 05:00 PM', 125000, 'Wire Transfer', 10, 0, 'Expired', 'USR-001', '2026-07-27 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-026', 'Dedicated Workstation Pass (10 Days)', 12500, 10, 125000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-026', 'REF-PAY-2026-026', 'BK-2026-026', 'CL-026', 125000, 'Wire Transfer', '2026-07-27', 'Completed', '2026-07-27 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-027', 'BK-REF-027', '2026-07-28', '09:00:00', '17:00:00', 'CL-027', 'Hadiza Aliyu', '+234 812 901 2347', 'hadiza.aliyu@vendeasefoods.ng', 'BR-001', 'Hive Hub', 'FAC-003', 'Executive Private Suite', 10, '08:00 AM - 06:00 PM', 450000, 'POS Terminal', 10, 0, 'Expired', 'USR-001', '2026-07-28 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-027', 'Executive Private Suite Pass (10 Days)', 45000, 10, 450000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-027', 'REF-PAY-2026-027', 'BK-2026-027', 'CL-027', 450000, 'POS Terminal', '2026-07-28', 'Completed', '2026-07-28 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-028', 'BK-REF-028', '2026-07-29', '09:00:00', '17:00:00', 'CL-028', 'Nonso Madu', '+234 814 012 3458', 'nonso.madu@lemfiremit.ng', 'BR-001', 'Hive Hub', 'FAC-004', 'Collaborative Meeting Room', 1, '10:00 AM - 04:00 PM', 20000, 'Cash', 1, 0, 'Expired', 'USR-001', '2026-07-29 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-028', 'Collaborative Meeting Room Pass (1 Day)', 20000, 1, 20000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-028', 'REF-PAY-2026-028', 'BK-2026-028', 'CL-028', 20000, 'Cash', '2026-07-29', 'Completed', '2026-07-29 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-029', 'BK-REF-029', '2026-07-30', '09:00:00', '17:00:00', 'CL-029', 'Yetunde Oladipo', '+234 816 123 4569', 'yetunde.oladipo@moovefleet.ng', 'BR-002', 'Art and Tech Hub', 'FAC-005', 'Creative Open Desk', 10, '09:00 AM - 01:00 PM', 45000, 'Credit Card', 10, 0, 'Expired', 'USR-001', '2026-07-30 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-029', 'Creative Open Desk Pass (10 Days)', 4500, 10, 45000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-029', 'REF-PAY-2026-029', 'BK-2026-029', 'CL-029', 45000, 'Credit Card', '2026-07-30', 'Completed', '2026-07-30 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-030', 'BK-REF-030', '2026-07-31', '09:00:00', '17:00:00', 'CL-030', 'Tariro Akindele', '+234 818 234 5670', 'tariro.akindele@chowdeckfleet.ng', 'BR-002', 'Art and Tech Hub', 'FAC-006', 'Private Studio Office', 10, '01:00 PM - 06:00 PM', 400000, 'Corporate Billing', 10, 0, 'Expired', 'USR-001', '2026-07-31 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-030', 'Private Studio Office Pass (10 Days)', 40000, 10, 400000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-030', 'REF-PAY-2026-030', 'BK-2026-030', 'CL-030', 400000, 'Corporate Billing', '2026-07-31', 'Completed', '2026-07-31 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-031', 'BK-REF-031', '2026-08-03', '09:00:00', '17:00:00', 'CL-031', 'Osas Ighodaro', '+234 803 345 6782', 'osas.ighodaro@getanchor.ng', 'BR-002', 'Art and Tech Hub', 'FAC-007', 'Podcast & Audio Lab', 10, '09:00 AM - 05:00 PM', 250000, 'Wire Transfer', 10, 0, 'Expired', 'USR-001', '2026-08-03 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-031', 'Podcast & Audio Lab Pass (10 Days)', 25000, 10, 250000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-031', 'REF-PAY-2026-031', 'BK-2026-031', 'CL-031', 250000, 'Wire Transfer', '2026-08-03', 'Completed', '2026-08-03 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-032', 'BK-REF-032', '2026-08-05', '09:00:00', '17:00:00', 'CL-032', 'Nkechi Nwankwo', '+234 802 456 7893', 'nkechi.nwankwo@remedialhealth.ng', 'BR-002', 'Art and Tech Hub', 'FAC-008', 'Tech Conference Hall', 2, '08:00 AM - 06:00 PM', 120000, 'POS Terminal', 2, 0, 'Expired', 'USR-001', '2026-08-05 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-032', 'Tech Conference Hall Pass (2 Days)', 60000, 2, 120000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-032', 'REF-PAY-2026-032', 'BK-2026-032', 'CL-032', 120000, 'POS Terminal', '2026-08-05', 'Completed', '2026-08-05 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-033', 'BK-REF-033', '2026-08-07', '09:00:00', '17:00:00', 'CL-033', 'Yusuf Garba', '+234 805 567 8904', 'yusuf.garba@sabidistribution.ng', 'BR-001', 'Hive Hub', 'FAC-001', 'Hot Desk Zone', 5, '10:00 AM - 04:00 PM', 25000, 'Cash', 5, 0, 'Expired', 'USR-001', '2026-08-07 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-033', 'Hot Desk Zone Pass (5 Days)', 5000, 5, 25000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-033', 'REF-PAY-2026-033', 'BK-2026-033', 'CL-033', 25000, 'Cash', '2026-08-07', 'Completed', '2026-08-07 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-034', 'BK-REF-034', '2026-08-10', '09:00:00', '17:00:00', 'CL-001', 'Babatunde Adeyemi', '+234 803 111 2233', 'babatunde.adeyemi@paystackalumni.ng', 'BR-001', 'Hive Hub', 'FAC-002', 'Dedicated Workstation', 10, '09:00 AM - 01:00 PM', 125000, 'Credit Card', 10, 0, 'Expired', 'USR-001', '2026-08-10 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-034', 'Dedicated Workstation Pass (10 Days)', 12500, 10, 125000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-034', 'REF-PAY-2026-034', 'BK-2026-034', 'CL-001', 125000, 'Credit Card', '2026-08-10', 'Completed', '2026-08-10 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-035', 'BK-REF-035', '2026-08-12', '09:00:00', '17:00:00', 'CL-002', 'Chioma Okoli', '+234 802 222 3344', 'chioma.okoli@koracreative.ng', 'BR-001', 'Hive Hub', 'FAC-003', 'Executive Private Suite', 10, '01:00 PM - 06:00 PM', 450000, 'Corporate Billing', 10, 0, 'Expired', 'USR-001', '2026-08-12 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-035', 'Executive Private Suite Pass (10 Days)', 45000, 10, 450000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-035', 'REF-PAY-2026-035', 'BK-2026-035', 'CL-002', 450000, 'Corporate Billing', '2026-08-12', 'Completed', '2026-08-12 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-036', 'BK-REF-036', '2026-08-14', '09:00:00', '17:00:00', 'CL-003', 'Olumide Bakare', '+234 814 333 4455', 'olumide.bakare@venturesplatform.ng', 'BR-001', 'Hive Hub', 'FAC-004', 'Collaborative Meeting Room', 3, '09:00 AM - 05:00 PM', 60000, 'Wire Transfer', 3, 0, 'Expired', 'USR-001', '2026-08-14 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-036', 'Collaborative Meeting Room Pass (3 Days)', 20000, 3, 60000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-036', 'REF-PAY-2026-036', 'BK-2026-036', 'CL-003', 60000, 'Wire Transfer', '2026-08-14', 'Completed', '2026-08-14 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-037', 'BK-REF-037', '2026-08-17', '09:00:00', '17:00:00', 'CL-004', 'Amina Ibrahim', '+234 809 444 5566', 'amina.ibrahim@savannahagri.ng', 'BR-002', 'Art and Tech Hub', 'FAC-005', 'Creative Open Desk', 2, '08:00 AM - 06:00 PM', 9000, 'POS Terminal', 0, 0, 'Cancelled', 'USR-001', '2026-08-17 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-037', 'Creative Open Desk Pass (2 Days)', 4500, 2, 9000);
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-038', 'BK-REF-038', '2026-08-19', '09:00:00', '17:00:00', 'CL-005', 'Chukwuemeka Eze', '+234 805 555 6677', 'c.eze@monopartners.ng', 'BR-002', 'Art and Tech Hub', 'FAC-006', 'Private Studio Office', 10, '10:00 AM - 04:00 PM', 400000, 'Cash', 10, 0, 'Expired', 'USR-001', '2026-08-19 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-038', 'Private Studio Office Pass (10 Days)', 40000, 10, 400000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-038', 'REF-PAY-2026-038', 'BK-2026-038', 'CL-005', 400000, 'Cash', '2026-08-19', 'Completed', '2026-08-19 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-039', 'BK-REF-039', '2026-08-21', '09:00:00', '17:00:00', 'CL-006', 'Folake Adeleke', '+234 818 666 7788', 'folake.adeleke@brass-studio.africa', 'BR-002', 'Art and Tech Hub', 'FAC-007', 'Podcast & Audio Lab', 10, '09:00 AM - 01:00 PM', 250000, 'Credit Card', 10, 0, 'Expired', 'USR-001', '2026-08-21 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-039', 'Podcast & Audio Lab Pass (10 Days)', 25000, 10, 250000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-039', 'REF-PAY-2026-039', 'BK-2026-039', 'CL-006', 250000, 'Credit Card', '2026-08-21', 'Completed', '2026-08-21 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-040', 'BK-REF-040', '2026-08-24', '09:00:00', '17:00:00', 'CL-007', 'Temitope Ogunleye', '+234 807 777 8899', 'temitope.ogunleye@designguild.ng', 'BR-002', 'Art and Tech Hub', 'FAC-008', 'Tech Conference Hall', 1, '01:00 PM - 06:00 PM', 60000, 'Corporate Billing', 1, 0, 'Expired', 'USR-001', '2026-08-24 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-040', 'Tech Conference Hall Pass (1 Day)', 60000, 1, 60000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-040', 'REF-PAY-2026-040', 'BK-2026-040', 'CL-007', 60000, 'Corporate Billing', '2026-08-24', 'Completed', '2026-08-24 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-041', 'BK-REF-041', '2026-08-26', '09:00:00', '17:00:00', 'CL-008', 'Zainab Bello', '+234 811 888 9900', 'zainab.bello@wealthlabs.ng', 'BR-001', 'Hive Hub', 'FAC-001', 'Hot Desk Zone', 1, '09:00 AM - 05:00 PM', 5000, 'Wire Transfer', 1, 0, 'Expired', 'USR-001', '2026-08-26 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-041', 'Hot Desk Zone Pass (1 Day)', 5000, 1, 5000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-041', 'REF-PAY-2026-041', 'BK-2026-041', 'CL-008', 5000, 'Wire Transfer', '2026-08-26', 'Completed', '2026-08-26 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-042', 'BK-REF-042', '2026-08-27', '09:00:00', '17:00:00', 'CL-009', 'Ifeanyi Nwosu', '+234 813 999 0011', 'ifeanyi.nwosu@risevestlabs.ng', 'BR-001', 'Hive Hub', 'FAC-002', 'Dedicated Workstation', 10, '08:00 AM - 06:00 PM', 125000, 'POS Terminal', 10, 0, 'Expired', 'USR-001', '2026-08-27 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-042', 'Dedicated Workstation Pass (10 Days)', 12500, 10, 125000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-042', 'REF-PAY-2026-042', 'BK-2026-042', 'CL-009', 125000, 'POS Terminal', '2026-08-27', 'Completed', '2026-08-27 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-043', 'BK-REF-043', '2026-08-28', '09:00:00', '17:00:00', 'CL-010', 'Ngozi Adeleke', '+234 816 111 0022', 'ngozi.adeleke@zikokomedia.ng', 'BR-001', 'Hive Hub', 'FAC-003', 'Executive Private Suite', 10, '10:00 AM - 04:00 PM', 450000, 'Cash', 10, 0, 'Expired', 'USR-001', '2026-08-28 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-043', 'Executive Private Suite Pass (10 Days)', 45000, 10, 450000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-043', 'REF-PAY-2026-043', 'BK-2026-043', 'CL-010', 450000, 'Cash', '2026-08-28', 'Completed', '2026-08-28 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-044', 'BK-REF-044', '2026-08-29', '09:00:00', '17:00:00', 'CL-011', 'Dapo Osinowo', '+234 802 345 6789', 'dapo.osinowo@edenlifeops.ng', 'BR-001', 'Hive Hub', 'FAC-004', 'Collaborative Meeting Room', 2, '09:00 AM - 01:00 PM', 40000, 'Credit Card', 2, 0, 'Expired', 'USR-001', '2026-08-29 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-044', 'Collaborative Meeting Room Pass (2 Days)', 20000, 2, 40000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-044', 'REF-PAY-2026-044', 'BK-2026-044', 'CL-011', 40000, 'Credit Card', '2026-08-29', 'Completed', '2026-08-29 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-045', 'BK-REF-045', '2026-08-31', '09:00:00', '17:00:00', 'CL-012', 'Halima Danjuma', '+234 803 456 7890', 'halima.danjuma@heliumrecords.ng', 'BR-002', 'Art and Tech Hub', 'FAC-005', 'Creative Open Desk', 20, '01:00 PM - 06:00 PM', 90000, 'Corporate Billing', 20, 0, 'Expired', 'USR-001', '2026-08-31 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-045', 'Creative Open Desk Pass (20 Days)', 4500, 20, 90000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-045', 'REF-PAY-2026-045', 'BK-2026-045', 'CL-012', 90000, 'Corporate Billing', '2026-08-31', 'Completed', '2026-08-31 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-046', 'BK-REF-046', '2026-09-01', '09:00:00', '17:00:00', 'CL-013', 'Kelechi Onyekwelu', '+234 805 567 8901', 'kelechi@cowrywisegrowth.ng', 'BR-002', 'Art and Tech Hub', 'FAC-006', 'Private Studio Office', 10, '09:00 AM - 05:00 PM', 400000, 'Wire Transfer', 10, 0, 'Expired', 'USR-001', '2026-09-01 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-046', 'Private Studio Office Pass (10 Days)', 40000, 10, 400000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-046', 'REF-PAY-2026-046', 'BK-2026-046', 'CL-013', 400000, 'Wire Transfer', '2026-09-01', 'Completed', '2026-09-01 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-047', 'BK-REF-047', '2026-09-03', '09:00:00', '17:00:00', 'CL-014', 'Simisola Fashola', '+234 807 678 9012', 'simisola.fashola@altschoolafrica.ng', 'BR-002', 'Art and Tech Hub', 'FAC-007', 'Podcast & Audio Lab', 10, '08:00 AM - 06:00 PM', 250000, 'POS Terminal', 10, 0, 'Expired', 'USR-001', '2026-09-03 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-047', 'Podcast & Audio Lab Pass (10 Days)', 25000, 10, 250000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-047', 'REF-PAY-2026-047', 'BK-2026-047', 'CL-014', 250000, 'POS Terminal', '2026-09-03', 'Completed', '2026-09-03 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-048', 'BK-REF-048', '2026-09-07', '09:00:00', '17:00:00', 'CL-015', 'Obinna Nnamani', '+234 809 789 0123', 'obinna.nnamani@reliancehealth.ng', 'BR-002', 'Art and Tech Hub', 'FAC-008', 'Tech Conference Hall', 3, '10:00 AM - 04:00 PM', 180000, 'Cash', 3, 0, 'Expired', 'USR-001', '2026-09-07 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-048', 'Tech Conference Hall Pass (3 Days)', 60000, 3, 180000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-048', 'REF-PAY-2026-048', 'BK-2026-048', 'CL-015', 180000, 'Cash', '2026-09-07', 'Completed', '2026-09-07 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-049', 'BK-REF-049', '2026-09-09', '09:00:00', '17:00:00', 'CL-016', 'Aisha Mohammed', '+234 810 890 1234', 'aisha.mohammed@stearsdata.ng', 'BR-001', 'Hive Hub', 'FAC-001', 'Hot Desk Zone', 10, '09:00 AM - 01:00 PM', 50000, 'Credit Card', 10, 0, 'Expired', 'USR-001', '2026-09-09 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-049', 'Hot Desk Zone Pass (10 Days)', 5000, 10, 50000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-049', 'REF-PAY-2026-049', 'BK-2026-049', 'CL-016', 50000, 'Credit Card', '2026-09-09', 'Completed', '2026-09-09 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-050', 'BK-REF-050', '2026-09-11', '09:00:00', '17:00:00', 'CL-017', 'Femi Balogun', '+234 812 901 2345', 'femi.balogun@techcabal.ng', 'BR-001', 'Hive Hub', 'FAC-002', 'Dedicated Workstation', 10, '01:00 PM - 06:00 PM', 125000, 'Corporate Billing', 10, 0, 'Expired', 'USR-001', '2026-09-11 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-050', 'Dedicated Workstation Pass (10 Days)', 12500, 10, 125000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-050', 'REF-PAY-2026-050', 'BK-2026-050', 'CL-017', 125000, 'Corporate Billing', '2026-09-11', 'Completed', '2026-09-11 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-051', 'BK-REF-051', '2026-09-14', '09:00:00', '17:00:00', 'CL-018', 'Blessing Jumbo', '+234 814 012 3456', 'blessing.jumbo@investbamboo.ng', 'BR-001', 'Hive Hub', 'FAC-003', 'Executive Private Suite', 10, '09:00 AM - 05:00 PM', 450000, 'Wire Transfer', 10, 0, 'Expired', 'USR-001', '2026-09-14 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-051', 'Executive Private Suite Pass (10 Days)', 45000, 10, 450000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-051', 'REF-PAY-2026-051', 'BK-2026-051', 'CL-018', 450000, 'Wire Transfer', '2026-09-14', 'Completed', '2026-09-14 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-052', 'BK-REF-052', '2026-09-16', '09:00:00', '17:00:00', 'CL-019', 'Tobi Alabi', '+234 816 123 4567', 'tobi.alabi@nombaservices.ng', 'BR-001', 'Hive Hub', 'FAC-004', 'Collaborative Meeting Room', 1, '08:00 AM - 06:00 PM', 20000, 'POS Terminal', 1, 0, 'Expired', 'USR-001', '2026-09-16 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-052', 'Collaborative Meeting Room Pass (1 Day)', 20000, 1, 20000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-052', 'REF-PAY-2026-052', 'BK-2026-052', 'CL-019', 20000, 'POS Terminal', '2026-09-16', 'Completed', '2026-09-16 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-053', 'BK-REF-053', '2026-09-18', '09:00:00', '17:00:00', 'CL-020', 'Mariam Abubakar', '+234 818 234 5678', 'mariam.abubakar@seamlesshr.ng', 'BR-002', 'Art and Tech Hub', 'FAC-005', 'Creative Open Desk', 5, '10:00 AM - 04:00 PM', 22500, 'Cash', 5, 0, 'Expired', 'USR-001', '2026-09-18 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-053', 'Creative Open Desk Pass (5 Days)', 4500, 5, 22500);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-053', 'REF-PAY-2026-053', 'BK-2026-053', 'CL-020', 22500, 'Cash', '2026-09-18', 'Completed', '2026-09-18 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-054', 'BK-REF-054', '2026-09-21', '09:00:00', '17:00:00', 'CL-021', 'Chinedu Obi', '+234 803 345 6781', 'chinedu.obi@tradedepot.ng', 'BR-002', 'Art and Tech Hub', 'FAC-006', 'Private Studio Office', 10, '09:00 AM - 01:00 PM', 400000, 'Credit Card', 10, 0, 'Expired', 'USR-001', '2026-09-21 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-054', 'Private Studio Office Pass (10 Days)', 40000, 10, 400000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-054', 'REF-PAY-2026-054', 'BK-2026-054', 'CL-021', 400000, 'Credit Card', '2026-09-21', 'Completed', '2026-09-21 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-055', 'BK-REF-055', '2026-09-22', '09:00:00', '17:00:00', 'CL-022', 'Ronke Awolowo', '+234 802 456 7892', 'ronke.awolowo@kudastrategy.ng', 'BR-002', 'Art and Tech Hub', 'FAC-007', 'Podcast & Audio Lab', 10, '01:00 PM - 06:00 PM', 250000, 'Corporate Billing', 10, 0, 'Expired', 'USR-001', '2026-09-22 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-055', 'Podcast & Audio Lab Pass (10 Days)', 25000, 10, 250000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-055', 'REF-PAY-2026-055', 'BK-2026-055', 'CL-022', 250000, 'Corporate Billing', '2026-09-22', 'Completed', '2026-09-22 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-056', 'BK-REF-056', '2026-09-23', '09:00:00', '17:00:00', 'CL-023', 'Uche Okoye', '+234 805 567 8903', 'uche.okoye@autochek.ng', 'BR-002', 'Art and Tech Hub', 'FAC-008', 'Tech Conference Hall', 2, '09:00 AM - 05:00 PM', 120000, 'Wire Transfer', 2, 0, 'Expired', 'USR-001', '2026-09-23 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-056', 'Tech Conference Hall Pass (2 Days)', 60000, 2, 120000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-056', 'REF-PAY-2026-056', 'BK-2026-056', 'CL-023', 120000, 'Wire Transfer', '2026-09-23', 'Completed', '2026-09-23 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-057', 'BK-REF-057', '2026-09-24', '09:00:00', '17:00:00', 'CL-024', 'Fatima Sanusi', '+234 807 678 9014', 'fatima.sanusi@termiisolutions.ng', 'BR-001', 'Hive Hub', 'FAC-001', 'Hot Desk Zone', 2, '08:00 AM - 06:00 PM', 10000, 'POS Terminal', 2, 0, 'Expired', 'USR-001', '2026-09-24 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-057', 'Hot Desk Zone Pass (2 Days)', 5000, 2, 10000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-057', 'REF-PAY-2026-057', 'BK-2026-057', 'CL-024', 10000, 'POS Terminal', '2026-09-24', 'Completed', '2026-09-24 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-058', 'BK-REF-058', '2026-09-25', '09:00:00', '17:00:00', 'CL-025', 'Kunle Ajayi', '+234 809 789 0125', 'kunle.ajayi@moniepointnetwork.ng', 'BR-001', 'Hive Hub', 'FAC-002', 'Dedicated Workstation', 10, '10:00 AM - 04:00 PM', 125000, 'Cash', 10, 0, 'Expired', 'USR-001', '2026-09-25 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-058', 'Dedicated Workstation Pass (10 Days)', 12500, 10, 125000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-058', 'REF-PAY-2026-058', 'BK-2026-058', 'CL-025', 125000, 'Cash', '2026-09-25', 'Completed', '2026-09-25 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-059', 'BK-REF-059', '2026-09-28', '09:00:00', '17:00:00', 'CL-026', 'Efe Omoworare', '+234 810 890 1236', 'efe.omoworare@patriciabrand.ng', 'BR-001', 'Hive Hub', 'FAC-003', 'Executive Private Suite', 10, '09:00 AM - 01:00 PM', 450000, 'Credit Card', 10, 0, 'Expired', 'USR-001', '2026-09-28 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-059', 'Executive Private Suite Pass (10 Days)', 45000, 10, 450000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-059', 'REF-PAY-2026-059', 'BK-2026-059', 'CL-026', 450000, 'Credit Card', '2026-09-28', 'Completed', '2026-09-28 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-060', 'BK-REF-060', '2026-09-29', '09:00:00', '17:00:00', 'CL-027', 'Hadiza Aliyu', '+234 812 901 2347', 'hadiza.aliyu@vendeasefoods.ng', 'BR-001', 'Hive Hub', 'FAC-004', 'Collaborative Meeting Room', 3, '01:00 PM - 06:00 PM', 60000, 'Corporate Billing', 3, 0, 'Expired', 'USR-001', '2026-09-29 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-060', 'Collaborative Meeting Room Pass (3 Days)', 20000, 3, 60000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-060', 'REF-PAY-2026-060', 'BK-2026-060', 'CL-027', 60000, 'Corporate Billing', '2026-09-29', 'Completed', '2026-09-29 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-061', 'BK-REF-061', '2026-09-30', '09:00:00', '17:00:00', 'CL-028', 'Nonso Madu', '+234 814 012 3458', 'nonso.madu@lemfiremit.ng', 'BR-002', 'Art and Tech Hub', 'FAC-005', 'Creative Open Desk', 1, '09:00 AM - 05:00 PM', 4500, 'Wire Transfer', 1, 0, 'Expired', 'USR-001', '2026-09-30 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-061', 'Creative Open Desk Pass (1 Day)', 4500, 1, 4500);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-061', 'REF-PAY-2026-061', 'BK-2026-061', 'CL-028', 4500, 'Wire Transfer', '2026-09-30', 'Completed', '2026-09-30 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-062', 'BK-REF-062', '2026-09-30', '09:00:00', '17:00:00', 'CL-029', 'Yetunde Oladipo', '+234 816 123 4569', 'yetunde.oladipo@moovefleet.ng', 'BR-002', 'Art and Tech Hub', 'FAC-006', 'Private Studio Office', 10, '08:00 AM - 06:00 PM', 400000, 'POS Terminal', 0, 0, 'Cancelled', 'USR-001', '2026-09-30 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-062', 'Private Studio Office Pass (10 Days)', 40000, 10, 400000);
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-063', 'BK-REF-063', '2026-09-30', '09:00:00', '17:00:00', 'CL-030', 'Tariro Akindele', '+234 818 234 5670', 'tariro.akindele@chowdeckfleet.ng', 'BR-002', 'Art and Tech Hub', 'FAC-007', 'Podcast & Audio Lab', 10, '10:00 AM - 04:00 PM', 250000, 'Cash', 10, 0, 'Expired', 'USR-001', '2026-09-30 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-063', 'Podcast & Audio Lab Pass (10 Days)', 25000, 10, 250000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-063', 'REF-PAY-2026-063', 'BK-2026-063', 'CL-030', 250000, 'Cash', '2026-09-30', 'Completed', '2026-09-30 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-064', 'BK-REF-064', '2026-10-01', '09:00:00', '17:00:00', 'CL-031', 'Osas Ighodaro', '+234 803 345 6782', 'osas.ighodaro@getanchor.ng', 'BR-002', 'Art and Tech Hub', 'FAC-008', 'Tech Conference Hall', 1, '09:00 AM - 01:00 PM', 60000, 'Credit Card', 1, 0, 'Active', 'USR-001', '2026-10-01 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-064', 'Tech Conference Hall Pass (1 Day)', 60000, 1, 60000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-064', 'REF-PAY-2026-064', 'BK-2026-064', 'CL-031', 60000, 'Credit Card', '2026-10-01', 'Completed', '2026-10-01 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-065', 'BK-REF-065', '2026-10-02', '09:00:00', '17:00:00', 'CL-032', 'Nkechi Nwankwo', '+234 802 456 7893', 'nkechi.nwankwo@remedialhealth.ng', 'BR-001', 'Hive Hub', 'FAC-001', 'Hot Desk Zone', 20, '01:00 PM - 06:00 PM', 100000, 'Corporate Billing', 12, 8, 'Active', 'USR-001', '2026-10-02 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-065', 'Hot Desk Zone Pass (20 Days)', 5000, 20, 100000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-065', 'REF-PAY-2026-065', 'BK-2026-065', 'CL-032', 100000, 'Corporate Billing', '2026-10-02', 'Completed', '2026-10-02 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-066', 'BK-REF-066', '2026-10-05', '09:00:00', '17:00:00', 'CL-033', 'Yusuf Garba', '+234 805 567 8904', 'yusuf.garba@sabidistribution.ng', 'BR-001', 'Hive Hub', 'FAC-002', 'Dedicated Workstation', 10, '09:00 AM - 05:00 PM', 125000, 'Wire Transfer', 6, 4, 'Active', 'USR-001', '2026-10-05 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-066', 'Dedicated Workstation Pass (10 Days)', 12500, 10, 125000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-066', 'REF-PAY-2026-066', 'BK-2026-066', 'CL-033', 125000, 'Wire Transfer', '2026-10-05', 'Completed', '2026-10-05 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-067', 'BK-REF-067', '2026-10-06', '09:00:00', '17:00:00', 'CL-001', 'Babatunde Adeyemi', '+234 803 111 2233', 'babatunde.adeyemi@paystackalumni.ng', 'BR-001', 'Hive Hub', 'FAC-003', 'Executive Private Suite', 10, '08:00 AM - 06:00 PM', 450000, 'POS Terminal', 6, 4, 'Active', 'USR-001', '2026-10-06 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-067', 'Executive Private Suite Pass (10 Days)', 45000, 10, 450000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-067', 'REF-PAY-2026-067', 'BK-2026-067', 'CL-001', 450000, 'POS Terminal', '2026-10-06', 'Completed', '2026-10-06 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-068', 'BK-REF-068', '2026-10-07', '09:00:00', '17:00:00', 'CL-002', 'Chioma Okoli', '+234 802 222 3344', 'chioma.okoli@koracreative.ng', 'BR-001', 'Hive Hub', 'FAC-004', 'Collaborative Meeting Room', 2, '10:00 AM - 04:00 PM', 40000, 'Cash', 1, 1, 'Active', 'USR-001', '2026-10-07 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-068', 'Collaborative Meeting Room Pass (2 Days)', 20000, 2, 40000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-068', 'REF-PAY-2026-068', 'BK-2026-068', 'CL-002', 40000, 'Cash', '2026-10-07', 'Completed', '2026-10-07 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-069', 'BK-REF-069', '2026-10-08', '09:00:00', '17:00:00', 'CL-003', 'Olumide Bakare', '+234 814 333 4455', 'olumide.bakare@venturesplatform.ng', 'BR-002', 'Art and Tech Hub', 'FAC-005', 'Creative Open Desk', 10, '09:00 AM - 01:00 PM', 45000, 'Credit Card', 6, 4, 'Active', 'USR-001', '2026-10-08 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-069', 'Creative Open Desk Pass (10 Days)', 4500, 10, 45000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-069', 'REF-PAY-2026-069', 'BK-2026-069', 'CL-003', 45000, 'Credit Card', '2026-10-08', 'Completed', '2026-10-08 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-070', 'BK-REF-070', '2026-10-09', '09:00:00', '17:00:00', 'CL-004', 'Amina Ibrahim', '+234 809 444 5566', 'amina.ibrahim@savannahagri.ng', 'BR-002', 'Art and Tech Hub', 'FAC-006', 'Private Studio Office', 10, '01:00 PM - 06:00 PM', 400000, 'Corporate Billing', 6, 4, 'Active', 'USR-001', '2026-10-09 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-070', 'Private Studio Office Pass (10 Days)', 40000, 10, 400000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-070', 'REF-PAY-2026-070', 'BK-2026-070', 'CL-004', 400000, 'Corporate Billing', '2026-10-09', 'Completed', '2026-10-09 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-071', 'BK-REF-071', '2026-10-12', '09:00:00', '17:00:00', 'CL-005', 'Chukwuemeka Eze', '+234 805 555 6677', 'c.eze@monopartners.ng', 'BR-002', 'Art and Tech Hub', 'FAC-007', 'Podcast & Audio Lab', 10, '09:00 AM - 05:00 PM', 250000, 'Wire Transfer', 6, 4, 'Active', 'USR-001', '2026-10-12 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-071', 'Podcast & Audio Lab Pass (10 Days)', 25000, 10, 250000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-071', 'REF-PAY-2026-071', 'BK-2026-071', 'CL-005', 250000, 'Wire Transfer', '2026-10-12', 'Completed', '2026-10-12 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-072', 'BK-REF-072', '2026-10-13', '09:00:00', '17:00:00', 'CL-006', 'Folake Adeleke', '+234 818 666 7788', 'folake.adeleke@brass-studio.africa', 'BR-002', 'Art and Tech Hub', 'FAC-008', 'Tech Conference Hall', 3, '08:00 AM - 06:00 PM', 180000, 'POS Terminal', 1, 2, 'Active', 'USR-001', '2026-10-13 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-072', 'Tech Conference Hall Pass (3 Days)', 60000, 3, 180000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-072', 'REF-PAY-2026-072', 'BK-2026-072', 'CL-006', 180000, 'POS Terminal', '2026-10-13', 'Completed', '2026-10-13 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-073', 'BK-REF-073', '2026-10-14', '09:00:00', '17:00:00', 'CL-007', 'Temitope Ogunleye', '+234 807 777 8899', 'temitope.ogunleye@designguild.ng', 'BR-001', 'Hive Hub', 'FAC-001', 'Hot Desk Zone', 5, '10:00 AM - 04:00 PM', 25000, 'Cash', 3, 2, 'Active', 'USR-001', '2026-10-14 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-073', 'Hot Desk Zone Pass (5 Days)', 5000, 5, 25000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-073', 'REF-PAY-2026-073', 'BK-2026-073', 'CL-007', 25000, 'Cash', '2026-10-14', 'Completed', '2026-10-14 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-074', 'BK-REF-074', '2026-10-15', '09:00:00', '17:00:00', 'CL-008', 'Zainab Bello', '+234 811 888 9900', 'zainab.bello@wealthlabs.ng', 'BR-001', 'Hive Hub', 'FAC-002', 'Dedicated Workstation', 10, '09:00 AM - 01:00 PM', 125000, 'Credit Card', 6, 4, 'Active', 'USR-001', '2026-10-15 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-074', 'Dedicated Workstation Pass (10 Days)', 12500, 10, 125000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-074', 'REF-PAY-2026-074', 'BK-2026-074', 'CL-008', 125000, 'Credit Card', '2026-10-15', 'Completed', '2026-10-15 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-075', 'BK-REF-075', '2026-10-16', '09:00:00', '17:00:00', 'CL-009', 'Ifeanyi Nwosu', '+234 813 999 0011', 'ifeanyi.nwosu@risevestlabs.ng', 'BR-001', 'Hive Hub', 'FAC-003', 'Executive Private Suite', 10, '01:00 PM - 06:00 PM', 450000, 'Corporate Billing', 6, 4, 'Active', 'USR-001', '2026-10-16 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-075', 'Executive Private Suite Pass (10 Days)', 45000, 10, 450000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-075', 'REF-PAY-2026-075', 'BK-2026-075', 'CL-009', 450000, 'Corporate Billing', '2026-10-16', 'Completed', '2026-10-16 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-076', 'BK-REF-076', '2026-10-19', '09:00:00', '17:00:00', 'CL-010', 'Ngozi Adeleke', '+234 816 111 0022', 'ngozi.adeleke@zikokomedia.ng', 'BR-001', 'Hive Hub', 'FAC-004', 'Collaborative Meeting Room', 1, '09:00 AM - 05:00 PM', 20000, 'Wire Transfer', 1, 0, 'Active', 'USR-001', '2026-10-19 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-076', 'Collaborative Meeting Room Pass (1 Day)', 20000, 1, 20000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-076', 'REF-PAY-2026-076', 'BK-2026-076', 'CL-010', 20000, 'Wire Transfer', '2026-10-19', 'Completed', '2026-10-19 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-077', 'BK-REF-077', '2026-10-20', '09:00:00', '17:00:00', 'CL-011', 'Dapo Osinowo', '+234 802 345 6789', 'dapo.osinowo@edenlifeops.ng', 'BR-002', 'Art and Tech Hub', 'FAC-005', 'Creative Open Desk', 2, '08:00 AM - 06:00 PM', 9000, 'POS Terminal', 1, 1, 'Active', 'USR-001', '2026-10-20 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-077', 'Creative Open Desk Pass (2 Days)', 4500, 2, 9000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-077', 'REF-PAY-2026-077', 'BK-2026-077', 'CL-011', 9000, 'POS Terminal', '2026-10-20', 'Completed', '2026-10-20 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-078', 'BK-REF-078', '2026-10-21', '09:00:00', '17:00:00', 'CL-012', 'Halima Danjuma', '+234 803 456 7890', 'halima.danjuma@heliumrecords.ng', 'BR-002', 'Art and Tech Hub', 'FAC-006', 'Private Studio Office', 10, '10:00 AM - 04:00 PM', 400000, 'Cash', 6, 4, 'Active', 'USR-001', '2026-10-21 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-078', 'Private Studio Office Pass (10 Days)', 40000, 10, 400000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-078', 'REF-PAY-2026-078', 'BK-2026-078', 'CL-012', 400000, 'Cash', '2026-10-21', 'Completed', '2026-10-21 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-079', 'BK-REF-079', '2026-10-21', '09:00:00', '17:00:00', 'CL-013', 'Kelechi Onyekwelu', '+234 805 567 8901', 'kelechi@cowrywisegrowth.ng', 'BR-002', 'Art and Tech Hub', 'FAC-007', 'Podcast & Audio Lab', 10, '09:00 AM - 01:00 PM', 250000, 'Credit Card', 6, 4, 'Active', 'USR-001', '2026-10-21 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-079', 'Podcast & Audio Lab Pass (10 Days)', 25000, 10, 250000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-079', 'REF-PAY-2026-079', 'BK-2026-079', 'CL-013', 250000, 'Credit Card', '2026-10-21', 'Completed', '2026-10-21 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-080', 'BK-REF-080', '2026-10-22', '09:00:00', '17:00:00', 'CL-014', 'Simisola Fashola', '+234 807 678 9012', 'simisola.fashola@altschoolafrica.ng', 'BR-002', 'Art and Tech Hub', 'FAC-008', 'Tech Conference Hall', 2, '01:00 PM - 06:00 PM', 120000, 'Corporate Billing', 1, 1, 'Active', 'USR-001', '2026-10-22 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-080', 'Tech Conference Hall Pass (2 Days)', 60000, 2, 120000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-080', 'REF-PAY-2026-080', 'BK-2026-080', 'CL-014', 120000, 'Corporate Billing', '2026-10-22', 'Completed', '2026-10-22 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-081', 'BK-REF-081', '2026-10-22', '09:00:00', '17:00:00', 'CL-015', 'Obinna Nnamani', '+234 809 789 0123', 'obinna.nnamani@reliancehealth.ng', 'BR-001', 'Hive Hub', 'FAC-001', 'Hot Desk Zone', 1, '09:00 AM - 05:00 PM', 5000, 'Wire Transfer', 1, 0, 'Active', 'USR-001', '2026-10-22 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-081', 'Hot Desk Zone Pass (1 Day)', 5000, 1, 5000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-081', 'REF-PAY-2026-081', 'BK-2026-081', 'CL-015', 5000, 'Wire Transfer', '2026-10-22', 'Completed', '2026-10-22 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-082', 'BK-REF-082', '2026-10-23', '09:00:00', '17:00:00', 'CL-016', 'Aisha Mohammed', '+234 810 890 1234', 'aisha.mohammed@stearsdata.ng', 'BR-001', 'Hive Hub', 'FAC-002', 'Dedicated Workstation', 10, '08:00 AM - 06:00 PM', 125000, 'POS Terminal', 6, 4, 'Active', 'USR-001', '2026-10-23 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-082', 'Dedicated Workstation Pass (10 Days)', 12500, 10, 125000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-082', 'REF-PAY-2026-082', 'BK-2026-082', 'CL-016', 125000, 'POS Terminal', '2026-10-23', 'Completed', '2026-10-23 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-083', 'BK-REF-083', '2026-10-23', '09:00:00', '17:00:00', 'CL-017', 'Femi Balogun', '+234 812 901 2345', 'femi.balogun@techcabal.ng', 'BR-001', 'Hive Hub', 'FAC-003', 'Executive Private Suite', 10, '10:00 AM - 04:00 PM', 450000, 'Cash', 6, 4, 'Active', 'USR-001', '2026-10-23 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-083', 'Executive Private Suite Pass (10 Days)', 45000, 10, 450000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-083', 'REF-PAY-2026-083', 'BK-2026-083', 'CL-017', 450000, 'Cash', '2026-10-23', 'Completed', '2026-10-23 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-084', 'BK-REF-084', '2026-10-24', '09:00:00', '17:00:00', 'CL-018', 'Blessing Jumbo', '+234 814 012 3456', 'blessing.jumbo@investbamboo.ng', 'BR-001', 'Hive Hub', 'FAC-004', 'Collaborative Meeting Room', 3, '09:00 AM - 01:00 PM', 60000, 'Credit Card', 1, 2, 'Active', 'USR-001', '2026-10-24 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-084', 'Collaborative Meeting Room Pass (3 Days)', 20000, 3, 60000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-084', 'REF-PAY-2026-084', 'BK-2026-084', 'CL-018', 60000, 'Credit Card', '2026-10-24', 'Completed', '2026-10-24 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-085', 'BK-REF-085', '2026-10-24', '09:00:00', '17:00:00', 'CL-019', 'Tobi Alabi', '+234 816 123 4567', 'tobi.alabi@nombaservices.ng', 'BR-002', 'Art and Tech Hub', 'FAC-005', 'Creative Open Desk', 20, '01:00 PM - 06:00 PM', 90000, 'Corporate Billing', 12, 8, 'Active', 'USR-001', '2026-10-24 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-085', 'Creative Open Desk Pass (20 Days)', 4500, 20, 90000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-085', 'REF-PAY-2026-085', 'BK-2026-085', 'CL-019', 90000, 'Corporate Billing', '2026-10-24', 'Completed', '2026-10-24 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-086', 'BK-REF-086', '2026-10-25', '09:00:00', '17:00:00', 'CL-020', 'Mariam Abubakar', '+234 818 234 5678', 'mariam.abubakar@seamlesshr.ng', 'BR-002', 'Art and Tech Hub', 'FAC-006', 'Private Studio Office', 10, '09:00 AM - 05:00 PM', 400000, 'Wire Transfer', 6, 4, 'Active', 'USR-001', '2026-10-25 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-086', 'Private Studio Office Pass (10 Days)', 40000, 10, 400000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-086', 'REF-PAY-2026-086', 'BK-2026-086', 'CL-020', 400000, 'Wire Transfer', '2026-10-25', 'Completed', '2026-10-25 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-087', 'BK-REF-087', '2026-10-26', '09:00:00', '17:00:00', 'CL-021', 'Chinedu Obi', '+234 803 345 6781', 'chinedu.obi@tradedepot.ng', 'BR-002', 'Art and Tech Hub', 'FAC-007', 'Podcast & Audio Lab', 10, '08:00 AM - 06:00 PM', 250000, 'POS Terminal', 6, 4, 'Active', 'USR-001', '2026-10-26 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-087', 'Podcast & Audio Lab Pass (10 Days)', 25000, 10, 250000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-087', 'REF-PAY-2026-087', 'BK-2026-087', 'CL-021', 250000, 'POS Terminal', '2026-10-26', 'Completed', '2026-10-26 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-088', 'BK-REF-088', '2026-10-26', '09:00:00', '17:00:00', 'CL-022', 'Ronke Awolowo', '+234 802 456 7892', 'ronke.awolowo@kudastrategy.ng', 'BR-002', 'Art and Tech Hub', 'FAC-008', 'Tech Conference Hall', 1, '10:00 AM - 04:00 PM', 60000, 'Cash', 1, 0, 'Active', 'USR-001', '2026-10-26 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-088', 'Tech Conference Hall Pass (1 Day)', 60000, 1, 60000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-088', 'REF-PAY-2026-088', 'BK-2026-088', 'CL-022', 60000, 'Cash', '2026-10-26', 'Completed', '2026-10-26 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-089', 'BK-REF-089', '2026-10-26', '09:00:00', '17:00:00', 'CL-023', 'Uche Okoye', '+234 805 567 8903', 'uche.okoye@autochek.ng', 'BR-001', 'Hive Hub', 'FAC-001', 'Hot Desk Zone', 10, '09:00 AM - 01:00 PM', 50000, 'Credit Card', 0, 0, 'Cancelled', 'USR-001', '2026-10-26 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-089', 'Hot Desk Zone Pass (10 Days)', 5000, 10, 50000);
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-090', 'BK-REF-090', '2026-10-27', '09:00:00', '17:00:00', 'CL-024', 'Fatima Sanusi', '+234 807 678 9014', 'fatima.sanusi@termiisolutions.ng', 'BR-001', 'Hive Hub', 'FAC-002', 'Dedicated Workstation', 10, '01:00 PM - 06:00 PM', 125000, 'Corporate Billing', 6, 4, 'Active', 'USR-001', '2026-10-27 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-090', 'Dedicated Workstation Pass (10 Days)', 12500, 10, 125000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-090', 'REF-PAY-2026-090', 'BK-2026-090', 'CL-024', 125000, 'Corporate Billing', '2026-10-27', 'Completed', '2026-10-27 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-091', 'BK-REF-091', '2026-10-27', '09:00:00', '17:00:00', 'CL-025', 'Kunle Ajayi', '+234 809 789 0125', 'kunle.ajayi@moniepointnetwork.ng', 'BR-001', 'Hive Hub', 'FAC-003', 'Executive Private Suite', 10, '09:00 AM - 05:00 PM', 450000, 'Wire Transfer', 6, 4, 'Active', 'USR-001', '2026-10-27 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-091', 'Executive Private Suite Pass (10 Days)', 45000, 10, 450000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-091', 'REF-PAY-2026-091', 'BK-2026-091', 'CL-025', 450000, 'Wire Transfer', '2026-10-27', 'Completed', '2026-10-27 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-092', 'BK-REF-092', '2026-10-27', '09:00:00', '17:00:00', 'CL-026', 'Efe Omoworare', '+234 810 890 1236', 'efe.omoworare@patriciabrand.ng', 'BR-001', 'Hive Hub', 'FAC-004', 'Collaborative Meeting Room', 2, '08:00 AM - 06:00 PM', 40000, 'POS Terminal', 1, 1, 'Active', 'USR-001', '2026-10-27 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-092', 'Collaborative Meeting Room Pass (2 Days)', 20000, 2, 40000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-092', 'REF-PAY-2026-092', 'BK-2026-092', 'CL-026', 40000, 'POS Terminal', '2026-10-27', 'Completed', '2026-10-27 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-093', 'BK-REF-093', '2026-10-27', '09:00:00', '17:00:00', 'CL-027', 'Hadiza Aliyu', '+234 812 901 2347', 'hadiza.aliyu@vendeasefoods.ng', 'BR-002', 'Art and Tech Hub', 'FAC-005', 'Creative Open Desk', 5, '10:00 AM - 04:00 PM', 22500, 'Cash', 3, 2, 'Active', 'USR-001', '2026-10-27 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-093', 'Creative Open Desk Pass (5 Days)', 4500, 5, 22500);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-093', 'REF-PAY-2026-093', 'BK-2026-093', 'CL-027', 22500, 'Cash', '2026-10-27', 'Completed', '2026-10-27 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-094', 'BK-REF-094', '2026-10-27', '09:00:00', '17:00:00', 'CL-028', 'Nonso Madu', '+234 814 012 3458', 'nonso.madu@lemfiremit.ng', 'BR-002', 'Art and Tech Hub', 'FAC-006', 'Private Studio Office', 10, '09:00 AM - 01:00 PM', 400000, 'Credit Card', 6, 4, 'Active', 'USR-001', '2026-10-27 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-094', 'Private Studio Office Pass (10 Days)', 40000, 10, 400000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-094', 'REF-PAY-2026-094', 'BK-2026-094', 'CL-028', 400000, 'Credit Card', '2026-10-27', 'Completed', '2026-10-27 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-095', 'BK-REF-095', '2026-10-27', '09:00:00', '17:00:00', 'CL-029', 'Yetunde Oladipo', '+234 816 123 4569', 'yetunde.oladipo@moovefleet.ng', 'BR-002', 'Art and Tech Hub', 'FAC-007', 'Podcast & Audio Lab', 10, '01:00 PM - 06:00 PM', 250000, 'Corporate Billing', 6, 4, 'Active', 'USR-001', '2026-10-27 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-095', 'Podcast & Audio Lab Pass (10 Days)', 25000, 10, 250000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-095', 'REF-PAY-2026-095', 'BK-2026-095', 'CL-029', 250000, 'Corporate Billing', '2026-10-27', 'Completed', '2026-10-27 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-096', 'BK-REF-096', '2026-10-27', '09:00:00', '17:00:00', 'CL-030', 'Tariro Akindele', '+234 818 234 5670', 'tariro.akindele@chowdeckfleet.ng', 'BR-002', 'Art and Tech Hub', 'FAC-008', 'Tech Conference Hall', 3, '09:00 AM - 05:00 PM', 180000, 'Wire Transfer', 1, 2, 'Active', 'USR-001', '2026-10-27 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-096', 'Tech Conference Hall Pass (3 Days)', 60000, 3, 180000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-096', 'REF-PAY-2026-096', 'BK-2026-096', 'CL-030', 180000, 'Wire Transfer', '2026-10-27', 'Completed', '2026-10-27 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-097', 'BK-REF-097', '2026-10-28', '09:00:00', '17:00:00', 'CL-031', 'Osas Ighodaro', '+234 803 345 6782', 'osas.ighodaro@getanchor.ng', 'BR-001', 'Hive Hub', 'FAC-001', 'Hot Desk Zone', 2, '08:00 AM - 06:00 PM', 10000, 'POS Terminal', 0, 2, 'Upcoming', 'USR-001', '2026-10-28 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-097', 'Hot Desk Zone Pass (2 Days)', 5000, 2, 10000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-097', 'REF-PAY-2026-097', 'BK-2026-097', 'CL-031', 10000, 'POS Terminal', '2026-10-28', 'Completed', '2026-10-28 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-098', 'BK-REF-098', '2026-10-29', '09:00:00', '17:00:00', 'CL-032', 'Nkechi Nwankwo', '+234 802 456 7893', 'nkechi.nwankwo@remedialhealth.ng', 'BR-001', 'Hive Hub', 'FAC-002', 'Dedicated Workstation', 10, '10:00 AM - 04:00 PM', 125000, 'Cash', 0, 10, 'Upcoming', 'USR-001', '2026-10-29 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-098', 'Dedicated Workstation Pass (10 Days)', 12500, 10, 125000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-098', 'REF-PAY-2026-098', 'BK-2026-098', 'CL-032', 125000, 'Cash', '2026-10-29', 'Completed', '2026-10-29 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-099', 'BK-REF-099', '2026-10-30', '09:00:00', '17:00:00', 'CL-033', 'Yusuf Garba', '+234 805 567 8904', 'yusuf.garba@sabidistribution.ng', 'BR-001', 'Hive Hub', 'FAC-003', 'Executive Private Suite', 10, '09:00 AM - 01:00 PM', 450000, 'Credit Card', 0, 10, 'Upcoming', 'USR-001', '2026-10-30 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-099', 'Executive Private Suite Pass (10 Days)', 45000, 10, 450000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-099', 'REF-PAY-2026-099', 'BK-2026-099', 'CL-033', 450000, 'Credit Card', '2026-10-30', 'Completed', '2026-10-30 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-100', 'BK-REF-100', '2026-11-02', '09:00:00', '17:00:00', 'CL-001', 'Babatunde Adeyemi', '+234 803 111 2233', 'babatunde.adeyemi@paystackalumni.ng', 'BR-001', 'Hive Hub', 'FAC-004', 'Collaborative Meeting Room', 1, '01:00 PM - 06:00 PM', 20000, 'Corporate Billing', 0, 1, 'Upcoming', 'USR-001', '2026-11-02 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-100', 'Collaborative Meeting Room Pass (1 Day)', 20000, 1, 20000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-100', 'REF-PAY-2026-100', 'BK-2026-100', 'CL-001', 20000, 'Corporate Billing', '2026-11-02', 'Completed', '2026-11-02 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-101', 'BK-REF-101', '2026-11-03', '09:00:00', '17:00:00', 'CL-002', 'Chioma Okoli', '+234 802 222 3344', 'chioma.okoli@koracreative.ng', 'BR-002', 'Art and Tech Hub', 'FAC-005', 'Creative Open Desk', 1, '09:00 AM - 05:00 PM', 4500, 'Wire Transfer', 0, 1, 'Upcoming', 'USR-001', '2026-11-03 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-101', 'Creative Open Desk Pass (1 Day)', 4500, 1, 4500);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-101', 'REF-PAY-2026-101', 'BK-2026-101', 'CL-002', 4500, 'Wire Transfer', '2026-11-03', 'Completed', '2026-11-03 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-102', 'BK-REF-102', '2026-11-05', '09:00:00', '17:00:00', 'CL-003', 'Olumide Bakare', '+234 814 333 4455', 'olumide.bakare@venturesplatform.ng', 'BR-002', 'Art and Tech Hub', 'FAC-006', 'Private Studio Office', 10, '08:00 AM - 06:00 PM', 400000, 'POS Terminal', 0, 10, 'Upcoming', 'USR-001', '2026-11-05 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-102', 'Private Studio Office Pass (10 Days)', 40000, 10, 400000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-102', 'REF-PAY-2026-102', 'BK-2026-102', 'CL-003', 400000, 'POS Terminal', '2026-11-05', 'Completed', '2026-11-05 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-103', 'BK-REF-103', '2026-11-09', '09:00:00', '17:00:00', 'CL-004', 'Amina Ibrahim', '+234 809 444 5566', 'amina.ibrahim@savannahagri.ng', 'BR-002', 'Art and Tech Hub', 'FAC-007', 'Podcast & Audio Lab', 10, '10:00 AM - 04:00 PM', 250000, 'Cash', 0, 10, 'Upcoming', 'USR-001', '2026-11-09 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-103', 'Podcast & Audio Lab Pass (10 Days)', 25000, 10, 250000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-103', 'REF-PAY-2026-103', 'BK-2026-103', 'CL-004', 250000, 'Cash', '2026-11-09', 'Completed', '2026-11-09 08:35:00');
INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('BK-2026-104', 'BK-REF-104', '2026-11-12', '09:00:00', '17:00:00', 'CL-005', 'Chukwuemeka Eze', '+234 805 555 6677', 'c.eze@monopartners.ng', 'BR-002', 'Art and Tech Hub', 'FAC-008', 'Tech Conference Hall', 2, '09:00 AM - 01:00 PM', 120000, 'Credit Card', 0, 2, 'Upcoming', 'USR-001', '2026-11-12 08:30:00');
INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('BK-2026-104', 'Tech Conference Hall Pass (2 Days)', 60000, 2, 120000);
INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('PAY-104', 'REF-PAY-2026-104', 'BK-2026-104', 'CL-005', 120000, 'Credit Card', '2026-11-12', 'Completed', '2026-11-12 08:35:00');

-- ============================================================================
-- 9. ACTIVE & RECURRING SUBSCRIPTIONS
-- ============================================================================
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-001', 'BK-2026-065', 'CL-001', 'FAC-003', 'Executive Private Suite', 'BR-001', 'Hive Hub', '2026-10-01', '2026-10-31', 30, 27, 4, 1350000, 'Wire Transfer', 'Active', '2026-10-01 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-002', 'BK-2026-066', 'CL-002', 'FAC-002', 'Dedicated Workstation', 'BR-001', 'Hive Hub', '2026-10-01', '2026-10-31', 30, 27, 4, 375000, 'Wire Transfer', 'Active', '2026-10-01 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-003', 'BK-2026-067', 'CL-003', 'FAC-004', 'Collaborative Meeting Room', 'BR-001', 'Hive Hub', '2026-10-05', '2026-11-05', 30, 22, 8, 600000, 'Wire Transfer', 'Active', '2026-10-05 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-004', 'BK-2026-068', 'CL-005', 'FAC-003', 'Executive Private Suite', 'BR-001', 'Hive Hub', '2026-10-01', '2026-10-31', 30, 27, 4, 1350000, 'Wire Transfer', 'Active', '2026-10-01 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-005', 'BK-2026-069', 'CL-008', 'FAC-006', 'Private Studio Office', 'BR-002', 'Art and Tech Hub', '2026-10-01', '2026-10-31', 30, 27, 4, 1200000, 'Wire Transfer', 'Active', '2026-10-01 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-006', 'BK-2026-070', 'CL-009', 'FAC-007', 'Podcast & Audio Lab', 'BR-002', 'Art and Tech Hub', '2026-10-08', '2026-10-29', 21, 19, 2, 525000, 'Wire Transfer', 'Expiring Soon', '2026-10-08 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-007', 'BK-2026-071', 'CL-012', 'FAC-002', 'Dedicated Workstation', 'BR-001', 'Hive Hub', '2026-10-10', '2026-11-10', 30, 17, 13, 375000, 'Wire Transfer', 'Active', '2026-10-10 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-008', 'BK-2026-072', 'CL-015', 'FAC-003', 'Executive Private Suite', 'BR-001', 'Hive Hub', '2026-10-01', '2026-10-31', 30, 27, 4, 1350000, 'Wire Transfer', 'Active', '2026-10-01 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-009', 'BK-2026-073', 'CL-018', 'FAC-006', 'Private Studio Office', 'BR-002', 'Art and Tech Hub', '2026-10-01', '2026-10-31', 30, 27, 4, 1200000, 'Wire Transfer', 'Active', '2026-10-01 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-010', 'BK-2026-074', 'CL-025', 'FAC-001', 'Hot Desk Zone', 'BR-001', 'Hive Hub', '2026-10-01', '2026-10-31', 30, 27, 4, 150000, 'Wire Transfer', 'Active', '2026-10-01 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-011', 'BK-2026-075', 'CL-031', 'FAC-005', 'Creative Open Desk', 'BR-002', 'Art and Tech Hub', '2026-10-01', '2026-10-28', 28, 26, 2, 126000, 'Wire Transfer', 'Expiring Soon', '2026-10-01 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-012', 'BK-2026-076', 'CL-032', 'FAC-001', 'Hot Desk Zone', 'BR-001', 'Hive Hub', '2026-09-01', '2026-09-30', 30, 30, 0, 150000, 'Wire Transfer', 'Expired', '2026-09-01 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-013', 'BK-2026-078', 'CL-004', 'FAC-002', 'Dedicated Workstation', 'BR-001', 'Hive Hub', '2026-10-15', '2026-11-15', 30, 12, 18, 375000, 'Wire Transfer', 'Active', '2026-10-15 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-014', 'BK-2026-079', 'CL-006', 'FAC-005', 'Creative Open Desk', 'BR-002', 'Art and Tech Hub', '2026-10-10', '2026-11-10', 30, 17, 13, 135000, 'Wire Transfer', 'Active', '2026-10-10 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-015', 'BK-2026-080', 'CL-010', 'FAC-008', 'Tech Conference Hall', 'BR-002', 'Art and Tech Hub', '2026-10-20', '2026-11-20', 30, 7, 23, 1800000, 'Wire Transfer', 'Active', '2026-10-20 09:00:00');
INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('SUB-016', 'BK-2026-081', 'CL-013', 'FAC-001', 'Hot Desk Zone', 'BR-001', 'Hive Hub', '2026-10-22', '2026-11-22', 30, 5, 25, 150000, 'Wire Transfer', 'Active', '2026-10-22 09:00:00');

-- ============================================================================
-- 10. EXPENSES (36 REALISTIC EXPENSES ACROSS 5 CATEGORIES)
-- ============================================================================
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-001', 'EXP-001', 'Starlink Business Satellite Monthly Renewal', 75000, '2026-05-05', 'BR-001', 'Hive Hub', 'CAT-001', 'Utilities', 'High-speed satellite internet backup line subscription', 'Paid', 'Dominion Adebayo', '2026-05-05 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-002', 'EXP-002', 'MTN Enterprise Fiber Broadband Monthly Fee', 95000, '2026-05-18', 'BR-002', 'Art and Tech Hub', 'CAT-001', 'Utilities', 'Dedicated 100Mbps symmetric business fiber line', 'Paid', 'Dominion Adebayo', '2026-05-18 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-003', 'EXP-003', 'Industrial Water Dispenser 20L Refills (15 bottles)', 32000, '2026-06-08', 'BR-001', 'Hive Hub', 'CAT-001', 'Utilities', 'Pure spring drinking water bottles for hub members', 'Paid', 'Dominion Adebayo', '2026-06-08 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-004', 'EXP-004', 'Starlink Satellite Subscription Renewal', 75000, '2026-06-20', 'BR-002', 'Art and Tech Hub', 'CAT-001', 'Utilities', 'Starlink monthly standard subscription plan', 'Paid', 'Dominion Adebayo', '2026-06-20 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-005', 'EXP-005', 'Municipal Clean Water Utility Bill & Borehole Power', 28000, '2026-07-10', 'BR-001', 'Hive Hub', 'CAT-001', 'Utilities', 'Water treatment and pumping filtration consumables', 'Paid', 'Dominion Adebayo', '2026-07-10 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-006', 'EXP-006', 'MTN 5G Router Data Bundle Subscription', 65000, '2026-08-04', 'BR-001', 'Hive Hub', 'CAT-001', 'Utilities', 'Uncapped 5G business broadband data package', 'Paid', 'Dominion Adebayo', '2026-08-04 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-007', 'EXP-007', 'Starlink Business Satellite High-Performance Renewal', 75000, '2026-09-02', 'BR-001', 'Hive Hub', 'CAT-001', 'Utilities', 'Priority satellite bandwidth monthly billing', 'Paid', 'Dominion Adebayo', '2026-09-02 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-008', 'EXP-008', 'MTN Fiber Broadband Line Renewal', 95000, '2026-10-05', 'BR-002', 'Art and Tech Hub', 'CAT-001', 'Utilities', 'Monthly primary fiber connection renewal', 'Paid', 'Dominion Adebayo', '2026-10-05 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-009', 'EXP-009', 'Water Dispenser Refill & Dispenser Sanitization', 34000, '2026-10-18', 'BR-002', 'Art and Tech Hub', 'CAT-001', 'Utilities', '20L water canister supplies and hot/cold unit maintenance', 'Paid', 'Dominion Adebayo', '2026-10-18 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-010', 'EXP-010', 'Jumbo Restroom Toilet Rolls & Paper Towels Bulk Carton', 38000, '2026-05-12', 'BR-001', 'Hive Hub', 'CAT-002', 'Hygiene', '2-ply embossed jumbo toilet roll packs for executive restrooms', 'Paid', 'Dominion Adebayo', '2026-05-12 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-011', 'EXP-011', 'Automatic Fragrance Diffusers & Refill Canisters', 28500, '2026-06-03', 'BR-002', 'Art and Tech Hub', 'CAT-002', 'Hygiene', 'Citrus and sandalwood fragrance diffuser cartridges', 'Paid', 'Dominion Adebayo', '2026-06-03 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-012', 'EXP-012', 'Surface Disinfectants, Mop Heads & Hand Wash Refills', 42000, '2026-07-14', 'BR-001', 'Hive Hub', 'CAT-002', 'Hygiene', 'Hospital-grade sanitizing liquids, multi-surface cleaners, and soaps', 'Paid', 'Dominion Adebayo', '2026-07-14 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-013', 'EXP-013', 'Toiletries & Restroom Hand Sanitizer Dispensers Pack', 31000, '2026-08-16', 'BR-002', 'Art and Tech Hub', 'CAT-002', 'Hygiene', 'Foam hand wash soap cartridges and touchless dispenser batteries', 'Paid', 'Dominion Adebayo', '2026-08-16 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-014', 'EXP-014', 'Air Freshener Dispensers & Aroma Diffuser Oils', 26000, '2026-09-12', 'BR-001', 'Hive Hub', 'CAT-002', 'Hygiene', 'Aroma essential oils and timed automated mist canisters', 'Paid', 'Dominion Adebayo', '2026-09-12 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-015', 'EXP-015', 'Bulk Toilet Rolls & Kitchenette Cleaning Consumables', 45000, '2026-10-10', 'BR-001', 'Hive Hub', 'CAT-002', 'Hygiene', 'Monthly hygiene replenishment for restrooms and cafe kitchenette', 'Paid', 'Dominion Adebayo', '2026-10-10 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-016', 'EXP-016', 'Air Fresheners and Janitorial Toiletries', 35000, '2026-10-22', 'BR-002', 'Art and Tech Hub', 'CAT-002', 'Hygiene', 'Deep cleaning detergents, sanitizing wipes, and fragrance cans', 'Paid', 'Dominion Adebayo', '2026-10-22 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-017', 'EXP-017', 'Heavy-Duty Surge Protector Extension Sockets (6-way)', 58000, '2026-05-20', 'BR-001', 'Hive Hub', 'CAT-003', 'Equipment', '6 units of 6-way surge-protected extension sockets for flex desks', 'Paid', 'Dominion Adebayo', '2026-05-20 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-018', 'EXP-018', 'Multi-Outlet Desktop Power Strips with USB-C PD Ports', 72000, '2026-06-16', 'BR-002', 'Art and Tech Hub', 'CAT-003', 'Equipment', 'Integrated clamp-on power sockets for dedicated workstations', 'Paid', 'Dominion Adebayo', '2026-06-16 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-019', 'EXP-019', 'Industrial Power Strips & Heavy-Duty Extension Cords', 46000, '2026-07-22', 'BR-001', 'Hive Hub', 'CAT-003', 'Equipment', 'Under-desk cable wire channels and surge protection boxes', 'Paid', 'Dominion Adebayo', '2026-07-22 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-020', 'EXP-020', 'Workstation 65W GaN Multi-Port Laptop Fast Chargers', 84000, '2026-08-20', 'BR-002', 'Art and Tech Hub', 'CAT-003', 'Equipment', 'Replacement universal laptop chargers for customer loaner desk', 'Paid', 'Dominion Adebayo', '2026-08-20 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-021', 'EXP-021', 'Heavy-Duty 10-Way Extension Sockets for Conference Hall', 62000, '2026-09-19', 'BR-002', 'Art and Tech Hub', 'CAT-003', 'Equipment', 'Heavy copper gauge power strips for tech presentation room', 'Paid', 'Dominion Adebayo', '2026-09-19 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-022', 'EXP-022', 'Under-Desk Extension Sockets & Power Strip Cable Trays', 55000, '2026-10-14', 'BR-001', 'Hive Hub', 'CAT-003', 'Equipment', 'Ergonomic cable management power boxes for hot desks', 'Paid', 'Dominion Adebayo', '2026-10-14 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-023', 'EXP-023', 'Quarterly Inverter & Solar Power Battery Servicing', 95000, '2026-05-25', 'BR-001', 'Hive Hub', 'CAT-004', 'Maintenance', 'Battery terminal desulfation, electrolyte check, and load test', 'Paid', 'Dominion Adebayo', '2026-05-25 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-024', 'EXP-024', 'AC Servicing, Deep Chemical Wash & Refrigerant Gas Refill', 130000, '2026-06-25', 'BR-002', 'Art and Tech Hub', 'CAT-004', 'Maintenance', 'Preventative servicing for 6 split air conditioning units', 'Paid', 'Dominion Adebayo', '2026-06-25 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-025', 'EXP-025', 'Electrical Socket Replacement & Breaker Box Rewiring', 48000, '2026-07-28', 'BR-001', 'Hive Hub', 'CAT-004', 'Maintenance', 'Repaired loose wall sockets and balanced 3-phase phase circuits', 'Paid', 'Dominion Adebayo', '2026-07-28 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-026', 'EXP-026', 'Restroom Plumbing Repairs & Pressure Booster Valve Servicing', 38000, '2026-08-25', 'BR-002', 'Art and Tech Hub', 'CAT-004', 'Maintenance', 'Fixed pressure leaks and replaced damaged sink sensor taps', 'Paid', 'Dominion Adebayo', '2026-08-25 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-027', 'EXP-027', 'Biometric Access Turnstile & Electronic Door Lock Maintenance', 65000, '2026-09-24', 'BR-001', 'Hive Hub', 'CAT-004', 'Maintenance', 'Optical sensor alignment and magnetic lock power supply replacement', 'Paid', 'Dominion Adebayo', '2026-09-24 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-028', 'EXP-028', 'AC Servicing & Antibacterial Filter Replacement', 125000, '2026-10-12', 'BR-001', 'Hive Hub', 'CAT-004', 'Maintenance', 'Routine preventative servicing across executive private suites', 'Paid', 'Dominion Adebayo', '2026-10-12 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-029', 'EXP-029', 'Electrical Sockets & LED Ceiling Panel Repairs', 42000, '2026-10-25', 'BR-002', 'Art and Tech Hub', 'CAT-004', 'Maintenance', 'Replaced faulty floor pop-up sockets and driver transformers', 'Paid', 'Dominion Adebayo', '2026-10-25 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-030', 'EXP-030', 'Rollup Banner Printing for Coworking Open House', 55000, '2026-05-10', 'BR-001', 'Hive Hub', 'CAT-005', 'Marketing', 'High-resolution tear-resistant rollup banners with luxury stands', 'Paid', 'Dominion Adebayo', '2026-05-10 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-031', 'EXP-031', 'Digital Social Media Targeted Advertising Campaign', 75000, '2026-06-12', 'BR-002', 'Art and Tech Hub', 'CAT-005', 'Marketing', 'Meta and LinkedIn sponsored promotions for creative studio desks', 'Paid', 'Dominion Adebayo', '2026-06-12 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-032', 'EXP-032', 'Coworking Membership Brochures & Community Promotional Flyers', 40000, '2026-07-18', 'BR-001', 'Hive Hub', 'CAT-005', 'Marketing', 'Full-color matte lamination trifold brochures for visitors', 'Paid', 'Dominion Adebayo', '2026-07-18 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-033', 'EXP-033', 'Tech Founders Meetup Sponsorship & Event Publicity', 85000, '2026-08-22', 'BR-002', 'Art and Tech Hub', 'CAT-005', 'Marketing', 'Co-branding banners and social media sponsor shoutouts', 'Paid', 'Dominion Adebayo', '2026-08-22 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-034', 'EXP-034', 'Workspace Entrance Wall Decal & Directional Signage Printing', 48000, '2026-09-15', 'BR-001', 'Hive Hub', 'CAT-005', 'Marketing', 'Branded frosted vinyl decals for glass partitions and meeting rooms', 'Paid', 'Dominion Adebayo', '2026-09-15 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-035', 'EXP-035', 'Quarterly Digital Marketing & SEO Optimization Ads', 90000, '2026-10-08', 'BR-001', 'Hive Hub', 'CAT-005', 'Marketing', 'Google Search ads for Lagos workspace and private office queries', 'Paid', 'Dominion Adebayo', '2026-10-08 10:00:00');
INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('EXP-2026-036', 'EXP-036', 'Promotional Banner Printing for Tech Conference Hall', 52000, '2026-10-20', 'BR-002', 'Art and Tech Hub', 'CAT-005', 'Marketing', 'Stage backdrop banners and registration desk signage', 'Paid', 'Dominion Adebayo', '2026-10-20 10:00:00');

-- ============================================================================
-- 11. HR EMPLOYEES & PAYROLL (EXACTLY 4 STAFF MEMBERS)
-- ============================================================================
INSERT INTO employees (id, user_id, first_name, last_name, email, phone, department, position, branch_id, branch_name, hire_date, employment_status, salary_amount, created_at) VALUES ('EMP-001', 'USR-001', 'Dominion', 'Adebayo', 'admin@gmail.com', '+234 803 200 1101', 'Executive', 'Director', 'BR-001', 'All Branches', '2024-01-15', 'Full-time', 850000, '2025-01-01 08:00:00');
INSERT INTO employees (id, user_id, first_name, last_name, email, phone, department, position, branch_id, branch_name, hire_date, employment_status, salary_amount, created_at) VALUES ('EMP-002', 'USR-002', 'Chioma', 'Okonkwo', 'chioma.okonkwo@workspace.ng', '+234 802 334 5566', 'Operations', 'Manager', 'BR-001', 'Hive Hub', '2024-01-15', 'Full-time', 450000, '2025-01-01 08:00:00');
INSERT INTO employees (id, user_id, first_name, last_name, email, phone, department, position, branch_id, branch_name, hire_date, employment_status, salary_amount, created_at) VALUES ('EMP-003', 'USR-003', 'Amara', 'Nwosu', 'amara.nwosu@workspace.ng', '+234 814 556 7788', 'Front Desk', 'Front Desk', 'BR-002', 'Art and Tech Hub', '2024-01-15', 'Full-time', 220000, '2025-01-01 08:00:00');
INSERT INTO employees (id, user_id, first_name, last_name, email, phone, department, position, branch_id, branch_name, hire_date, employment_status, salary_amount, created_at) VALUES ('EMP-004', 'USR-004', 'Ibrahim', 'Danjuma', 'ibrahim.danjuma@workspace.ng', '+234 809 667 8899', 'Finance', 'Accountant', 'BR-001', 'All Branches', '2024-01-15', 'Full-time', 400000, '2025-01-01 08:00:00');
INSERT INTO payroll_records (id, employee_id, period_start, period_end, gross_salary, deductions, net_salary, payment_status, payment_date, created_at) VALUES ('PR-AUG-001', 'EMP-001', '2026-08-01', '2026-08-31', 850000, 68000, 782000, 'Paid', '2026-08-31', '2026-08-31 16:00:00');
INSERT INTO payroll_records (id, employee_id, period_start, period_end, gross_salary, deductions, net_salary, payment_status, payment_date, created_at) VALUES ('PR-SEP-001', 'EMP-001', '2026-09-01', '2026-09-30', 850000, 68000, 782000, 'Paid', '2026-09-30', '2026-09-30 16:00:00');
INSERT INTO payroll_records (id, employee_id, period_start, period_end, gross_salary, deductions, net_salary, payment_status, payment_date, created_at) VALUES ('PR-AUG-002', 'EMP-002', '2026-08-01', '2026-08-31', 450000, 36000, 414000, 'Paid', '2026-08-31', '2026-08-31 16:00:00');
INSERT INTO payroll_records (id, employee_id, period_start, period_end, gross_salary, deductions, net_salary, payment_status, payment_date, created_at) VALUES ('PR-SEP-002', 'EMP-002', '2026-09-01', '2026-09-30', 450000, 36000, 414000, 'Paid', '2026-09-30', '2026-09-30 16:00:00');
INSERT INTO payroll_records (id, employee_id, period_start, period_end, gross_salary, deductions, net_salary, payment_status, payment_date, created_at) VALUES ('PR-AUG-003', 'EMP-003', '2026-08-01', '2026-08-31', 220000, 17600, 202400, 'Paid', '2026-08-31', '2026-08-31 16:00:00');
INSERT INTO payroll_records (id, employee_id, period_start, period_end, gross_salary, deductions, net_salary, payment_status, payment_date, created_at) VALUES ('PR-SEP-003', 'EMP-003', '2026-09-01', '2026-09-30', 220000, 17600, 202400, 'Paid', '2026-09-30', '2026-09-30 16:00:00');
INSERT INTO payroll_records (id, employee_id, period_start, period_end, gross_salary, deductions, net_salary, payment_status, payment_date, created_at) VALUES ('PR-AUG-004', 'EMP-004', '2026-08-01', '2026-08-31', 400000, 32000, 368000, 'Paid', '2026-08-31', '2026-08-31 16:00:00');
INSERT INTO payroll_records (id, employee_id, period_start, period_end, gross_salary, deductions, net_salary, payment_status, payment_date, created_at) VALUES ('PR-SEP-004', 'EMP-004', '2026-09-01', '2026-09-30', 400000, 32000, 368000, 'Paid', '2026-09-30', '2026-09-30 16:00:00');

-- ============================================================================
-- 12. CLIENT COMMUNICATIONS & CRM ACTIVITY
-- ============================================================================
INSERT INTO client_communications (client_id, user_id, type, subject, summary, direction, status, logged_by, sent_date, created_at) VALUES ('CL-001', 'USR-001', 'Meeting', 'Q4 Enterprise Suite Renewal', 'Discussed 6-month extension for 4-person executive suite at Hive Hub with 5% annual prepay discount.', 'Outbound', 'Logged', 'Dominion Adebayo', '2026-10-10 11:00:00', '2026-10-10 11:00:00');
INSERT INTO client_communications (client_id, user_id, type, subject, summary, direction, status, logged_by, sent_date, created_at) VALUES ('CL-003', 'USR-001', 'Call', 'Boardroom Catering & Video Conf Setup', 'Confirmed dual 4K video conference integration and corporate luncheon order for 12 partners.', 'Outbound', 'Logged', 'Dominion Adebayo', '2026-10-11 11:00:00', '2026-10-11 11:00:00');
INSERT INTO client_communications (client_id, user_id, type, subject, summary, direction, status, logged_by, sent_date, created_at) VALUES ('CL-005', 'USR-001', 'Email', 'Dedicated Workstation Expansion', 'Sent proposal for onboarding 4 additional fintech analysts into Hive Hub dedicated workstation row.', 'Outbound', 'Logged', 'Dominion Adebayo', '2026-10-12 11:00:00', '2026-10-12 11:00:00');
INSERT INTO client_communications (client_id, user_id, type, subject, summary, direction, status, logged_by, sent_date, created_at) VALUES ('CL-008', 'USR-001', 'SMS', 'Audio Lab Booking Confirmation', 'Automated confirmation sent for 4-hour podcast recording session at Art and Tech Hub.', 'Outbound', 'Logged', 'Dominion Adebayo', '2026-10-13 11:00:00', '2026-10-13 11:00:00');
INSERT INTO client_communications (client_id, user_id, type, subject, summary, direction, status, logged_by, sent_date, created_at) VALUES ('CL-012', 'USR-001', 'Note', 'Health Tech Advisory Onboarding', 'Client onboarded successfully. Biometric card access issued for 24 Commercial Ave facility.', 'Outbound', 'Logged', 'Dominion Adebayo', '2026-10-14 11:00:00', '2026-10-14 11:00:00');
INSERT INTO client_communications (client_id, user_id, type, subject, summary, direction, status, logged_by, sent_date, created_at) VALUES ('CL-015', 'USR-001', 'Call', 'Tech Conference Hall Reservation', 'Confirmed booking for weekend developer hackathon. Audio visual technician assigned.', 'Outbound', 'Logged', 'Dominion Adebayo', '2026-10-15 11:00:00', '2026-10-15 11:00:00');
INSERT INTO client_communications (client_id, user_id, type, subject, summary, direction, status, logged_by, sent_date, created_at) VALUES ('CL-018', 'USR-001', 'Meeting', 'Investment Guild Weekly Standup', 'Reserved Collaborative Meeting Room every Tuesday and Thursday morning for Q4.', 'Outbound', 'Logged', 'Dominion Adebayo', '2026-10-16 11:00:00', '2026-10-16 11:00:00');
INSERT INTO client_communications (client_id, user_id, type, subject, summary, direction, status, logged_by, sent_date, created_at) VALUES ('CL-025', 'USR-001', 'Email', 'VIP Account Manager Introduction', 'Assigned Chioma Okonkwo as dedicated executive relationship manager.', 'Outbound', 'Logged', 'Dominion Adebayo', '2026-10-17 11:00:00', '2026-10-17 11:00:00');
INSERT INTO client_communications (client_id, user_id, type, subject, summary, direction, status, logged_by, sent_date, created_at) VALUES ('CL-031', 'USR-001', 'SMS', 'Desk Membership Expiry Notice', 'Subscription expires in 2 days. Link sent for instant card or wire transfer renewal.', 'Outbound', 'Logged', 'Dominion Adebayo', '2026-10-18 11:00:00', '2026-10-18 11:00:00');
INSERT INTO client_communications (client_id, user_id, type, subject, summary, direction, status, logged_by, sent_date, created_at) VALUES ('CL-032', 'USR-001', 'Call', 'Subscription Renewal Follow-up', 'Client currently traveling; requested follow-up next Monday to reactivate hot desk pass.', 'Outbound', 'Logged', 'Dominion Adebayo', '2026-10-19 11:00:00', '2026-10-19 11:00:00');

-- ============================================================================
-- 13. SYSTEM NOTIFICATIONS & AUDIT LOGS
-- ============================================================================
INSERT INTO system_notifications (user_id, title, message, type, is_read, related_entity, related_entity_id, created_at) VALUES
('USR-001', 'High-Yield Booking Confirmed', 'Paystack Alumni Ventures booked Executive Suite at Hive Hub (₦1,350,000).', 'success', 0, 'bookings', 'BK-2026-065', '2026-10-27 09:15:00'),
('USR-001', 'Starlink Broadband Recharged', 'Utilities expense of ₦75,000 logged and paid for Hive Hub satellite link.', 'info', 0, 'expenses', 'EXP-2026-007', '2026-10-26 14:00:00'),
('USR-001', 'Membership Expiring Alert', 'Anchor Banking Infrastructure desk membership expires in 48 hours.', 'warning', 0, 'subscriptions', 'SUB-011', '2026-10-27 08:00:00'),
('USR-001', 'Quarterly Maintenance Complete', 'AC Servicing and refrigerant recharge completed across all Art and Tech Hub suites.', 'success', 1, 'expenses', 'EXP-2026-024', '2026-10-25 17:30:00');
INSERT INTO audit_logs (user, action, ip_address, entity, entity_id, previous_value, new_value, timestamp) VALUES
('Dominion Adebayo', 'UPDATE_SETTINGS', '127.0.0.1', 'business_settings', '1', '{"currency": "USD"}', '{"currency": "NGN (₦)", "business_name": "Nexus Workspace ERP"}', '2026-10-01 08:00:00'),
('Dominion Adebayo', 'CREATE_BRANCH', '127.0.0.1', 'branches', 'BR-001', NULL, '{"name": "Hive Hub", "location": "Lekki Phase 1"}', '2026-10-01 08:30:00'),
('Dominion Adebayo', 'CREATE_BRANCH', '127.0.0.1', 'branches', 'BR-002', NULL, '{"name": "Art and Tech Hub", "location": "Yaba, Lagos"}', '2026-10-01 09:00:00'),
('Chioma Okonkwo', 'CREATE_BOOKING', '127.0.0.1', 'bookings', 'BK-2026-065', NULL, '{"client": "Paystack Alumni Ventures", "amount": 1350000}', '2026-10-01 09:30:00'),
('Ibrahim Danjuma', 'CREATE_EXPENSE', '127.0.0.1', 'expenses', 'EXP-2026-007', NULL, '{"name": "Starlink Subscription", "amount": 75000}', '2026-10-05 10:15:00');

-- ============================================================================
-- 14. FACILITY ANALYTICS SNAPSHOTS (OCTOBER 2026)
-- ============================================================================
INSERT INTO facility_analytics (facility_id, facility_name, branch_name, period, total_bookings, total_revenue, occupancy_rate) VALUES ('FAC-001', 'Hot Desk Zone', 'Hive Hub', '2026-10', 12, 395000, 50.00);
INSERT INTO facility_analytics (facility_id, facility_name, branch_name, period, total_bookings, total_revenue, occupancy_rate) VALUES ('FAC-002', 'Dedicated Workstation', 'Hive Hub', '2026-10', 12, 1500000, 50.00);
INSERT INTO facility_analytics (facility_id, facility_name, branch_name, period, total_bookings, total_revenue, occupancy_rate) VALUES ('FAC-003', 'Executive Private Suite', 'Hive Hub', '2026-10', 13, 5850000, 95.00);
INSERT INTO facility_analytics (facility_id, facility_name, branch_name, period, total_bookings, total_revenue, occupancy_rate) VALUES ('FAC-004', 'Collaborative Meeting Room', 'Hive Hub', '2026-10', 13, 500000, 81.00);
INSERT INTO facility_analytics (facility_id, facility_name, branch_name, period, total_bookings, total_revenue, occupancy_rate) VALUES ('FAC-005', 'Creative Open Desk', 'Art and Tech Hub', '2026-10', 12, 450000, 50.00);
INSERT INTO facility_analytics (facility_id, facility_name, branch_name, period, total_bookings, total_revenue, occupancy_rate) VALUES ('FAC-006', 'Private Studio Office', 'Art and Tech Hub', '2026-10', 12, 4800000, 95.00);
INSERT INTO facility_analytics (facility_id, facility_name, branch_name, period, total_bookings, total_revenue, occupancy_rate) VALUES ('FAC-007', 'Podcast & Audio Lab', 'Art and Tech Hub', '2026-10', 13, 3250000, 95.00);
INSERT INTO facility_analytics (facility_id, facility_name, branch_name, period, total_bookings, total_revenue, occupancy_rate) VALUES ('FAC-008', 'Tech Conference Hall', 'Art and Tech Hub', '2026-10', 13, 1560000, 50.00);

-- ============================================================================
-- 15. AI CONVERSATIONS & EXECUTIVE INSIGHTS
-- ============================================================================
INSERT INTO ai_conversations (id, session_id, user_id, title, prompt, response, created_at) VALUES
(1, 'SESS-2026-1', 'USR-001', 'October Executive Revenue Performance', 'Summarize Q4 October revenue performance across Hive Hub and Art & Tech Hub.', 'During October 2026, total enterprise workspace revenue reached ₦9,450,000 across 33 active client accounts. Hive Hub maintained an 88% occupancy rate driven by private suites, while Art and Tech Hub experienced high turnover in creative studio desks and audio labs.', '2026-10-27 10:00:00'),
(2, 'SESS-2026-2', 'USR-001', 'Expense Taxonomy & Yield Analysis', 'Analyze our major operational expense drivers for October 2026.', 'Operational expenses were predominantly led by Utilities (Starlink & MTN fiber at ₦170,000) and Maintenance (HVAC servicing at ₦125,000). Total operating margins remain highly sound at 68.4%.', '2026-10-27 11:30:00');
INSERT INTO ai_messages (id, conversation_id, sender, text, timestamp) VALUES
('MSG-001', 'default', 'user', 'What is our top revenue contributing facility across both branches?', '2026-10-27 10:00:00'),
('MSG-002', 'default', 'assistant', 'The top revenue contributor is the Executive Private Suite at Hive Hub, followed by the Tech Conference Hall and Private Studio Offices at Art and Tech Hub. Overall facility utilization is optimal at 84.5%.', '2026-10-27 10:00:03');

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;