import 'package:flutter/material.dart';
import 'package:my_library/widgets/filter_popup_menu.dart';
import 'package:provider/provider.dart';

import '../providers/books.dart';
import '../widgets/books_view.dart';
import '../widgets/filter_popup_menu.dart';
import '../models/filter_options.dart';

class BooksListScreen extends StatefulWidget {
  static const route = '/books-list';

  @override
  _BooksListScreenState createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  final _searchController = TextEditingController();
  String _textFilter;
  FilterOptions _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = FilterOptions.All;
    _searchController.addListener(() {
      setState(() {
        _textFilter = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  

  void _setFilter(FilterOptions filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  Widget _getGridView(Books data) {
    var books = data.myBooks;
    if (_textFilter != null && _textFilter.isEmpty == false) {
      if (_selectedFilter == FilterOptions.Title) {
        books = books.where((item) {
          if (item.title.toLowerCase().contains(_textFilter.toLowerCase())) {
            return true;
          }
          return false;
        }).toList();
      } else if (_selectedFilter == FilterOptions.Author) {
        books = books.where((item) {
          if (item.author.toLowerCase().contains(_textFilter.toLowerCase())) {
            return true;
          }
          return false;
        }).toList();
      } else if (_selectedFilter == FilterOptions.Publisher) {
        books = books.where((item) {
          if (item.publisher
              .toLowerCase()
              .contains(_textFilter.toLowerCase())) {
            return true;
          }
          return false;
        }).toList();
      } else if (_selectedFilter == FilterOptions.LentTo) {
        books = books.where((item) {
          if (item.lendTo != null && item.lendTo.toLowerCase().contains(_textFilter.toLowerCase()) &&
              item.isLent) {
            return true;
          }
          return false;
        }).toList();
      } else {
        books = books.where((item) {
          if (item.title.toLowerCase().contains(_textFilter.toLowerCase()) ||
              item.author.toLowerCase().contains(_textFilter.toLowerCase()) ||
              item.publisher
                  .toLowerCase()
                  .contains(_textFilter.toLowerCase())) {
            return true;
          }
          return false;
        }).toList();
      }
    }
    //if(books == null) books = [];
    return BooksView(books);
  }

  @override
  Widget build(BuildContext context) {
    //final booksData = Provider.of<Books>(context).items;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                controller: _searchController,
              ),
            ),
            FilterPopUpMenu(_setFilter)
          ],
        ),
        Divider(
          height: 5,
        ),
        Expanded(
          child: Consumer<Books>(builder: (ctx, booksData, _) {
            return _getGridView(booksData);
          }),
        ),
      ],
    );
  }
}
