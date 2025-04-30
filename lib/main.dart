import 'package:flutter/material.dart';
import 'package:tabi_memo/models/memo.dart';
import 'package:tabi_memo/screens/add_data_screen.dart';
import 'package:tabi_memo/screens/detail_screen.dart';
import 'package:tabi_memo/database/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'tabi memo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Memo> memos = [];

  @override
  void initState() {
    super.initState();
    _getMemos();
  }

  Future<void> _getMemos() async {
    final List<Map<String, dynamic>> maps = await DatabaseHelper.select();
    setState(() {
      memos = List.generate(maps.length, (i) {
        return Memo(
          maps[i]['id'],
          maps[i]['title'],
          maps[i]['body'],
          DateTime.parse(maps[i]['date']),
          maps[i]['imagePath'] ?? '',
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _getMemos();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddDataScreen(),
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: memos.length,
        itemBuilder: (context, index) {
          final memo = memos[index];
          return Dismissible(
            key: Key(memo.id.toString()),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              setState(() {
                memos.removeAt(index);
              });

              DatabaseHelper.delete(memo.id);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${memo.title}を削除しました'),
                ),
              );
            },
            child: ListTile(
              title: Text(memos[index].title),
              subtitle: Text(memos[index].body),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(memo: memos[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
