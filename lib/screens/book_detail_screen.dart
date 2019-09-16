import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/books.dart';
import '../widgets/name_value_row.dart';
import '../providers/book.dart';

class BookDetailScreen extends StatefulWidget {
  static const route = '/book-detail';

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final _borrowerController = TextEditingController();

  void _setLentStatus(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        title: Text('Lend Book'),
        content: TextField(
          decoration: InputDecoration(labelText: 'Name of Borrower'),
          controller: _borrowerController,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text('Confirm'),
            onPressed: () {
              if (_borrowerController.text.isEmpty) {
                return;
              }
              book.setLentStatus(true, _borrowerController.text);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _getImage(File image) {
    final height = 200.0;
    final boxFit = BoxFit.cover;
    return image == null
        ? Image.asset(
            'assets/images/book-cover-placeholder.png',
            height: height,
            //width: double.infinity,
            fit: boxFit,
          )
        : Image.file(
            image,
            height: height,
            //width: double.infinity,
            fit: boxFit,
          );
  }

  @override
  Widget build(BuildContext context) {
    final bookId = ModalRoute.of(context).settings.arguments;
    final bookData = Provider.of<Books>(context).findById(bookId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: bookData.id,
                  child: _getImage(bookData.image),
                ),
                Divider(),
                NameValueRow('Title:', bookData.title),
                Divider(),
                NameValueRow('Author:', bookData.author),
                Divider(),
                NameValueRow('Publisher:', bookData.publisher),
                Divider(),
                NameValueRow('ISBN:', bookData.isbn),
                Divider(),
                NameValueRow('Remarks:', bookData.remarks),
                Divider(),
                if (bookData.isLent) NameValueRow('Lend To:', bookData.lendTo),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!bookData.isWishList)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    bookData.toggleWishList();
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.shopping_basket),
                ),
              ),
            if (!bookData.isLent)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    _setLentStatus(context, bookData);
                  },
                  child: Icon(Icons.contacts),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  setState(() {
                    bookData.toggleFavorite();
                  });
                },
                child: bookData.isFavorite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
