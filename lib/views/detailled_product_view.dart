import 'package:flutter/material.dart';
import 'package:is_eat_safe/api_utils.dart';

import '../models/produit.dart';


class DetailledProductView extends StatelessWidget {

  final Produit p;

  const DetailledProductView(this.p, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 350,
              flexibleSpace: FlexibleSpaceBar(
                background:  Image.network(p.images),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 30,
              delegate: SliverChildListDelegate([
                Text(p.nomProduit),
                Text(p.motifRappel),
                Text(p.risques),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
