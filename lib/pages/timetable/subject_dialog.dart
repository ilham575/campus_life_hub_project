import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timetable_state.dart';

class SubjectDialog extends StatefulWidget {
  @override
  _SubjectDialogState createState() => _SubjectDialogState();
}

class _SubjectDialogState extends State<SubjectDialog> {
  String? selectedDay;
  String? selectedTime;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final timetable = Provider.of<TimetableState>(context);
    return AlertDialog(
      title: Text('จัดการตารางเรียน'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'เลือกวัน'),
            value: selectedDay,
            items: timetable.days
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedDay = val;
                _updateController(timetable);
              });
            },
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'เลือกเวลา'),
            value: selectedTime,
            items: timetable.times
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedTime = val;
                _updateController(timetable);
              });
            },
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'ชื่อวิชา'),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('ยกเลิก')),
        if (_hasSubject(timetable))
          TextButton(
            onPressed: () {
              timetable.removeSubject(selectedDay!, selectedTime!);
              Navigator.pop(context);
            },
            child: Text('ลบ', style: TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: () {
            if (selectedDay != null &&
                selectedTime != null &&
                controller.text.trim().isNotEmpty) {
              timetable.updateSubject(
                selectedDay!,
                selectedTime!,
                controller.text.trim(),
              );
              Navigator.pop(context);
            }
          },
          child: Text('บันทึก'),
        ),
      ],
    );
  }

  void _updateController(TimetableState timetable) {
    if (selectedDay != null && selectedTime != null) {
      final key = '$selectedDay|$selectedTime';
      controller.text = timetable.subjects[key] ?? '';
    }
  }

  bool _hasSubject(TimetableState timetable) {
    if (selectedDay == null || selectedTime == null) return false;
    return timetable.subjects.containsKey('$selectedDay|$selectedTime');
  }
}
