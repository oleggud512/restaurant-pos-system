

import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

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
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get store => 'Склад';

  @override
  String get stats => 'Статистика';

  @override
  String get settings => 'Налаштування';

  @override
  String supply(Object count) {
    return intl.Intl.select(
      count,
      {
        '1': 'Поставка',
        '2': 'Поставки'
      },
      desc: 'No description provided in @supply'
    );
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
    return intl.Intl.select(
      gr,
      {
        'day': 'день',
        'month': 'місяць',
        'hour': 'година',
        'year': 'рік',
        'other': '...'
      },
      desc: 'No description provided in @grouping'
    );
  }

  @override
  String grocery(num count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Інгредієнтіи',
    );
  }

  @override
  String get price => 'Ціна';

  @override
  String supplier(Object count) {
    return intl.Intl.select(
      count,
      {
        '1': 'Постачальник',
        '2': 'Постачальники'
      },
      desc: 'No description provided in @supplier'
    );
  }

  @override
  String get enter_groc => 'введіть назву інгредієнту...';

  @override
  String measure(String measure) {
    return intl.Intl.select(
      measure,
      {
        'gram': 'кілограм',
        'liter': 'літр',
        'other': 'неправильна міра'
      },
      desc: 'No description provided in @measure'
    );
  }

  @override
  String measure_short(String measure) {
    return intl.Intl.select(
      measure,
      {
        'gram': 'кг',
        'liter': 'л',
        'other': 'xxx'
      },
      desc: 'No description provided in @measure_short'
    );
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
    return intl.Intl.select(
      a,
      {
        'asc': 'за збільшенням',
        'desc': 'за зменшенням'
      },
      desc: 'No description provided in @asc'
    );
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
    return intl.Intl.select(
      g,
      {
        'm': 'Чоловіки',
        'f': 'Жінки'
      },
      desc: 'No description provided in @gen'
    );
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
}
