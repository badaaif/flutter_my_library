import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/books.dart';
import '../screens/book_detail_screen.dart';

class BookItem extends StatelessWidget {
  final String id;
  final String title;
  final String author;
  final bool isFavorite;
  final bool isLent;

  BookItem(
    this.id,
    this.title,
    this.author,
    this.isFavorite,
    this.isLent,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to delete the book'),
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
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Books>(context, listen: false).deleteBook(id);
      },
      child: Card(
        elevation: 5,
        child: ListTile(
          leading: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                if (isFavorite)
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 15,
                  ),
                if (isLent)
                  Icon(
                    Icons.contacts,
                    color: Theme.of(context).accentColor,
                    size: 15,
                  ),
              ],
            ),
          ),
          title: Text(title),
          subtitle: Text(author),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.of(context).pushNamed(
              BookDetailScreen.route,
              arguments: id,
            );
          },
        ),
      ),
    );
  }
}
