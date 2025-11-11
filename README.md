# Shop App - تطبيق المتجر الإلكتروني

تطبيق متجر إلكتروني كامل مبني باستخدام **Flutter** (Frontend) و **Laravel** (Backend) مع دعم كامل للغة العربية والإنجليزية.

## 📋 محتويات المشروع

### Frontend (Flutter)
- تطبيق Flutter متعدد المنصات (Android, iOS, Web, Windows, macOS, Linux)
- دعم كامل للغة العربية والإنجليزية مع RTL
- استخدام BLoC Pattern لإدارة الحالة
- واجهة مستخدم حديثة ومتجاوبة مع Material Design 3
- عرض تفاصيل المنتجات في نفس الصفحة (Expandable)
- التحقق من المخزون (Stock) قبل الشراء
- Tooltips على جميع الأيقونات

### Backend (Laravel)
- API RESTful باستخدام Laravel 12
- نظام مصادقة باستخدام Sanctum
- قاعدة بيانات SQLite/MySQL
- نظام إدارة المنتجات والسلة والطلبات
- ترتيب المنتجات أبجدياً
- إدارة المخزون (Stock Management)

## 🚀 متطلبات التشغيل

### Frontend
- **Flutter SDK** >= 3.3.4
- **Dart SDK** >= 3.3.4
- **Android Studio** / **VS Code** مع Flutter Extension
- **Android SDK** (للتطوير على Android)
- **Xcode** (للتطوير على iOS - macOS فقط)

### Backend
- **PHP** >= 8.2
- **Composer** (PHP Package Manager)
- **MySQL** >= 8.0 أو **SQLite**
- **Laravel** >= 12.0
- **XAMPP** / **Laravel Valet** / **Laravel Sail**

## 📦 التثبيت والتشغيل

### 1️⃣ Backend (Laravel)

#### الخطوة 1: الانتقال لمجلد Backend
```bash
cd backend
```

#### الخطوة 2: تثبيت Dependencies
```bash
composer install
```

#### الخطوة 3: إعداد ملف البيئة
```bash
# نسخ ملف البيئة
cp .env.example .env

# أو على Windows
copy .env.example .env
```

#### الخطوة 4: إنشاء مفتاح التطبيق
```bash
php artisan key:generate
```

#### الخطوة 5: إعداد قاعدة البيانات

افتح ملف `.env` وعدل إعدادات قاعدة البيانات:

**لـ SQLite (الأسهل للبداية):**
```env
DB_CONNECTION=sqlite
DB_DATABASE=C:\xampp\htdocs\New folder\backend\database\database.sqlite
```

**أو لـ MySQL:**
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=shop_app
DB_USERNAME=root
DB_PASSWORD=
```

#### الخطوة 6: تشغيل Migrations
```bash
php artisan migrate
```

#### الخطوة 7: (اختياري) تشغيل Seeders لإضافة بيانات تجريبية
```bash
php artisan db:seed
```

أو لتحديث المنتجات فقط:
```bash
php artisan db:seed --class=ProductSeeder
```

#### الخطوة 8: تشغيل السيرفر
```bash
php artisan serve
```

✅ الـ Backend سيعمل على: **http://localhost:8000**

---

### 2️⃣ Frontend (Flutter)

#### الخطوة 1: الانتقال لمجلد Frontend
```bash
cd frontend
```

#### الخطوة 2: تثبيت Dependencies
```bash
flutter pub get
```

#### الخطوة 3: إعداد API URL

ملف `frontend/lib/core/api_client.dart` مُعد تلقائياً:
- **للـ Android Emulator**: `http://10.0.2.2:8000`
- **للـ iOS/Desktop**: `http://127.0.0.1:8000`
- **للـ Web**: يستخدم نفس URL المتصفح

**للأجهزة الحقيقية:**
إذا كنت تريد تشغيل التطبيق على جهاز حقيقي، يمكنك تعديل `api_client.dart`:

