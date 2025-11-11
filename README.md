# Shop App - E-Commerce Application

A complete e-commerce application built with **Flutter** (Frontend) and **Laravel** (Backend) with full support for Arabic and English languages.

## 📋 Project Contents

### Frontend (Flutter)
- Cross-platform Flutter application (Android, iOS, Web, Windows, macOS, Linux)
- Full support for Arabic and English with RTL
- BLoC Pattern for state management
- Modern and responsive UI with Material Design 3
- Expandable product details on the same page
- Stock verification before purchase
- Tooltips on all icons

### Backend (Laravel)
- RESTful API using Laravel 12
- Authentication system using Sanctum
- SQLite/MySQL database
- Product, cart, and order management system
- Alphabetical product sorting
- Stock management

## 🚀 Requirements

### Frontend
- **Flutter SDK** >= 3.3.4
- **Dart SDK** >= 3.3.4
- **Android Studio** / **VS Code** with Flutter Extension
- **Android SDK** (for Android development)
- **Xcode** (for iOS development - macOS only)

### Backend
- **PHP** >= 8.2
- **Composer** (PHP Package Manager)
- **MySQL** >= 8.0 or **SQLite**
- **Laravel** >= 12.0
- **XAMPP** / **Laravel Valet** / **Laravel Sail**

## 📦 Installation and Setup

### 1️⃣ Backend (Laravel)

#### Step 1: Navigate to Backend Directory
```bash
cd backend
```

#### Step 2: Install Dependencies
```bash
composer install
```

#### Step 3: Setup Environment File
```bash
# Copy environment file
cp .env.example .env

# Or on Windows
copy .env.example .env
```

#### Step 4: Generate Application Key
```bash
php artisan key:generate
```

#### Step 5: Configure Database

Open the `.env` file and modify database settings:

**For SQLite (Easiest to start):**
```env
DB_CONNECTION=sqlite
DB_DATABASE=C:\xampp\htdocs\New folder\backend\database\database.sqlite
```

**Or for MySQL:**
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=shop_app
DB_USERNAME=root
DB_PASSWORD=
```

#### Step 6: Run Migrations
```bash
php artisan migrate
```

#### Step 7: (Optional) Run Seeders to Add Sample Data
```bash
php artisan db:seed
```

Or to update products only:
```bash
php artisan db:seed --class=ProductSeeder
```

#### Step 8: Start the Server
```bash
php artisan serve
```

✅ The Backend will run on: **http://localhost:8000**

---

### 2️⃣ Frontend (Flutter)

#### Step 1: Navigate to Frontend Directory
```bash
cd frontend
```

#### Step 2: Install Dependencies
```bash
flutter pub get
```

#### Step 3: Configure API URL

The `frontend/lib/core/api_client.dart` file is automatically configured:
- **For Android Emulator**: `http://10.0.2.2:8000`
- **For iOS/Desktop**: `http://127.0.0.1:8000`
- **For Web**: Uses the same browser URL

**For Real Devices:**
If you want to run the app on a real device, you can modify `api_client.dart`:

```dart
// In api_client.dart, replace:
Platform.isAndroid
    ? 'http://10.0.2.2:8000'  // For Emulator
    : 'http://127.0.0.1:8000'

// With:
Platform.isAndroid
    ? 'http://YOUR_COMPUTER_IP:8000'  // For real device
    : 'http://YOUR_COMPUTER_IP:8000'
```

**To get your computer's IP:**
- Windows: `ipconfig` in Command Prompt
- Mac/Linux: `ifconfig` in Terminal

#### Step 4: Run the Application

**For Android:**
```bash
flutter run
```

**For iOS (macOS only):**
```bash
flutter run -d ios
```

**For Web:**
```bash
flutter run -d chrome
```

**For Windows:**
```bash
flutter run -d windows
```

---

## 🔧 Important Settings

### 1. CORS Configuration in Laravel

Open `backend/config/cors.php` and ensure:

```php
'paths' => ['api/*', 'sanctum/csrf-cookie'],
'allowed_origins' => ['*'], // Or specify specific ports
'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
'supports_credentials' => true,
```

### 2. Session Configuration in Laravel

Open `backend/config/session.php` and ensure:

```php
'driver' => env('SESSION_DRIVER', 'file'),
'domain' => env('SESSION_DOMAIN', null),
```

---

## 📱 Features

### ✅ Implemented Features

1. **Authentication System**
   - ✅ User registration with extended profile fields
   - ✅ User login
   - ✅ User logout
   - ✅ User session persistence
   - ✅ Clear and detailed error messages

2. **User Registration**
   - ✅ Name (required)
   - ✅ Email (required)
   - ✅ Password with confirmation (required, min 8 characters)
   - ✅ Phone number (optional)
   - ✅ Address (optional)
   - ✅ Date of birth (optional)
   - ✅ City (optional)
   - ✅ Country (optional)

3. **User Profile Management**
   - ✅ View complete profile information
   - ✅ Edit profile information (name, email, phone, address, date of birth, city, country)
   - ✅ Upload/change profile avatar image
   - ✅ Change password functionality
   - ✅ View account creation date

