import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/books.dart';
import '../screens/book_detail_screen.dart';

class BookItemGrid extends StatelessWidget {
  final String id;
  final String title;
  final String author;
  final bool isFavorite;
  final bool isLent;
  final File image;

  BookItemGrid(this.id, this.title, this.author, this.isFavorite, this.isLent,
      this.image);

  static const _imagePlaceholder = 'assets/images/book-cover-placeholder.png';

  Widget get _getImage {
    final height = double.infinity;
    final boxFit = BoxFit.cover;
    return image == null
        ? Image.asset(
            _imagePlaceholder,
            height: height,
            width: double.infinity,
            fit: boxFit,
          )
        : Image.file(
            image,
            height: height,
            width: double.infinity,
            fit: boxFit,
          );
  }

  Future<void> _showDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to delete the book?'),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Provider.of<Books>(context, listen: false).deleteBook(id);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Book has been deleted.'),
                duration: Duration(
                  seconds: 3,
                ),
              ));
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          BookDetailScreen.route,
          arguments: id,
        );
      },
      onLongPress: () => _showDeleteDialog(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                      tag: id,
                      child: _getImage,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Container(
                        color: Colors.black54,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    right: 5,
                    top: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        if (isFavorite)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: constraints.maxWidth * 0.1,
                              );
                            },
                          ),
                        if (isLent)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Icon(
                                Icons.contacts,
                                color: Theme.of(context).accentColor,
                                size: constraints.maxWidth * 0.1,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
