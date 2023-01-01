import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:is_eat_safe/models/produit.dart';

import '../views/detailled_product_view.dart';

class ListviewTile extends StatelessWidget {
  final Produit p;

  final double imageWidth = 100;
  final double imageHeight = 100;
  final BoxFit imageFitting = BoxFit.cover;

  const ListviewTile({Key? key, required this.p}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => DetailledProductView(p)))
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color.fromRGBO(248, 244, 10, 0.30980392156862746), Color.fromRGBO(
                      255, 0, 0, 0.30196078431372547)]
              ),
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(p.images.split(' ')[0], width: imageWidth, height: imageHeight, fit: imageFitting,
                    //errorBuilder: (context, exception, stackTrace) {return Image.network("https://developers.google.com/static/maps/documentation/streetview/images/error-image-generic.png", width: imageWidth, height: imageHeight, fit: imageFitting,);},
                  ),
                ),
              ),
              Expanded(
                child: Text(
                    p.nomProduit,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
