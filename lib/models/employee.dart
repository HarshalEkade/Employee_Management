class Employee {
  final int? id;
  final String name;
  final String designation;
  final DateTime dob;
  final String? imagePath;

  const Employee({
    this.id,
    required this.name,
    required this.designation,
    required this.dob,
    this.imagePath,
  });

  Employee copyWith({
    int? id,
    String? name,
    String? designation,
    DateTime? dob,
    String? imagePath,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      designation: designation ?? this.designation,
      dob: dob ?? this.dob,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'designation': designation,
      'dob': dob.toIso8601String(),
      'image_path': imagePath,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      designation: map['designation'] as String? ?? '',
      dob: DateTime.parse(map['dob'] as String),
      imagePath: map['image_path'] as String?,
    );
  }
}

