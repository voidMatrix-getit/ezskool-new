import 'package:ezskool/core/bloc/auth_bloc.dart';
import 'package:ezskool/core/constants/api.dart';
import 'package:ezskool/core/services/http_service.dart';
import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/core/utils/API_data_utils.dart';

import '../datasources/local/dao/dropdown/dropdown_options_dao.dart';
import '../datasources/local/db/app_database.dart';

class HomeRepo extends HttpService {
  static final AppDatabase _db = AppDatabase.instance;
  static final dropdownDao = DropdownDao(_db);

  static final List<String> keys = [
    'id',
    'full_name',
    'pg_ids',
    'current_class_id',
    'current_roll_no',
    'status',
    'ppsp'
  ];

  Future<void> loginSyncLrDiv() async {
    final tkn = await getBearerToken();

    final data = await post(
      API.buildUrl(API.getLoginSync),
      data: {
        'sync_req': 'lr,div'
      }, //lr for leave reason, no use of div right now
      headers: {
        'Authorization': 'Bearer $tkn',
      },
    );

    Log.d(data['data']);

    // final extractedData = data['data'].entries.expand((entry) {
    //   final key = entry.key; // "lr" or "div"
    //   final values = entry.value.split(',').map((e) => e.trim()); // Split and trim
    //   return values.map((value) => {'key': key, 'value': value});
    // }).toList();
    final extractedData = (data['data'] as Map<String, dynamic>)
        .entries
        .expand((entry) {
          // final key = entry.key; // "lr" or "div"
          // final values = (entry.value as String).split(',').map((e) => e.trim()); // Split and trim
          // return values.map((value) => {'key': key, 'value': value});
          final key = entry.key; // "lr" or "div"
          final value = entry.value;

          if (value is String) {
            final values = value.split(',').map((e) => e.trim());
            return values.map((v) => {'key': key, 'value': v});
          } else {
            Log.d('Unexpected value for key: $key, Value: $value');
            return []; // Skip non-string values
          }
        })
        .toList()
        .cast<Map<String, String>>();
    data['data'].entries.forEach((entry) {
      Log.d(
          'Key: ${entry.key}, Value: ${entry.value}, Type: ${entry.value.runtimeType}');
    });

    Log.d(extractedData);

    // Insert into the database
    await dropdownDao.insertDropdownOptions(extractedData);

    final div = await dropdownDao.getDropdownValues('div');

    final lr = await dropdownDao.getDropdownValues('lr');
    //

    Log.d(div);

    Log.d(lr);
  }

  Future<List<Map<String, String>>> fetchStudentData() async {
    var tkn = await getBearerToken();

    print('Bearer token: $tkn');

    final data = await get(
      API.buildUrl(API.getDataStudent),
      headers: {
        'Authorization': 'Bearer $tkn',
      },
    );
    print(data);

    if (data['success'] == true) {
      List<dynamic> rawData = data['data']; // Original dynamic list
      print(data);
      // Pass rawData directly to parseDelimitedData
      return parseDelimitedData(
        data: rawData.cast<Map<String, dynamic>>(), // Ensure correct type
        keys: keys, // Provide keys for mapping
        fieldName: 'x', // Field to parse
      );
    } else {
      throw Exception('Failed to fetch student data');
    }

    // if (data['success']) {
    //   if (data['success'] == true) {
    //     List<Map<String,dynamic>> students = data['data'];
    //     return parseDelimitedData(data: students, keys: keys,fieldName: 'x');
    //   } else {
    //     throw Exception('Failed to fetch student data');
    //   }
    // } else {
    //   throw Exception('Failed to connect to server');
    // }
  }
}
