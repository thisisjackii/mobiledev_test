import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobiledev_test/features/employee/bloc/employee_event.dart';
import 'package:mobiledev_test/features/employee/bloc/employee_state.dart';
import 'package:mobiledev_test/features/employee/repositories/employee_repository.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository _repo;

  EmployeeBloc(this._repo) : super(EmployeeInitial()) {
    on<FetchEmployees>((event, emit) async {
      emit(EmployeeLoading());
      try {
        final employees = await _repo.getEmployees();
        emit(EmployeeLoadSuccess(employees));
      } catch (e) {
        emit(EmployeeFailure(e.toString()));
      }
    });

    on<AddEmployee>((event, emit) async {
      try {
        await _repo.createEmployee(event.name, event.nik, event.position);
        emit(const EmployeeOperationSuccess("Pegawai berhasil ditambahkan!"));
        add(FetchEmployees());
      } catch (e) {
        emit(EmployeeFailure(e.toString()));
      }
    });

    on<UpdateEmployee>((event, emit) async {
      try {
        await _repo.updateEmployee(
          event.id,
          name: event.name,
          nik: event.nik,
          position: event.position,
        );
        emit(const EmployeeOperationSuccess("Data pegawai berhasil diubah!"));
        add(FetchEmployees());
      } catch (e) {
        emit(EmployeeFailure(e.toString()));
      }
    });

    on<DeleteEmployee>((event, emit) async {
      try {
        await _repo.deleteEmployee(event.id);
        emit(const EmployeeOperationSuccess("Pegawai berhasil dihapus!"));
        add(FetchEmployees());
      } catch (e) {
        emit(EmployeeFailure(e.toString()));
      }
    });
  }
}
