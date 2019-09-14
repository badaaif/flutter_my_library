import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/books.dart';
import '../providers/book.dart';

class WishListBooksScreen extends StatefulWidget {
  @override
  _WishListBooksScreenState createState() => _WishListBooksScreenState();
}

class _WishListBooksScreenState extends State<WishListBooksScreen> {
  _showAlert(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm'),
        content: Text('I have bought the book'),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              setState(() {
                book.toggleWishList();
              });
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = Provider.of<Books>(context).wishListBooks;
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (ctx, i) => Card(
        child: ListTile(
          title: Text(books[i].title),
          subtitle: Text(books[i].author),
          trailing: GestureDetector(
            onTap: () {
              _showAlert(context, books[i]);
            },
            child: Icon(
              Icons.done,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
