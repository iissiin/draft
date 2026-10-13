const titleMaxLength = 40;
const textMaxLength = 200;

String? validateTitle(String value) {
  final title = value.trim();
  if (title.isEmpty) return 'Введите заголовок';
  if (title.length > titleMaxLength) {
    return 'Не более $titleMaxLength символов';
  }
  return null;
}

String? validateText(String value) {
  if (value.length > textMaxLength) {
    return 'Не более $textMaxLength символов';
  }
  return null;
}
