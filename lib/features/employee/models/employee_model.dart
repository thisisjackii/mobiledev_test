import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String id;
  final String name;
  final String nik;
  final String position;

  const Employee({
    required this.id,
    required this.name,
    required this.nik,
    required this.position,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      name: json['name'] as String,
      nik: json['nik'] as String,
      position: json['position'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'nik': nik, 'position': position};
  }

  Employee copyWith({String? name, String? nik, String? position}) {
    return Employee(
      id: id,
      name: name ?? this.name,
      nik: nik ?? this.nik,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [id, name, nik, position];
}
