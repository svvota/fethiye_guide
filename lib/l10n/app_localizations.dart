import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'City Guide'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover places, events, and favorites—right in your pocket.'**
  String get welcomeSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @homeExploreFethiye.
  ///
  /// In en, this message translates to:
  /// **'Explore Fethiye'**
  String get homeExploreFethiye;

  /// No description provided for @quickPlaces.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get quickPlaces;

  /// No description provided for @quickEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get quickEvents;

  /// No description provided for @quickFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get quickFavorites;

  /// No description provided for @quickTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get quickTheme;

  /// No description provided for @tipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tipsTitle;

  /// No description provided for @tipsBody.
  ///
  /// In en, this message translates to:
  /// **'• Pull data from assets now; swap to Firebase later.\n• Use categories and filters to help tourists discover quickly.'**
  String get tipsBody;

  /// No description provided for @placesTitle.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get placesTitle;

  /// No description provided for @searchPlacesHint.
  ///
  /// In en, this message translates to:
  /// **'Search places'**
  String get searchPlacesHint;

  /// No description provided for @noPlacesMatch.
  ///
  /// In en, this message translates to:
  /// **'No places match your search.'**
  String get noPlacesMatch;

  /// No description provided for @eventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get eventsTitle;

  /// No description provided for @searchEventsHint.
  ///
  /// In en, this message translates to:
  /// **'Search events'**
  String get searchEventsHint;

  /// No description provided for @noEventsMatch.
  ///
  /// In en, this message translates to:
  /// **'No events match your search.'**
  String get noEventsMatch;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @favoritesPlacesHeader.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get favoritesPlacesHeader;

  /// No description provided for @favoritesEventsHeader.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get favoritesEventsHeader;

  /// No description provided for @noFavoritePlaces.
  ///
  /// In en, this message translates to:
  /// **'No favorite places yet.'**
  String get noFavoritePlaces;

  /// No description provided for @noFavoriteEvents.
  ///
  /// In en, this message translates to:
  /// **'No favorite events yet.'**
  String get noFavoriteEvents;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageValue.
  ///
  /// In en, this message translates to:
  /// **'English / Turkish'**
  String get languageValue;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Google Maps'**
  String get openInMaps;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

