class Memo {
  Memo({
    required this.id, // ID
    required this.title, // タイトル
    required this.body, // 本文
    required this.date, // 日付
    required this.imagePath, // 画像パス
  });

  final int id;
  final String title;
  final String body;
  final DateTime date;
  final String imagePath;
}
