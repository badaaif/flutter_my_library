import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './book_item_grid.dart';
import './book_item_list.dart';
import '../providers/shared_vars.dart';

class BooksView extends StatelessWidget {
  final books;

  BooksView(this.books);

  @override
  Widget build(BuildContext context) {
    final gridType = Provider.of<SharedVars>(context).gridType;
    return gridType == 1
        ? GridView.builder(
            itemCount: books.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.1 / 3,
            ),
            itemBuilder: (ctx, i) => BookItemGrid(
              books[i].id,
              books[i].title,
              books[i].author,
              books[i].isFavorite,
              books[i].isLent,
              books[i].image,
            ),
          )
        : ListView.builder(
            itemCount: books.length,
            itemBuilder: (ctx, i) => BookItemList(
              books[i].id,
              books[i].title,
              books[i].author,
              books[i].isFavorite,
              books[i].isLent,
            ),
          );
  }
}
