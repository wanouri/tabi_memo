class Memo {
  const Memo(
    this.id, // ID
    this.title, // タイトル
    this.body, // 本文
    this.date, // 日付
    this.imagePath, // 画像パス
    this.category, // カテゴリ
  );

  final int? id;
  final String? title;
  final String? body;
  final DateTime? date;
  final String? imagePath;
  final String? category;
}
