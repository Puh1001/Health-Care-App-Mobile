import 'package:flutter/material.dart';

class SingleImage extends StatelessWidget {
  final String imageUrl;

  SingleImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}
