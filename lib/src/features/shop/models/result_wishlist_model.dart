import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';

class ResultWishlistModel {
  WishlistModel wishlist;
  List<ProductModel> products;
  ResultWishlistModel({
    required this.wishlist,
    required this.products,
  });
}