4. **Product Management**
   - ✅ Display product list sorted alphabetically
   - ✅ Expandable product details on the same page
   - ✅ Add/remove from favorites
   - ✅ Display category
   - ✅ Display description
   - ✅ Display specifications
   - ✅ Display stock availability

5. **Stock Management**
   - ✅ Verify stock before purchase
   - ✅ Prevent purchase if stock = 0
   - ✅ Display "Out of Stock" message for unavailable products
   - ✅ Set maximum quantity based on stock

6. **Shopping Cart**
   - ✅ Add products to cart
   - ✅ Select quantity (with stock verification)
   - ✅ Automatic quantity updates
   - ✅ Display product count in cart icon
   - ✅ Remove products from cart
   - ✅ Display subtotal

7. **Payment System**
   - ✅ Complete payment form with validation
   - ✅ Shipping information (name, phone, address)
   - ✅ Payment methods (Cash on Delivery / Card)
   - ✅ Card details:
     - Card number (16 digits only)
     - Expiry date (select month then year)
     - CVV (3 digits)
     - Card holder name
   - ✅ Order summary

8. **Localization**
   - ✅ Full support for Arabic and English languages
   - ✅ Change language from icon in HomeScreen
   - ✅ Default language: English
   - ✅ All texts fully translated
   - ✅ Save selected language

9. **User Interface**
   - ✅ Tooltips on all icons
   - ✅ Material Design 3
   - ✅ Dark mode support
   - ✅ Smooth user experience
   - ✅ Hide loading indicator when navigating between pages

---

## 📁 Project Structure

```
project/
├── frontend/                 # Flutter Application
│   ├── lib/
│   │   ├── core/            # API Client, Secure Storage
│   │   │   ├── api_client.dart
│   │   │   └── secure_storage.dart
│   │   ├── features/        # Auth, Products, Cart, Profile
│   │   │   ├── auth/
│   │   │   │   ├── bloc/    # AuthBloc, AuthState, AuthEvent
│   │   │   │   └── data/    # AuthRepository
│   │   │   ├── products/
│   │   │   │   ├── bloc/    # ProductsBloc, ProductsState, ProductsEvent
│   │   │   │   └── data/    # ProductRepository, Product Model
│   │   │   ├── cart/
│   │   │   │   ├── bloc/    # CartBloc, CartState, CartEvent
│   │   │   │   └── data/    # CartRepository, CartItem Model
│   │   │   └── profile/
│   │   │       └── data/    # ProfileRepository, UserProfile Model
│   │   ├── l10n/            # Translation files
│   │   │   └── app_localizations.dart
│   │   ├── screens/         # Screens
│   │   │   ├── auth/
│   │   │   │   └── login_register_screen.dart
│   │   │   ├── splash_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── cart_screen.dart
│   │   │   ├── favorites_screen.dart
│   │   │   ├── payment_screen.dart
│   │   │   └── profile_screen.dart
│   │   ├── widgets/         # Reusable Widgets
│   │   │   ├── cart_icon_with_badge.dart
│   │   │   ├── expandable_product_tile.dart
│   │   │   └── quantity_picker.dart
│   │   ├── utils/           # Utilities
│   │   │   └── locale_storage.dart
│   │   └── main.dart        # Entry point
│   ├── pubspec.yaml         # Dependencies
│   └── README.md
│
└── backend/                  # Laravel API
    ├── app/
    │   ├── Http/
    │   │   ├── Controllers/ # AuthController, ProductController, CartController, ProfileController
    │   │   ├── Requests/    # Form Validation
    │   │   └── Resources/   # API Resources (UserResource, ProductResource)
    │   └── Models/          # User, Product, CartItem, Order, OrderItem, Favorite
    ├── database/
    │   ├── migrations/      # Database Migrations
    │   │   ├── create_users_table.php
    │   │   ├── add_avatar_to_users_table.php
    │   │   ├── add_additional_fields_to_users_table.php
    │   │   ├── create_products_table.php
    │   │   ├── create_orders_table.php
    │   │   ├── create_order_items_table.php
    │   │   ├── create_cart_items_table.php
    │   │   └── create_favorites_table.php
    │   └── seeders/         # Database Seeders
    │       ├── DatabaseSeeder.php
    │       ├── UserSeeder.php
    │       ├── ProductSeeder.php
    │       ├── CartSeeder.php
    │       └── OrderSeeder.php
    ├── routes/
    │   └── api.php         # API Routes
    └── .env                 # Environment Configuration
```

---

## 🔑 API Endpoints

### Authentication
- `POST /api/register` - Register a new user
  ```json
  {
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "phone": "+1234567890",
    "address": "123 Main St",
    "date_of_birth": "1990-01-01",
    "city": "New York",
    "country": "USA"
  }
  ```

- `POST /api/login` - Login
  ```json
  {
    "email": "john@example.com",
    "password": "password123"
  }
  ```

- `POST /api/logout` - Logout (requires authentication)

