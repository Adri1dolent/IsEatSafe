import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:is_eat_safe/models/produit.dart';

import 'models/watchlist_item.dart';

class ApiUtils {


  //Returns a list of maximum 20 items based on the number of the page without search filters
  //Empty string query doesnt filter anything therefore calling fetchPageByProductId
  static Future<List<Produit>> fetchPage(int page) async {
    return fetchPageByProductId(page, "");
  }


  static Future<Produit> getOneRecalledProduct(String id) async {
    final response = await http.get(Uri.parse(
      "https://data.economie.gouv.fr/api/records/1.0/search/?dataset=rappelconso0&q=$id&rows=1",
    ));
    List<dynamic> decoded = json.decode(response.body)["records"];
    if (response.statusCode == 200) {
      return Produit(
        decoded[0]['fields']['nom_de_la_marque_du_produit'],
        decoded[0]['fields']['noms_des_modeles_ou_references'],
        decoded[0]['fields']['motif_du_rappel'],
        (decoded[0]['fields']['liens_vers_les_images'] ??
            'https://st3.depositphotos.com/23594922/31822/v/600/depositphotos_318221368-stock-illustration-missing-picture-page-for-website.jpg'),
        decoded[0]['fields']['risques_encourus_par_le_consommateur'],
      );
    }
    return Produit("Marque inconnue", "Nom du produit inconnu", "Motif de rappel inconnu", 'https://st3.depositphotos.com/23594922/31822/v/600/depositphotos_318221368-stock-illustration-missing-picture-page-for-website.jpg', "Risques inconnus");
  }


  //Returns a list of maximum 20 items based on the number of the page and the search query
  static Future<List<Produit>> fetchPageByProductId(int page, String id) async {
    page *= 20;
    final response = await http.get(Uri.parse(
      "https://data.economie.gouv.fr/api/records/1.0/search/?dataset=rappelconso0&rows=20&start=$page&q=$id&sort=date_de_publication&facet=nature_juridique_du_rappel&facet=categorie_de_produit&facet=sous_categorie_de_produit&facet=nom_de_la_marque_du_produit&facet=conditionnements&facet=zone_geographique_de_vente&facet=distributeurs&facet=motif_du_rappel&facet=risques_encourus_par_le_consommateur&facet=conduites_a_tenir_par_le_consommateur&facet=modalites_de_compensation&facet=date_de_publication",
    ));
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<Produit> allProduits = [];
      List<dynamic> data = map["records"];
      for (var i in data) {
        Produit p = Produit(
          i['fields']['nom_de_la_marque_du_produit'],
          i['fields']['noms_des_modeles_ou_references'],
          i['fields']['motif_du_rappel'],
          (i['fields']['liens_vers_les_images'] ??
              'https://st3.depositphotos.com/23594922/31822/v/600/depositphotos_318221368-stock-illustration-missing-picture-page-for-website.jpg'),
          i['fields']['risques_encourus_par_le_consommateur'],
        );
        allProduits.add(p);
      }
      return allProduits;
    } else {
      throw Exception('Failed to load products');
    }
  }

  //Creates a WatchlistItem based on his id obtainned by scanning barcode
  static Future<WatchlistItem> fetchWLItem(String id) async {
    final response = await http.get(Uri.parse(
      "https://world.openfoodfacts.org/api/v0/product/$id.json",
    ));
    var decoded = json.decode(response.body);
    if (response.statusCode == 200 && decoded["status_verbose"] != "product not found") {
      Map<String, dynamic> map = decoded["product"];
      WatchlistItem it = WatchlistItem(
          id,
          map["product_name"] ?? "Unknown name: $id",
          map["image_front_small_url"] ?? "https://us.123rf.com/450wm/dzm1try/dzm1try2011/dzm1try201100099/159901749-secret-product-icon-black-box-clipart-image-isolated-on-white-background.jpg?ver=6",
          await isItemRecalled(id));
      return it;
    }
    return WatchlistItem(
        id,
        "Unknown Product: $id",
        "https://us.123rf.com/450wm/dzm1try/dzm1try2011/dzm1try201100099/159901749-secret-product-icon-black-box-clipart-image-isolated-on-white-background.jpg?ver=6",
        await isItemRecalled(id));
  }

  //Call to api to know if the item with id id is recalled
  static Future<bool> isItemRecalled(String id) async {
    final response = await http.get(Uri.parse(
      "https://data.economie.gouv.fr/api/records/1.0/search/?dataset=rappelconso0&q=$id&rows=1",
    ));
    List<dynamic> decoded = json.decode(response.body)["records"];
    if (response.statusCode == 200 && decoded.isNotEmpty) {
      return true;
    }
    return false;
  }
}
