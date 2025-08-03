import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timetable_state.dart';

class SubjectDialog extends StatelessWidget {
  final String? selectedDay;
  final String? selectedTime;
  final TextEditingController controller;
  final void Function(String?) onDayChanged;
  final void Function(String?) onTimeChanged;
  final VoidCallback onSave;
  final VoidCallback? onDelete;

  const SubjectDialog({
    super.key,
    required this.selectedDay,
    required this.selectedTime,
    required this.controller,
    required this.onDayChanged,
    required this.onTimeChanged,
    required this.onSave,
    this.onDelete,
  });

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
            onChanged: onDayChanged,
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'เลือกเวลา'),
            value: selectedTime,
            items: timetable.times
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: onTimeChanged,
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'ชื่อวิชา'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('ยกเลิก'),
        ),
        if (onDelete != null)
          TextButton(
            onPressed: () {
              onDelete!();
              Navigator.pop(context);
            },
            child: Text('ลบ', style: TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: () {
            onSave();
            Navigator.pop(context);
          },
          child: Text('บันทึก'),
        ),
      ],
    );
  }
}