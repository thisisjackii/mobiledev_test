import 'package:equatable/equatable.dart';
import 'package:mobiledev_test/features/employee/models/employee_model.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();
  @override
  List<Object?> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoadSuccess extends EmployeeState {
  final List<Employee> employees;
  const EmployeeLoadSuccess(this.employees);
  @override
  List<Object?> get props => [employees];
}

class EmployeeOperationSuccess extends EmployeeState {
  final String message;
  const EmployeeOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class EmployeeFailure extends EmployeeState {
  final String error;
  const EmployeeFailure(this.error);
  @override
  List<Object?> get props => [error];
}
