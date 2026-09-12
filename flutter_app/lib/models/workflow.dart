class Workflow {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final List<String> steps;
  final DateTime? lastRunAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Workflow({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.steps,
    this.lastRunAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Workflow.fromJson(Map<String, dynamic> json) {
    return Workflow(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Untitled workflow',
      description: json['description'] ?? '',
      isActive: json['isActive'] == true,
      steps: (json['steps'] as List<dynamic>?)
              ?.map((step) => step.toString())
              .toList() ??
          [],
      lastRunAt: _readDate(json['lastRunAt']),
      createdAt: _readDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: _readDate(json['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
      'steps': steps,
      'lastRunAt': lastRunAt?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  Workflow copyWith({
    String? id,
    String? name,
    String? description,
    bool? isActive,
    List<String>? steps,
    DateTime? lastRunAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Workflow(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      steps: steps ?? this.steps,
      lastRunAt: lastRunAt ?? this.lastRunAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _readDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) {
      final milliseconds = int.tryParse(value);
      if (milliseconds != null) {
        return DateTime.fromMillisecondsSinceEpoch(milliseconds);
      }
    }
    return null;
  }
}
