import '../data/local_db_service.dart';
import '../models/employee.dart';

class EmployeeRepository {
  EmployeeRepository(this._dbService);

  final LocalDbService _dbService;

  Future<List<Employee>> getEmployees({
    String search = '',
    DateTime? startDob,
    DateTime? endDob,
    int page = 0,
    int pageSize = 10,
  }) {
    return _dbService.fetchEmployees(
      search: search,
      startDob: startDob,
      endDob: endDob,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<int> insertEmployee(Employee employee) {
    return _dbService.insertEmployee(employee);
  }

  Future<int> updateEmployee(Employee employee) {
    return _dbService.updateEmployee(employee);
  }

  Future<int> deleteEmployee(int id) {
    return _dbService.deleteEmployee(id);
  }
}

