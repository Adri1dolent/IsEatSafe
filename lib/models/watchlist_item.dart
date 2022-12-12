import 'package:equatable/equatable.dart';

class WatchlistItem {
  final String id;
  final String nomProduit;
  final String image;
  bool isRecalled;

  WatchlistItem(this.id, this.nomProduit, this.image, this.isRecalled);

}