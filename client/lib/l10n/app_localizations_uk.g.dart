import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get ru => 'Російська';

  @override
  String get en => 'Англійська';

  @override
  String get uk => 'Українска';

  @override
  String get language => 'Мова';

  @override
  String get delete_inf_ab_sup => 'Видалити всю інформацію про видалених постачальників';

  @override
  String get dark_theme => 'Темна тема';

  @override
  String get yes => 'ТАК';

  @override
  String get no => 'НІ';

  @override
  String get store => 'Склад';

  @override
  String get stats => 'Статистика';

  @override
  String get settings => 'Налаштування';

  @override
  String supply(String count) {
    String _temp0 = intl.Intl.selectLogic(
      count,
      {
        '1': 'Поставка',
        '2': 'Поставки',
        'other': 'Поставка',
      },
    );
    return '$_temp0';
  }

  @override
  String get menu => 'Меню';

  @override
  String get employees => 'Робітники';

  @override
  String get orders => 'Замовлення';

  @override
  String get date => 'Дата';

  @override
  String get group => 'Групування';

  @override
  String get day => 'День';

  @override
  String get hour => 'Година';

  @override
  String get month => 'Місяць';

  @override
  String get year => 'Рік';

  @override
  String grouping(String gr) {
    String _temp0 = intl.Intl.selectLogic(
      gr,
      {
        'day': 'день',
        'month': 'місяць',
        'hour': 'година',
        'year': 'рік',
        'other': '...',
      },
    );
    return '$_temp0';
  }

  @override
  String grocery(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Інгредієнтіи',
      one: 'Інгредієнт',
    );
    return '$_temp0';
  }

  @override
  String get price => 'Ціна';

  @override
  String supplier(String count) {
    String _temp0 = intl.Intl.selectLogic(
      count,
      {
        '1': 'Постачальник',
        '2': 'Постачальники',
        'other': 'Постачальник',
      },
    );
    return '$_temp0';
  }

  @override
  String get enter_groc => 'введіть назву інгредієнту...';

  @override
  String measure(String measure) {
    String _temp0 = intl.Intl.selectLogic(
      measure,
      {
        'gram': 'кілограм',
        'liter': 'літр',
        'other': 'неправильна міра',
      },
    );
    return '$_temp0';
  }

  @override
  String measure_short(String measure) {
    String _temp0 = intl.Intl.selectLogic(
      measure,
      {
        'gram': 'кг',
        'liter': 'л',
        'other': 'xxx',
      },
    );
    return '$_temp0';
  }

  @override
  String get name => 'Назва';

  @override
  String get left => 'Залишилося';

  @override
  String get count => 'Кількість';

  @override
  String get add => 'Додати';

  @override
  String get add_supplier => 'Додати постачальника';

  @override
  String get contacts => 'Контакти';

  @override
  String get number => 'Номер';

  @override
  String get sorting => 'Сортування';

  @override
  String get filtering => 'Фільтр';

  @override
  String get by => 'По';

  @override
  String get find => 'Знайти';

  @override
  String asc(String a) {
    String _temp0 = intl.Intl.selectLogic(
      a,
      {
        'asc': 'за збільшенням',
        'desc': 'за зменшенням',
        'other': 'no',
      },
    );
    return '$_temp0';
  }

  @override
  String get dish => 'Страва';

  @override
  String get dish_name => 'Назва страви';

  @override
  String get groups => 'Групы';

  @override
  String get prime_cost => 'Собівартість';

  @override
  String get save => 'Зберегти';

  @override
  String get add_group => 'Додати групу';

  @override
  String get total => 'Загальна';

  @override
  String get total1 => 'Отже';

  @override
  String get choose_image => 'Оберіть зображення';

  @override
  String get enter_descr => 'Введіть опис';

  @override
  String get no_descr => 'Опису немає...';

  @override
  String get update_role => 'Змінити посаду';

  @override
  String get delete => 'Видалити';

  @override
  String get roles => 'Посади';

  @override
  String get diary => 'Щоденник';

  @override
  String get add_role => 'Додати посаду';

  @override
  String get namee => 'Ім\'я';

  @override
  String get surname => 'Фамілія';

  @override
  String get birthday => 'День народження';

  @override
  String get hours_per_month => 'Годин на місяць';

  @override
  String gen(String g) {
    String _temp0 = intl.Intl.selectLogic(
      g,
      {
        'm': 'Чоловіки',
        'f': 'Жінки',
        'other': 'no',
      },
    );
    return '$_temp0';
  }

  @override
  String get hours => 'Години';

  @override
  String get clear => 'Очистити';

  @override
  String get has_come => 'Прийшов';

  @override
  String get from => 'Від';

  @override
  String get to => 'до';

  @override
  String get has_gone => 'Пішов';

  @override
  String get waiter => 'Офіціант';

  @override
  String get salary_per_hour => 'зп/година';

  @override
  String get comment => 'Коментар';

  @override
  String get summ => 'Сума';

  @override
  String get pay => 'Сплатити';

  @override
  String get rest => 'Решта';

  @override
  String get order => 'Замовлення';

  @override
  String get or_rec => 'Замовлення прийнято в';

  @override
  String get or_paid => 'Замовлення сплачено в';

  @override
  String get or_list => 'Склад замовлення';

  @override
  String get confirm_delete_role_message => 'Ви впевнені що хочете видалити цю роль? Ця дія незворотна';

  @override
  String get no_role_selected_placeholder => '[роль не обрано]';

  @override
  String get no_group_selected_placeholder => '[група не обрано]';

  @override
  String get cancel => 'Відмінити';

  @override
  String get submit => 'Зберегти';

  @override
  String get edit_role => 'Редагувати роль';

  @override
  String get new_dish => 'Нова страва';

  @override
  String get new_group => 'Новая група';

  @override
  String get dish_group => 'Група страви';

  @override
  String get no_orders_placeholder => 'Немає замовлень.\nНатисніть кнопку \"+\" щоб додати...';

  @override
  String get add_new_order => 'Додати нове замовелння';

  @override
  String get no_waiter_selected_placeholder => '[офіціанта не обрано]';

  @override
  String get order_list => 'Список замовлення';

  @override
  String order_per_period_chart_description(String group) {
    String _temp0 = intl.Intl.selectLogic(
      group,
      {
        'DAY': 'дням',
        'HOUR': 'часам',
        'MONTH': 'месяцам',
        'YEAR': 'годам',
        'other': '...',
      },
    );
    return 'Кількість замовлень, згрупованих по $_temp0';
  }

  @override
  String get most_popular_dishes => 'Найпопулярніші страви';

  @override
  String get delete_supplier => 'Видалити постачальника';

  @override
  String get select_grocery_placeholder => 'Оберіть інгредієнт';

  @override
  String get add_grocery => 'Додати інгедієнт';

  @override
  String get ok => 'OK';

  @override
  String get new_supply => 'Нова поставка';

  @override
  String get no_supplier_selected_placeholder => '[постачальника не вибрано]';

  @override
  String get choose_supplier_hint => 'Оберіть постачальника';

  @override
  String amount(double s) {
    return 'Сума поставки: $s';
  }

  @override
  String get select_grocery_tooltip => 'Оберіть інгредієнт зі списку';

  @override
  String get select_supplier_placeholder => 'Оберіть постачальника';

  @override
  String get stats_page_title => 'Статистика';

  @override
  String get store_page_title => 'Склад';

  @override
  String get orders_page_title => 'Замовлення';

  @override
  String get employees_page_title => 'Робітники';

  @override
  String get menu_page_title => 'Меню';

  @override
  String get supplies_page_title => 'Поставки';

  @override
  String get settings_page_title => 'Налаштування';
}
