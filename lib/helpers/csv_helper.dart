import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart' as syspath;

import '../providers/book.dart';
import '../helpers/db_helper.dart';
import '../providers/books.dart';

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
            image: item['image'].toString().isEmpty
                ? null
                : File(item['image']), //Books.stringToImage(item['image']), //
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
      if (items[i].image != null) {
        //row.add(Books.imageToString(items[i].image));
        row.add(items[i].image.path);
        row.add(Books.imageToString(items[i].image));
      } else {
        row.add('');
        row.add('');
      }
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
    await file.writeAsString(csv);
    Uint8List uIntBytes = file.readAsBytesSync();
    final ByteData bytes = ByteData.view(
        uIntBytes.buffer); //await rootBundle.load('assets/image1.png');
    await Share.file(
        'Books', 'Books.csv', bytes.buffer.asUint8List(), 'text/csv',
        text: 'This is a copy of my book library');
  }

  static Future<void> openFile() async {
    //Open File
    String filePath = await FilePicker.getFilePath();
    final input = new File(filePath).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();

    //Loop through CSV
    for (var i = 0; i < fields.length; i++) {
      var row = fields[i];
        File image;
        if (row[10].toString().isNotEmpty) {
          final appDir = await syspath.getApplicationDocumentsDirectory();
          final fileName = path.basename(row[10]);
          image = new File('${appDir.path}/$fileName');
          Uint8List bytes = base64Decode(row[11]);
          await image.writeAsBytes(bytes);
        }
        DBHelper.insert('user_books', {
          'id': row[0],
          'title': row[1],
          'author': row[2],
          'publisher': row[3],
          'isbn': row[4],
          'remarks': row[5],
          'favorite': row[6],
          'lent': row[7],
          'lend_to': row[8],
          'wish_list': row[9],
          'image': row[10],
        });
      //}
    }
  }
}
