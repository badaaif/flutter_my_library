import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/csv_helper.dart';
import './books_list_screen.dart';
import './lent_books_screen.dart';
import './add_book_screen.dart';
import './wish_list_books_screen.dart';
import './favorites_books_screen.dart';
import '../providers/books.dart';
import '../providers/shared_vars.dart';

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
    Provider.of<SharedVars>(context, listen: false).initGridType();
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
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                final result = await CSVHelper.exportBooks();
                var message = 'Something went wrong...';
                if (result == 1) {
                  message = 'Books data exported successfully';
                }
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                  duration: Duration(seconds: 3),
                ));
              },
            ),
          ),
           Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.folder),
              onPressed: () async {
                await CSVHelper.openFile();
                Provider.of<Books>(context, listen: false).fetchBooks();
              },
            ),
          ),
          Consumer<SharedVars>(builder: (ctx, sharedVars, child) {
            return IconButton(
              icon: Icon(
                  sharedVars.gridType == 2 ? Icons.view_module : Icons.list),
              onPressed: () {
                Provider.of<SharedVars>(context, listen: false)
                    .toggleGridType();
              },
            );
          }),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
                Navigator.of(context).pushNamed(AddBookScreen.route);
            },
          ),
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
