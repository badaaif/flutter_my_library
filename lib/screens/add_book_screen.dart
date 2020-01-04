import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../providers/book.dart';
import '../providers/books.dart';
import '../widgets/image_input.dart';

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
    category: null,
    isWishList: false,
    image: null,
  );

  var _initialValues = {
    'id': '',
    'title': '',
    'author': '',
    'publisher': '',
    'isbn': '',
    'remarks': '',
    'category': null,
    'isWishList': false,
    'image': null,
  };

  var _isInit = true;
  var _isEdit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final bookId = ModalRoute.of(context).settings.arguments as String;
      if (bookId != null) {
        _book = Provider.of<Books>(context, listen: false).findById(bookId);
        _initialValues = {
          'id': _book.id,
          'title': _book.title,
          'author': _book.author,
          'publisher': _book.publisher,
          'isbn': _book.isbn,
          'remarks': _book.remarks,
          'category': _book.category,
          'isWishList': _book.isWishList,
          'image': _book.image,
        };

        _isEdit = true;
      }
    }
    _isInit = false;
  }

  void _selectImage(File pickedImage) {
    _book.image = pickedImage;
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_isEdit) {
      await Provider.of<Books>(context, listen: false)
          .updateBook(_book.id, _book);
    } else {
      await Provider.of<Books>(context, listen: false).insertBook(
        _book.title,
        _book.author,
        _book.publisher,
        _book.isbn,
        _book.remarks,
        _book.category,
        _book.isWishList,
        _book.image,
      );
    }

    Navigator.of(context)
        .pop(_isEdit ? 'Updated Successfully' : 'New book has been added');
  }

  @override
  Widget build(BuildContext context) {
    final appBarTitle = (_isEdit) ? 'Update Book' : 'Add New Book';
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Expanded(
              child: Card(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: _form,
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          initialValue: _initialValues['title'],
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
                              category: _book.category,
                              isWishList: _book.isWishList,
                              image: _book.image,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initialValues['author'],
                          decoration: InputDecoration(labelText: 'Author'),
                          onSaved: (value) {
                            _book = Book(
                              id: _book.id,
                              title: _book.title,
                              author: value,
                              publisher: _book.publisher,
                              isbn: _book.isbn,
                              remarks: _book.remarks,
                              category: _book.category,
                              isWishList: _book.isWishList,
                              image: _book.image,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initialValues['publisher'],
                          decoration: InputDecoration(labelText: 'Publisher'),
                          onSaved: (value) {
                            _book = Book(
                              id: _book.id,
                              title: _book.title,
                              author: _book.author,
                              publisher: value,
                              isbn: _book.isbn,
                              remarks: _book.remarks,
                              category: _book.category,
                              isWishList: _book.isWishList,
                              image: _book.image,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initialValues['isbn'],
                          decoration: InputDecoration(labelText: 'ISBN'),
                          onSaved: (value) {
                            _book = Book(
                              id: _book.id,
                              title: _book.title,
                              author: _book.author,
                              publisher: _book.publisher,
                              isbn: value,
                              remarks: _book.remarks,
                              category: _book.category,
                              isWishList: _book.isWishList,
                              image: _book.image,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initialValues['remarks'],
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
                              category: _book.category,
                              isWishList: _book.isWishList,
                              image: _book.image,
                            );
                          },
                        ),
                        // DropdownButton<String>(
                        //   isExpanded: true,
                        //   value: _book.category ,
                        //   hint: Text('Select Category'),
                        //   items: Book.bookCategories.map((value) {
                        //     return DropdownMenuItem(
                        //       value: value,
                        //       child: Text(value),
                        //     );
                        //   }).toList(),
                        //   onChanged: (value) {
                        //     setState(() {
                        //       _book = Book(
                        //         id: _book.id,
                        //         title: _book.title,
                        //         author: _book.author,
                        //         publisher: _book.publisher,
                        //         isbn: _book.isbn,
                        //         remarks: _book.remarks,
                        //         category: value,
                        //         isWishList: _book.isWishList,
                        //         image: _book.image,
                        //       );
                        //     });
                        //   },
                        // ),
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
                                category: _book.category,
                                isWishList: value,
                                image: _book.image,
                              );
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        ImageInput(
                            _selectImage, (_isEdit) ? _book.image : null),
                      ],
                    ),
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
                _isEdit ? 'Update' : 'Add',
                textAlign: TextAlign.center,
              ),
              color: Theme.of(context).accentColor,
              onPressed: _saveForm,
            ),
          ),
        ],
      ),
    );
  }
}
