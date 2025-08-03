import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timetable_state.dart';
import 'subject_dialog.dart';

class TimetablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timetable = Provider.of<TimetableState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ตารางเรียน'),
        actions: [
          IconButton(
            icon: Icon(timetable.isGrid ? Icons.list : Icons.grid_on),
            onPressed: timetable.toggleView,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: timetable.isGrid
                ? buildGrid(timetable)
                : buildList(timetable),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => SubjectDialog(),
                );
              },
              icon: Icon(Icons.edit_calendar),
              label: Text('จัดการตารางเรียน'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGrid(TimetableState timetable) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: Colors.grey),
        defaultColumnWidth: FixedColumnWidth(100),
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey[300]),
            children: [
              TableCell(child: Center(child: Text('วัน/เวลา'))),
              ...timetable.times.map((t) => TableCell(child: Center(child: Text(t)))),
            ],
          ),
          ...timetable.days.map((day) {
            return TableRow(
              children: [
                TableCell(child: Center(child: Text(day))),
                ...timetable.times.map((time) {
                  final subject = timetable.subjects['$day|$time'] ?? '';
                  return TableCell(
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      color: subject.isNotEmpty ? Colors.blue[50] : null,
                      child: Text(subject),
                    ),
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget buildList(TimetableState timetable) {
    final day = timetable.selectedWeekday;
    final filtered = timetable.times.map((time) {
      final key = '$day|$time';
      return {
        'time': time,
        'subject': timetable.subjects[key] ?? '',
      };
    }).where((e) => e['subject']!.isNotEmpty).toList();

    return Column(
      children: [
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: timetable.days.map((d) {
              final selected = d == day;
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ChoiceChip(
                  label: Text(d),
                  selected: selected,
                  onSelected: (_) => timetable.setDay(d),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? Center(child: Text('ไม่มีตารางเรียน'))
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final item = filtered[i];
                    return ListTile(
                      leading: Icon(Icons.book),
                      title: Text(item['subject']!),
                      subtitle: Text(item['time']!),
                    );
                  },
                ),
        )
      ],
    );
  }
}
