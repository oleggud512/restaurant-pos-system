import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.g.dart';
import 'app_localizations_ru.g.dart';
import 'app_localizations_uk.g.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.g.dart';
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
    Locale('ru'),
    Locale('uk')
  ];

  /// No description provided for @ru.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get ru;

  /// No description provided for @en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get en;

  /// No description provided for @uk.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get uk;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @delete_inf_ab_sup.
  ///
  /// In en, this message translates to:
  /// **'Delete all information about deleted suppliers'**
  String get delete_inf_ab_sup;

  /// No description provided for @dark_theme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get dark_theme;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @supply.
  ///
  /// In en, this message translates to:
  /// **'{count, select, 1{Supply} 2{Supplies} other{Supply}}'**
  String supply(String count);

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @employees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employees;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// No description provided for @grouping.
  ///
  /// In en, this message translates to:
  /// **'{gr, select, day{day} month{month} hour{hour} year{year} other{...}}'**
  String grouping(String gr);

  /// No description provided for @grocery.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, one{Grocery} other{Groceries}}'**
  String grocery(num count);

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @supplier.
  ///
  /// In en, this message translates to:
  /// **'{count, select, 1{Supplier} 2{Suppliers} other{err}}'**
  String supplier(String count);

  /// No description provided for @enter_groc.
  ///
  /// In en, this message translates to:
  /// **'enter grocery name...'**
  String get enter_groc;

  /// No description provided for @measure.
  ///
  /// In en, this message translates to:
  /// **'{measure,select, gram{kilogram} liter{liter} other{wrong measure}}'**
  String measure(String measure);

  /// No description provided for @measure_short.
  ///
  /// In en, this message translates to:
  /// **'{measure,select, gram{kg} liter{l} other{xxx}}'**
  String measure_short(String measure);

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get left;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get count;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @add_supplier.
  ///
  /// In en, this message translates to:
  /// **'Add supplier'**
  String get add_supplier;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @sorting.
  ///
  /// In en, this message translates to:
  /// **'Sorting'**
  String get sorting;

  /// No description provided for @filtering.
  ///
  /// In en, this message translates to:
  /// **'Filtering'**
  String get filtering;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'By'**
  String get by;

  /// No description provided for @find.
  ///
  /// In en, this message translates to:
  /// **'Find'**
  String get find;

  /// No description provided for @asc.
  ///
  /// In en, this message translates to:
  /// **'{a,select, asc{ascedenting} desc{descedenting} other{no}}'**
  String asc(String a);

  /// No description provided for @dish.
  ///
  /// In en, this message translates to:
  /// **'Dish'**
  String get dish;

  /// No description provided for @dish_name.
  ///
  /// In en, this message translates to:
  /// **'Dish name'**
  String get dish_name;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @prime_cost.
  ///
  /// In en, this message translates to:
  /// **'Prime cost'**
  String get prime_cost;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add_group.
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get add_group;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @total1.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total1;

  /// No description provided for @choose_image.
  ///
  /// In en, this message translates to:
  /// **'Choose image'**
  String get choose_image;

  /// No description provided for @enter_descr.
  ///
  /// In en, this message translates to:
  /// **'Enter description...'**
  String get enter_descr;

  /// No description provided for @no_descr.
  ///
  /// In en, this message translates to:
  /// **'No description...'**
  String get no_descr;

  /// No description provided for @update_role.
  ///
  /// In en, this message translates to:
  /// **'Update role'**
  String get update_role;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @roles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @diary.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get diary;

  /// No description provided for @add_role.
  ///
  /// In en, this message translates to:
  /// **'Add role'**
  String get add_role;

  /// No description provided for @namee.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get namee;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get surname;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @hours_per_month.
  ///
  /// In en, this message translates to:
  /// **'Hours per month'**
  String get hours_per_month;

  /// No description provided for @gen.
  ///
  /// In en, this message translates to:
  /// **'{g,select, m{Mans} f{Womans} other{no}}'**
  String gen(String g);

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @has_come.
  ///
  /// In en, this message translates to:
  /// **'Has come'**
  String get has_come;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @has_gone.
  ///
  /// In en, this message translates to:
  /// **'Has gone'**
  String get has_gone;

  /// No description provided for @waiter.
  ///
  /// In en, this message translates to:
  /// **'Waiter'**
  String get waiter;

  /// No description provided for @salary_per_hour.
  ///
  /// In en, this message translates to:
  /// **'Salary per hour'**
  String get salary_per_hour;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @summ.
  ///
  /// In en, this message translates to:
  /// **'Summ'**
  String get summ;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @rest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get rest;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @or_rec.
  ///
  /// In en, this message translates to:
  /// **'order received in'**
  String get or_rec;

  /// No description provided for @or_paid.
  ///
  /// In en, this message translates to:
  /// **'order paid at'**
  String get or_paid;

  /// No description provided for @or_list.
  ///
  /// In en, this message translates to:
  /// **'order list'**
  String get or_list;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
    case 'uk': return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
