import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './screens/navbar_screen.dart';
import './screens/add_book_screen.dart';
import './screens/book_detail_screen.dart';
import './providers/books.dart';
import './providers/shared_vars.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Books(),
        ),
        ChangeNotifierProvider.value(
          value: SharedVars(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          accentColor: Colors.orange[400],
          errorColor: Colors.red,
        ),
        home: NavBarScreen(),
        routes: {
          AddBookScreen.route: (ctx) => AddBookScreen(),
          BookDetailScreen.route: (ctx) => BookDetailScreen(),
        },
      ),
    );
  }
}
