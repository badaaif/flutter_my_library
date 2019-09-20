import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './book_item.dart';
import '../providers/shared_vars.dart';

class BooksGridView extends StatelessWidget {
  final books;

  BooksGridView(this.books);

  @override
  Widget build(BuildContext context) {
    final gridSize = Provider.of<SharedVars>(context).gridSize;
    return  GridView.builder(
                  itemCount: books.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
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