```dart
// في api_client.dart، استبدل:
Platform.isAndroid
    ? 'http://10.0.2.2:8000'  // للـ Emulator
    : 'http://127.0.0.1:8000'

// بـ:
Platform.isAndroid
    ? 'http://YOUR_COMPUTER_IP:8000'  // للجهاز الحقيقي
    : 'http://YOUR_COMPUTER_IP:8000'
```

**للحصول على IP جهازك:**
- Windows: `ipconfig` في Command Prompt
- Mac/Linux: `ifconfig` في Terminal

#### الخطوة 4: تشغيل التطبيق

**لـ Android:**
```bash
flutter run
```

**لـ iOS (macOS فقط):**
```bash
flutter run -d ios
```

**لـ Web:**
```bash
flutter run -d chrome
```

**لـ Windows:**
```bash
flutter run -d windows
```

---

## 🔧 إعدادات مهمة

### 1. إعداد CORS في Laravel

افتح ملف `backend/config/cors.php` وتأكد من:

```php
'paths' => ['api/*', 'sanctum/csrf-cookie'],
'allowed_origins' => ['*'], // أو حدد المنافذ المحددة
'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
'supports_credentials' => true,
```

### 2. إعداد Session في Laravel

افتح ملف `backend/config/session.php` وتأكد من:

```php
'driver' => env('SESSION_DRIVER', 'file'),
'domain' => env('SESSION_DOMAIN', null),
```

---

## 📱 الميزات

### ✅ الميزات المطبقة

1. **نظام المصادقة**
   - ✅ تسجيل مستخدم جديد
   - ✅ تسجيل دخول
   - ✅ تسجيل خروج
   - ✅ حفظ جلسة المستخدم
   - ✅ رسائل خطأ واضحة ومفصلة

2. **إدارة المنتجات**
   - ✅ عرض قائمة المنتجات مرتبة أبجدياً
   - ✅ عرض تفاصيل المنتج في نفس الصفحة (Expandable)
   - ✅ إضافة/إزالة من المفضلة
   - ✅ عرض الفئة (Category)
   - ✅ عرض الوصف (Description)
   - ✅ عرض المواصفات (Specifications)
   - ✅ عرض المخزون (Stock)

3. **إدارة المخزون**
   - ✅ التحقق من المخزون قبل الشراء
   - ✅ منع الشراء إذا كان المخزون = 0
   - ✅ عرض رسالة "نفد المخزون" للمنتجات غير المتوفرة
   - ✅ تحديد الكمية القصوى بناءً على المخزون

4. **السلة (Cart)**
   - ✅ إضافة منتجات للسلة
   - ✅ اختيار الكمية (مع التحقق من المخزون)
   - ✅ تحديث الكمية تلقائياً
   - ✅ عرض عدد المنتجات في أيقونة السلة
   - ✅ حذف منتجات من السلة
   - ✅ عرض المجموع الفرعي

5. **الدفع (Payment)**
   - ✅ نموذج دفع كامل مع validation
   - ✅ معلومات الشحن (الاسم، الهاتف، العنوان)
   - ✅ طرق الدفع (نقد عند الاستلام / بطاقة)
   - ✅ تفاصيل البطاقة:
     - رقم البطاقة (16 رقم فقط)
     - تاريخ الانتهاء (اختيار الشهر ثم السنة)
     - CVV (3 أرقام)
     - اسم حامل البطاقة
   - ✅ ملخص الطلب

6. **الترجمة (Localization)**
   - ✅ دعم كامل للغة العربية والإنجليزية
   - ✅ تغيير اللغة من أيقونة في HomeScreen
   - ✅ اللغة الافتراضية: الإنجليزية
   - ✅ جميع النصوص مترجمة بالكامل
   - ✅ حفظ اللغة المختارة

7. **واجهة المستخدم**
   - ✅ Tooltips على جميع الأيقونات
   - ✅ تصميم Material Design 3
   - ✅ دعم الوضع الداكن
   - ✅ تجربة مستخدم سلسة
   - ✅ إخفاء Loading Indicator عند التنقل بين الصفحات

