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

  @override
  Widget build(BuildContext context) {
    final bookId = ModalRoute.of(context).settings.arguments;
    final bookData = Provider.of<Books>(context).findById(bookId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.delete,
        //       color: Colors.red,
        //     ),
        //     onPressed: () async {
        //       Provider.of<Books>(context, listen: false)
        //           .deleteBook(bookData.id);
        //       Navigator.of(context).pop();
        //     },
        //   )
        // ],
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       bookData.toggleFavorite();
      //     });
      //   },
      //   child: bookData.isFavorite
      //       ? Icon(Icons.favorite)
      //       : Icon(Icons.favorite_border),
      // ),
    );
  }
}
