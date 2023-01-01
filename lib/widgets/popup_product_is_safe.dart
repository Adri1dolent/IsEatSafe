import 'package:flutter/material.dart';

class PopUpOk extends StatelessWidget {
  const PopUpOk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return AlertDialog(
        title: const Text("Produit OK"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
                "Selon nos informations ce produit ne fait pas l'objet d'un rappel"),
            SizedBox(height: 20,),
            Icon(Icons.check_circle, color: Colors.green,size: 40,),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Bien reçu!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
  }
}