---

## 📁 هيكل المشروع

```
project/
├── frontend/                 # تطبيق Flutter
│   ├── lib/
│   │   ├── core/            # API Client, Secure Storage
│   │   │   ├── api_client.dart
│   │   │   └── secure_storage.dart
│   │   ├── features/        # Auth, Products, Cart
│   │   │   ├── auth/
│   │   │   │   ├── bloc/    # AuthBloc, AuthState, AuthEvent
│   │   │   │   └── data/    # AuthRepository
│   │   │   ├── products/
│   │   │   │   ├── bloc/    # ProductsBloc, ProductsState, ProductsEvent
│   │   │   │   └── data/    # ProductRepository, Product Model
│   │   │   └── cart/
│   │   │       ├── bloc/    # CartBloc, CartState, CartEvent
│   │   │       └── data/    # CartRepository, CartItem Model
│   │   ├── l10n/            # ملفات الترجمة
│   │   │   └── app_localizations.dart
│   │   ├── screens/         # الشاشات
│   │   │   ├── auth/
│   │   │   │   └── login_register_screen.dart
│   │   │   ├── splash_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── cart_screen.dart
│   │   │   ├── favorites_screen.dart
│   │   │   └── payment_screen.dart
│   │   ├── widgets/         # Widgets قابلة لإعادة الاستخدام
│   │   │   ├── cart_icon_with_badge.dart
│   │   │   ├── expandable_product_tile.dart
│   │   │   └── quantity_picker.dart
│   │   ├── utils/           # Utilities
│   │   │   └── locale_storage.dart
│   │   └── main.dart        # نقطة البداية
│   ├── pubspec.yaml         # Dependencies
│   └── README.md
│
└── backend/                  # Laravel API
    ├── app/
    │   ├── Http/
    │   │   ├── Controllers/ # AuthController, ProductController, CartController
    │   │   ├── Requests/    # Form Validation
    │   │   └── Resources/   # API Resources (ProductResource)
    │   └── Models/          # User, Product, CartItem, Order, OrderItem, Favorite
    ├── database/
    │   ├── migrations/      # Database Migrations
    │   │   ├── create_users_table.php
    │   │   ├── create_products_table.php
    │   │   ├── create_orders_table.php
    │   │   ├── create_order_items_table.php
    │   │   ├── create_cart_items_table.php
    │   │   ├── create_favorites_table.php
    │   │   └── add_details_to_products_table.php
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
- `POST /api/register` - تسجيل مستخدم جديد
  ```json
  {
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }
  ```

- `POST /api/login` - تسجيل دخول
  ```json
  {
    "email": "john@example.com",
    "password": "password123"
  }
  ```

- `POST /api/logout` - تسجيل خروج (يتطلب authentication)

### Products
- `GET /api/products` - قائمة المنتجات (مرتبة أبجدياً)
  - Query Parameters: `page`, `per_page`

- `GET /api/favorites` - قائمة المفضلة (يتطلب authentication)

- `POST /api/favorites/toggle/{id}` - إضافة/إزالة من المفضلة (يتطلب authentication)

### Cart
- `GET /api/cart` - عرض السلة (يتطلب authentication)

- `POST /api/cart/add` - إضافة منتج للسلة (يتطلب authentication)
  ```json
  {
    "product_id": 1,
    "quantity": 2
  }
  ```

- `DELETE /api/cart/remove/{id}` - حذف منتج من السلة (يتطلب authentication)

- `PATCH /api/cart/update/{id}` - تحديث الكمية (يتطلب authentication)
  ```json
  {
    "quantity": 5
  }
  ```

- `POST /api/checkout` - إتمام الطلب (يتطلب authentication)
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

## 🛠️ التقنيات المستخدمة

### Frontend
- **Flutter** 3.3.4+ - Framework التطوير
- **flutter_bloc** 8.1.6 - إدارة الحالة
- **dio** 5.9.0 - HTTP Client
- **flutter_secure_storage** 9.2.4 - تخزين آمن للـ tokens
- **equatable** 2.0.7 - مقارنة الكائنات
- **flutter_localizations** - دعم الترجمة

### Backend
- **Laravel** 12.0 - PHP Framework
- **Sanctum** 4.2 - API Authentication
- **MySQL/SQLite** - قاعدة البيانات

---

## 📝 ملاحظات مهمة

1. **اللغة الافتراضية**: الإنجليزية
2. **الصفحة الأولى**: صفحة التسجيل (Register)
3. **بعد التسجيل**: يتم الانتقال تلقائياً لصفحة تسجيل الدخول
4. **تحديث السلة**: يتم تحديث عدد المنتجات في أيقونة السلة فوراً عند الإضافة
5. **الكمية**: عند إضافة منتج موجود في السلة، يتم إضافة الكمية الجديدة للكمية الموجودة
6. **المخزون**: يتم التحقق من المخزون قبل الشراء، ولا يمكن شراء منتج إذا كان المخزون = 0
7. **ترتيب المنتجات**: المنتجات مرتبة أبجدياً حسب الاسم
8. **تفاصيل المنتج**: يمكن عرض تفاصيل المنتج في نفس الصفحة بدون الانتقال لصفحة أخرى

---

## 🐛 حل المشاكل الشائعة

### مشكلة CORS
إذا واجهت مشكلة CORS، تأكد من:
1. إعداد `cors.php` بشكل صحيح
2. إضافة `HandleCors` middleware في `bootstrap/app.php`
3. التأكد من أن `allowed_origins` يحتوي على `*` أو المنفذ الصحيح

### مشكلة الاتصال بالـ API
- ✅ تأكد من أن الـ Backend يعمل على `http://localhost:8000`
- ✅ تحقق من `BASE_URL` في `api_client.dart`
- ✅ للأجهزة الحقيقية، استخدم IP جهازك بدلاً من `localhost`
  - للعثور على IP: `ipconfig` (Windows) أو `ifconfig` (Mac/Linux)
