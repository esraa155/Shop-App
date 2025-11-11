import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  // Translations
  String get appTitle => _localizedValues[locale.languageCode]?['appTitle'] ?? 'Shop App';
  String get products => _localizedValues[locale.languageCode]?['products'] ?? 'Products';
  String get cart => _localizedValues[locale.languageCode]?['cart'] ?? 'Cart';
  String get favorites => _localizedValues[locale.languageCode]?['favorites'] ?? 'Favorites';
  String get login => _localizedValues[locale.languageCode]?['login'] ?? 'Login';
  String get register => _localizedValues[locale.languageCode]?['register'] ?? 'Register';
  String get name => _localizedValues[locale.languageCode]?['name'] ?? 'Name';
  String get email => _localizedValues[locale.languageCode]?['email'] ?? 'Email';
  String get password => _localizedValues[locale.languageCode]?['password'] ?? 'Password';
  String get required => _localizedValues[locale.languageCode]?['required'] ?? 'Required';
  String get minChars => _localizedValues[locale.languageCode]?['minChars'] ?? 'Min 6 chars';
  String get pleaseWait => _localizedValues[locale.languageCode]?['pleaseWait'] ?? 'Please wait...';
  String get createAccount => _localizedValues[locale.languageCode]?['createAccount'] ?? 'Create account';
  String get haveAccount => _localizedValues[locale.languageCode]?['haveAccount'] ?? 'I have an account';
  String get noProducts => _localizedValues[locale.languageCode]?['noProducts'] ?? 'No products';
  String get failedToLoad => _localizedValues[locale.languageCode]?['failedToLoad'] ?? 'Failed to load products';
  String get addedToCart => _localizedValues[locale.languageCode]?['addedToCart'] ?? 'Added to cart';
  String get addedQtyToCart => _localizedValues[locale.languageCode]?['addedQtyToCart'] ?? 'Added {qty} to cart';
  String addedQtyToCartWith(int qty) => addedQtyToCart.replaceAll('{qty}', qty.toString());
  String get quantity => _localizedValues[locale.languageCode]?['quantity'] ?? 'Quantity';
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? 'Cancel';
  String get add => _localizedValues[locale.languageCode]?['add'] ?? 'Add';
  String get qty => _localizedValues[locale.languageCode]?['qty'] ?? 'Qty';
  String get subtotal => _localizedValues[locale.languageCode]?['subtotal'] ?? 'Subtotal';
  String get checkout => _localizedValues[locale.languageCode]?['checkout'] ?? 'Checkout';
  String get payment => _localizedValues[locale.languageCode]?['payment'] ?? 'Payment';
  String get shippingAddress => _localizedValues[locale.languageCode]?['shippingAddress'] ?? 'Shipping Address';
  String get paymentMethod => _localizedValues[locale.languageCode]?['paymentMethod'] ?? 'Payment Method';
  String get cashOnDelivery => _localizedValues[locale.languageCode]?['cashOnDelivery'] ?? 'Cash on Delivery';
  String get creditDebitCard => _localizedValues[locale.languageCode]?['creditDebitCard'] ?? 'Credit/Debit Card';
  String get total => _localizedValues[locale.languageCode]?['total'] ?? 'Total';
  String get payNow => _localizedValues[locale.languageCode]?['payNow'] ?? 'Pay now';
  String get paymentSuccessful => _localizedValues[locale.languageCode]?['paymentSuccessful'] ?? 'Payment successful';
  String get noFavoritesYet => _localizedValues[locale.languageCode]?['noFavoritesYet'] ?? 'No favorites yet';
  String get failedToLoadCart => _localizedValues[locale.languageCode]?['failedToLoadCart'] ?? 'Failed to load cart';
  String get addToCart => _localizedValues[locale.languageCode]?['addToCart'] ?? 'Add to cart';
  String get price => _localizedValues[locale.languageCode]?['price'] ?? 'Price';
  String get noDescription => _localizedValues[locale.languageCode]?['noDescription'] ?? 'No description';
  String get logout => _localizedValues[locale.languageCode]?['logout'] ?? 'Logout';
  String get arabic => _localizedValues[locale.languageCode]?['arabic'] ?? 'العربية';
  String get english => _localizedValues[locale.languageCode]?['english'] ?? 'English';
  String get fullName => _localizedValues[locale.languageCode]?['fullName'] ?? 'Full Name';
  String get phoneNumber => _localizedValues[locale.languageCode]?['phoneNumber'] ?? 'Phone Number';
  String get city => _localizedValues[locale.languageCode]?['city'] ?? 'City';
  String get street => _localizedValues[locale.languageCode]?['street'] ?? 'Street';
  String get building => _localizedValues[locale.languageCode]?['building'] ?? 'Building';
  String get cardNumber => _localizedValues[locale.languageCode]?['cardNumber'] ?? 'Card Number';
  String get expiryDate => _localizedValues[locale.languageCode]?['expiryDate'] ?? 'Expiry Date';
  String get cvv => _localizedValues[locale.languageCode]?['cvv'] ?? 'CVV';
  String get cardHolderName => _localizedValues[locale.languageCode]?['cardHolderName'] ?? 'Card Holder Name';
  String get invalidEmail => _localizedValues[locale.languageCode]?['invalidEmail'] ?? 'Invalid email';
  String get invalidPhone => _localizedValues[locale.languageCode]?['invalidPhone'] ?? 'Invalid phone number';
  String get selectLanguage => _localizedValues[locale.languageCode]?['selectLanguage'] ?? 'Select Language';
  String get viewFavorites => _localizedValues[locale.languageCode]?['viewFavorites'] ?? 'View Favorites';
  String get viewCart => _localizedValues[locale.languageCode]?['viewCart'] ?? 'View Cart';
  String get addToFavorites => _localizedValues[locale.languageCode]?['addToFavorites'] ?? 'Add to Favorites';
  String get removeFromFavorites => _localizedValues[locale.languageCode]?['removeFromFavorites'] ?? 'Remove from Favorites';
  String get showDetails => _localizedValues[locale.languageCode]?['showDetails'] ?? 'Show Details';
  String get hideDetails => _localizedValues[locale.languageCode]?['hideDetails'] ?? 'Hide Details';
  String get category => _localizedValues[locale.languageCode]?['category'] ?? 'Category';
  String get description => _localizedValues[locale.languageCode]?['description'] ?? 'Description';
  String get specifications => _localizedValues[locale.languageCode]?['specifications'] ?? 'Specifications';
  String get stock => _localizedValues[locale.languageCode]?['stock'] ?? 'Stock';
  String get outOfStock => _localizedValues[locale.languageCode]?['outOfStock'] ?? 'Out of Stock';
  String get cannotPurchaseOutOfStock => _localizedValues[locale.languageCode]?['cannotPurchaseOutOfStock'] ?? 'Cannot purchase this product because it is out of stock';
  String get profile => _localizedValues[locale.languageCode]?['profile'] ?? 'Profile';

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Shop App',
      'products': 'Products',
      'cart': 'Cart',
      'favorites': 'Favorites',
      'login': 'Login',
      'register': 'Register',
      'name': 'Name',
      'email': 'Email',
      'password': 'Password',
      'required': 'Required',
      'minChars': 'Min 6 chars',
      'pleaseWait': 'Please wait...',
      'createAccount': 'Create account',
      'haveAccount': 'I have an account',
      'noProducts': 'No products',
      'failedToLoad': 'Failed to load products',
      'addedToCart': 'Added to cart',
      'addedQtyToCart': 'Added {qty} to cart',
      'quantity': 'Quantity',
      'cancel': 'Cancel',
      'add': 'Add',
      'qty': 'Qty',
      'subtotal': 'Subtotal',
      'checkout': 'Checkout',
      'payment': 'Payment',
      'shippingAddress': 'Shipping Address',
      'paymentMethod': 'Payment Method',
      'cashOnDelivery': 'Cash on Delivery',
      'creditDebitCard': 'Credit/Debit Card',
      'total': 'Total',
      'payNow': 'Pay now',
      'paymentSuccessful': 'Payment successful',
      'noFavoritesYet': 'No favorites yet',
      'failedToLoadCart': 'Failed to load cart',
      'addToCart': 'Add to cart',
      'price': 'Price',
      'noDescription': 'No description',
      'logout': 'Logout',
      'arabic': 'العربية',
      'english': 'English',
      'fullName': 'Full Name',
      'phoneNumber': 'Phone Number',
      'city': 'City',
      'street': 'Street',
      'building': 'Building',
      'cardNumber': 'Card Number',
      'expiryDate': 'Expiry Date',
      'cvv': 'CVV',
      'cardHolderName': 'Card Holder Name',
      'invalidEmail': 'Invalid email',
      'invalidPhone': 'Invalid phone number',
      'selectLanguage': 'Select Language',
      'viewFavorites': 'View Favorites',
      'viewCart': 'View Cart',
      'addToFavorites': 'Add to Favorites',
      'removeFromFavorites': 'Remove from Favorites',
      'showDetails': 'Show Details',
      'hideDetails': 'Hide Details',
      'category': 'Category',
      'description': 'Description',
      'specifications': 'Specifications',
      'stock': 'Stock',
      'outOfStock': 'Out of Stock',
      'cannotPurchaseOutOfStock': 'Cannot purchase this product because it is out of stock',
      'profile': 'Profile',
    },
    'ar': {
      'appTitle': 'تطبيق المتجر',
      'products': 'المنتجات',
      'cart': 'السلة',
      'favorites': 'المفضلة',
      'login': 'تسجيل الدخول',
      'register': 'التسجيل',
      'name': 'الاسم',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'required': 'مطلوب',
      'minChars': 'الحد الأدنى 6 أحرف',
      'pleaseWait': 'يرجى الانتظار...',
      'createAccount': 'إنشاء حساب',
      'haveAccount': 'لدي حساب',
      'noProducts': 'لا توجد منتجات',
      'failedToLoad': 'فشل تحميل المنتجات',
      'addedToCart': 'تمت الإضافة إلى السلة',
      'addedQtyToCart': 'تمت إضافة {qty} إلى السلة',
      'quantity': 'الكمية',
      'cancel': 'إلغاء',
      'add': 'إضافة',
      'qty': 'الكمية',
      'subtotal': 'المجموع الفرعي',
      'checkout': 'الدفع',
      'payment': 'الدفع',
      'shippingAddress': 'عنوان الشحن',
      'paymentMethod': 'طريقة الدفع',
      'cashOnDelivery': 'الدفع عند الاستلام',
      'creditDebitCard': 'بطاقة ائتمان/خصم',
      'total': 'الإجمالي',
      'payNow': 'ادفع الآن',
      'paymentSuccessful': 'تم الدفع بنجاح',
      'noFavoritesYet': 'لا توجد مفضلات بعد',
      'failedToLoadCart': 'فشل تحميل السلة',
      'addToCart': 'أضف إلى السلة',
      'price': 'السعر',
      'noDescription': 'لا يوجد وصف',
      'logout': 'تسجيل الخروج',
      'arabic': 'العربية',
      'english': 'English',
      'fullName': 'الاسم الكامل',
      'phoneNumber': 'رقم الهاتف',
      'city': 'المدينة',
      'street': 'الشارع',
      'building': 'المبنى',
      'cardNumber': 'رقم البطاقة',
      'expiryDate': 'تاريخ الانتهاء',
      'cvv': 'CVV',
      'cardHolderName': 'اسم حامل البطاقة',
      'invalidEmail': 'بريد إلكتروني غير صحيح',
      'invalidPhone': 'رقم هاتف غير صحيح',
      'selectLanguage': 'اختر اللغة',
      'viewFavorites': 'عرض المفضلة',
      'viewCart': 'عرض السلة',
      'addToFavorites': 'أضف إلى المفضلة',
      'removeFromFavorites': 'إزالة من المفضلة',
      'showDetails': 'عرض التفاصيل',
      'hideDetails': 'إخفاء التفاصيل',
      'category': 'الفئة',
      'description': 'الوصف',
      'specifications': 'المواصفات',
      'stock': 'المخزون',
      'outOfStock': 'نفد المخزون',
      'cannotPurchaseOutOfStock': 'لا يمكن شراء هذا المنتج لأنه نفد من المخزون',
      'profile': 'الملف الشخصي',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

