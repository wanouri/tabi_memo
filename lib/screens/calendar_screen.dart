import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tabi_memo/models/memo.dart';
import 'package:tabi_memo/database/database_helper.dart';
import 'package:tabi_memo/widgets/memo_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Memo> _allMemos = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadMemos();
  }

  Future<void> _loadMemos() async {
    final maps = await DatabaseHelper.select();
    setState(() {
      _allMemos = maps.map((map) {
        return Memo(
          map['id'],
          map['title'],
          map['body'],
          map['date'] != null ? DateTime.parse(map['date']) : null,
          map['imagePath'],
          map['category'],
        );
      }).toList();
    });
  }

  List<Memo> _getMemosForDay(DateTime day) {
    return _allMemos.where((memo) {
      if (memo.date == null) return false;
      return memo.date!.year == day.year &&
          memo.date!.month == day.month &&
          memo.date!.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final memosForSelectedDay =
        _selectedDay != null ? _getMemosForDay(_selectedDay!) : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダーで探す'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) =>
                _selectedDay != null && isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: memosForSelectedDay.isEmpty
                ? const Center(child: Text('この日にはメモがありません'))
                : ListView.builder(
                    itemCount: memosForSelectedDay.length,
                    itemBuilder: (context, index) {
                      return MemoCard(
                        memo: memosForSelectedDay[index],
                        onDeleted: _loadMemos,
                        onUpdated: _loadMemos,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
