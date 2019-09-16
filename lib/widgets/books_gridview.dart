import 'package:flutter/material.dart';

import './book_item.dart';
class BooksGridView extends StatelessWidget {
  final books;

  BooksGridView(this.books);
  @override
  Widget build(BuildContext context) {
   return GridView.builder(
      itemCount: books.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.1 / 3,
      ),
      itemBuilder: (ctx, i) => BookItem(
        books[i].id,
        books[i].title,
        books[i].author,
        books[i].isFavorite,
        books[i].isLent,
        books[i].image,
      ),
    );
  }
}