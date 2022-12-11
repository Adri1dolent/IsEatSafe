import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:is_eat_safe/models/produit.dart';

import 'models/watchlist_item.dart';

class ApiUtils {
  static Future<List<Produit>> fetchPage(int page) async {
    page*=20;
    final response = await http.get(
      Uri.parse(
        "https://data.economie.gouv.fr/api/records/1.0/search/?dataset=rappelconso0&rows=20&start=$page&sort=date_de_publication&facet=nature_juridique_du_rappel&facet=categorie_de_produit&facet=sous_categorie_de_produit&facet=nom_de_la_marque_du_produit&facet=conditionnements&facet=zone_geographique_de_vente&facet=distributeurs&facet=motif_du_rappel&facet=risques_encourus_par_le_consommateur&facet=conduites_a_tenir_par_le_consommateur&facet=modalites_de_compensation&facet=date_de_publication"
    ,));
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<Produit> allProduits = [];
      List<dynamic> data = map["records"];
      for (var i in data) {
        Produit p = Produit(
          i['fields']['nom_de_la_marque_du_produit'],
          i['fields']['noms_des_modeles_ou_references'],
          i['fields']['motif_du_rappel'],
          (i['fields']['liens_vers_les_images'] ?? 'https://st3.depositphotos.com/23594922/31822/v/600/depositphotos_318221368-stock-illustration-missing-picture-page-for-website.jpg'),
          i['fields']['risques_encourus_par_le_consommateur'],
        );
        allProduits.add(p);
      }
      return allProduits;
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<WatchlistItem>? fetchWLItem(String id){
    return null;
  }
}