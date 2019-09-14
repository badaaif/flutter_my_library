import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './book_detail_screen.dart';
import '../providers/books.dart';
import '../widgets/book_item.dart';

class FavoritesBooksScreen extends StatelessWidget {
  static const route = 'favorites-books';
  @override
  Widget build(BuildContext context) {
    final books = Provider.of<Books>(context).favoriteBooks;
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (ctx, i) => 
       BookItem(
            books[i].id,
            books[i].title,
            books[i].author,
            books[i].isFavorite,
            books[i].isLent,
          ),
    );
  }
}