// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'WordZoo';

  @override
  String get welcome => 'Welcome to WordZoo';

  @override
  String get subtitle => 'Learn English through fun';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get guestMode => 'Continue as Guest';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get displayName => 'Display Name';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signIn => 'Sign In';

  @override
  String get playNow => 'Start Learning';

  @override
  String get signOut => 'Sign Out';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get displayNameRequired => 'Display name is required';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get registerSuccess => 'Registration successful';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get guestLogin => 'Logged in as guest';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get finish => 'Finish';

  @override
  String get home => 'Home';

  @override
  String get categories => 'Categories';

  @override
  String get favorites => 'Favorites';

  @override
  String get progress => 'Progress';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get premium => 'Premium';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get premiumLocked => '🔒 Upgrade to Premium to unlock';

  @override
  String get learned => 'Learned';

  @override
  String get favorite => 'Favorite';

  @override
  String get notFavorite => 'Not Favorite';

  @override
  String get markAsLearned => 'Mark as Learned';

  @override
  String get unmarkAsLearned => 'Unmark as Learned';

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get removeFromFavorites => 'Remove from Favorites';

  @override
  String get audio => 'Audio';

  @override
  String get soundEffect => 'Sound Effect';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get search => 'Search...';

  @override
  String get noResults => 'No results found';

  @override
  String get noData => 'No data available';

  @override
  String get syncing => 'Syncing...';

  @override
  String get syncComplete => 'Sync complete';

  @override
  String get syncFailed => 'Sync failed';

  @override
  String get offline => 'Offline';

  @override
  String get online => 'Online';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get networkError => 'Network error';

  @override
  String get serverError => 'Server error';

  @override
  String get validationError => 'Validation error';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get loadingData => 'Loading data...';

  @override
  String get loadingCategories => 'Loading categories...';

  @override
  String get loadingEntities => 'Loading entities...';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get chinese => 'Chinese';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get preferences => 'Preferences';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get help => 'Help';

  @override
  String get feedback => 'Feedback';

  @override
  String get rateUs => 'Rate Us';

  @override
  String get shareApp => 'Share App';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String helloUser(Object name) {
    return 'Hello, $name!';
  }

  @override
  String get todayIsNewDay => 'What will you learn today? 😊';

  @override
  String get continueLearning => 'Continue Learning';

  @override
  String get startLearning => 'Start Learning';

  @override
  String get animals => 'Animals';

  @override
  String get plants => 'Plants';

  @override
  String get vehicles => 'Vehicles';

  @override
  String get humanRelations => 'Human Relations';

  @override
  String get selectCategory => 'Select a category';

  @override
  String get selectSubcategory => 'Select a subcategory';

  @override
  String get entityList => 'Entity List';

  @override
  String get entityDetail => 'Entity Detail';

  @override
  String get practice => 'Practice';

  @override
  String get quiz => 'Quiz';

  @override
  String get flashcard => 'Flashcard';

  @override
  String get dailyStreak => 'Daily Streak';

  @override
  String streakDays(Object count) {
    return '$count day streak';
  }

  @override
  String streakDays_plural(Object count) {
    return '$count days streak';
  }

  @override
  String get points => 'Points';

  @override
  String get level => 'Level';

  @override
  String get rank => 'Rank';

  @override
  String get achievement => 'Achievement';

  @override
  String get achievements => 'Achievements';

  @override
  String get badge => 'Badge';

  @override
  String get badges => 'Badges';

  @override
  String get completed => 'Completed';

  @override
  String get inProgress => 'In Progress';

  @override
  String get notStarted => 'Not Started';

  @override
  String get timeSpent => 'Time spent';

  @override
  String get entitiesLearned => 'Entities learned';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get correct => 'Correct';

  @override
  String get wrong => 'Wrong';

  @override
  String get skip => 'Skip';

  @override
  String get submit => 'Submit';

  @override
  String get answer => 'Answer';

  @override
  String get answers => 'Answers';

  @override
  String get question => 'Question';

  @override
  String get questions => 'Questions';

  @override
  String get result => 'Result';

  @override
  String get results => 'Results';

  @override
  String get score => 'Score';

  @override
  String get totalScore => 'Total Score';

  @override
  String get percentage => 'Percentage';

  @override
  String get pass => 'Pass';

  @override
  String get fail => 'Fail';

  @override
  String get excellent => 'Excellent!';

  @override
  String get great => 'Great job!';

  @override
  String get good => 'Good!';

  @override
  String get keepTrying => 'Keep trying!';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String get wellDone => 'Well done!';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get goalReached => 'Goal reached!';

  @override
  String get goalNotReached => 'Goal not reached';

  @override
  String get streak => 'Streak';

  @override
  String get longestStreak => 'Longest Streak';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get bestScore => 'Best Score';

  @override
  String get lastPlayed => 'Last Played';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(Object count) {
    return '$count days ago';
  }

  @override
  String hoursAgo(Object count) {
    return '$count hours ago';
  }

  @override
  String minutesAgo(Object count) {
    return '$count minutes ago';
  }

  @override
  String get justNow => 'Just now';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get checkingConnection => 'Checking connection...';

  @override
  String get retryNow => 'Retry Now';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get enableNetwork => 'Please enable network connection';

  @override
  String get premiumFeature => 'Premium Feature';

  @override
  String get premiumDescription => 'Unlock all features with Premium';

  @override
  String get premiumMonthly => 'Premium Monthly';

  @override
  String get premiumYearly => 'Premium Yearly';

  @override
  String get premiumBenefits => 'Premium Benefits';

  @override
  String get benefit1 => 'Ad-free experience';

  @override
  String get benefit2 => 'Unlimited entities';

  @override
  String get benefit3 => 'Advanced analytics';

  @override
  String get benefit4 => 'Priority support';

  @override
  String get benefit5 => 'Exclusive content';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get subscribed => 'Subscribed';

  @override
  String get notSubscribed => 'Not Subscribed';

  @override
  String get paymentSuccessful => 'Payment successful!';

  @override
  String get paymentFailed => 'Payment failed';

  @override
  String get paymentCancelled => 'Payment cancelled';

  @override
  String get processingPayment => 'Processing payment...';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get purchased => 'Purchased';

  @override
  String get notPurchased => 'Not Purchased';

  @override
  String get consumed => 'Consumed';

  @override
  String get notConsumed => 'Not Consumed';

  @override
  String get rewardedAd => 'Watch ad to earn reward';

  @override
  String get rewardedAdGranted => 'Reward granted!';

  @override
  String get rewardedAdFailed => 'Failed to grant reward';

  @override
  String get adNotAvailable => 'Ad not available';

  @override
  String get loadingAd => 'Loading ad...';

  @override
  String get dataSync => 'Data Sync';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get autoSync => 'Auto Sync';

  @override
  String get lastSync => 'Last Sync';

  @override
  String get never => 'Never';

  @override
  String get dataVersion => 'Data Version';

  @override
  String get dataUpdated => 'Data updated successfully';

  @override
  String get dataUpdateFailed => 'Data update failed';

  @override
  String get downloadingData => 'Downloading data...';

  @override
  String get dataReady => 'Data ready';

  @override
  String get noNewData => 'No new data';

  @override
  String get cacheCleared => 'Cache cleared';

  @override
  String get cacheClearFailed => 'Failed to clear cache';

  @override
  String get storageFull => 'Storage full';

  @override
  String get storageWarning => 'Device storage is low';

  @override
  String get appUpdated => 'App updated';

  @override
  String get newVersionAvailable => 'New version available';

  @override
  String get latestVersion => 'You are using the latest version';

  @override
  String get checkUpdate => 'Check for Updates';

  @override
  String get notification => 'Notification';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get notificationEnabled => 'Notifications enabled';

  @override
  String get notificationDisabled => 'Notifications disabled';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get permissionRequired => 'This feature requires permission';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get settingsReset => 'Settings reset';

  @override
  String get resetSettings => 'Reset Settings';

  @override
  String get confirmReset => 'Are you sure you want to reset all settings?';

  @override
  String get logout => 'Log Out';

  @override
  String get confirmLogout => 'Are you sure you want to log out?';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get confirmDeleteAccount => 'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get accountDeleted => 'Account deleted';

  @override
  String get accountDeleteFailed => 'Failed to delete account';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get sendFeedback => 'Send Feedback';

  @override
  String get feedbackSent => 'Feedback sent';

  @override
  String get feedbackFailed => 'Failed to send feedback';

  @override
  String get share => 'Share';

  @override
  String get copyLink => 'Copy Link';

  @override
  String get linkCopied => 'Link copied';

  @override
  String get rateThisApp => 'Rate this app';

  @override
  String get thanksForRating => 'Thanks for rating!';

  @override
  String get noRatingGiven => 'No rating given';

  @override
  String get openInStore => 'Open in Store';

  @override
  String get writeReview => 'Write a Review';

  @override
  String get reviewSent => 'Review sent';

  @override
  String get reviewFailed => 'Failed to send review';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get faq => 'FAQ';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get supportEmail => 'support@wordzoo.com';

  @override
  String get socialMedia => 'Social Media';

  @override
  String get followUs => 'Follow Us';

  @override
  String get copyright => '© 2026 WordZoo. All rights reserved.';

  @override
  String get madeWithLove => 'Made with ❤️ for kids';

  @override
  String get developer => 'Developer';

  @override
  String get company => 'WordZoo Inc.';

  @override
  String get tagline => 'Learn English, Play Together';

  @override
  String get selectEntityToViewDetails => 'Select an entity to view details';

  @override
  String errorWithMessage(Object message) {
    return 'Error: $message';
  }

  @override
  String englishLabel(Object text) {
    return 'EN: $text';
  }

  @override
  String chineseLabel(Object text) {
    return 'ZH: $text';
  }
}
