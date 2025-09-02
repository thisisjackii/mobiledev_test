import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobiledev_test/app/routes/routes.dart';
import 'package:mobiledev_test/core/state/auth_state.dart';
import 'package:mobiledev_test/features/employee/bloc/employee_bloc.dart';
import 'package:mobiledev_test/features/employee/bloc/employee_event.dart';
import 'package:mobiledev_test/features/employee/bloc/employee_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(FetchEmployees());
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final email = authState.currentUser?.email ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, $email', style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthState>().logout();
            },
          ),
        ],
      ),

      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EmployeeLoadSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<EmployeeBloc>().add(FetchEmployees());
              },
              child: ListView.builder(
                itemCount: state.employees.length,
                itemBuilder: (context, index) {
                  final employee = state.employees[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(employee.id)),
                    title: Text(employee.name),
                    subtitle: Text(employee.position),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.employeeForm,
                        arguments: employee,
                      );
                    },
                  );
                },
              ),
            );
          }
          return const Center(
            child: Text('Gagal memuat data atau belum ada data.'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.employeeForm, arguments: null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
