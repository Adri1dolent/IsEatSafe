import 'package:flutter/material.dart';
import 'package:is_eat_safe/views/fullscreen_image.dart';

import '../models/produit.dart';

class DetailledProductView extends StatelessWidget {
  final Produit p;

  const DetailledProductView(this.p, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return FullscreenImage(s: p.images.split(' ')[0]);
                    }));
                  },
                  child: Hero(
                    tag: "product image",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        p.images.split(' ')[0],
                        width: 200,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      p.nomProduit,
                      style: const TextStyle(
                          color: Colors.black,
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: Colors.orangeAccent,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 4),
                    child: Text(
                      "Raison du rappel :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Align(
                  alignment: Alignment.centerLeft, child: Text(p.motifRappel)),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: Colors.orangeAccent,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 4),
                    child: Text(
                      "Risques encourus :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Align(
                  alignment: Alignment.centerLeft, child: Text(p.risques)),
            ),
          ],
        ),
      ),
    );
  }
}
