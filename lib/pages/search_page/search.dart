import 'package:barber/pages/list/lists.dart';
import 'package:barber/pages/search_page/flexible_appBar_search.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexSearch(),
            floating: true,
            expandedHeight: 110,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).canvasColor,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    ListItem(
                      productsProps: [],
                    ),
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
