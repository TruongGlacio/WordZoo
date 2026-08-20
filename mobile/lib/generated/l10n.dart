// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `WordZoo`
  String get appName {
    return Intl.message('WordZoo', name: 'appName', desc: '', args: []);
  }

  /// `Welcome to WordZoo`
  String get welcome {
    return Intl.message(
      'Welcome to WordZoo',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Learn English through fun`
  String get subtitle {
    return Intl.message(
      'Learn English through fun',
      name: 'subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Continue as Guest`
  String get guestMode {
    return Intl.message(
      'Continue as Guest',
      name: 'guestMode',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Display Name`
  String get displayName {
    return Intl.message(
      'Display Name',
      name: 'displayName',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Start Learning`
  String get playNow {
    return Intl.message('Start Learning', name: 'playNow', desc: '', args: []);
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message('Sign Out', name: 'signOut', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get noAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account? ',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordMismatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordTooShort {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get confirmPasswordRequired {
    return Intl.message(
      'Please confirm your password',
      name: 'confirmPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get emailRequired {
    return Intl.message(
      'Email is required',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Display name is required`
  String get displayNameRequired {
    return Intl.message(
      'Display name is required',
      name: 'displayNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Login successful`
  String get loginSuccess {
    return Intl.message(
      'Login successful',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful`
  String get registerSuccess {
    return Intl.message(
      'Registration successful',
      name: 'registerSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get loginFailed {
    return Intl.message(
      'Login failed',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed`
  String get registerFailed {
    return Intl.message(
      'Registration failed',
      name: 'registerFailed',
      desc: '',
      args: [],
    );
  }

  /// `Logged in as guest`
  String get guestLogin {
    return Intl.message(
      'Logged in as guest',
      name: 'guestLogin',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Favorites`
  String get favorites {
    return Intl.message('Favorites', name: 'favorites', desc: '', args: []);
  }

  /// `Progress`
  String get progress {
    return Intl.message('Progress', name: 'progress', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Premium`
  String get premium {
    return Intl.message('Premium', name: 'premium', desc: '', args: []);
  }

  /// `Upgrade`
  String get upgrade {
    return Intl.message('Upgrade', name: 'upgrade', desc: '', args: []);
  }

  /// `🔒 Upgrade to Premium to unlock`
  String get premiumLocked {
    return Intl.message(
      '🔒 Upgrade to Premium to unlock',
      name: 'premiumLocked',
      desc: '',
      args: [],
    );
  }

  /// `Learned`
  String get learned {
    return Intl.message('Learned', name: 'learned', desc: '', args: []);
  }

  /// `Favorite`
  String get favorite {
    return Intl.message('Favorite', name: 'favorite', desc: '', args: []);
  }

  /// `Not Favorite`
  String get notFavorite {
    return Intl.message(
      'Not Favorite',
      name: 'notFavorite',
      desc: '',
      args: [],
    );
  }

  /// `Mark as Learned`
  String get markAsLearned {
    return Intl.message(
      'Mark as Learned',
      name: 'markAsLearned',
      desc: '',
      args: [],
    );
  }

  /// `Unmark as Learned`
  String get unmarkAsLearned {
    return Intl.message(
      'Unmark as Learned',
      name: 'unmarkAsLearned',
      desc: '',
      args: [],
    );
  }

  /// `Add to Favorites`
  String get addToFavorites {
    return Intl.message(
      'Add to Favorites',
      name: 'addToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Remove from Favorites`
  String get removeFromFavorites {
    return Intl.message(
      'Remove from Favorites',
      name: 'removeFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Audio`
  String get audio {
    return Intl.message('Audio', name: 'audio', desc: '', args: []);
  }

  /// `Sound Effect`
  String get soundEffect {
    return Intl.message(
      'Sound Effect',
      name: 'soundEffect',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty`
  String get difficulty {
    return Intl.message('Difficulty', name: 'difficulty', desc: '', args: []);
  }

  /// `Easy`
  String get easy {
    return Intl.message('Easy', name: 'easy', desc: '', args: []);
  }

  /// `Medium`
  String get medium {
    return Intl.message('Medium', name: 'medium', desc: '', args: []);
  }

  /// `Hard`
  String get hard {
    return Intl.message('Hard', name: 'hard', desc: '', args: []);
  }

  /// `Search...`
  String get search {
    return Intl.message('Search...', name: 'search', desc: '', args: []);
  }

  /// `No results found`
  String get noResults {
    return Intl.message(
      'No results found',
      name: 'noResults',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get noData {
    return Intl.message(
      'No data available',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Syncing...`
  String get syncing {
    return Intl.message('Syncing...', name: 'syncing', desc: '', args: []);
  }

  /// `Sync complete`
  String get syncComplete {
    return Intl.message(
      'Sync complete',
      name: 'syncComplete',
      desc: '',
      args: [],
    );
  }

  /// `Sync failed`
  String get syncFailed {
    return Intl.message('Sync failed', name: 'syncFailed', desc: '', args: []);
  }

  /// `Offline`
  String get offline {
    return Intl.message('Offline', name: 'offline', desc: '', args: []);
  }

  /// `Online`
  String get online {
    return Intl.message('Online', name: 'online', desc: '', args: []);
  }

  /// `An error occurred`
  String get errorOccurred {
    return Intl.message(
      'An error occurred',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get unknownError {
    return Intl.message(
      'Unknown error',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Network error`
  String get networkError {
    return Intl.message(
      'Network error',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `Server error`
  String get serverError {
    return Intl.message(
      'Server error',
      name: 'serverError',
      desc: '',
      args: [],
    );
  }

  /// `Validation error`
  String get validationError {
    return Intl.message(
      'Validation error',
      name: 'validationError',
      desc: '',
      args: [],
    );
  }

  /// `Please wait...`
  String get pleaseWait {
    return Intl.message(
      'Please wait...',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Loading data...`
  String get loadingData {
    return Intl.message(
      'Loading data...',
      name: 'loadingData',
      desc: '',
      args: [],
    );
  }

  /// `Loading categories...`
  String get loadingCategories {
    return Intl.message(
      'Loading categories...',
      name: 'loadingCategories',
      desc: '',
      args: [],
    );
  }

  /// `Loading entities...`
  String get loadingEntities {
    return Intl.message(
      'Loading entities...',
      name: 'loadingEntities',
      desc: '',
      args: [],
    );
  }

  /// `Vietnamese`
  String get vietnamese {
    return Intl.message('Vietnamese', name: 'vietnamese', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Chinese`
  String get chinese {
    return Intl.message('Chinese', name: 'chinese', desc: '', args: []);
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Preferences`
  String get preferences {
    return Intl.message('Preferences', name: 'preferences', desc: '', args: []);
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Version`
  String get version {
    return Intl.message('Version', name: 'version', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get termsOfService {
    return Intl.message(
      'Terms of Service',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `Help`
  String get help {
    return Intl.message('Help', name: 'help', desc: '', args: []);
  }

  /// `Feedback`
  String get feedback {
    return Intl.message('Feedback', name: 'feedback', desc: '', args: []);
  }

  /// `Rate Us`
  String get rateUs {
    return Intl.message('Rate Us', name: 'rateUs', desc: '', args: []);
  }

  /// `Share App`
  String get shareApp {
    return Intl.message('Share App', name: 'shareApp', desc: '', args: []);
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Hello, {name}!`
  String helloUser(Object name) {
    return Intl.message(
      'Hello, $name!',
      name: 'helloUser',
      desc: '',
      args: [name],
    );
  }

  /// `What will you learn today? 😊`
  String get todayIsNewDay {
    return Intl.message(
      'What will you learn today? 😊',
      name: 'todayIsNewDay',
      desc: '',
      args: [],
    );
  }

  /// `Continue Learning`
  String get continueLearning {
    return Intl.message(
      'Continue Learning',
      name: 'continueLearning',
      desc: '',
      args: [],
    );
  }

  /// `Start Learning`
  String get startLearning {
    return Intl.message(
      'Start Learning',
      name: 'startLearning',
      desc: '',
      args: [],
    );
  }

  /// `Animals`
  String get animals {
    return Intl.message('Animals', name: 'animals', desc: '', args: []);
  }

  /// `Plants`
  String get plants {
    return Intl.message('Plants', name: 'plants', desc: '', args: []);
  }

  /// `Vehicles`
  String get vehicles {
    return Intl.message('Vehicles', name: 'vehicles', desc: '', args: []);
  }

  /// `Human Relations`
  String get humanRelations {
    return Intl.message(
      'Human Relations',
      name: 'humanRelations',
      desc: '',
      args: [],
    );
  }

  /// `Select a category`
  String get selectCategory {
    return Intl.message(
      'Select a category',
      name: 'selectCategory',
      desc: '',
      args: [],
    );
  }

  /// `Select a subcategory`
  String get selectSubcategory {
    return Intl.message(
      'Select a subcategory',
      name: 'selectSubcategory',
      desc: '',
      args: [],
    );
  }

  /// `Entity List`
  String get entityList {
    return Intl.message('Entity List', name: 'entityList', desc: '', args: []);
  }

  /// `Entity Detail`
  String get entityDetail {
    return Intl.message(
      'Entity Detail',
      name: 'entityDetail',
      desc: '',
      args: [],
    );
  }

  /// `Practice`
  String get practice {
    return Intl.message('Practice', name: 'practice', desc: '', args: []);
  }

  /// `Quiz`
  String get quiz {
    return Intl.message('Quiz', name: 'quiz', desc: '', args: []);
  }

  /// `Flashcard`
  String get flashcard {
    return Intl.message('Flashcard', name: 'flashcard', desc: '', args: []);
  }

  /// `Daily Streak`
  String get dailyStreak {
    return Intl.message(
      'Daily Streak',
      name: 'dailyStreak',
      desc: '',
      args: [],
    );
  }

  /// `{count} day streak`
  String streakDays(Object count) {
    return Intl.message(
      '$count day streak',
      name: 'streakDays',
      desc: '',
      args: [count],
    );
  }

  /// `{count} days streak`
  String streakDays_plural(Object count) {
    return Intl.message(
      '$count days streak',
      name: 'streakDays_plural',
      desc: '',
      args: [count],
    );
  }

  /// `Points`
  String get points {
    return Intl.message('Points', name: 'points', desc: '', args: []);
  }

  /// `Level`
  String get level {
    return Intl.message('Level', name: 'level', desc: '', args: []);
  }

  /// `Rank`
  String get rank {
    return Intl.message('Rank', name: 'rank', desc: '', args: []);
  }

  /// `Achievement`
  String get achievement {
    return Intl.message('Achievement', name: 'achievement', desc: '', args: []);
  }

  /// `Achievements`
  String get achievements {
    return Intl.message(
      'Achievements',
      name: 'achievements',
      desc: '',
      args: [],
    );
  }

  /// `Badge`
  String get badge {
    return Intl.message('Badge', name: 'badge', desc: '', args: []);
  }

  /// `Badges`
  String get badges {
    return Intl.message('Badges', name: 'badges', desc: '', args: []);
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `In Progress`
  String get inProgress {
    return Intl.message('In Progress', name: 'inProgress', desc: '', args: []);
  }

  /// `Not Started`
  String get notStarted {
    return Intl.message('Not Started', name: 'notStarted', desc: '', args: []);
  }

  /// `Time spent`
  String get timeSpent {
    return Intl.message('Time spent', name: 'timeSpent', desc: '', args: []);
  }

  /// `Entities learned`
  String get entitiesLearned {
    return Intl.message(
      'Entities learned',
      name: 'entitiesLearned',
      desc: '',
      args: [],
    );
  }

  /// `Accuracy`
  String get accuracy {
    return Intl.message('Accuracy', name: 'accuracy', desc: '', args: []);
  }

  /// `Correct`
  String get correct {
    return Intl.message('Correct', name: 'correct', desc: '', args: []);
  }

  /// `Wrong`
  String get wrong {
    return Intl.message('Wrong', name: 'wrong', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Answer`
  String get answer {
    return Intl.message('Answer', name: 'answer', desc: '', args: []);
  }

  /// `Answers`
  String get answers {
    return Intl.message('Answers', name: 'answers', desc: '', args: []);
  }

  /// `Question`
  String get question {
    return Intl.message('Question', name: 'question', desc: '', args: []);
  }

  /// `Questions`
  String get questions {
    return Intl.message('Questions', name: 'questions', desc: '', args: []);
  }

  /// `Result`
  String get result {
    return Intl.message('Result', name: 'result', desc: '', args: []);
  }

  /// `Results`
  String get results {
    return Intl.message('Results', name: 'results', desc: '', args: []);
  }

  /// `Score`
  String get score {
    return Intl.message('Score', name: 'score', desc: '', args: []);
  }

  /// `Total Score`
  String get totalScore {
    return Intl.message('Total Score', name: 'totalScore', desc: '', args: []);
  }

  /// `Percentage`
  String get percentage {
    return Intl.message('Percentage', name: 'percentage', desc: '', args: []);
  }

  /// `Pass`
  String get pass {
    return Intl.message('Pass', name: 'pass', desc: '', args: []);
  }

  /// `Fail`
  String get fail {
    return Intl.message('Fail', name: 'fail', desc: '', args: []);
  }

  /// `Excellent!`
  String get excellent {
    return Intl.message('Excellent!', name: 'excellent', desc: '', args: []);
  }

  /// `Great job!`
  String get great {
    return Intl.message('Great job!', name: 'great', desc: '', args: []);
  }

  /// `Good!`
  String get good {
    return Intl.message('Good!', name: 'good', desc: '', args: []);
  }

  /// `Keep trying!`
  String get keepTrying {
    return Intl.message('Keep trying!', name: 'keepTrying', desc: '', args: []);
  }

  /// `Congratulations!`
  String get congratulations {
    return Intl.message(
      'Congratulations!',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `Well done!`
  String get wellDone {
    return Intl.message('Well done!', name: 'wellDone', desc: '', args: []);
  }

  /// `Daily Goal`
  String get dailyGoal {
    return Intl.message('Daily Goal', name: 'dailyGoal', desc: '', args: []);
  }

  /// `Goal reached!`
  String get goalReached {
    return Intl.message(
      'Goal reached!',
      name: 'goalReached',
      desc: '',
      args: [],
    );
  }

  /// `Goal not reached`
  String get goalNotReached {
    return Intl.message(
      'Goal not reached',
      name: 'goalNotReached',
      desc: '',
      args: [],
    );
  }

  /// `Streak`
  String get streak {
    return Intl.message('Streak', name: 'streak', desc: '', args: []);
  }

  /// `Longest Streak`
  String get longestStreak {
    return Intl.message(
      'Longest Streak',
      name: 'longestStreak',
      desc: '',
      args: [],
    );
  }

  /// `Current Streak`
  String get currentStreak {
    return Intl.message(
      'Current Streak',
      name: 'currentStreak',
      desc: '',
      args: [],
    );
  }

  /// `Best Score`
  String get bestScore {
    return Intl.message('Best Score', name: 'bestScore', desc: '', args: []);
  }

  /// `Last Played`
  String get lastPlayed {
    return Intl.message('Last Played', name: 'lastPlayed', desc: '', args: []);
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `{count} days ago`
  String daysAgo(Object count) {
    return Intl.message(
      '$count days ago',
      name: 'daysAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count} hours ago`
  String hoursAgo(Object count) {
    return Intl.message(
      '$count hours ago',
      name: 'hoursAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count} minutes ago`
  String minutesAgo(Object count) {
    return Intl.message(
      '$count minutes ago',
      name: 'minutesAgo',
      desc: '',
      args: [count],
    );
  }

  /// `Just now`
  String get justNow {
    return Intl.message('Just now', name: 'justNow', desc: '', args: []);
  }

  /// `No internet connection`
  String get noInternet {
    return Intl.message(
      'No internet connection',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `Checking connection...`
  String get checkingConnection {
    return Intl.message(
      'Checking connection...',
      name: 'checkingConnection',
      desc: '',
      args: [],
    );
  }

  /// `Retry Now`
  String get retryNow {
    return Intl.message('Retry Now', name: 'retryNow', desc: '', args: []);
  }

  /// `Go to Settings`
  String get goToSettings {
    return Intl.message(
      'Go to Settings',
      name: 'goToSettings',
      desc: '',
      args: [],
    );
  }

  /// `Please enable network connection`
  String get enableNetwork {
    return Intl.message(
      'Please enable network connection',
      name: 'enableNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Premium Feature`
  String get premiumFeature {
    return Intl.message(
      'Premium Feature',
      name: 'premiumFeature',
      desc: '',
      args: [],
    );
  }

  /// `Unlock all features with Premium`
  String get premiumDescription {
    return Intl.message(
      'Unlock all features with Premium',
      name: 'premiumDescription',
      desc: '',
      args: [],
    );
  }

  /// `Premium Monthly`
  String get premiumMonthly {
    return Intl.message(
      'Premium Monthly',
      name: 'premiumMonthly',
      desc: '',
      args: [],
    );
  }

  /// `Premium Yearly`
  String get premiumYearly {
    return Intl.message(
      'Premium Yearly',
      name: 'premiumYearly',
      desc: '',
      args: [],
    );
  }

  /// `Premium Benefits`
  String get premiumBenefits {
    return Intl.message(
      'Premium Benefits',
      name: 'premiumBenefits',
      desc: '',
      args: [],
    );
  }

  /// `Ad-free experience`
  String get benefit1 {
    return Intl.message(
      'Ad-free experience',
      name: 'benefit1',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited entities`
  String get benefit2 {
    return Intl.message(
      'Unlimited entities',
      name: 'benefit2',
      desc: '',
      args: [],
    );
  }

  /// `Advanced analytics`
  String get benefit3 {
    return Intl.message(
      'Advanced analytics',
      name: 'benefit3',
      desc: '',
      args: [],
    );
  }

  /// `Priority support`
  String get benefit4 {
    return Intl.message(
      'Priority support',
      name: 'benefit4',
      desc: '',
      args: [],
    );
  }

  /// `Exclusive content`
  String get benefit5 {
    return Intl.message(
      'Exclusive content',
      name: 'benefit5',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe`
  String get subscribe {
    return Intl.message('Subscribe', name: 'subscribe', desc: '', args: []);
  }

  /// `Subscribed`
  String get subscribed {
    return Intl.message('Subscribed', name: 'subscribed', desc: '', args: []);
  }

  /// `Not Subscribed`
  String get notSubscribed {
    return Intl.message(
      'Not Subscribed',
      name: 'notSubscribed',
      desc: '',
      args: [],
    );
  }

  /// `Payment successful!`
  String get paymentSuccessful {
    return Intl.message(
      'Payment successful!',
      name: 'paymentSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Payment failed`
  String get paymentFailed {
    return Intl.message(
      'Payment failed',
      name: 'paymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Payment cancelled`
  String get paymentCancelled {
    return Intl.message(
      'Payment cancelled',
      name: 'paymentCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Processing payment...`
  String get processingPayment {
    return Intl.message(
      'Processing payment...',
      name: 'processingPayment',
      desc: '',
      args: [],
    );
  }

  /// `Restore Purchases`
  String get restorePurchases {
    return Intl.message(
      'Restore Purchases',
      name: 'restorePurchases',
      desc: '',
      args: [],
    );
  }

  /// `Purchased`
  String get purchased {
    return Intl.message('Purchased', name: 'purchased', desc: '', args: []);
  }

  /// `Not Purchased`
  String get notPurchased {
    return Intl.message(
      'Not Purchased',
      name: 'notPurchased',
      desc: '',
      args: [],
    );
  }

  /// `Consumed`
  String get consumed {
    return Intl.message('Consumed', name: 'consumed', desc: '', args: []);
  }

  /// `Not Consumed`
  String get notConsumed {
    return Intl.message(
      'Not Consumed',
      name: 'notConsumed',
      desc: '',
      args: [],
    );
  }

  /// `Watch ad to earn reward`
  String get rewardedAd {
    return Intl.message(
      'Watch ad to earn reward',
      name: 'rewardedAd',
      desc: '',
      args: [],
    );
  }

  /// `Reward granted!`
  String get rewardedAdGranted {
    return Intl.message(
      'Reward granted!',
      name: 'rewardedAdGranted',
      desc: '',
      args: [],
    );
  }

  /// `Failed to grant reward`
  String get rewardedAdFailed {
    return Intl.message(
      'Failed to grant reward',
      name: 'rewardedAdFailed',
      desc: '',
      args: [],
    );
  }

  /// `Ad not available`
  String get adNotAvailable {
    return Intl.message(
      'Ad not available',
      name: 'adNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Loading ad...`
  String get loadingAd {
    return Intl.message('Loading ad...', name: 'loadingAd', desc: '', args: []);
  }

  /// `Data Sync`
  String get dataSync {
    return Intl.message('Data Sync', name: 'dataSync', desc: '', args: []);
  }

  /// `Sync Now`
  String get syncNow {
    return Intl.message('Sync Now', name: 'syncNow', desc: '', args: []);
  }

  /// `Auto Sync`
  String get autoSync {
    return Intl.message('Auto Sync', name: 'autoSync', desc: '', args: []);
  }

  /// `Last Sync`
  String get lastSync {
    return Intl.message('Last Sync', name: 'lastSync', desc: '', args: []);
  }

  /// `Never`
  String get never {
    return Intl.message('Never', name: 'never', desc: '', args: []);
  }

  /// `Data Version`
  String get dataVersion {
    return Intl.message(
      'Data Version',
      name: 'dataVersion',
      desc: '',
      args: [],
    );
  }

  /// `Data updated successfully`
  String get dataUpdated {
    return Intl.message(
      'Data updated successfully',
      name: 'dataUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Data update failed`
  String get dataUpdateFailed {
    return Intl.message(
      'Data update failed',
      name: 'dataUpdateFailed',
      desc: '',
      args: [],
    );
  }

  /// `Downloading data...`
  String get downloadingData {
    return Intl.message(
      'Downloading data...',
      name: 'downloadingData',
      desc: '',
      args: [],
    );
  }

  /// `Data ready`
  String get dataReady {
    return Intl.message('Data ready', name: 'dataReady', desc: '', args: []);
  }

  /// `No new data`
  String get noNewData {
    return Intl.message('No new data', name: 'noNewData', desc: '', args: []);
  }

  /// `Cache cleared`
  String get cacheCleared {
    return Intl.message(
      'Cache cleared',
      name: 'cacheCleared',
      desc: '',
      args: [],
    );
  }

  /// `Failed to clear cache`
  String get cacheClearFailed {
    return Intl.message(
      'Failed to clear cache',
      name: 'cacheClearFailed',
      desc: '',
      args: [],
    );
  }

  /// `Storage full`
  String get storageFull {
    return Intl.message(
      'Storage full',
      name: 'storageFull',
      desc: '',
      args: [],
    );
  }

  /// `Device storage is low`
  String get storageWarning {
    return Intl.message(
      'Device storage is low',
      name: 'storageWarning',
      desc: '',
      args: [],
    );
  }

  /// `App updated`
  String get appUpdated {
    return Intl.message('App updated', name: 'appUpdated', desc: '', args: []);
  }

  /// `New version available`
  String get newVersionAvailable {
    return Intl.message(
      'New version available',
      name: 'newVersionAvailable',
      desc: '',
      args: [],
    );
  }

  /// `You are using the latest version`
  String get latestVersion {
    return Intl.message(
      'You are using the latest version',
      name: 'latestVersion',
      desc: '',
      args: [],
    );
  }

  /// `Check for Updates`
  String get checkUpdate {
    return Intl.message(
      'Check for Updates',
      name: 'checkUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Enable Notifications`
  String get enableNotifications {
    return Intl.message(
      'Enable Notifications',
      name: 'enableNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Notifications enabled`
  String get notificationEnabled {
    return Intl.message(
      'Notifications enabled',
      name: 'notificationEnabled',
      desc: '',
      args: [],
    );
  }

  /// `Notifications disabled`
  String get notificationDisabled {
    return Intl.message(
      'Notifications disabled',
      name: 'notificationDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Permission denied`
  String get permissionDenied {
    return Intl.message(
      'Permission denied',
      name: 'permissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `This feature requires permission`
  String get permissionRequired {
    return Intl.message(
      'This feature requires permission',
      name: 'permissionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Grant Permission`
  String get grantPermission {
    return Intl.message(
      'Grant Permission',
      name: 'grantPermission',
      desc: '',
      args: [],
    );
  }

  /// `Settings saved`
  String get settingsSaved {
    return Intl.message(
      'Settings saved',
      name: 'settingsSaved',
      desc: '',
      args: [],
    );
  }

  /// `Settings reset`
  String get settingsReset {
    return Intl.message(
      'Settings reset',
      name: 'settingsReset',
      desc: '',
      args: [],
    );
  }

  /// `Reset Settings`
  String get resetSettings {
    return Intl.message(
      'Reset Settings',
      name: 'resetSettings',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to reset all settings?`
  String get confirmReset {
    return Intl.message(
      'Are you sure you want to reset all settings?',
      name: 'confirmReset',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logout {
    return Intl.message('Log Out', name: 'logout', desc: '', args: []);
  }

  /// `Are you sure you want to log out?`
  String get confirmLogout {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'confirmLogout',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account? This action cannot be undone.`
  String get confirmDeleteAccount {
    return Intl.message(
      'Are you sure you want to delete your account? This action cannot be undone.',
      name: 'confirmDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Account deleted`
  String get accountDeleted {
    return Intl.message(
      'Account deleted',
      name: 'accountDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete account`
  String get accountDeleteFailed {
    return Intl.message(
      'Failed to delete account',
      name: 'accountDeleteFailed',
      desc: '',
      args: [],
    );
  }

  /// `Report Issue`
  String get reportIssue {
    return Intl.message(
      'Report Issue',
      name: 'reportIssue',
      desc: '',
      args: [],
    );
  }

  /// `Send Feedback`
  String get sendFeedback {
    return Intl.message(
      'Send Feedback',
      name: 'sendFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Feedback sent`
  String get feedbackSent {
    return Intl.message(
      'Feedback sent',
      name: 'feedbackSent',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send feedback`
  String get feedbackFailed {
    return Intl.message(
      'Failed to send feedback',
      name: 'feedbackFailed',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Copy Link`
  String get copyLink {
    return Intl.message('Copy Link', name: 'copyLink', desc: '', args: []);
  }

  /// `Link copied`
  String get linkCopied {
    return Intl.message('Link copied', name: 'linkCopied', desc: '', args: []);
  }

  /// `Rate this app`
  String get rateThisApp {
    return Intl.message(
      'Rate this app',
      name: 'rateThisApp',
      desc: '',
      args: [],
    );
  }

  /// `Thanks for rating!`
  String get thanksForRating {
    return Intl.message(
      'Thanks for rating!',
      name: 'thanksForRating',
      desc: '',
      args: [],
    );
  }

  /// `No rating given`
  String get noRatingGiven {
    return Intl.message(
      'No rating given',
      name: 'noRatingGiven',
      desc: '',
      args: [],
    );
  }

  /// `Open in Store`
  String get openInStore {
    return Intl.message(
      'Open in Store',
      name: 'openInStore',
      desc: '',
      args: [],
    );
  }

  /// `Write a Review`
  String get writeReview {
    return Intl.message(
      'Write a Review',
      name: 'writeReview',
      desc: '',
      args: [],
    );
  }

  /// `Review sent`
  String get reviewSent {
    return Intl.message('Review sent', name: 'reviewSent', desc: '', args: []);
  }

  /// `Failed to send review`
  String get reviewFailed {
    return Intl.message(
      'Failed to send review',
      name: 'reviewFailed',
      desc: '',
      args: [],
    );
  }

  /// `Help Center`
  String get helpCenter {
    return Intl.message('Help Center', name: 'helpCenter', desc: '', args: []);
  }

  /// `FAQ`
  String get faq {
    return Intl.message('FAQ', name: 'faq', desc: '', args: []);
  }

  /// `Contact Support`
  String get contactSupport {
    return Intl.message(
      'Contact Support',
      name: 'contactSupport',
      desc: '',
      args: [],
    );
  }

  /// `support@wordzoo.com`
  String get supportEmail {
    return Intl.message(
      'support@wordzoo.com',
      name: 'supportEmail',
      desc: '',
      args: [],
    );
  }

  /// `Social Media`
  String get socialMedia {
    return Intl.message(
      'Social Media',
      name: 'socialMedia',
      desc: '',
      args: [],
    );
  }

  /// `Follow Us`
  String get followUs {
    return Intl.message('Follow Us', name: 'followUs', desc: '', args: []);
  }

  /// `© 2026 WordZoo. All rights reserved.`
  String get copyright {
    return Intl.message(
      '© 2026 WordZoo. All rights reserved.',
      name: 'copyright',
      desc: '',
      args: [],
    );
  }

  /// `Made with ❤️ for kids`
  String get madeWithLove {
    return Intl.message(
      'Made with ❤️ for kids',
      name: 'madeWithLove',
      desc: '',
      args: [],
    );
  }

  /// `Developer`
  String get developer {
    return Intl.message('Developer', name: 'developer', desc: '', args: []);
  }

  /// `WordZoo Inc.`
  String get company {
    return Intl.message('WordZoo Inc.', name: 'company', desc: '', args: []);
  }

  /// `Learn English, Play Together`
  String get tagline {
    return Intl.message(
      'Learn English, Play Together',
      name: 'tagline',
      desc: '',
      args: [],
    );
  }

  /// `Select an entity to view details`
  String get selectEntityToViewDetails {
    return Intl.message(
      'Select an entity to view details',
      name: 'selectEntityToViewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Error: {message}`
  String errorWithMessage(Object message) {
    return Intl.message(
      'Error: $message',
      name: 'errorWithMessage',
      desc: '',
      args: [message],
    );
  }

  /// `EN: {text}`
  String englishLabel(Object text) {
    return Intl.message(
      'EN: $text',
      name: 'englishLabel',
      desc: '',
      args: [text],
    );
  }

  /// `ZH: {text}`
  String chineseLabel(Object text) {
    return Intl.message(
      'ZH: $text',
      name: 'chineseLabel',
      desc: '',
      args: [text],
    );
  }

  /// `Buy Premium`
  String get buy_premium {
    return Intl.message('Buy Premium', name: 'buy_premium', desc: '', args: []);
  }

  /// `Watching Ads`
  String get watching_ads {
    return Intl.message(
      'Watching Ads',
      name: 'watching_ads',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
