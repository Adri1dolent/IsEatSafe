import 'package:flutter/material.dart';

class FullscreenImage extends StatelessWidget {
  final String s;
  const FullscreenImage({Key? key, required this.s}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
            tag: 'product image',
            child: Image.network(
              s,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
