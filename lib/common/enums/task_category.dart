enum TaskCategory {
  work('Work'),
  study('Study'),
  personal('Personal'),
  shopping('Shopping'),
  others('Others');

  final String text;

  const TaskCategory(this.text);

  factory TaskCategory.fromMap(String text) {
    switch (text) {
      case 'Work':
        return TaskCategory.work;
      case 'Study':
        return TaskCategory.study;
      case 'Personal':
        return TaskCategory.personal;
      case 'Shopping':
        return TaskCategory.shopping;
      case 'Others':
        return TaskCategory.others;
      default:
        throw Exception('Invalid TaskCategory');
    }
  }
}
