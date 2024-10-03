import 'dart:collection';

typedef Collection = List<Map<String, dynamic>>;

class EmployeeDB {
  HashMap<String, Collection> collections = HashMap();
  void createCollection(String p_collection_name) {
    collections[p_collection_name] = [];
    print('Collection "$p_collection_name" created.');
  }
void indexData(String p_collection_name, String p_exclude_column) {
    if (!collections.containsKey(p_collection_name)) {
      print('Collection "$p_collection_name" does not exist.');
      return;
    }

    Collection? collection = collections[p_collection_name];
    if (collection != null) {
      collection.forEach((record) {
        record.remove(p_exclude_column);
      });
      print(
          'Indexed collection "$p_collection_name" excluding column "$p_exclude_column".');
    }
  }
 List<Map<String, dynamic>> searchByColumn(
      String p_collection_name, String p_column_name, String p_column_value) {
    if (!collections.containsKey(p_collection_name)) {
      print('Collection "$p_collection_name" does not exist.');
      return [];
    }

    Collection? collection = collections[p_collection_name];
    if (collection == null) return [];

    List<Map<String, dynamic>> result = collection.where((record) {
      return record[p_column_name] == p_column_value;
    }).toList();

    return result;
  }
  int getEmpCount(String p_collection_name) {
    if (!collections.containsKey(p_collection_name)) {
      print('Collection "$p_collection_name" does not exist.');
      return 0;
    }

    return collections[p_collection_name]?.length ?? 0;
  }
  void delEmpById(String p_collection_name, String p_employee_id) {
    if (!collections.containsKey(p_collection_name)) {
      print('Collection "$p_collection_name" does not exist.');
      return;
    }

    Collection? collection = collections[p_collection_name];
    if (collection != null) {
      collection.removeWhere((record) => record['id'] == p_employee_id);
      print(
          'Employee with ID "$p_employee_id" deleted from "$p_collection_name".');
    } else {
      print('No records found in collection "$p_collection_name".');
    }
  }
  Map<String, int> getDepFacet(String p_collection_name) {
    if (!collections.containsKey(p_collection_name)) {
      print('Collection "$p_collection_name" does not exist.');
      return {};
    }

    Collection? collection = collections[p_collection_name];
    if (collection == null) return {};

    Map<String, int> departmentCount = {};
    collection.forEach((record) {
      String? department = record['Department'];
      if (department != null && department.isNotEmpty) {
        departmentCount[department] = (departmentCount[department] ?? 0) + 1;
      }
    });

    return departmentCount;
  }
  void addEmployee(String p_collection_name, Map<String, dynamic> employee) {
    collections[p_collection_name]?.add(employee);
    print(
        'Added employee: ${employee['Full_Name']} to collection: $p_collection_name');
  }
}

void main() {
  final EmployeeDB employeeDB = EmployeeDB();
  String v_nameCollection =
      'NAGESWARI'; 
  String v_phoneCollection =
      '9704';
  employeeDB.createCollection(v_nameCollection);
  employeeDB.createCollection(v_phoneCollection);
  employeeDB.addEmployee(v_nameCollection, {
    'id': 'E001',
    'Full_Name': 'Nages',
    'Department': 'IT',
    'Job_Title': 'Software Engineer',
    'Age': 22,
    'Gender': 'Female'
  });

  employeeDB.addEmployee(v_nameCollection, {
    'id': 'E002',
    'Full_Name': 'Siva',
    'Department': 'HR',
    'Job_Title': 'HR Manager',
    'Age': 25,
    'Gender': 'Male',
  });

  employeeDB.addEmployee(v_phoneCollection, {
    'id': 'E003',
    'Full_Name': 'Vjs',
    'Department': 'IT',
    'Job_Title': 'Network Engineer',
    'Age': 23,
    'Gender': 'Male',
  });
  print(
      'Employee Count in Name Collection: ${employeeDB.getEmpCount(v_nameCollection)}');
  employeeDB.indexData(v_nameCollection, 'Department');
  employeeDB.indexData(v_phoneCollection, 'Gender');
  employeeDB.delEmpById(v_nameCollection,
      'E003'); 
  print(
      'Employee Count in Name Collection after deletion: ${employeeDB.getEmpCount(v_nameCollection)}');

 
  var nameCollectionSearchIT =
      employeeDB.searchByColumn(v_nameCollection, 'Department', 'IT');
  var nameCollectionSearchMale =
      employeeDB.searchByColumn(v_nameCollection, 'Gender', 'Male');

  print(
      'Search by Department (IT) in Name Collection: $nameCollectionSearchIT');
  print(
      'Search by Gender (Male) in Name Collection: $nameCollectionSearchMale');
  var phoneCollectionSearchIT =
      employeeDB.searchByColumn(v_phoneCollection, 'Department', 'IT');
  print(
      'Search by Department (IT) in Phone Collection: $phoneCollectionSearchIT');
  Map<String, int> nameDepFacet = employeeDB.getDepFacet(v_nameCollection);
  Map<String, int> phoneDepFacet = employeeDB.getDepFacet(v_phoneCollection);
  print('Department Facet in Name Collection: $nameDepFacet');
  print('Department Facet in Phone Collection: $phoneDepFacet');
}
