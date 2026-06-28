String formatAttribute(String attribute) {
  final dot = attribute.lastIndexOf('.');
  final name = dot == -1 ? attribute : attribute.substring(dot + 1);
  return name.replaceAll('_', ' ');
}

abstract class ValidationMessages {
  static ValidationMessages forLocale(String locale) {
    final normalized = locale.toLowerCase().split('-').first;
    if (normalized == 'ru') {
      return ValidationMessagesRu();
    }
    return ValidationMessagesEn();
  }

  String required(String attribute);
  String string(String attribute);
  String integer(String attribute);
  String numeric(String attribute);
  String boolean(String attribute);
  String array(String attribute);
  String email(String attribute);
  String minChars(String attribute, num limit);
  String minItems(String attribute, num limit);
  String minValue(String attribute, num limit);
  String minGeneric(String attribute, num limit);
  String maxChars(String attribute, num limit);
  String maxItems(String attribute, num limit);
  String maxValue(String attribute, num limit);
  String maxGeneric(String attribute, num limit);
  String sizeChars(String attribute, num size);
  String sizeItems(String attribute, num size);
  String sizeValue(String attribute, num size);
  String sizeGeneric(String attribute, num size);
  String betweenChars(String attribute, num min, num max);
  String betweenItems(String attribute, num min, num max);
  String betweenValue(String attribute, num min, num max);
  String betweenGeneric(String attribute, num min, num max);
  String regex(String attribute);
  String inInvalid(String attribute);
  String notInInvalid(String attribute);
  String unique(String attribute);
}

class ValidationMessagesEn extends ValidationMessages {
  @override
  String required(String attribute) =>
      'The ${formatAttribute(attribute)} field is required.';

  @override
  String string(String attribute) =>
      'The ${formatAttribute(attribute)} must be a string.';

  @override
  String integer(String attribute) =>
      'The ${formatAttribute(attribute)} must be an integer.';

  @override
  String numeric(String attribute) =>
      'The ${formatAttribute(attribute)} must be a number.';

  @override
  String boolean(String attribute) =>
      'The ${formatAttribute(attribute)} field must be true or false.';

  @override
  String array(String attribute) =>
      'The ${formatAttribute(attribute)} must be an array.';

  @override
  String email(String attribute) =>
      'The ${formatAttribute(attribute)} must be a valid email address.';

  @override
  String minChars(String attribute, num limit) =>
      'The ${formatAttribute(attribute)} must be at least $limit characters.';

  @override
  String minItems(String attribute, num limit) =>
      'The ${formatAttribute(attribute)} must have at least $limit items.';

  @override
  String minValue(String attribute, num limit) =>
      'The ${formatAttribute(attribute)} must be at least $limit.';

  @override
  String minGeneric(String attribute, num limit) =>
      'The ${formatAttribute(attribute)} must be at least $limit.';

  @override
  String maxChars(String attribute, num limit) =>
      'The ${formatAttribute(attribute)} must not be greater than $limit characters.';

  @override
  String maxItems(String attribute, num limit) =>
      'The ${formatAttribute(attribute)} must not have more than $limit items.';

  @override
  String maxValue(String attribute, num limit) =>
      'The ${formatAttribute(attribute)} must not be greater than $limit.';

  @override
  String maxGeneric(String attribute, num limit) =>
      'The ${formatAttribute(attribute)} must not be greater than $limit.';

  @override
  String sizeChars(String attribute, num size) =>
      'The ${formatAttribute(attribute)} must be $size characters.';

  @override
  String sizeItems(String attribute, num size) =>
      'The ${formatAttribute(attribute)} must contain $size items.';

  @override
  String sizeValue(String attribute, num size) =>
      'The ${formatAttribute(attribute)} must be $size.';

  @override
  String sizeGeneric(String attribute, num size) =>
      'The ${formatAttribute(attribute)} must be $size.';

  @override
  String betweenChars(String attribute, num min, num max) =>
      'The ${formatAttribute(attribute)} must be between $min and $max characters.';

  @override
  String betweenItems(String attribute, num min, num max) =>
      'The ${formatAttribute(attribute)} must have between $min and $max items.';

  @override
  String betweenValue(String attribute, num min, num max) =>
      'The ${formatAttribute(attribute)} must be between $min and $max.';

