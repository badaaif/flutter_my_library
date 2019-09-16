import 'package:flutter/material.dart';

import '../models/filter_options.dart';

class FilterPopUpMenu extends StatefulWidget {
  final Function setFilter;

  FilterPopUpMenu(this.setFilter);

  @override
  _FilterPopUpMenuState createState() => _FilterPopUpMenuState();
}

class _FilterPopUpMenuState extends State<FilterPopUpMenu> {
  FilterOptions _selected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selected = FilterOptions.All;
  }
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (FilterOptions filter) {
        setState(() {
          _selected = filter;
        });

        widget.setFilter(filter);
      },
      icon: Icon(Icons.filter_list),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Text(
            'Title',
            style: TextStyle(
              color: _selected == FilterOptions.Title
                  ? Theme.of(context).primaryColor
                  : Colors.black,
            ),
          ),
          value: FilterOptions.Title,
        ),
        PopupMenuItem(
          child: Text(
            'Author',
            style: TextStyle(
              color: _selected == FilterOptions.Author
                  ? Theme.of(context).primaryColor
                  : Colors.black,
            ),
          ),
          value: FilterOptions.Author,
        ),
        PopupMenuItem(
          child: Text(
            'Publisher',
            style: TextStyle(
              color: _selected == FilterOptions.Publisher
                  ? Theme.of(context).primaryColor
                  : Colors.black,
            ),
          ),
          value: FilterOptions.Publisher,
        ),
        PopupMenuItem(
          child: Text(
            'Lent To',
            style: TextStyle(
              color: _selected == FilterOptions.LentTo
                  ? Theme.of(context).primaryColor
                  : Colors.black,
            ),
          ),
          value: FilterOptions.LentTo,
        ),
        PopupMenuItem(
          child: Text(
            'All',
            style: TextStyle(
              color: _selected == FilterOptions.All
                  ? Theme.of(context).primaryColor
                  : Colors.black,
            ),
          ),
          value: FilterOptions.All,
        ),
      ],
    );
  }
}
