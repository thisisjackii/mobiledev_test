import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobiledev_test/features/employee/bloc/employee_bloc.dart';
import 'package:mobiledev_test/features/employee/bloc/employee_event.dart';
import 'package:mobiledev_test/features/employee/bloc/employee_state.dart';
import 'package:mobiledev_test/features/employee/models/employee_model.dart';

enum FormMode { add, view, edit }

class EmployeeFormPage extends StatefulWidget {
  final Employee? employee;
  const EmployeeFormPage({super.key, this.employee});

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nikController;
  late TextEditingController _positionController;
  late FormMode _mode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nikController = TextEditingController();
    _positionController = TextEditingController();

    if (widget.employee == null) {
      _mode = FormMode.add;
    } else {
      _mode = FormMode.view;
      _nameController.text = widget.employee!.name;
      _nikController.text = widget.employee!.nik;
      _positionController.text = widget.employee!.position;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_mode == FormMode.add) {
        context.read<EmployeeBloc>().add(
          AddEmployee(
            name: _nameController.text,
            nik: _nikController.text,
            position: _positionController.text,
          ),
        );
      } else if (_mode == FormMode.edit) {
        context.read<EmployeeBloc>().add(
          UpdateEmployee(
            id: widget.employee!.id,
            name: _nameController.text,
            nik: _nikController.text,
            position: _positionController.text,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnly = _mode == FormMode.view;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _mode == FormMode.add ? 'Daftarkan Employee' : 'Detail Employee',
        ),
        actions: [
          if (_mode == FormMode.view)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _mode = FormMode.edit),
            ),
          if (_mode == FormMode.edit)
            IconButton(
              icon: const Icon(Icons.cancel_outlined),
              onPressed: () => setState(() => _mode = FormMode.view),
            ),
        ],
      ),
      body: BlocListener<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pop(context);
          }
          if (state is EmployeeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  readOnly: isReadOnly,
                  decoration: const InputDecoration(labelText: 'Nama'),

                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Nama tidak boleh kosong'
                      : null,
                ),
                TextFormField(
                  controller: _nikController,
                  readOnly: isReadOnly,
                  decoration: const InputDecoration(labelText: 'NIK'),

                  validator: (value) => (value == null || value.isEmpty)
                      ? 'NIK tidak boleh kosong'
                      : null,
                ),
                TextFormField(
                  controller: _positionController,
                  readOnly: isReadOnly,
                  decoration: const InputDecoration(labelText: 'Posisi'),

                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Posisi tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 24),
                if (_mode != FormMode.view)
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      _mode == FormMode.add ? 'Daftarkan' : 'Simpan Perubahan',
                    ),
                  ),
                if (_mode == FormMode.edit)
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Hapus Pegawai?'),
                          content: const Text(
                            'Anda yakin ingin menghapus data ini?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<EmployeeBloc>().add(
                                  DeleteEmployee(widget.employee!.id),
                                );
                                Navigator.pop(ctx);
                              },
                              child: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Hapus Employee'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
