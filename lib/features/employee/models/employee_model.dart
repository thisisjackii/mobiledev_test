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
    String _safeString(dynamic value, String defaultValue) {
      if (value is String) return value;
      if (value != null) return value.toString();
      return defaultValue;
    }

    return Employee(
      id: _safeString(json['id'], ''),
      name: _safeString(json['name'], 'No Name'),
      nik: _safeString(json['nik'], 'No NIK'),
      position: _safeString(json['position'], 'No Position'),
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
