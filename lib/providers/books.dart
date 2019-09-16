import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../providers/book.dart';
import '../helpers/db_helper.dart';

class Books with ChangeNotifier {
  List<Book> _items = [];

  List<Book> get items {
    return [..._items];
  }

  List<Book> get myBooks {
    return _items.where((item) => !item.isWishList).toList();
  }

  List<Book> get favoriteBooks {
    return _items.where((item) => item.isFavorite).toList();
  }

  List<Book> get lentBooks {
    return _items.where((item) => item.isLent).toList();
  }

  List<Book> get wishListBooks {
    return _items.where((item) => item.isWishList).toList();
  }

  Book findById(String id) {
    return _items.firstWhere((book) => book.id == id);
  }

  Future<void> deleteBook(String id) async {
    _items.removeWhere((item) => item.id == id);
    await DBHelper.deleteBook(id);
    notifyListeners();
  }

  Future<void> insertBook(
    String title,
    String author,
    String publisher,
    String isbn,
    String remarks,
    bool isWishList,
    File image,
  ) async {
    final newBook = Book(
      id: Uuid().v1(),
      title: title,
      author: author,
      publisher: publisher,
      isbn: isbn,
      remarks: remarks,
      isWishList: isWishList,
      image: image,
    );
    _items.add(newBook);
    notifyListeners();
    DBHelper.insert('user_books', {
      'id': newBook.id,
      'title': newBook.title,
      'author': newBook.author,
      'publisher': newBook.publisher,
      'isbn': newBook.isbn,
      'remarks': newBook.remarks,
      'wish_list': newBook.isWishList,
      'image': newBook.image == null ? '' : newBook.image.path,
    });
  }

  Future<void> fetchBooks() async {
    final booksList = await DBHelper.getData('user_books');
    _items = booksList
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
            image: item['image'].toString().isEmpty ? null : File(item['image']),
          ),
        )
        .toList();
    notifyListeners();
  }
}
