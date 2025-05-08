import 'package:flutter/material.dart';
import 'package:tabi_memo/database/database_helper.dart';
import 'package:tabi_memo/models/memo.dart';
import 'package:tabi_memo/screens/add_data_screen.dart';
import 'package:tabi_memo/screens/calendar_screen.dart';
import 'package:tabi_memo/widgets/memo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  // メモのリストを保持する
  List<Memo> memos = [];

  // 検索キーワードを保持する
  String _searchKeyword = '';

  // メモの並び替えの順序を保持する
  // true: 新しい順、false: 古い順
  bool _isNewestFirst = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getMemos();
  }

  // データベースからメモを取得する
  Future<void> _getMemos() async {
    final List<Map<String, dynamic>> maps = await DatabaseHelper.select();
    setState(() {
      memos = List.generate(maps.length, (i) {
        return Memo(
          maps[i]['id'],
          maps[i]['title'],
          maps[i]['body'],
          maps[i]['date'] == null
              ? DateTime.now()
              : DateTime.parse(maps[i]['date']),
          maps[i]['imagePath'],
          maps[i]['category'],
        );
      });
    });
  }

  // メモのリストをフィルタリングする
  List<Memo> _filteredMemos() {
    List<Memo> filtered = _searchKeyword.isEmpty
        ? List.from(memos)
        : memos.where((memo) {
            final title = memo.title?.toLowerCase() ?? '';
            final body = memo.body?.toLowerCase() ?? '';
            final category = memo.category?.toLowerCase() ?? '';
            return title.contains(_searchKeyword) ||
                body.contains(_searchKeyword) ||
                category.contains(_searchKeyword);
          }).toList();

    filtered.sort((a, b) => _isNewestFirst
        ? b.date!.compareTo(a.date!)
        : a.date!.compareTo(b.date!));

    return filtered;
  }

  // メモのリストをソートする
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddDataScreen(memo: Memo(null, null, null, null, null, null)),
            ),
          );
          if (result == true) {
            _getMemos();
          }
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _getMemos();
            },
          ),
          IconButton(
            icon: Icon(
                _isNewestFirst ? Icons.arrow_downward : Icons.arrow_upward),
            tooltip: _isNewestFirst ? '新しい順' : '古い順',
            onPressed: () {
              setState(() {
                _isNewestFirst = !_isNewestFirst;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'キーワードで検索',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value.toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _filteredMemos().length,
                itemBuilder: (context, index) {
                  final memo = _filteredMemos()[index];
                  return MemoCard(
                    memo: memo,
                    onDeleted: _getMemos,
                    onUpdated: _getMemos,
                  );
                }),
          ),
        ],
      ),
    );
    // ListView.builder(
  }
}
