import 'package:flutter/foundation.dart';

import '../helpers/db_helper.dart';

class Book with ChangeNotifier {
  final String id;
  final String title;
  final String author;
  final String publisher;
  final String isbn;
  final String remarks;
  bool isFavorite;
  bool isLent;
  String lendTo;
  bool isWishList;

  Book({
    @required this.id,
    @required this.title,
    this.author,
    this.publisher,
    this.isbn,
    this.remarks,
    this.isFavorite = false,
    this.isLent = false,
    this.lendTo = '',
    this.isWishList,
  });

 Future<void> toggleFavorite() async{
   isFavorite = !isFavorite;
   notifyListeners();
   DBHelper.updateFavorite(id, isFavorite);
 }

 void setLentStatus(bool isLent,String lendTo) {
   this.isLent = isLent;
   this.lendTo = lendTo;
   notifyListeners();
   DBHelper.updateLent(id, isLent, lendTo);
 }

 void toggleWishList() {
   isWishList = !isWishList;
   notifyListeners();
   DBHelper.updateWishList(id, isWishList);
 }
  
}
