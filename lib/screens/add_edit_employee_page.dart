import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/employee_controller.dart';
import '../models/employee.dart';
import '../services/image_service.dart';
import '../theme/app_theme.dart';
import '../widgets/date_range_sheet.dart';

class AddEditEmployeePage extends StatefulWidget {
  const AddEditEmployeePage({super.key, this.employee});
  final Employee? employee;

  @override
  State<AddEditEmployeePage> createState() => _AddEditEmployeePageState();
}

class _AddEditEmployeePageState extends State<AddEditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _designationController = TextEditingController();
  DateTime? _selectedDob;
  String? _imagePath;
  final _dateFormatter = DateFormat('dd MMM yyyy');
  final _imageService = ImageService();

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;
    if (employee != null) {
      _nameController.text = employee.name;
      _designationController.text = employee.designation;
      _selectedDob = employee.dob;
      _imagePath = employee.imagePath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _designationController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDobRangeSheet(
      context,
      initialDate: _selectedDob ?? DateTime(now.year - 25),
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final path = await _imageService.pickAndSaveImage();
    if (path != null) {
      setState(() => _imagePath = path);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDob == null) {
      if (_selectedDob == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select Date of Birth'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final controller = Get.find<EmployeeController>();
    final employee = Employee(
      id: widget.employee?.id,
      name: _nameController.text.trim(),
      designation: _designationController.text.trim(),
      dob: _selectedDob!,
      imagePath: _imagePath,
    );

    if (widget.employee == null) {
      await controller.addEmployee(employee);
    } else {
      await controller.updateEmployee(employee);
    }

    if (mounted) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.employee != null;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1D3D),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _DecorativeRing(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 42,
                            backgroundColor: const Color(0xFF2A2D52),
                            backgroundImage:
                                _imagePath != null ? FileImage(File(_imagePath!)) : null,
                            child: _imagePath == null
                                ? const Icon(Icons.person, color: Color(0xFFFF9580), size: 40)
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _InputTile(
                        iconPath: 'assets/icons/usernsame.png',
                        hint: 'User Name',
                        controller: _nameController,
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Name required' : null,
                        iconColor: const Color(0xFFFF9580),
                      ),
                      const SizedBox(height: 14),
                      _InputTile(
                        iconPath: 'assets/icons/designation.png',
                        hint: 'Designation',
                        controller: _designationController,
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Designation required'
                            : null,
                        iconColor: const Color(0xFF5B9FFF),
                      ),
                      const SizedBox(height: 14),
                      _DateTile(
                        iconPath: 'assets/icons/dob.png',
                        label: _selectedDob == null
                            ? 'DOB'
                            : _dateFormatter.format(_selectedDob!),
                        onTap: _pickDob,
                        isSelected: _selectedDob != null,
                        iconColor: const Color(0xFFFF6B9D),
                      ),
                      const SizedBox(height: 32),
                      GradientButton(
                        text: isEditing ? 'Update' : 'Submit',
                        onTap: _submit,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D4FF), Color(0xFF0066FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        height: 52,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecorativeRing extends StatelessWidget {
  const _DecorativeRing({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        Container(
          width: 170,
          height: 170,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                Color(0xFF7C3AED),
                Color(0xFF3B82F6),
                Color(0xFF10B981),
                Color(0xFF7C3AED),
              ],
              startAngle: 0.0,
              endAngle: 6.28,
            ),
          ),
        ),
        Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF1A1D3D),
          ),
        ),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF252850),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}

class _InputTile extends StatelessWidget {
  const _InputTile({
    this.icon,
    this.iconPath,
    required this.hint,
    required this.controller,
    required this.validator,
    this.iconColor,
  });

  final IconData? icon;
  final String? iconPath;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF252850),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor?.withOpacity(0.15) ?? Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: iconPath != null
                  ? Image.asset(
                      iconPath!,
                      width: 20,
                      height: 20,
                      color: iconColor ?? Colors.white,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          color: iconColor ?? Colors.white,
                          size: 20,
                        );
                      },
                    )
                  : Icon(
                      icon ?? Icons.person,
                      color: iconColor ?? Colors.white,
                      size: 20,
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextFormField(
              controller: controller,
              validator: validator,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    this.icon,
    this.iconPath,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.iconColor,
  });

  final IconData? icon;
  final String? iconPath;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF252850),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor?.withOpacity(0.15) ?? Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: iconPath != null
                    ? Image.asset(
                        iconPath!,
                        width: 20,
                        height: 20,
                        color: iconColor ?? Colors.white,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.calendar_today,
                            color: iconColor ?? Colors.white,
                            size: 18,
                          );
                        },
                      )
                    : Icon(
                        icon ?? Icons.calendar_today,
                        color: iconColor ?? Colors.white,
                        size: 18,
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.gradient,
    this.height = 56,
  });

  final String text;
  final VoidCallback onTap;
  final Gradient gradient;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0066FF).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
