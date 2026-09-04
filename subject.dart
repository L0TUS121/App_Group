class Subject {
  final String shortName;
  final String fullName;

  final String lectureTeacher;
  final String lecturePhone;

  final String practiceTeacher;
  final String practicePhone;

  final String homework;

  const Subject({
    required this.shortName,
    required this.fullName,
    required this.lectureTeacher,
    required this.lecturePhone,
    required this.practiceTeacher,
    required this.practicePhone,
    required this.homework,
  });
}

const List<Subject> subjects = [
  Subject(
    shortName: 'СРМ',
    fullName: 'Спеціальні розділи математики',
    lectureTeacher: 'Викладач вищої математики',
    lecturePhone: '—',
    practiceTeacher: 'Викладач вищої математики',
    practicePhone: '—',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'КПП',
    fullName: 'Крос-платформне програмування',
    lectureTeacher: 'Викладач програмування',
    lecturePhone: '—',
    practiceTeacher: 'Викладач програмування',
    practicePhone: '—',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'АМ',
    fullName: 'Англійська мова',
    lectureTeacher: 'Викладач англійської мови',
    lecturePhone: '—',
    practiceTeacher: 'Викладач англійської мови',
    practicePhone: '—',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ТЕК',
    fullName: 'Теорія електронних кіл',
    lectureTeacher: 'Викладач фізики',
    lecturePhone: '—',
    practiceTeacher: 'Викладач фізики',
    practicePhone: '—',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ФІЛ',
    fullName: 'Філософія',
    lectureTeacher: 'Викладач філософії',
    lecturePhone: '-',
    practiceTeacher: 'Викладач філософії',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ЗТ',
    fullName: 'Загальна тактика',
    lectureTeacher: 'Викладач тактики',
    lecturePhone: '-',
    practiceTeacher: 'Викладач тактики',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ОВУ',
    fullName: 'Основи військового управління',
    lectureTeacher: 'Викладач ОВУ',
    lecturePhone: '-',
    practiceTeacher: 'Викладач ОВУ',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ОВЗв',
    fullName: 'Організація військового зв\'язку',
    lectureTeacher: 'Викладач ОВЗв',
    lecturePhone: '-',
    practiceTeacher: 'Викладач ОВЗв',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'СЗВП',
    fullName: 'Стрілецька зброя та вогнева підготовка',
    lectureTeacher: 'Викладач СЗВП',
    lecturePhone: '-',
    practiceTeacher: 'Викладач СЗВП',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ОВЗак',
    fullName: 'Основи військового законодавства та МГП',
    lectureTeacher: 'Викладач ОВЗак',
    lecturePhone: '-',
    practiceTeacher: 'Викладач ОВЗак',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'РП',
    fullName: 'Розвідувальна підготовка',
    lectureTeacher: 'Викладач розвідки',
    lecturePhone: '-',
    practiceTeacher: 'Викладач розвідки',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'АТ',
    fullName: 'Автомобільна техніка',
    lectureTeacher: 'Викладач техніки',
    lecturePhone: '-',
    practiceTeacher: 'Викладач техніки',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ФВ',
    fullName: 'Фізичне виховання',
    lectureTeacher: 'Викладач фізо',
    lecturePhone: '-',
    practiceTeacher: 'Викладач фізо',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ІКГ',
    fullName: 'Інженерна та комп\'ютерна графіка',
    lectureTeacher: 'Викладач ІКГ',
    lecturePhone: '-',
    practiceTeacher: 'Викладач ІКГ',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
];

/// Мапить короткий ідентифікатор пари, як він зберігається в Firestore
/// (напр. 'srm', 'tek'), на короткий надпис предмету для відображення
/// у розкладі.
String getSubjectName(String subjectId) {
  switch (subjectId.toLowerCase()) {
    case 'srm':
      return 'СРМ';
    case 'tek':
      return 'ТЕК';
    case 'fv':
      return 'ФВ';
    case 'at':
      return 'АТ';
    case 'kpp':
      return 'КПП';
    case 'im':
      return 'ІМ';
    case 'fil':
      return 'ФІЛ';
    case 'zt':
      return 'ЗТ';
    case 'ovu':
      return 'ОВУ';
    case 'ovzv':
      return 'ОВЗв';
    case 'szvp':
      return 'СЗВП';
    case 'ovzak':
      return 'ОВЗак';
    case 'rp':
      return 'РП';
    case 'ikg':
      return 'ІКГ';
    case '-':
      return 'Сампо';

    default:
      return subjectId;
  }
}
