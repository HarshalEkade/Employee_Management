import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/employee.dart';
import '../repositories/employee_repository.dart';

class EmployeeController extends GetxController {
  EmployeeController(this._repository);

  final EmployeeRepository _repository;
  final RxList<Employee> employees = <Employee>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxString searchQuery = ''.obs;
  final Rxn<DateTimeRange> dobRange = Rxn<DateTimeRange>();

  int _page = 0;
  final int _pageSize = 10;

  @override
  void onInit() {
    debounce<String>(
      searchQuery,
      (_) => loadEmployees(reset: true),
      time: const Duration(milliseconds: 350),
    );
    super.onInit();
  }

  Future<void> init() async {
    await loadEmployees(reset: true);
  }

  Future<void> loadEmployees({bool reset = false}) async {
    if (isLoading.value) return;
    if (!reset && !hasMore.value) return;

    if (reset) {
      _page = 0;
      hasMore.value = true;
      employees.clear();
    }

    isLoading.value = true;
    final fetched = await _repository.getEmployees(
      search: searchQuery.value,
      startDob: dobRange.value?.start,
      endDob: dobRange.value?.end,
      page: _page,
      pageSize: _pageSize,
    );

    employees.addAll(fetched);
    if (fetched.length < _pageSize) {
      hasMore.value = false;
    } else {
      _page += 1;
    }
    isLoading.value = false;
  }

  Future<void> addEmployee(Employee employee) async {
    await _repository.insertEmployee(employee);
    await loadEmployees(reset: true);
  }

  Future<void> updateEmployee(Employee employee) async {
    if (employee.id == null) return;
    await _repository.updateEmployee(employee);
    await loadEmployees(reset: true);
  }

  Future<void> deleteEmployee(int id) async {
    await _repository.deleteEmployee(id);
    employees.removeWhere((element) => element.id == id);
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  Future<void> applyDobRange(DateTimeRange? range) async {
    dobRange.value = range;
    await loadEmployees(reset: true);
  }

  Future<void> clearFilters() async {
    dobRange.value = null;
    searchQuery.value = '';
    await loadEmployees(reset: true);
  }
}

