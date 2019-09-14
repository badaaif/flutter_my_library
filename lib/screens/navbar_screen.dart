import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './books_list_screen.dart';
import './lent_books_screen.dart';
import './add_book_screen.dart';
import './wish_list_books_screen.dart';
import './favorites_books_screen.dart';
import '../providers/books.dart';

class NavBarScreen extends StatefulWidget {
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  final List<Widget> _pages = [
    BooksListScreen(),
    FavoritesBooksScreen(),
    LentBooksScreen(),
    WishListBooksScreen(),
  ];

  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<Books>(context, listen: false).fetchBooks();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddBookScreen.route);
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x445D4157), Color(0x66A8CABA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _pages[_selectedPageIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            title: Text('Lent'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            title: Text('Wish List'),
          ),
        ],
      ),
    );
  }
}
