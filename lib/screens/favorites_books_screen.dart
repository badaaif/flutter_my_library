import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/books.dart';
import '../widgets/books_view.dart';

class FavoritesBooksScreen extends StatelessWidget {
  static const route = 'favorites-books';
  @override
  Widget build(BuildContext context) {
    final books = Provider.of<Books>(context).favoriteBooks;
    return BooksView(books);
  }
}