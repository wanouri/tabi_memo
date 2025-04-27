import 'package:flutter/material.dart';
import 'package:tabi_memo/screens/add_data_screen.dart';
import 'package:tabi_memo/screens/detail.dart';
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
  @override
  Widget build(BuildContext context) {
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
            },
          ),
        ],
      ),
      body: GestureDetector(
        child: ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Title ", // Replace with actual title
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "body", // Replace with actual title
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Text(
                    "DateTime", // Replace with actual title
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DetailPage(),
            ),
          );
        },
      ),
    );
  }
}
