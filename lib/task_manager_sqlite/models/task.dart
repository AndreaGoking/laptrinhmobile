class Task {
    String id;
    String title;
    String description;
    String status;
    int priority;
    DateTime? dueDate;
    DateTime createdAt;
    DateTime updatedAt;
    String? assignedTo;
    String createdBy;
    String? category;
    List<String>? attachments;
    bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.assignedTo,
    required this.createdBy,
    this.category,
    this.attachments,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'assignedTo': assignedTo,
      'createdBy': createdBy,
      'category': category,
      'attachments': attachments?.join(','),
      'completed': completed ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      priority: map['priority'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      assignedTo: map['assignedTo'],
      createdBy: map['createdBy'],
      category: map['category'],
      attachments: map['attachments']?.toString().split(','),
      completed: map['completed'] == 1,
    );
  }
}