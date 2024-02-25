import 'dart:math';

import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';

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

  static int randomSalePersent() {
    return random.nextBool() ? randomInt(10, 99) : 0;
  }

  static int randomPriceSale(int price, int salePersent) {
    double priceNum = price.toDouble();
    double priceSaleNum = priceNum * (1 - salePersent / 100);

    return (priceSaleNum / 1000).ceil() * 1000;
  }

  static T randomElement<T>(List<T> list) {
    return list[random.nextInt(list.length)];
  }

  static List<ProductModel> getAllProducts() {
    List<ProductModel> list = [];
    list = List<ProductModel>.generate(
      1500,
      (index) {
        int storeId = randomInt(1, listStore.length);
        String nameStore = listStore[storeId].name;
        String imgStore = listStore[storeId].imgStore;
        String origin = '';
        if (listStore[storeId].import) {
          origin = randomBool() ? randomElement(otherCountry) : 'Việt Nam';
        } else {
          origin = 'Việt Nam';
        }
        String category = randomElement(listStore[storeId].category);
        String name = randomElement(names);
        int price = randomInt(1, 1000) * 1000;
        String unit = randomElement(units);
        int salePersent = randomSalePersent();
        int priceSale = randomPriceSale(price, salePersent);
        String imgPath = randomElement(imgPaths);
        String status = randomInt(1, 10) <= 2 ? "Tạm hết hàng" : "";
        int countBuyed = randomInt(10, 500);
        double rating = randomDouble(3.0, 5.0);
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
            wishlistName: '',
            rating: rating,
            origin: origin,
            productId: index,
            storeId: storeId);
      },
    );
    return list;
  }

  static String vietNamCurrencyFormatting(int amount) {
    return '${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}₫';
  }
}
