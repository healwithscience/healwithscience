class Category {
  String name;
  String frequency;

  Category({required this.name, required this.frequency});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'frequency': frequency,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] as String,
      frequency: map['frequency'] as String,
    );
  }
}