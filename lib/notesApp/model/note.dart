class Note {
  final int? id;
  final String title;
  final String content;
  final int priority; // Mức độ ưu tiên
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String color; // Màu nền của ghi chú

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.createdAt,
    required this.modifiedAt,
    required this.color,
  });
  // Chuyển đối tượng thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'color': color,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      priority: map['priority'],
      createdAt: DateTime.parse(map['createdAt']),
      modifiedAt: DateTime.parse(map['modifiedAt']),
      color: map['color'],
    );
  }
}
