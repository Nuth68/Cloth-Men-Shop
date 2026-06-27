import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedStrings = <String, Map<String, String>>{
    'en': {
      // ── App / Navigation ──
      'appName': 'Steav Fashion',
      'home': 'Home',
      'shop': 'Shop',
      'lookbook': 'Lookbook',
      'stylist': 'Stylist',
      'account': 'Account',
      'language': 'Language',

      // ── Auth ──
      'signIn': 'SIGN IN',
      'signingIn': 'SIGNING IN...',
      'createAccount': 'Create account',
      'register': 'Create Account',
      'forgotPassword': 'Forgot Password?',
      'logout': 'Log Out',
      'welcomeBack': 'Welcome back',
      'guestCheckout': 'Continue as guest',
      'skip': 'Skip',
      'signInTitle': 'Sign in',
      'email': 'Email',
      'password': 'Password',
      'fullName': 'Full Name',

      // ── Home ──
      'allProducts': 'All Products',
      'top': 'Top',
      'discount': 'Discount',
      'items': 'items',
      'noProducts': 'No products found',
      'newArrivals': 'New Arrivals',

      // ── Categories ──
      'allCategory': 'All',
      'outerwear': 'Outerwear',
      'shirts': 'Shirts',
      'pants': 'Pants',
      'shoes': 'Shoes',
      'bags': 'Bags',

      // ── Catalog / Filter ──
      'filter': 'Filter',
      'retry': 'Retry',
      'clearFilters': 'Clear Filters',
      'showResults': 'SHOW RESULTS',
      'showAllResults': 'SHOW ALL RESULTS',
      'tryAdjustingFilters': 'Try adjusting your filters or check back later.',
      'somethingWentWrong': 'Something went wrong',
      'color': 'Color',
      'priceRange': 'Price Range',
      'brand': 'Brand',

      // ── Product Detail ──
      'addToCart': 'ADD TO CART',
      'buyNow': 'Buy Now',
      'wishlist': 'WISHLIST',
      'sizeGuide': 'Size Guide',
      'reviews': 'Reviews',
      'seeAll': 'See All',
      'newArrivalTag': 'NEW ARRIVAL',
      'productNotFound': 'Product not found',
      'notAvailable': 'Product not available.',
      'youMightAlsoLike': 'You Might Also Like',

      // ── Cart ──
      'cart': 'Cart',
      'cartEmpty': 'Your cart is empty',
      'cartEmptyMessage': 'Add items to get started.',
      'shopNow': 'Shop Now',
      'total': 'Total',
      'checkout': 'CHECKOUT',
      'addedToCart': 'added to cart',

      // ── Wishlist ──
      'noFavorites': 'No favorites yet',
      'browseProducts': 'Browse Products',
      'itemsSaved': 'items saved',
      'remove': 'REMOVE',

      // ── Checkout ──
      'orderSummary': 'ORDER SUMMARY',
      'subtotal': 'Subtotal',
      'shipping': 'Shipping',
      'free': 'FREE',
      'shippingAddress': 'Shipping Address',
      'streetAddress': 'Street Address',
      'city': 'City',
      'zipCode': 'ZIP Code',
      'addPaymentMethod': 'ADD PAYMENT METHOD',
      'placingOrder': 'PLACING ORDER...',
      'placeOrder': 'PLACE ORDER',
      'pleaseEnterAddress': 'Please enter your shipping address',
      'fullNameHint': 'John Doe',
      'phoneNumber': 'Phone',
      'phoneHint': '+1 234 567 8900',
      'addressHint': '123 Main St, Apt 4',
      'continueToPayment': 'CONTINUE TO PAYMENT',

      // ── Payment ──
      'paymentMethods': 'Payment Methods',
      'savedCards': 'SAVED CARDS',
      'addNewCard': 'Add New Card',
      'otherMethods': 'OTHER METHODS',
      'billingAddress': 'BILLING ADDRESS',
      'paypal': 'PayPal',
      'connected': 'Connected',
      'applePay': 'Apple Pay',
      'readyToUse': 'Ready to use',
      'edit': 'Edit',
      'cardNumber': 'Card Number',
      'expiryDate': 'MM/YY',
      'cvv': 'CVV',
      'cardholderName': 'Cardholder Name',
      'saveCard': 'Save Card',
      'setDefault': 'Set Default',
      'defaultLabel': 'Default',

      // ── Orders ──
      'orders': 'Orders',
      'couldntLoadOrders': 'Couldn\'t load orders',
      'noOrdersYet': 'No orders yet',
      'purchaseHistory': 'Your purchase history will appear here.',
      'orderId': 'Order ID',
      'placedOn': 'Placed on',
      'shippingTo': 'Shipping to',
      'trackPackage': 'TRACK PACKAGE',
      'order': 'Order',
      'delivered': 'DELIVERED',
      'processing': 'PROCESSING',
      'shipped': 'SHIPPED',

      // ── Profile / Edit Profile ──
      'profile': 'Profile',
      'editProfile': 'Edit Profile',
      'save': 'Save',
      'saveChanges': 'SAVE CHANGES',
      'emailAddress': 'Email Address',
      'phoneOptional': 'Phone (Optional)',
      'required': 'Required',
      'invalidEmail': 'Invalid email',
      'profileUpdated': 'Profile updated',
      'darkMode': 'Dark Mode',
      'privacy': 'Privacy',
      'helpCenter': 'Help Center',
      'about': 'About',
      'welcomeArchive': 'Welcome to Your Archive',
      'signInPrompt': 'Sign in to access your profile, orders, and saved items.',
      'theArchive': 'THE ARCHIVE',
      'preferences': 'Preferences',
      'appearance': 'Appearance',
      'support': 'Support',
      'shopping': 'Shopping',
      'selectLanguage': 'Select Language',

      // ── Notifications ──
      'notifications': 'Notifications',
      'markAllRead': 'Mark all read',
      'noNotifications': 'No notifications yet',
      'orderConfirmed': 'Order Confirmed',
      'orderShipped': 'Order Shipped',
      'orderDelivered': 'Order Delivered',
      'seasonSale': 'Season Sale — 30% Off',
      'stylistMessage': 'sent you a message',
      'newDrop': 'New Arrivals Dropped',
      'notifOrderMsg': 'Your order #1024 has been confirmed and is being prepared.',
      'notifShippingMsg': 'Order #1023 is on its way. Track your package now.',
      'notifDeliveredMsg': 'Order #1022 has been delivered. Enjoy your new pieces.',
      'notifSaleMsg': 'Autumn/Winter collection now on sale. Limited time only.',
      'notifStylistMsg': 'I\'ve curated some pieces you might love for the weekend...',
      'notifNewDropMsg': 'The Foundation Collection is here. Be the first to shop.',

      // ── Search ──
      'searchHint': 'Search...',
      'noResultsFound': 'No results found',
      'recentSearches': 'Recent Searches',
      'trending': 'Trending',

      // ── Size Guide ──
      'size': 'SIZE',
      'male': 'MALE',
      'female': 'FEMALE',
      'howToMeasure': 'HOW TO MEASURE',
      'chest': 'Chest',
      'waist': 'Waist',
      'hip': 'Hip',
      'length': 'Length',
      'chestMeasure': 'Measure around the fullest part of your chest, keeping the tape measure horizontal and snug but not tight.',
      'waistMeasure': 'Measure around your natural waistline, keeping the tape comfortably loose.',
      'hipMeasure': 'Measure around the fullest part of your hips, about 7-8 inches below your waistline.',
      'lengthMeasure': 'Measure from the top of your shoulder down to where you want the garment to end.',

      // ── Stylist ──
      'selectStylist': 'SELECT YOUR STYLIST',
      'selectDate': 'SELECT DATE',
      'selectTime': 'SELECT TIME',
      'sessionSummary': 'Session Summary',
      'bookAppointment': 'BOOK APPOINTMENT',
      'selected': 'SELECTED',
      'minConsultation': '60 min Consultation',
      'with': 'with',
      'expertStylist': 'EXPERT STYLIST',
      'online': 'Online',
      'messageHint': 'Message...',
      'bespokeTailoring': 'Bespoke Tailoring',
      'casualLuxe': 'Casual Luxe',
      'archiveVintage': 'Archive & Vintage',
      'savileRow': 'Savile Row trained. Precision blazers and formal wear.',
      'italianKnitwear': 'Italian knitwear, denim curation, relaxed silhouettes.',
      'rareArchival': 'Rare archival sourcing. Statement pieces worldwide.',

      // ── Lookbook ──
      'theEdit': 'THE EDIT',
      'autumnWinter': 'Autumn / Winter\n2024 Lookbook',
      'blazers': 'BLAZERS',
      'knits': 'KNITS',
      'formal': 'FORMAL',
      'casual': 'CASUAL',
      'editorial': 'EDITORIAL',
      'resort': 'RESORT',
      'shopThisLook': 'SHOP THIS LOOK',

      // ── Promotions ──
      'summerSale': 'SUMMER SALE',
      'upToFiftyOff': 'Up to 50% Off',
      'newArrivalsBanner': 'NEW ARRIVALS',
      'fifteenOffFirst': '15% Off First Order',
      'freeShippingBanner': 'FREE SHIPPING',
      'freeShippingOver': 'On Orders Over \$100',
      'useCode': 'Use code',
      'availableCoupons': 'Available Coupons',
      'codeCopied': 'Code copied!',
      'expiresIn': 'Expires in',
      'days': 'days',
      'useNow': 'Use Now',

      // ── Reviews ──
      'basedOn': 'Based on',
      'writeReview': 'Write a Review',
      'submitReview': 'Submit Review',
      'yourRating': 'Your Rating',
      'yourReview': 'Your Review',
      'verifiedPurchase': 'Verified Purchase',
      'fitFeedback': 'Fit Feedback',
      'runsSmall': 'Runs Small',
      'trueToSize': 'True to Size',
      'runsLarge': 'Runs Large',
      'sizePurchased': 'Size Purchased',

      // ── Onboarding ──
      'onboardingTagline': 'CURATED FOR THE MODERN WARDROBE',
      'getStarted': 'Get Started',
      'next': 'NEXT',
      'slideArchiveTitle': 'The Archive\nAwaits',
      'slideArchiveSubtitle':
          'Discover meticulously curated pieces designed to outlast the season.',
      'slideStylistTitle': 'Your Personal\nStylist',
      'slideStylistSubtitle':
          'Book one-on-one consultations with expert stylists who understand your language.',
      'slideCraftedTitle': 'Crafted to\nPerfection',
      'slideCraftedSubtitle':
          'Every piece is a documented study in silhouette, material, and movement.',

      // ── Map / Store Locator ──
      'getDirections': 'GET DIRECTIONS',
      'tryOnInStore': 'Try on in store',
      'openNow': 'Open Now',
      'closed': 'Closed',
      'distance': 'Distance',
      'rating': 'Rating',
      'nearbyStores': 'Nearby Stores',
      'storeLocations': 'Store Locations',
      'promotions': 'Promotions',
      'discover': 'Discover',
      'storeAddress': 'Address',
      'storeHours': 'Hours',
      'storePhone': 'Phone',
      'kmAway': 'km away',

      // ── Media ──
      'photos': 'Photos',
      'videos': 'Videos',
      'videoPlaybackComingSoon': 'Video playback coming soon',
      'springSummerRunway': 'Spring/Summer Runway',
      'behindTheScenes': 'Behind the Scenes',
      'stylingTips': 'Styling Tips',
    },
    'km': {
      // ── App / Navigation ──
      'appName': 'ស្ទីវ ហ្វេសិន',
      'home': 'ទំព័រដើម',
      'shop': 'ហាង',
      'lookbook': 'កាតាឡុក',
      'stylist': 'ស្ទីលីស',
      'account': 'គណនី',
      'language': 'ភាសា',

      // ── Auth ──
      'signIn': 'ចូល',
      'signingIn': 'កំពុងចូល...',
      'createAccount': 'បង្កើតគណនី',
      'register': 'បង្កើតគណនី',
      'forgotPassword': 'ភ្លេចពាក្យសម្ងាត់?',
      'logout': 'ចាកចេញ',
      'welcomeBack': 'សូមស្វាគមន៍',
      'guestCheckout': 'ចូលជាភ្ញៀវ',
      'skip': 'រំលង',
      'signInTitle': 'ចូលគណនី',
      'email': 'អ៊ីមែល',
      'password': 'ពាក្យសម្ងាត់',
      'fullName': 'ឈ្មោះពេញ',

      // ── Home ──
      'allProducts': 'ផលិតផលទាំងអស់',
      'top': 'ពេញនិយម',
      'discount': 'បញ្ចុះតម្លៃ',
      'items': 'ទំនិញ',
      'noProducts': 'រកមិនឃើញផលិតផល',
      'newArrivals': 'មកដល់ថ្មី',

      // ── Categories ──
      'allCategory': 'ទាំងអស់',
      'outerwear': 'អាវក្រៅ',
      'shirts': 'អាវ',
      'pants': 'ខោ',
      'shoes': 'ស្បែកជើង',
      'bags': 'កាបូប',

      // ── Catalog / Filter ──
      'filter': 'តម្រង',
      'retry': 'ព្យាយាមម្តងទៀត',
      'clearFilters': 'សម្អាតតម្រង',
      'showResults': 'បង្ហាញលទ្ធផល',
      'showAllResults': 'បង្ហាញលទ្ធផលទាំងអស់',
      'tryAdjustingFilters': 'សូមកែតម្រូវតម្រងរបស់អ្នក ឬពិនិត្យមើលពេលក្រោយ។',
      'somethingWentWrong': 'មានបញ្ហាមួយបានកើតឡើង',
      'color': 'ពណ៌',
      'priceRange': 'ជួរតម្លៃ',
      'brand': 'ម៉ាក',

      // ── Product Detail ──
      'addToCart': 'ដាក់ក្នុងកន្ត្រក',
      'buyNow': 'ទិញឥឡូវ',
      'wishlist': 'ចំណូលចិត្ត',
      'sizeGuide': 'តារាងទំហំ',
      'reviews': 'ការវាយតម្លៃ',
      'seeAll': 'មើលទាំងអស់',
      'newArrivalTag': 'មកដល់ថ្មី',
      'productNotFound': 'រកមិនឃើញផលិតផល',
      'notAvailable': 'មិនមានទំនិញ។',
      'youMightAlsoLike': 'អ្នកក៏អាចចូលចិត្ត',

      // ── Cart ──
      'cart': 'កន្ត្រក',
      'cartEmpty': 'កន្ត្រកទទេ',
      'cartEmptyMessage': 'បន្ថែមទំនិញដើម្បីចាប់ផ្តើម។',
      'shopNow': 'ចូលហាង',
      'total': 'សរុប',
      'checkout': 'ទូទាត់',
      'addedToCart': 'បានដាក់ក្នុងកន្ត្រក',

      // ── Wishlist ──
      'noFavorites': 'គ្មានចំណូលចិត្ត',
      'browseProducts': 'រកមើលផលិតផល',
      'itemsSaved': 'ទំនិញបានរក្សាទុក',
      'remove': 'ដកចេញ',

      // ── Checkout ──
      'orderSummary': 'សង្ខេបការបញ្ជាទិញ',
      'subtotal': 'សរុបរង',
      'shipping': 'ការដឹកជញ្ជូន',
      'free': 'ឥតគិតថ្លៃ',
      'shippingAddress': 'អាសយដ្ឋានដឹកជញ្ជូន',
      'streetAddress': 'អាសយដ្ឋាន',
      'city': 'ទីក្រុង',
      'zipCode': 'លេខប្រៃសណីយ៍',
      'addPaymentMethod': 'បន្ថែមវិធីទូទាត់',
      'placingOrder': 'កំពុងបញ្ជាទិញ...',
      'placeOrder': 'បញ្ជាទិញ',
      'pleaseEnterAddress': 'សូមបញ្ចូលអាសយដ្ឋានដឹកជញ្ជូន',
      'fullNameHint': 'ចន ដូ',
      'phoneNumber': 'លេខទូរសព្ទ',
      'phoneHint': '+៨៥៥ ១២ ៣៤៥ ៦៧៨',
      'addressHint': 'ផ្ទះលេខ១២៣ ផ្លូវសំខាន់',
      'continueToPayment': 'បន្តទៅទូទាត់',

      // ── Payment ──
      'paymentMethods': 'វិធីទូទាត់',
      'savedCards': 'កាតដែលបានរក្សាទុក',
      'addNewCard': 'បន្ថែមកាតថ្មី',
      'otherMethods': 'វិធីផ្សេងទៀត',
      'billingAddress': 'អាសយដ្ឋានវិក័យបត្រ',
      'paypal': 'ប៉េផាល់',
      'connected': 'បានភ្ជាប់',
      'applePay': 'អេផលផេយ៍',
      'readyToUse': 'រួចរាល់',
      'edit': 'កែសម្រួល',
      'cardNumber': 'លេខកាត',
      'expiryDate': 'ខែ/ឆ្នាំ',
      'cvv': 'CVV',
      'cardholderName': 'ឈ្មោះម្ចាស់កាត',
      'saveCard': 'រក្សាទុកកាត',
      'setDefault': 'កំណត់ជាលំនាំដើម',
      'defaultLabel': 'លំនាំដើម',

      // ── Orders ──
      'orders': 'ការបញ្ជាទិញ',
      'couldntLoadOrders': 'មិនអាចផ្ទុកការបញ្ជាទិញ',
      'noOrdersYet': 'មិនទាន់មានការបញ្ជាទិញ',
      'purchaseHistory': 'ប្រវត្តិនៃការបញ្ជាទិញនឹងបង្ហាញនៅទីនេះ។',
      'orderId': 'លេខបញ្ជាទិញ',
      'placedOn': 'បានបញ្ជាទិញនៅ',
      'shippingTo': 'ដឹកជញ្ជូនទៅ',
      'trackPackage': 'តាមដានកញ្ចប់',
      'order': 'ការបញ្ជាទិញ',
      'delivered': 'បានដឹកជញ្ជូន',
      'processing': 'កំពុងដំណើរការ',
      'shipped': 'បានដឹកជញ្ជូន',

      // ── Profile / Edit Profile ──
      'profile': 'ប្រវត្តិរូប',
      'editProfile': 'កែប្រវត្តិរូប',
      'save': 'រក្សាទុក',
      'saveChanges': 'រក្សាទុក',
      'emailAddress': 'អាសយដ្ឋានអ៊ីមែល',
      'phoneOptional': 'លេខទូរសព្ទ (ជម្រើស)',
      'required': 'ចាំបាច់',
      'invalidEmail': 'អ៊ីមែលមិនត្រឹមត្រូវ',
      'profileUpdated': 'ប្រវត្តិរូបបានធ្វើបច្ចុប្បន្នភាព',
      'darkMode': 'របៀបងងឹត',
      'privacy': 'ឯកជនភាព',
      'helpCenter': 'មជ្ឈមណ្ឌលជំនួយ',
      'about': 'អំពី',
      'welcomeArchive': 'សូមស្វាគមន៍មកកាន់បណ្ណសារ',
      'signInPrompt': 'ចូលគណនីដើម្បីចូលមើលប្រវត្តិរូប ការបញ្ជាទិញ និងទំនិញដែលបានរក្សាទុក។',
      'theArchive': 'បណ្ណសារ',
      'preferences': 'ចំណូលចិត្ត',
      'appearance': 'រូបរាង',
      'support': 'ជំនួយ',
      'shopping': 'ការទិញទំនិញ',
      'selectLanguage': 'ជ្រើសរើសភាសា',

      // ── Notifications ──
      'notifications': 'ការជូនដំណឹង',
      'markAllRead': 'សម្គាល់ថាបានអានទាំងអស់',
      'noNotifications': 'គ្មានការជូនដំណឹង',
      'orderConfirmed': 'ការបញ្ជាទិញបានបញ្ជាក់',
      'orderShipped': 'ការបញ្ជាទិញបានដឹកជញ្ជូន',
      'orderDelivered': 'ការបញ្ជាទិញបានដឹកជញ្ជូនដល់',
      'seasonSale': 'ការបញ្ចុះតម្លៃរដូវកាល ៣០%',
      'stylistMessage': 'បានផ្ញើសារមកអ្នក',
      'newDrop': 'មកដល់ថ្មី',
      'notifOrderMsg': 'ការបញ្ជាទិញ #១០២៤ ត្រូវបានបញ្ជាក់ និងកំពុងរៀបចំ។',
      'notifShippingMsg': 'ការបញ្ជាទិញ #១០២៣ កំពុងដឹកជញ្ជូន។ តាមដានកញ្ចប់របស់អ្នក។',
      'notifDeliveredMsg': 'ការបញ្ជាទិញ #១០២២ បានដឹកជញ្ជូនដល់។ សូមរីករាយជាមួយទំនិញថ្មី។',
      'notifSaleMsg': 'ការប្រមូលរដូវស្លឹកឈើជ្រុះ/រដូវរងាបញ្ចុះតម្លៃ។ មានកំណត់។',
      'notifStylistMsg': 'ខ្ញុំបានជ្រើសរើសទំនិញខ្លះដែលអ្នកអាចចូលចិត្តសម្រាប់ចុងសប្តាហ៍...',
      'notifNewDropMsg': 'ការប្រមូលគ្រឹះបានមកដល់។ ក្លាយជាអ្នកដំបូងដែលបានទិញ។',

      // ── Search ──
      'searchHint': 'ស្វែងរក...',
      'noResultsFound': 'រកមិនឃើញលទ្ធផល',
      'recentSearches': 'ការស្វែងរកថ្មីៗ',
      'trending': 'កំពុងពេញនិយម',

      // ── Size Guide ──
      'size': 'ទំហំ',
      'male': 'ប្រុស',
      'female': 'ស្រី',
      'howToMeasure': 'របៀបវាស់',
      'chest': 'ទ្រូង',
      'waist': 'ចង្កេះ',
      'hip': 'ត្រគាក',
      'length': 'ប្រវែង',
      'chestMeasure': 'វាស់ជុំវិញផ្នែកពេញបំផុតនៃទ្រូង ដោយរក្សាខ្សែវាស់ឱ្យផ្ដេកនិងតឹងល្មម។',
      'waistMeasure': 'វាស់ជុំវិញចង្កេះធម្មជាតិ ដោយរក្សាខ្សែវាស់ឱ្យរលុងល្មម។',
      'hipMeasure': 'វាស់ជុំវិញផ្នែកពេញបំផុតនៃត្រគាក ប្រហែល ៧-៨ អ៊ីញក្រោមចង្កេះ។',
      'lengthMeasure': 'វាស់ពីកំពូលស្មាចុះក្រោមដល់កន្លែងដែលអ្នកចង់ឱ្យសម្លៀកបំពាក់បញ្ចប់។',

      // ── Stylist ──
      'selectStylist': 'ជ្រើសរើសស្ទីលីស',
      'selectDate': 'ជ្រើសរើសថ្ងៃ',
      'selectTime': 'ជ្រើសរើសម៉ោង',
      'sessionSummary': 'សង្ខេបវគ្គ',
      'bookAppointment': 'កក់ការណាត់',
      'selected': 'បានជ្រើសរើស',
      'minConsultation': '៦០ នាទីពិគ្រោះ',
      'with': 'ជាមួយ',
      'expertStylist': 'ស្ទីលីសជំនាញ',
      'online': 'អនឡាញ',
      'messageHint': 'សារ...',
      'bespokeTailoring': 'កាត់ដេរផ្ទាល់ខ្លួន',
      'casualLuxe': 'ស្ទីលធម្មតាបែបប្រណីត',
      'archiveVintage': 'បណ្ណសារ និងវីនថេច',
      'savileRow': 'បណ្តុះបណ្តាលពី Savile Row។ អាវក្រៅនិងសម្លៀកបំពាក់ផ្លូវការ។',
      'italianKnitwear': 'សម្លៀកបំពាក់ប៉ាក់អ៊ីតាលី ការជ្រើសរើសខោខូវប៊យ ស្ទីលធូររលុង។',
      'rareArchival': 'ការស្វែងរកបណ្ណសារដ៏កម្រ។ ទំនិញពិសេសទូទាំងពិភពលោក។',

      // ── Lookbook ──
      'theEdit': 'ការបោះពុម្ព',
      'autumnWinter': 'កាតាឡុករដូវស្លឹកឈើជ្រុះ\n/ រដូវរងា ២០២៤',
      'blazers': 'អាវក្រៅ',
      'knits': 'ប៉ាក់',
      'formal': 'ផ្លូវការ',
      'casual': 'ធម្មតា',
      'editorial': 'វិចារណកថា',
      'resort': 'រីសត',
      'shopThisLook': 'ទិញស្ទីលនេះ',

      // ── Promotions ──
      'summerSale': 'ការបញ្ចុះតម្លៃរដូវក្តៅ',
      'upToFiftyOff': 'បញ្ចុះតម្លៃរហូតដល់ ៥០%',
      'newArrivalsBanner': 'មកដល់ថ្មី',
      'fifteenOffFirst': 'បញ្ចុះ ១៥% សម្រាប់ការបញ្ជាទិញដំបូង',
      'freeShippingBanner': 'ដឹកជញ្ជូនឥតគិតថ្លៃ',
      'freeShippingOver': 'សម្រាប់ការបញ្ជាទិញលើសពី \$១០០',
      'useCode': 'ប្រើកូដ',
      'availableCoupons': 'គូប៉ុងដែលអាចប្រើបាន',
      'codeCopied': 'បានចម្លងកូដ!',
      'expiresIn': 'ផុតកំណត់ក្នុងរយៈពេល',
      'days': 'ថ្ងៃ',
      'useNow': 'ប្រើឥឡូវ',

      // ── Reviews ──
      'basedOn': 'ផ្អែកលើ',
      'writeReview': 'សរសេរការវាយតម្លៃ',
      'submitReview': 'ដាក់ស្នើការវាយតម្លៃ',
      'yourRating': 'ការវាយតម្លៃរបស់អ្នក',
      'yourReview': 'ការវាយតម្លៃរបស់អ្នក',
      'verifiedPurchase': 'ការទិញដែលបានផ្ទៀងផ្ទាត់',
      'fitFeedback': 'មតិអំពីទំហំ',
      'runsSmall': 'តូចជាងទំហំធម្មតា',
      'trueToSize': 'ត្រឹមទំហំ',
      'runsLarge': 'ធំជាងទំហំធម្មតា',
      'sizePurchased': 'ទំហំដែលបានទិញ',

      // ── Onboarding ──
      'onboardingTagline': 'រៀបចំសម្រាប់ទូខោអាវទំនើប',
      'getStarted': 'ចាប់ផ្តើម',
      'next': 'បន្ទាប់',
      'slideArchiveTitle': 'បណ្ណសារ\nកំពុងរង់ចាំ',
      'slideArchiveSubtitle':
          'ស្វែងរកទំនិញដែលបានជ្រើសរើសយ៉ាងល្អិតល្អន់ រចនាឡើងដើម្បីប្រើប្រាស់បានយូរជាងរដូវកាល។',
      'slideStylistTitle': 'ស្ទីលីស\nផ្ទាល់ខ្លួនរបស់អ្នក',
      'slideStylistSubtitle':
          'កក់ការពិគ្រោះយោបល់ផ្ទាល់ខ្លួនជាមួយស្ទីលីសជំនាញដែលយល់ពីភាសារបស់អ្នក។',
      'slideCraftedTitle': 'ផលិតយ៉ាង\nល្អឥតខ្ចោះ',
      'slideCraftedSubtitle':
          'រាល់ទំនិញគឺជាការសិក្សាឯកសារអំពីរូបរាង សម្ភារៈ និងចលនា។',

      // ── Map / Store Locator ──
      'getDirections': 'ទទួលទិសដៅ',
      'tryOnInStore': 'សាកល្បងនៅក្នុងហាង',
      'openNow': 'បើកឥឡូវ',
      'closed': 'បិទ',
      'distance': 'ចម្ងាយ',
      'rating': 'ការវាយតម្លៃ',
      'nearbyStores': 'ហាងនៅជិត',
      'storeLocations': 'ទីតាំងហាង',
      'promotions': 'ការផ្សព្វផ្សាយ',
      'discover': 'រកឃើញ',
      'storeAddress': 'អាសយដ្ឋាន',
      'storeHours': 'ម៉ោងធ្វើការ',
      'storePhone': 'លេខទូរសព្ទ',
      'kmAway': 'គ.ម ពីទីនេះ',

      // ── Media ──
      'photos': 'រូបថត',
      'videos': 'វីដេអូ',
      'videoPlaybackComingSoon': 'ការចាក់វីដេអូនឹងមកដល់ឆាប់ៗនេះ',
      'springSummerRunway': 'ដំណើរបង្ហាញរដូវផ្ការីក/រដូវក្តៅ',
      'behindTheScenes': 'នៅពីក្រោយឆាក',
      'stylingTips': 'គន្លឹះក្នុងការស្លៀកពាក់',
    },
  };

  String translate(String key) {
    final langMap = _localizedStrings[locale.languageCode] ?? _localizedStrings['en']!;
    return langMap[key] ?? key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['km', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => Future.value(AppLocalizations(locale));

  @override
  bool shouldReload(covariant _AppLocalizationsDelegate old) => true;
}