- ✅ تأكد من أن الجهاز والكمبيوتر على نفس الشبكة

### مشكلة اللغة
- اللغة الافتراضية هي الإنجليزية
- يمكن تغيير اللغة من أيقونة اللغة في HomeScreen
- اللغة المحفوظة يتم تحميلها تلقائياً عند فتح التطبيق

### مشكلة Stock = 0
- إذا كان Stock = 0، لا يمكن شراء المنتج
- يتم تعطيل أزرار الشراء تلقائياً
- تظهر رسالة "نفد المخزون"

### مشكلة Migration
إذا واجهت مشكلة في Migration:
```bash
# حذف جميع الجداول وإعادة إنشائها
php artisan migrate:fresh

# ثم تشغيل Seeders
php artisan db:seed
```

### مشكلة Flutter Dependencies
```bash
# تنظيف المشروع
flutter clean

# إعادة تثبيت Dependencies
flutter pub get

# إعادة تشغيل
flutter run
```

---

## 🎯 خطوات التشغيل السريع

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
# تحديث BASE_URL في api_client.dart
flutter run
```

---

## 📊 قاعدة البيانات

### الجداول الرئيسية:
- **users** - المستخدمون
- **products** - المنتجات (name, category, description, specifications, price, stock, image_url)
- **cart_items** - عناصر السلة
- **orders** - الطلبات
- **order_items** - عناصر الطلبات
- **favorites** - المفضلة

---

## 👥 المساهمة

هذا مشروع تعليمي. يمكنك استخدامه كقاعدة لمشاريعك الخاصة.

---

## 📄 الترخيص

هذا المشروع مفتوح المصدر ومتاح للاستخدام الحر.

---

## 📞 الدعم

إذا واجهت أي مشاكل أو لديك أسئلة، يمكنك:
1. فتح Issue في المشروع
2. مراجعة قسم "حل المشاكل الشائعة" أعلاه

---

**تم التطوير بواسطة:** [Your Name]  
**التاريخ:** 2024  
**الإصدار:** 1.0.0
