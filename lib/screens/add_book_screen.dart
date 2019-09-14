import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../providers/book.dart';
import '../providers/books.dart';

class AddBookScreen extends StatefulWidget {
  static const route = '/add-place';
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _form = GlobalKey<FormState>();
  var _book = Book(
    id: '',
    title: '',
    author: '',
    publisher: '',
    isbn: '',
    remarks: '',
    isWishList: false,
  );

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    await Provider.of<Books>(context, listen: false).insertBook(
        _book.title,
        _book.author,
        _book.publisher,
        _book.isbn,
        _book.remarks,
        _book.isWishList);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add New Book'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: _form,
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Title'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter title';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _book = Book(
                              id: _book.id,
                              title: value,
                              author: _book.author,
                              publisher: _book.publisher,
                              isbn: _book.isbn,
                              remarks: _book.remarks,
                              isWishList: _book.isWishList,
                            );
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Author'),
                          onSaved: (value) {
                            _book = Book(
                              id: _book.id,
                              title: _book.title,
                              author: value,
                              publisher: _book.publisher,
                              isbn: _book.isbn,
                              remarks: _book.remarks,
                              isWishList: _book.isWishList,
                            );
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Publisher'),
                          onSaved: (value) {
                            _book = Book(
                              id: _book.id,
                              title: _book.title,
                              author: _book.author,
                              publisher: value,
                              isbn: _book.isbn,
                              remarks: _book.remarks,
                              isWishList: _book.isWishList,
                            );
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'ISBN'),
                          onSaved: (value) {
                            _book = Book(
                              id: _book.id,
                              title: _book.title,
                              author: _book.author,
                              publisher: _book.publisher,
                              isbn: value,
                              remarks: _book.remarks,
                              isWishList: _book.isWishList,
                            );
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Remarks'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) {
                            _book = Book(
                              id: _book.id,
                              title: _book.title,
                              author: _book.author,
                              publisher: _book.publisher,
                              isbn: _book.isbn,
                              remarks: value,
                              isWishList: _book.isWishList,
                            );
                          },
                        ),
                        CheckboxListTile(
                          title: Text("Wish List"),
                          value: _book.isWishList,
                          onChanged: (value) {
                            setState(() {
                              _book = Book(
                                id: _book.id,
                                title: _book.title,
                                author: _book.author,
                                publisher: _book.publisher,
                                isbn: _book.isbn,
                                remarks: _book.remarks,
                                isWishList: value,
                              );
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: FlatButton.icon(
                icon: Icon(
                  Icons.add,
                ),
                label: Text(
                  'Add',
                  textAlign: TextAlign.center,
                ),
                color: Theme.of(context).accentColor,
                onPressed: _saveForm,
              ),
            ),
          ],
        ));
  }
}
