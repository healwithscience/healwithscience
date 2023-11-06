class CustomCategory {
  String name;
  List<String> frequency;

  CustomCategory({required this.name, required this.frequency});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'frequencies': frequency,
    };
  }

  factory CustomCategory.fromMap(Map<String, dynamic> map) {
    return CustomCategory(
      name: map['name'] as String,

      frequency: (map['frequency'] ?? []).cast<String>(),
    );
  }
}