  @override
  String betweenGeneric(String attribute, num min, num max) =>
      'The ${formatAttribute(attribute)} must be between $min and $max.';

  @override
  String regex(String attribute) =>
      'The ${formatAttribute(attribute)} format is invalid.';

  @override
  String inInvalid(String attribute) =>
      'The selected ${formatAttribute(attribute)} is invalid.';

  @override
  String notInInvalid(String attribute) =>
      'The selected ${formatAttribute(attribute)} is invalid.';

  @override
  String unique(String attribute) =>
      'The ${formatAttribute(attribute)} has already been taken.';
}

class ValidationMessagesRu extends ValidationMessages {
  @override
  String required(String attribute) =>
      'Поле ${formatAttribute(attribute)} обязательно для заполнения.';

  @override
  String string(String attribute) =>
      'Поле ${formatAttribute(attribute)} должно быть строкой.';

  @override
  String integer(String attribute) =>
      'Поле ${formatAttribute(attribute)} должно быть целым числом.';

  @override
  String numeric(String attribute) =>
      'Поле ${formatAttribute(attribute)} должно быть числом.';

  @override
  String boolean(String attribute) =>
      'Поле ${formatAttribute(attribute)} должно быть true или false.';

  @override
  String array(String attribute) =>
      'Поле ${formatAttribute(attribute)} должно быть массивом.';

  @override
  String email(String attribute) =>
      'Поле ${formatAttribute(attribute)} должно быть действительным email адресом.';

  @override
  String minChars(String attribute, num limit) =>
      'Поле ${formatAttribute(attribute)} должно содержать не менее $limit символов.';

  @override
  String minItems(String attribute, num limit) =>
      'Поле ${formatAttribute(attribute)} должно содержать не менее $limit элементов.';

  @override
  String minValue(String attribute, num limit) =>
      'Поле ${formatAttribute(attribute)} должно быть не менее $limit.';

  @override
  String minGeneric(String attribute, num limit) =>
      'Поле ${formatAttribute(attribute)} должно быть не менее $limit.';

  @override
  String maxChars(String attribute, num limit) =>
      'Поле ${formatAttribute(attribute)} не должно содержать более $limit символов.';

  @override
  String maxItems(String attribute, num limit) =>
      'Поле ${formatAttribute(attribute)} не должно содержать более $limit элементов.';

  @override
  String maxValue(String attribute, num limit) =>
      'Поле ${formatAttribute(attribute)} не должно быть больше $limit.';

  @override
  String maxGeneric(String attribute, num limit) =>
      'Поле ${formatAttribute(attribute)} не должно быть больше $limit.';

  @override
  String sizeChars(String attribute, num size) =>
      'Поле ${formatAttribute(attribute)} должно содержать $size символов.';

  @override
  String sizeItems(String attribute, num size) =>
      'Поле ${formatAttribute(attribute)} должно содержать $size элементов.';

  @override
  String sizeValue(String attribute, num size) =>
      'Поле ${formatAttribute(attribute)} должно быть равно $size.';

  @override
  String sizeGeneric(String attribute, num size) =>
      'Поле ${formatAttribute(attribute)} должно быть равно $size.';

  @override
  String betweenChars(String attribute, num min, num max) =>
      'Поле ${formatAttribute(attribute)} должно содержать от $min до $max символов.';

  @override
  String betweenItems(String attribute, num min, num max) =>
      'Поле ${formatAttribute(attribute)} должно содержать от $min до $max элементов.';

  @override
  String betweenValue(String attribute, num min, num max) =>
      'Поле ${formatAttribute(attribute)} должно быть между $min и $max.';

  @override
  String betweenGeneric(String attribute, num min, num max) =>
      'Поле ${formatAttribute(attribute)} должно быть между $min и $max.';

  @override
  String regex(String attribute) =>
      'Поле ${formatAttribute(attribute)} имеет неверный формат.';

  @override
  String inInvalid(String attribute) =>
      'Выбранное значение для ${formatAttribute(attribute)} некорректно.';

  @override
  String notInInvalid(String attribute) =>
      'Выбранное значение для ${formatAttribute(attribute)} некорректно.';

  @override
  String unique(String attribute) =>
      'Такое значение ${formatAttribute(attribute)} уже занято.';
}
