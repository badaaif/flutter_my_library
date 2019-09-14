import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/books.dart';
import '../providers/book.dart';
import './book_detail_screen.dart';
import '../widgets/book_item.dart';

class BooksListScreen extends StatefulWidget {
  static const route = '/books-list';

  @override
  _BooksListScreenState createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  final _searchController = TextEditingController();
  String filter;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        filter = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  ListView _getListView(Books data) {
    var books = data.myBooks;
    if (filter != null && filter.isEmpty == false) {
      books = books.where((item) {
        if (item.title.toLowerCase().contains(filter.toLowerCase()) ||
            item.author.toLowerCase().contains(filter.toLowerCase()) ||
            item.publisher.toLowerCase().contains(filter.toLowerCase())) {
          return true;
        }
        return false;
      }).toList();
    }
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (ctx, i) => Column(
        children: <Widget>[
          BookItem(
            books[i].id,
            books[i].title,
            books[i].author,
            books[i].isFavorite,
            books[i].isLent,
          ),
          
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final booksData = Provider.of<Books>(context).items;
    return Column(
      children: <Widget>[
       TextField(
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
            controller: _searchController,
          ),
        
        Divider(
          height: 5,
        ),
        Expanded(
          child: Consumer<Books>(builder: (ctx, booksData, _) {
            return _getListView(booksData);
          }),
        ),
      ],
    );
  }
}
