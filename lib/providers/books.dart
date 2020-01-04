import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../providers/book.dart';
import '../helpers/db_helper.dart';

class Books with ChangeNotifier {
  List<Book> _items = [];

  List<Book> get items {
    return [..._items];
  }

  static File stringToImage(String base64) {
    Uint8List decoded = base64Decode(base64);
    return File.fromRawPath(decoded);
  }

  static String imageToString(File image) {
    List<int> imageBytes = image.readAsBytesSync();
    print(imageBytes);
    String base64Image = base64Encode(imageBytes);
    return base64Image;
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
    String category,
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
      category: category,
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
      'category': newBook.category,
      'wish_list': newBook.isWishList,
      'image': newBook.image == null ? '' : newBook.image.path, //imageToString(newBook.image),
    });
  }

  Future<void> updateBook(String bookId, Book book) async {
    final bookIndex = _items.indexWhere((b) => b.id == bookId);
    var updatedBook = Book(
      id: book.id,
      title: book.title,
      author: book.author,
      publisher: book.publisher,
      isbn: book.isbn,
      remarks: book.remarks,
      category: book.category,
      isWishList: book.isWishList,
      image: book.image,
      isFavorite: _items[bookIndex].isFavorite,
      isLent: _items[bookIndex].isLent,
      lendTo: _items[bookIndex].lendTo,
    );
    _items[bookIndex] = updatedBook;
    notifyListeners();
    DBHelper.updateBook(
      bookId,
      {
        'id': updatedBook.id,
        'title': updatedBook.title,
        'author': updatedBook.author,
        'publisher': updatedBook.publisher,
        'isbn': updatedBook.isbn,
        'remarks': updatedBook.remarks,
        'category': updatedBook.category,
        'wish_list': updatedBook.isWishList,
        'image': updatedBook.image == null
            ? ''
            : updatedBook.image.path, //imageToString(updatedBook.image),
        'favorite': updatedBook.isFavorite,
        'lent': updatedBook.isLent,
        'lend_to': updatedBook.lendTo,
      },
    );
  }

  Future<void> fetchBooks() async {
    final booksList = await DBHelper.getData(DBHelper.userBookTable);
    _items = booksList
        .map(
          (item) => Book(
            id: item['id'],
            title: item['title'],
            author: item['author'],
            publisher: item['publisher'],
            isbn: item['isbn'],
            remarks: item['remarks'],
            category: item['category'],
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
                : File(item['image']), //stringToImage(item['image']),
          ),
        )
        .toList();
    notifyListeners();
  }
}
