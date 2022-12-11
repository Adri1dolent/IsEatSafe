import 'package:equatable/equatable.dart';

class WatchlistItem extends Equatable{
  String id;
  String nomProduit;
  String image;

  WatchlistItem(this.id, this.nomProduit, this.image);

  @override
  List<Object?> get props => [id, nomProduit, image];
}