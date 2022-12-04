import 'package:equatable/equatable.dart';

class Produit extends Equatable{
  String marque;
  String nomProduit;
  String motifRappel;
  String images;
  String risques;

  Produit(this.marque, this.nomProduit, this.motifRappel, this.images,
      this.risques);

  @override
  List<Object?> get props => [marque, nomProduit, motifRappel, images, risques];
}