import 'dart:convert';

import 'package:is_eat_safe/Produit.dart';
import 'package:http/http.dart' as http;

Future<List<Produit>>  fetchPage(int page) async {
  final response = await http.get(
      Uri.parse("https://data.economie.gouv.fr/api/records/1.0/search/?dataset=rappelconso0&q=&start="+ page.toString() +"&sort=date_de_publication&facet=nature_juridique_du_rappel&facet=categorie_de_produit&facet=sous_categorie_de_produit&facet=nom_de_la_marque_du_produit&facet=conditionnements&facet=zone_geographique_de_vente&facet=distributeurs&facet=motif_du_rappel&facet=risques_encourus_par_le_consommateur&facet=conduites_a_tenir_par_le_consommateur&facet=modalites_de_compensation&facet=date_de_publication"),
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    List<Produit> allProduits = [];
    List<dynamic> data = map["records"];
    for (var i in data) {
      Produit p = Produit(
        i['nom_de_la_marque_du_produit'],
        i['noms_des_modeles_ou_references'],
        i['motif_du_rappel'],
        i['liens_vers_les_images'],
        i['risques_encourus_par_le_consommateur'],
      );
      allProduits.add(p);
    }
    return allProduits;
  }else{
    throw Exception('Failed to load products');
  }
}