import 'package:flutter/material.dart';

class DetailContainer extends StatefulWidget {
  const DetailContainer({Key? key,}) : super(key: key);

  @override
  State<DetailContainer> createState() => _DetailContainerState();
}

class _DetailContainerState extends State<DetailContainer>{
  

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).focusColor,
      child: Column(
        children: [
          Text('data')
        ],
      ),
    );
  }

}