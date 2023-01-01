import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:is_eat_safe/bloc/watchlist_bloc.dart';
import 'package:is_eat_safe/models/watchlist_item.dart';

import '../api_utils.dart';
import '../views/detailled_product_view.dart';

class WatchlistTile extends StatelessWidget {

  final WatchlistItem item;
  final WatchlistBloc watchlistBloc;

  final double imageWidth = 75;
  final double imageHeight = 75;
  final BoxFit imageFitting = BoxFit.fitHeight;

  const WatchlistTile({Key? key, required this.item, required this.watchlistBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
      if(item.isRecalled){
        ApiUtils.getOneRecalledProduct(item.id).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailledProductView(value))))
      }
    },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: item.isRecalled ? const [Color.fromRGBO(248, 10, 10, 0.30980392156862746), Color.fromRGBO(
                    255, 255, 255, 0.4745098039215686)]
                    : const [Color.fromRGBO(38, 246, 6, 0.30980392156862746), Color.fromRGBO(
                    255, 255, 255, 0.4745098039215686)]
            ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(item.image, width: imageWidth, height: imageHeight, fit: imageFitting,
                  //errorBuilder: (context, exception, stackTrace) {return Image.network("https://developers.google.com/static/maps/documentation/streetview/images/error-image-generic.png", width: imageWidth, height: imageHeight, fit: imageFitting,);},
                ),
              ),
            ),
            Expanded(
              child: Text(
                item.nomProduit,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () {
                  watchlistBloc.add(ElementToBeDeleted(item));
                }),
          ],
        ),
      ),
    );
  }
}