### Profile
- `GET /api/profile` - Get user profile (requires authentication)
- `PUT /api/profile` - Update user profile (requires authentication)
  ```json
  {
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "address": "123 Main St",
    "date_of_birth": "1990-01-01",
    "city": "New York",
    "country": "USA",
    "avatar": "data:image/jpeg;base64,..."
  }
  ```
- `POST /api/profile/change-password` - Change password (requires authentication)
  ```json
  {
    "current_password": "oldpassword123",
    "password": "newpassword123",
    "password_confirmation": "newpassword123"
  }
  ```

### Products
- `GET /api/products` - Product list (sorted alphabetically)
  - Query Parameters: `page`, `per_page`

- `GET /api/favorites` - Favorites list (requires authentication)

- `POST /api/favorites/toggle/{id}` - Add/remove from favorites (requires authentication)

### Cart
- `GET /api/cart` - View cart (requires authentication)

- `POST /api/cart/add` - Add product to cart (requires authentication)
  ```json
  {
    "product_id": 1,
    "quantity": 2
  }
  ```

- `DELETE /api/cart/remove/{id}` - Remove product from cart (requires authentication)

- `PATCH /api/cart/update/{id}` - Update quantity (requires authentication)
  ```json
  {
    "quantity": 5
  }
  ```

- `POST /api/checkout` - Complete order (requires authentication)
  ```json
  {
    "full_name": "John Doe",
    "phone_number": "1234567890",
    "city": "Cairo",
    "street": "Main Street",
    "building": "Building 1",
    "payment_method": "cod",
    "card_number": "1234567890123456",
    "expiry_date": "12/25",
    "cvv": "123",
    "card_holder_name": "John Doe"
  }
  ```

---

## 🛠️ Technologies Used

### Frontend
- **Flutter** 3.3.4+ - Development Framework
- **flutter_bloc** 8.1.6 - State Management
- **dio** 5.9.0 - HTTP Client
- **flutter_secure_storage** 9.2.4 - Secure token storage
- **equatable** 2.0.7 - Object comparison
- **flutter_localizations** - Translation support
- **image_picker** - Image selection for profile avatar

### Backend
- **Laravel** 12.0 - PHP Framework
- **Sanctum** 4.2 - API Authentication
- **MySQL/SQLite** - Database

---

## 📝 Important Notes

1. **Default Language**: English
2. **First Page**: Registration page (Register)
3. **After Registration**: Automatically navigates to login page
4. **Cart Updates**: Product count in cart icon updates immediately upon addition
5. **Quantity**: When adding an existing product to cart, new quantity is added to existing quantity
6. **Stock**: Stock is verified before purchase, and products with stock = 0 cannot be purchased
7. **Product Sorting**: Products are sorted alphabetically by name
8. **Product Details**: Product details can be displayed on the same page without navigating to another page
9. **Profile Fields**: All profile fields (phone, address, date of birth, city, country) are optional during registration and can be updated later in the profile screen
10. **Password Change**: Users can change their password from the profile screen by providing current password and new password

---

## 🐛 Troubleshooting

### CORS Issue
If you encounter a CORS issue, ensure:
1. `cors.php` is configured correctly
2. `HandleCors` middleware is added in `bootstrap/app.php`
3. `allowed_origins` contains `*` or the correct port

### API Connection Issue
- ✅ Ensure Backend is running on `http://localhost:8000`
- ✅ Check `BASE_URL` in `api_client.dart`
- ✅ For real devices, use your computer's IP instead of `localhost`
  - To find IP: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)
- ✅ Ensure device and computer are on the same network

### Language Issue
- Default language is English
- Language can be changed from the language icon in HomeScreen
- Saved language is loaded automatically when opening the app

### Stock = 0 Issue
- If Stock = 0, product cannot be purchased
- Purchase buttons are automatically disabled
- "Out of Stock" message is displayed

### Migration Issue
If you encounter a migration issue:
```bash
# Delete all tables and recreate them
php artisan migrate:fresh

# Then run Seeders
php artisan db:seed
```

### Flutter Dependencies Issue
```bash
# Clean the project
flutter clean

# Reinstall Dependencies
flutter pub get

# Restart
flutter run
```

---

## 🎯 Quick Start Steps

### Backend
```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan db:seed
php artisan serve
```

### Frontend
```bash
cd frontend
flutter pub get
# Update BASE_URL in api_client.dart if needed
flutter run
```

---

## 📊 Database

### Main Tables:
- **users** - Users (name, email, password, avatar, phone, address, date_of_birth, city, country)
- **products** - Products (name, category, description, specifications, price, stock, image_url)
- **cart_items** - Cart items
- **orders** - Orders
- **order_items** - Order items
- **favorites** - Favorites

---

## 👥 Contributing

This is an educational project. You can use it as a base for your own projects.

---

## 📄 License

This project is open source and available for free use.

---

## 📞 Support

If you encounter any issues or have questions, you can:
1. Open an Issue in the project
2. Review the "Troubleshooting" section above

---

**Developed by:** [Your Name]  
**Date:** 2024  
**Version:** 1.0.0
