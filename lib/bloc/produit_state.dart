part of 'produit_bloc.dart';

abstract class ProduitState extends Equatable {
  const ProduitState();

  @override
  List<Object?> get props => [];

}

class ProduitInitial extends ProduitState {

}

class ProduitLoading extends ProduitState {

}

class ProduitError extends ProduitState {

}

class ProduitLoaded extends ProduitState {

  const ProduitLoaded({
    this.produits = const <Produit>[],
    this.page = 1,
    this.hasReachedMax = false
  });

  final List<Produit> produits;
  final int page;
  final bool hasReachedMax;

  ProduitLoaded copyWith({List<Produit>? produits,int? page, bool? hasReachedMax}){
    return ProduitLoaded(
      produits: produits ?? this.produits,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
  }

  @override
  List<Object?> get props => [produits, page, hasReachedMax];
}
