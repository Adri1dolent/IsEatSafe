import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:is_eat_safe/Produit.dart';


class RappelListView extends StatefulWidget {
  const RappelListView({Key? key}) : super(key: key);

  @override
  State<RappelListView> createState() => _RappelListViewState();
}

class _RappelListViewState extends State<RappelListView> {

  final controller = ScrollController();

  List<Produit> items = [];

  bool isLoading = false;

  int page = 0;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    fetchPage();

    controller.addListener(() {
      if(controller.position.maxScrollExtent <= controller.offset + 300 && !isLoading){
        isLoading = true;
        fetchPage();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future fetchPage() async {
    var tmpPage = page * 20;
    final response = await http.get(
      Uri.parse("https://data.economie.gouv.fr/api/records/1.0/search/?dataset=rappelconso0&rows=20&start=$tmpPage&sort=date_de_publication&facet=nature_juridique_du_rappel&facet=categorie_de_produit&facet=sous_categorie_de_produit&facet=nom_de_la_marque_du_produit&facet=conditionnements&facet=zone_geographique_de_vente&facet=distributeurs&facet=motif_du_rappel&facet=risques_encourus_par_le_consommateur&facet=conduites_a_tenir_par_le_consommateur&facet=modalites_de_compensation&facet=date_de_publication"),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<Produit> allProduits = [];
      List<dynamic> data = map["records"];
      for (var i in data) {
        //print(data);
        Produit p = Produit(
          i['fields']['nom_de_la_marque_du_produit'],
          i['fields']['noms_des_modeles_ou_references'],
          i['fields']['motif_du_rappel'],
          (i['fields']['liens_vers_les_images'] ?? 'https://st3.depositphotos.com/23594922/31822/v/600/depositphotos_318221368-stock-illustration-missing-picture-page-for-website.jpg'),
          i['fields']['risques_encourus_par_le_consommateur'],
        );
        allProduits.add(p);
      }
       setState(() {
         items.addAll(allProduits);
         page++;
         isLoading = false;
       });
    }else{
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if(index < items.length){
        final item = items[index];

        return ListTile(
          leading: Image.network(item.images.split(' ')[0],
              height: 150, width: 100, fit: BoxFit.cover),
          title: Text(item.nomProduit),
        );}
        else{
          return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
