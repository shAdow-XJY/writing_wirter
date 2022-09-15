import 'package:flutter/material.dart';

class MyListView extends StatefulWidget {
  const MyListView({Key? key,}) : super(key: key);

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          thickness: 1,
          height: 1,
          color: Colors.white24,
        ),
        itemCount: 25,
        itemBuilder: (context, index) => IconButton(
          icon: const Icon(Icons.add),
          onPressed: (){},
        ),
    );
  }
  
}