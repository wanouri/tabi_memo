import 'package:flutter/material.dart';
import 'package:tabi_memo/models/memo.dart';
import 'package:tabi_memo/screens/add_data_screen.dart';
import 'package:tabi_memo/screens/detail_screen.dart';
import 'package:tabi_memo/database/database_helper.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'tabi memo',
      theme: ThemeData(
        textTheme: GoogleFonts.mPlusRounded1cTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 1,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const MyHomePage(title: '旅のひとことメモ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
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

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'travel':
        return Icons.flight;
      case 'gourmet':
        return Icons.restaurant;
      case 'business':
        return Icons.work;
      default:
        return Icons.label;
    }
  }

  // カテゴリに応じた色を取得する
  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'travel':
        return Colors.blue;
      case 'gourmet':
        return Colors.red;
      case 'business':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

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
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  // DismissibleのonDismissedは、スワイプして削除したときに呼ばれる
                  // directionは、スワイプした方向を示す
                  // onDismissedは、スワイプして削除したときに呼ばれる
                  // directionは、スワイプした方向を示す
                  child: Dismissible(
                    key: Key(memo.id.toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('削除確認'),
                        content: const Text('このメモを削除しますか？'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('キャンセル'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('削除'),
                          ),
                        ],
                      ),
                    ),
                    onDismissed: (direction) async {
                      setState(() {
                        memos.removeAt(index);
                      });

                      DatabaseHelper.delete(memo.id ?? 0);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${memo.title}を削除しました'),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: memo.imagePath != null &&
                              memo.imagePath!.isNotEmpty &&
                              File(memo.imagePath!).existsSync()
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(memo.imagePath!),
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.image,
                              size: 40, color: Colors.grey),
                      title: Text(
                        memo.title ?? '',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            memo.body ?? '',
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (memo.category != null)
                            Row(
                              children: [
                                Icon(
                                  _getCategoryIcon(memo.category),
                                  color: _getCategoryColor(memo.category),
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  memo.category!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _getCategoryColor(memo.category),
                                  ),
                                ),
                              ],
                            ),
                          if (memo.date != null)
                            Text(
                              '${memo.date!.year}/${memo.date!.month.toString().padLeft(2, '0')}/${memo.date!.day.toString().padLeft(2, '0')}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                        ],
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(memo: memo),
                          ),
                        );
                        if (result == true) {
                          _getMemos();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
    // ListView.builder(
  }
}
