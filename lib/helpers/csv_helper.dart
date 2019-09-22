import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:simple_permissions/simple_permissions.dart';

import '../providers/book.dart';
import '../helpers/db_helper.dart';

class CSVHelper {
  static Future<int> exportBooks() async {
    final booksList = await DBHelper.getData(DBHelper.userBookTable);
    var rows = List<List<dynamic>>();
    var items = booksList
        .map(
          (item) => Book(
            id: item['id'],
            title: item['title'],
            author: item['author'],
            publisher: item['publisher'],
            isbn: item['isbn'],
            remarks: item['remarks'],
            isFavorite: item['favorite'] == null
                ? false
                : (item['favorite'] == 1 ? true : false),
            isLent: item['lent'] == null
                ? false
                : (item['lent'] == 1 ? true : false),
            lendTo: item['lend_to'],
            isWishList: item['wish_list'] == null
                ? false
                : (item['wish_list'] == 1 ? true : false),
            image:
                item['image'].toString().isEmpty ? null : File(item['image']),
          ),
        )
        .toList();

    for (var i = 0; i < items.length; i++) {
      var row = List<dynamic>();
      row.add(items[i].id);
      row.add(items[i].title);
      row.add(items[i].author);
      row.add(items[i].publisher);
      row.add(items[i].isbn);
      row.add(items[i].remarks);
      row.add(items[i].isFavorite);
      row.add(items[i].isLent);
      row.add(items[i].lendTo);
      row.add(items[i].isWishList);
      rows.add(row);
    }

    _saveCSV(rows);
    return 1;
  }

  static Future<void> _saveCSV(List<List<dynamic>> rows) async {
    bool checkResult = await SimplePermissions.checkPermission(
        Permission.WriteExternalStorage);
    if (!checkResult) {
      var status = await SimplePermissions.requestPermission(
          Permission.WriteExternalStorage);
      if (status == PermissionStatus.authorized) {
        await _writeCSV(rows);
      }
    } else {
      await _writeCSV(rows);
    }
  }

  static Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/books.csv');
  }

  static Future<void> _writeCSV(List<List<dynamic>> rows) async {
    final file = await _localFile;
    // Write the file.
    final csv = const ListToCsvConverter().convert(rows);
    file.writeAsString(csv);
  }
}
