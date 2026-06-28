String formatAttribute(String attribute) {
  final dot = attribute.lastIndexOf('.');
  final name = dot == -1 ? attribute : attribute.substring(dot + 1);
  return name.replaceAll('_', ' ');
}

String resolveAttributeName(String attribute, [String? alias]) {
  if (alias != null && alias.isNotEmpty) {
    return alias;
  }
  return formatAttribute(attribute);
}

abstract class ValidationMessages {
  static ValidationMessages forLocale(String locale) {
    final normalized = locale.toLowerCase().split('-').first;
    if (normalized == 'ru') {
      return ValidationMessagesRu();
    }
    return ValidationMessagesEn();
  }

  String required(String attribute, [String? alias]);
  String string(String attribute, [String? alias]);
  String integer(String attribute, [String? alias]);
  String numeric(String attribute, [String? alias]);
  String boolean(String attribute, [String? alias]);
  String array(String attribute, [String? alias]);
  String email(String attribute, [String? alias]);
  String minChars(String attribute, num limit, [String? alias]);
  String minItems(String attribute, num limit, [String? alias]);
  String minValue(String attribute, num limit, [String? alias]);
  String minGeneric(String attribute, num limit, [String? alias]);
  String maxChars(String attribute, num limit, [String? alias]);
  String maxItems(String attribute, num limit, [String? alias]);
  String maxValue(String attribute, num limit, [String? alias]);
  String maxGeneric(String attribute, num limit, [String? alias]);
  String sizeChars(String attribute, num size, [String? alias]);
  String sizeItems(String attribute, num size, [String? alias]);
  String sizeValue(String attribute, num size, [String? alias]);
  String sizeGeneric(String attribute, num size, [String? alias]);
  String betweenChars(String attribute, num min, num max, [String? alias]);
  String betweenItems(String attribute, num min, num max, [String? alias]);
  String betweenValue(String attribute, num min, num max, [String? alias]);
  String betweenGeneric(String attribute, num min, num max, [String? alias]);
  String regex(String attribute, [String? alias]);
  String inInvalid(String attribute, [String? alias]);
  String notInInvalid(String attribute, [String? alias]);
  String unique(String attribute, [String? alias]);
}

class ValidationMessagesEn extends ValidationMessages {
  @override
  String required(String attribute, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} field is required.';

  @override
  String string(String attribute, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be a string.';

  @override
  String integer(String attribute, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be an integer.';

  @override
  String numeric(String attribute, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be a number.';

  @override
  String boolean(String attribute, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} field must be true or false.';

  @override
  String array(String attribute, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be an array.';

  @override
  String email(String attribute, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be a valid email address.';

  @override
  String minChars(String attribute, num limit, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be at least $limit characters.';

  @override
  String minItems(String attribute, num limit, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must have at least $limit items.';

  @override
  String minValue(String attribute, num limit, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be at least $limit.';

  @override
  String minGeneric(String attribute, num limit, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be at least $limit.';

  @override
  String maxChars(String attribute, num limit, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must not be greater than $limit characters.';

  @override
  String maxItems(String attribute, num limit, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must not have more than $limit items.';

  @override
  String maxValue(String attribute, num limit, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must not be greater than $limit.';

  @override
  String maxGeneric(String attribute, num limit, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must not be greater than $limit.';

  @override
  String sizeChars(String attribute, num size, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be $size characters.';

  @override
  String sizeItems(String attribute, num size, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must contain $size items.';

  @override
  String sizeValue(String attribute, num size, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be $size.';

  @override
  String sizeGeneric(String attribute, num size, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be $size.';

  @override
  String betweenChars(String attribute, num min, num max, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be between $min and $max characters.';

  @override
  String betweenItems(String attribute, num min, num max, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must have between $min and $max items.';

  @override
  String betweenValue(String attribute, num min, num max, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be between $min and $max.';

  @override
  String betweenGeneric(String attribute, num min, num max, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} must be between $min and $max.';

  @override
  String regex(String attribute, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} format is invalid.';

  @override
  String inInvalid(String attribute, [String? alias]) =>
      'The selected ${resolveAttributeName(attribute, alias)} is invalid.';

  @override
  String notInInvalid(String attribute, [String? alias]) =>
      'The selected ${resolveAttributeName(attribute, alias)} is invalid.';

  @override
  String unique(String attribute, [String? alias]) =>
      'The ${resolveAttributeName(attribute, alias)} has already been taken.';
}

class ValidationMessagesRu extends ValidationMessages {
  @override
  String required(String attribute, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} обязательно для заполнения.';

  @override
  String string(String attribute, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно быть строкой.';

  @override
  String integer(String attribute, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно быть целым числом.';

  @override
  String numeric(String attribute, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно быть числом.';

  @override
  String boolean(String attribute, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно быть true или false.';

  @override
  String array(String attribute, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно быть массивом.';

  @override
  String email(String attribute, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно быть действительным email адресом.';

  @override
  String minChars(String attribute, num limit, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно содержать не менее $limit символов.';

  @override
  String minItems(String attribute, num limit, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно содержать не менее $limit элементов.';

  @override
  String minValue(String attribute, num limit, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно быть не менее $limit.';

  @override
  String minGeneric(String attribute, num limit, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно быть не менее $limit.';

  @override
  String maxChars(String attribute, num limit, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} не должно содержать более $limit символов.';

  @override
  String maxItems(String attribute, num limit, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} не должно содержать более $limit элементов.';

  @override
  String maxValue(String attribute, num limit, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} не должно быть больше $limit.';

  @override
  String maxGeneric(String attribute, num limit, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} не должно быть больше $limit.';

  @override
  String sizeChars(String attribute, num size, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно содержать $size символов.';

  @override
  String sizeItems(String attribute, num size, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно содержать $size элементов.';

  @override
  String sizeValue(String attribute, num size, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно быть равно $size.';

  @override
  String sizeGeneric(String attribute, num size, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно быть равно $size.';

  @override
  String betweenChars(String attribute, num min, num max, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно содержать от $min до $max символов.';

  @override
  String betweenItems(String attribute, num min, num max, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно содержать от $min до $max элементов.';

  @override
  String betweenValue(String attribute, num min, num max, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно быть между $min и $max.';

  @override
  String betweenGeneric(String attribute, num min, num max, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} должно быть между $min и $max.';

  @override
  String regex(String attribute, [String? alias]) =>
      'Поле ${resolveAttributeName(attribute, alias)} имеет неверный формат.';

  @override
  String inInvalid(String attribute, [String? alias]) =>
      'Выбранное значение для ${resolveAttributeName(attribute, alias)} некорректно.';

  @override
  String notInInvalid(String attribute, [String? alias]) =>
      'Выбранное значение для ${resolveAttributeName(attribute, alias)} некорректно.';

  @override
  String unique(String attribute, [String? alias]) =>
      'Такое значение ${resolveAttributeName(attribute, alias)} уже занято.';
}
