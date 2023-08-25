import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get ru => 'Русский';

  @override
  String get en => 'Английский';

  @override
  String get uk => 'Украинский';

  @override
  String get language => 'Язык';

  @override
  String get delete_inf_ab_sup => 'Удалить всю информацию про удаленных поставщиков';

  @override
  String get dark_theme => 'Темная тема';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get store => 'Склад';

  @override
  String get stats => 'Статистика';

  @override
  String get settings => 'Настройки';

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
  String get employees => 'Работники';

  @override
  String get orders => 'Заказы';

  @override
  String get date => 'Дата';

  @override
  String get group => 'Группировка';

  @override
  String get day => 'День';

  @override
  String get hour => 'Час';

  @override
  String get month => 'Месяц';

  @override
  String get year => 'Год';

  @override
  String grouping(String gr) {
    String _temp0 = intl.Intl.selectLogic(
      gr,
      {
        'day': 'день',
        'month': 'месяц',
        'hour': 'час',
        'year': 'год',
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
      other: 'Ингридиенты',
      one: 'Ингридиент',
    );
    return '$_temp0';
  }

  @override
  String get price => 'Цена';

  @override
  String supplier(String count) {
    String _temp0 = intl.Intl.selectLogic(
      count,
      {
        '1': 'Поставщик',
        '2': 'Поставщики',
        'other': 'Поставщик',
      },
    );
    return '$_temp0';
  }

  @override
  String get enter_groc => 'введите название ингредиента...';

  @override
  String measure(String measure) {
    String _temp0 = intl.Intl.selectLogic(
      measure,
      {
        'gram': 'килограмм',
        'liter': 'литр',
        'other': 'неправильная мера',
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
  String get name => 'Название';

  @override
  String get left => 'Осталось';

  @override
  String get count => 'Количество';

  @override
  String get add => 'Добавить';

  @override
  String get add_supplier => 'Добавить поставщика';

  @override
  String get contacts => 'Контакты';

  @override
  String get number => 'Номер';

  @override
  String get sorting => 'Сортировка';

  @override
  String get filtering => 'Фильтр';

  @override
  String get by => 'По';

  @override
  String get find => 'Найти';

  @override
  String asc(String a) {
    String _temp0 = intl.Intl.selectLogic(
      a,
      {
        'asc': 'по возрастанию',
        'desc': 'по убыванию',
        'other': 'no',
      },
    );
    return '$_temp0';
  }

  @override
  String get dish => 'Блюдо';

  @override
  String get dish_name => 'Название блюда';

  @override
  String get groups => 'Группы';

  @override
  String get prime_cost => 'Себестоимость';

  @override
  String get save => 'Сохранить';

  @override
  String get add_group => 'Добавить группу';

  @override
  String get total => 'Общая';

  @override
  String get total1 => 'Итого';

  @override
  String get choose_image => 'Выберите изображение';

  @override
  String get enter_descr => 'Введите описание';

  @override
  String get no_descr => 'Описание отсутствует...';

  @override
  String get update_role => 'Изменить должность';

  @override
  String get delete => 'Удалить';

  @override
  String get roles => 'Должности';

  @override
  String get diary => 'Дневник';

  @override
  String get add_role => 'Добавить должность';

  @override
  String get namee => 'Имя';

  @override
  String get surname => 'Фимилия';

  @override
  String get birthday => 'Дань рождения';

  @override
  String get hours_per_month => 'Часов в месяц';

  @override
  String gen(String g) {
    String _temp0 = intl.Intl.selectLogic(
      g,
      {
        'm': 'Мужчины',
        'f': 'Женщины',
        'other': 'no',
      },
    );
    return '$_temp0';
  }

  @override
  String get hours => 'Часы';

  @override
  String get clear => 'Очистить';

  @override
  String get has_come => 'Пришел';

  @override
  String get from => 'от';

  @override
  String get to => 'до';

  @override
  String get has_gone => 'Ушел';

  @override
  String get waiter => 'Официант';

  @override
  String get salary_per_hour => 'зп/час';

  @override
  String get comment => 'Комментарий';

  @override
  String get summ => 'Сумма';

  @override
  String get pay => 'Оплатить';

  @override
  String get rest => 'Сдача';

  @override
  String get order => 'Заказ';

  @override
  String get or_rec => 'Заказ принято в';

  @override
  String get or_paid => 'Заказ оплачено в';

  @override
  String get or_list => 'Состав заказа';
}
