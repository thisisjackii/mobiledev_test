import 'package:equatable/equatable.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();
  @override
  List<Object?> get props => [];
}

class FetchEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final String name;
  final String nik;
  final String position;
  const AddEmployee({
    required this.name,
    required this.nik,
    required this.position,
  });
  @override
  List<Object?> get props => [name, nik, position];
}

class UpdateEmployee extends EmployeeEvent {
  final String id;
  final String name;
  final String nik;
  final String position;
  const UpdateEmployee({
    required this.id,
    required this.name,
    required this.nik,
    required this.position,
  });
  @override
  List<Object?> get props => [id, name, nik, position];
}

class DeleteEmployee extends EmployeeEvent {
  final String id;
  const DeleteEmployee(this.id);
  @override
  List<Object?> get props => [id];
}
