import 'dart:math';

import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';

class DummyData {
  static Random random = Random();

  static int randomInt(int min, int max) {
    return min + random.nextInt(max - min);
  }

  static double randomDouble(double min, double max) {
    return min + random.nextDouble() * (max - min);
  }

  static bool randomBool() {
    return random.nextBool();
  }

  static String randomSalePersent() {
    return random.nextBool() ? '${randomInt(0, 100)}%' : '';
  }

  static String randomPriceSale(String price, String salePersent) {
    double priceNum = double.parse(price);
    if (salePersent == '') {
      return priceNum.ceil().toString();
    }
    int salePersentNum =
        int.parse(salePersent.substring(0, salePersent.length - 1));

    double priceSaleNum = priceNum * (1 - salePersentNum / 100);

    return priceSaleNum.ceil().toString();
  }

  static T randomElement<T>(List<T> list) {
    return list[random.nextInt(list.length)];
  }

  static List<ProductModel> getAllProducts() {
    List<ProductModel> list = [];
    list = List<ProductModel>.generate(
      1000,
      (index) {
        String nameStore = "";
        String category = randomElement(categories);
        String name = randomElement(names);
        String price = randomDouble(1, 1000).ceil().toString();
        String unit = randomElement(units);
        String salePersent = randomSalePersent().toString();
        String priceSale = randomPriceSale(price, salePersent);
        String imgPath = randomElement(imgPaths);
        String imgStore = randomElement(imgStores);
        String status = randomInt(1, 10) <= 2 ? "Tạm hết hàng" : "";
        if (imgStore == imgStores[0]) {
          nameStore = "Big C";
        } else if (imgStore == imgStores[1]) {
          nameStore = "Win Mart";
        } else if (imgStore == imgStores[2]) {
          nameStore = "Coop Mart";
        } else if (imgStore == imgStores[3]) {
          nameStore = "Lan Chi Mart";
        } else if (imgStore == imgStores[4]) {
          nameStore = "Aeon Mall";
        } else if (imgStore == imgStores[5]) {
          nameStore = "Mega Mart";
        } else if (imgStore == imgStores[6]) {
          nameStore = "Lotte Mart";
        }
        String countBuyed = randomInt(10, 5000).toString();
        price = '$price.000₫';
        priceSale = '$priceSale.000₫';
        return ProductModel(
            category: category,
            name: name,
            price: price,
            salePersent: salePersent,
            priceSale: priceSale,
            imgPath: imgPath,
            imgStore: imgStore,
            unit: unit,
            countBuyed: countBuyed,
            nameStore: nameStore,
            quantity: 0,
            status: status,
            wishlistName: '');
      },
    );
    return list;
  }
}
