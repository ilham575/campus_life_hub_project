import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  bool isGrid = false;
  String? selectedWeekday;

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

  final Map<String, String> subjects = {
    'จันทร์|08:00-09:00': 'คณิต',
    'จันทร์|09:00-10:00': 'ภาษาไทย',
    'อังคาร|10:00-11:00': 'วิทย์',
    'พุธ|13:00-14:00': 'อังกฤษ',
    'พฤหัสบดี|15:00-16:00': 'ประวัติ',
    'ศุกร์|08:00-09:00': 'ศิลปะ',
  };

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('th', null).then((_) {
      final today = _getThaiWeekday();
      setState(() {
        selectedWeekday = today;
      });
    });
  }

  String _getThaiWeekday() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตารางเรียน'),
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.list : Icons.grid_on),
            tooltip: isGrid ? "แสดงแบบรายการ" : "แสดงแบบตาราง",
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
          ),
        ],
      ),
      body: isGrid ? buildGridTable() : buildListViewWithDaySelector(),
    );
  }

  Widget buildGridTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: Colors.grey),
        defaultColumnWidth: FixedColumnWidth(100),
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey[300]),
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('วัน/เวลา', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              ...times.map((t) => TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        t,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )),
            ],
          ),
          ...days.map((day) {
            return TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                ...times.map((time) {
                  final key = '$day|$time';
                  final subject = subjects[key] ?? '';
                  return TableCell(
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Text(subject),
                    ),
                  );
                }).toList(),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget buildListViewWithDaySelector() {
    final selectedDay = selectedWeekday ?? 'จันทร์';

    List<Map<String, String>> filtered = [];
    for (var time in times) {
      final key = '$selectedDay|$time';
      if (subjects.containsKey(key)) {
        filtered.add({
          'time': time,
          'subject': subjects[key]!,
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 ปุ่มเลือกวันแนวนอน
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = day == selectedDay;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(day),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedWeekday = day;
                    });
                  },
                  selectedColor: Colors.blue[300],
                  backgroundColor: Colors.grey[300],
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // 🔹 แสดงรายวิชาเฉพาะวัน
        Expanded(
          child: filtered.isEmpty
              ? Center(child: Text('ไม่มีตารางเรียนสำหรับ "$selectedDay"'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: Icon(Icons.book),
                        title: Text(item['subject']!),
                        subtitle: Text(item['time']!),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
