import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimetableState with ChangeNotifier {
  bool isGrid = false;
  late String selectedWeekday;

  TimetableState() {
    selectedWeekday = _getTodayThaiName();
  }

  String _getTodayThaiName() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE', 'th');
    final weekday = formatter.format(now);
    if (weekday.contains('จันทร์')) return 'จันทร์';
    if (weekday.contains('อังคาร')) return 'อังคาร';
    if (weekday.contains('พุธ')) return 'พุธ';
    if (weekday.contains('พฤหัส')) return 'พฤหัสบดี';
    if (weekday.contains('ศุกร์')) return 'ศุกร์';
    return 'จันทร์'; 
  }
  
  final List<String> days = ['จันทร์', 'อังคาร', 'พุธ', 'พฤหัสบดี', 'ศุกร์'];
  final List<String> times = [
    '08:00-09:00',
    '09:00-10:00',
    '10:00-11:00',
    '11:00-12:00',
    '13:00-14:00',
    '14:00-15:00',
    '15:00-16:00',
  ];

  final Map<String, String> _subjects = {
    'จันทร์|08:00-09:00': 'คณิต',
    'จันทร์|09:00-10:00': 'ภาษาไทย',
    'อังคาร|10:00-11:00': 'วิทย์',
    'พุธ|13:00-14:00': 'อังกฤษ',
    'พฤหัสบดี|15:00-16:00': 'ประวัติ',
    'ศุกร์|08:00-09:00': 'ศิลปะ',
  };

  Map<String, String> get subjects => _subjects;

  void toggleView() {
    isGrid = !isGrid;
    selectedWeekday = _getTodayThaiName();
    notifyListeners();
  }

  void setDay(String day) {
    selectedWeekday = day;
    notifyListeners();
  }

  void updateSubject(String day, String time, String subject) {
    _subjects['$day|$time'] = subject;
    notifyListeners();
  }

  void removeSubject(String day, String time) {
    _subjects.remove('$day|$time');
    notifyListeners();
  }

  void resetToToday() {
    selectedWeekday = _getTodayThaiName();
    notifyListeners();
  }

}
