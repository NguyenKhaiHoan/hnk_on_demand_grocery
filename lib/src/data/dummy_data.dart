import 'dart:math';

import 'package:get/get.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/category_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/voucher_model.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';

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

  static List<String> getRandomElements(List<String> list, int count) {
    var random = Random();
    Set<int> indices = {};

    count = min(list.length, count);

    while (indices.length < count) {
      indices.add(random.nextInt(list.length));
    }

    return indices.map((index) => list[index]).toList();
  }

  static List<VoucherModel> getAllVoucher() {
    return [
      VoucherModel(
          id: '',
          name: 'DEMOSAVE50000',
          description: '',
          type: 'Flat',
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now().subtract(const Duration(days: 1)),
          discountValue: 50000,
          usedById: [],
          isActive: true),
      VoucherModel(
          id: '',
          name: 'DEMOSALE20',
          description: '',
          type: 'Percentage',
          minAmount: 2000000,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          discountValue: 20,
          usedById: [],
          isActive: true),
      VoucherModel(
          id: '',
          name: 'DEMOSALE30',
          description: '',
          type: 'Percentage',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          discountValue: 30,
          usedById: [],
          isActive: true),
    ];
  }

  static List<CategoryModel> getAllCategory() {
    return List.generate(
        18,
        (index) => CategoryModel(
            id: index.toString(), image: '', name: categoryNames[index]));
  }

  static List<StoreModel> getAllStore(List<CategoryModel> categories) {
    var listOfCategoryId = categories.map((e) => e.id.toString()).toList();
    return [
      StoreModel(
          id: '0',
          storeImage: '',
          name: 'Big C',
          storeImageBackground: '',
          listOfCategoryId: getRandomElements(listOfCategoryId, 5),
          rating: 5,
          import: false,
          isFamous: false,
          email: '',
          phoneNumber: '',
          description: '',
          productCount: 0,
          status: true,
          cloudMessagingToken: ''),
      StoreModel(
          id: '1',
          storeImage: '',
          name: 'Coop Mart',
          storeImageBackground: '',
          listOfCategoryId: getRandomElements(listOfCategoryId, 5),
          rating: 5,
          import: true,
          isFamous: true,
          email: '',
          phoneNumber: '',
          description: '',
          productCount: 0,
          status: true,
          cloudMessagingToken: ''),
    ];
  }

  static List<ProductModel> getAllProducts(List<StoreModel> stores) {
    return [
      ProductModel(
          id: '0',
          name: 'Táo',
          image: 'assets/products/Vegetables/Ginger_Iconic.jpg',
          categoryId: '4',
          description:
              'Innuo palam qualis stips mater curo, opportune jugis. Longe mereo.',
          status: 'Còn hàng',
          price: 372000,
          salePersent: 0,
          priceSale: 372000,
          unit: 'vỉ',
          countBuyed: 170,
          rating: 4.856446764471369,
          origin: 'Việt Nam',
          storeId: '0',
          uploadTime: DateTime.fromMillisecondsSinceEpoch(1711645995716)),
      ProductModel(
          id: '1',
          name: 'Bơ',
          image: 'assets/products/Fruit/Pink-Lady_Iconic.jpg',
          categoryId: '14',
          description:
              'Mane explicatus ut. Vicissitudo tardus pulvis putesco usque edi dives.',
          status: 'Còn hàng',
          price: 885000,
          salePersent: 31,
          priceSale: 611000,
          unit: 'vỉ',
          countBuyed: 455,
          rating: 3.7068188591066975,
          origin: 'Nhật Bản',
          storeId: '1',
          uploadTime: DateTime.fromMillisecondsSinceEpoch(1712769195716)),
      ProductModel(
          id: '2',
          name: 'Chuối',
          image: 'assets/products/Vegetables/Red-Beet_Iconic.jpg',
          categoryId: '13',
          description:
              'Conduco indux, ire ago sermo. Labia pre. Quos vinco audio.',
          status: 'Tạm hết hàng',
          price: 531000,
          salePersent: 39,
          priceSale: 324000,
          unit: 'cái',
          countBuyed: 401,
          rating: 4.647663521336262,
          origin: 'Việt Nam',
          storeId: '0',
          uploadTime: DateTime.fromMillisecondsSinceEpoch(1713546795716)),
      ProductModel(
          id: '3',
          name: 'Kiwi',
          image: 'assets/products/Packages/Alpro-Shelf-Soy-Milk_Iconic.jpg',
          categoryId: '10',
          description:
              'Ceno placo. Eximo obviam. Theologus, illorum. Cessum factum pacis vindico.',
          status: 'Còn hàng',
          price: 414000,
          salePersent: 0,
          priceSale: 414000,
          unit: 'kg',
          countBuyed: 98,
          rating: 3.4017616023586887,
          origin: 'Trung Quốc',
          storeId: '1',
          uploadTime: DateTime.fromMillisecondsSinceEpoch(1711818795717)),
      ProductModel(
          id: '4',
          name: 'Chanh vàng',
          image:
              'assets/products/Packages/Tropicana-Golden-Grapefruit_Iconic.jpg',
          categoryId: '16',
          description:
              'Tres contristo, contemplatio irritus lusum pium claro cruentus minus, ut.',
          status: 'Còn hàng',
          price: 978000,
          salePersent: 0,
          priceSale: 978000,
          unit: 'vỉ',
          countBuyed: 229,
          rating: 4.03573201982277,
          origin: 'Việt Nam',
          storeId: '0',
          uploadTime: DateTime.fromMillisecondsSinceEpoch(1712423595717)),
      ProductModel(
          id: '5',
          name: 'Chanh xanh',
          image: 'assets/products/Fruit/Pink-Lady_Iconic.jpg',
          categoryId: '6',
          description:
              'Sulum, repo hae duco effrego. Mitis, exsto fortis fides atqui.',
          status: 'Còn hàng',
          price: 444000,
          salePersent: 0,
          priceSale: 444000,
          unit: 'kg',
          countBuyed: 123,
          rating: 4.172554201185786,
          origin: 'Việt Nam',
          storeId: '1',
          uploadTime: DateTime.fromMillisecondsSinceEpoch(1711645995717)),
      ProductModel(
          id: '6',
          name: 'Xoài',
          image: 'assets/products/Fruit/Conference_Iconic.jpg',
          categoryId: '15',
          description:
              'Vomito consulo ara morior harum. Sursum hoc abutor miser, tener.',
          status: 'Tạm hết hàng',
          price: 497000,
          salePersent: 0,
          priceSale: 497000,
          unit: 'chai',
          countBuyed: 277,
          rating: 3.7992866949462027,
          origin: 'Việt Nam',
          storeId: '0',
          uploadTime: DateTime.fromMillisecondsSinceEpoch(1711991595717)),
      ProductModel(
          id: '7',
          name: 'Dưa',
          image: 'assets/products/Fruit/Honeydew-Melon_Iconic.jpg',
          categoryId: '14',
          description:
              'Quasi his illa. Pomum illi orno posse prominens undique nobis.',
          status: 'Còn hàng',
          price: 341000,
          salePersent: 37,
          priceSale: 215000,
          unit: 'vỉ',
          countBuyed: 379,
          rating: 3.343013138893032,
          origin: 'Việt Nam',
          storeId: '1',
          uploadTime: DateTime.fromMillisecondsSinceEpoch(1713114795718)),
      ProductModel(
          id: '8',
          name: 'Xuân đào',
          image:
              'assets/products/Packages/Arla-Natural-Mild-Low-Fat-Yoghurt_Iconic.jpg',
          categoryId: '15',
          description:
              'At, pueriliter cito adnuo audio cessum hactenus. Denuo estus pulsus.',
          status: 'Còn hàng',
          price: 64000,
          salePersent: 82,
          priceSale: 12000,
          unit: 'kg',
          countBuyed: 171,
          rating: 4.350499409202966,
          origin: 'Việt Nam',
          storeId: '0',
          uploadTime: DateTime.fromMillisecondsSinceEpoch(1712250795718)),
      ProductModel(
          id: '9',
          name: 'Cam',
          image: 'assets/products/Vegetables/Red-Beet_Iconic.jpg',
          categoryId: '6',
          description:
              'Fruor pulex quae humilis palma animi amor miror. Illae comminuo.',
          status: 'Còn hàng',
          price: 965000,
          salePersent: 0,
          priceSale: 965000,
          unit: 'kg',
          countBuyed: 81,
          rating: 4.382098325974027,
          origin: 'Việt Nam',
          storeId: '1',
          uploadTime: DateTime.fromMillisecondsSinceEpoch(1712769195718)),
    ];
    // return List<ProductModel>.generate(
    //   10,
    //   (index) {
    //     var store = stores[index % stores.length];
    //     String storeId = store.id;
    //     String origin = '';
    //     if (store.import) {
    //       origin = randomBool() ? randomElement(otherCountry) : 'Việt Nam';
    //     } else {
    //       origin = 'Việt Nam';
    //     }
    //     String description = loremIpsum(words: 10, paragraphs: 1);
    //     String categoryId = randomElement(store.listOfCategoryId);
    //     String name = names[index % names.length];
    //     int price = randomInt(1, 1000) * 1000;
    //     String unit = randomElement(units);
    //     int salePersent = randomSalePersent();
    //     int priceSale = randomPriceSale(price, salePersent);
    //     String image = randomElement(imageProduct);
    //     String status = randomInt(1, 10) <= 1 ? "Tạm hết hàng" : "Còn hàng";
    //     int countBuyed = randomInt(10, 500);
    //     double rating = randomDouble(3.0, 5.0);
    //     DateTime uploadTime =
    //         DateTime.now().subtract(Duration(days: randomInt(1, 30)));
    //     return ProductModel(
    //         id: index.toString(),
    //         name: name,
    //         image: image,
    //         categoryId: categoryId,
    //         description: description,
    //         status: status,
    //         price: price,
    //         salePersent: salePersent,
    //         priceSale: priceSale,
    //         unit: unit,
    //         countBuyed: countBuyed,
    //         rating: rating,
    //         origin: origin,
    //         storeId: storeId,
    //         uploadTime: DateTime.fromMillisecondsSinceEpoch(
    //             uploadTime.millisecondsSinceEpoch));
    //   },
    // );
  }

  static List<String> categoryNames = [
    'Trái cây',
    'Rau củ',
    'Đồ hộp',
    'Sữa',
    'Thịt',
    'Cá & Hải sản',
    'Trứng',
    'Đồ nguội',
    "Dầu ăn & Gia vị",
    "Ăn vặt",
    "Bánh mỳ",
    "Đồ uống",
    "Mỳ, Gạo & Ngũ cốc",
    "Thực phẩm đông lạnh",
    "Làm bánh",
    "Chăm sóc cá nhân",
    "Đồ gia dụng",
    "Dành cho bé"
  ];

  static List<String> names = [
    "Táo",
    "Bơ",
    "Chuối",
    "Kiwi",
    "Chanh vàng",
    "Chanh xanh",
    "Xoài",
    "Dưa",
    "Xuân đào",
    "Cam",
    "Đu đủ",
    "Chanh dây",
    "Đào",
    "Lê",
    "Dứa",
    "Mận",
    "Lựu",
    "Bưởi đỏ",
    "Quýt",
    "Nước ép",
    "Sữa",
    "Sữa yến mạch",
    "Sữa đậu nành",
    "Sữa chua",
    "Măng tây",
    "Cà tím",
    "Bắp cải",
    "Cà rốt",
    "Dưa chuột",
    "Tỏi",
    "Gừng",
    "Tỏi tây",
    "Nấm",
    "Hành tây",
    "Hạt tiêu",
    "Khoai tây",
    "Củ dền",
    "Cà chua",
    "Bí xanh"
  ];

  static List<String> otherCountry = [
    'Trung Quốc',
    'Hàn Quốc',
    'Nhật Bản',
    'Thái Lan',
    'Lào',
    'Mỹ',
  ];

  static List<String> units = ['kg', 'cái', 'vỉ', 'chai', 'gói'];

  static List<String> imageProduct = [
    'assets/products/Fruit/Golden-Delicious_Iconic.jpg',
    'assets/products/Fruit/Granny-Smith_Iconic.jpg',
    'assets/products/Fruit/Pink-Lady_Iconic.jpg',
    'assets/products/Fruit/Red-Delicious_Iconic.jpg',
    'assets/products/Fruit/Royal-Gala_Iconic.jpg',
    'assets/products/Fruit/Avocado_Iconic.jpg',
    'assets/products/Fruit/Banana_Iconic.jpg',
    'assets/products/Fruit/Kiwi_Iconic.jpg',
    'assets/products/Fruit/Lemon_Iconic.jpg',
    'assets/products/Fruit/Lime_Iconic.jpg',
    'assets/products/Fruit/Mango_Iconic.jpg',
    'assets/products/Fruit/Cantaloupe_Iconic.jpg',
    'assets/products/Fruit/Galia-Melon_Iconic.jpg',
    'assets/products/Fruit/Honeydew-Melon_Iconic.jpg',
    'assets/products/Fruit/Watermelon_Iconic.jpg',
    'assets/products/Fruit/Nectarine_Iconic.jpg',
    'assets/products/Fruit/Orange_Iconic.jpg',
    'assets/products/Fruit/Papaya_Iconic.jpg',
    'assets/products/Fruit/Passion-Fruit_Iconic.jpg',
    'assets/products/Fruit/Peach_Iconic.jpg',
    'assets/products/Fruit/Anjou_Iconic.jpg',
    'assets/products/Fruit/Conference_Iconic.jpg',
    'assets/products/Fruit/Kaiser_Iconic.jpg',
    'assets/products/Fruit/Pineapple_Iconic.jpg',
    'assets/products/Fruit/Plum_Iconic.jpg',
    'assets/products/Fruit/Pomegranate_Iconic.jpg',
    'assets/products/Fruit/Red-Grapefruit_Iconic.jpg',
    'assets/products/Fruit/Satsumas_Iconic.jpg',
    'assets/products/Packages/Bravo-Apple-Juice_Iconic.jpg',
    'assets/products/Packages/Bravo-Orange-Juice_Iconic.jpg',
    'assets/products/Packages/God-Morgon-Apple-Juice_Iconic.jpg',
    'assets/products/Packages/God-Morgon-Orange-Juice_Iconic.jpg',
    'assets/products/Packages/God-Morgon-Orange-Red-Grapefruit-Juice_Iconic.jpg',
    'assets/products/Packages/God-Morgon-Red-Grapefruit-Juice_Iconic.jpg',
    'assets/products/Packages/Tropicana-Apple-Juice_Iconic.jpg',
    'assets/products/Packages/Tropicana-Golden-Grapefruit_Iconic.jpg',
    'assets/products/Packages/Tropicana-Juice-Smooth_Iconic.jpg',
    'assets/products/Packages/Tropicana-Mandarin-Morning_Iconic.jpg',
    'assets/products/Packages/Arla-Ecological-Medium-Fat-Milk_Iconic.jpg',
    'assets/products/Packages/Arla-Lactose-Medium-Fat-Milk_Iconic.jpg',
    'assets/products/Packages/Arla-Medium-Fat-Milk_Iconic.jpg',
    'assets/products/Packages/Arla-Standard-Milk_Iconic.jpg',
    'assets/products/Packages/Garant-Ecological-Medium-Fat-Milk_Iconic.jpg',
    'assets/products/Packages/Garant-Ecological-Standard-Milk_Iconic.jpg',
    'assets/products/Packages/Oatly-Oat-Milk_Iconic.jpg',
    'assets/products/Packages/Alpro-Fresh-Soy-Milk_Iconic.jpg',
    'assets/products/Packages/Alpro-Shelf-Soy-Milk_Iconic.jpg',
    'assets/products/Packages/Arla-Mild-Vanilla-Yoghurt_Iconic.jpg',
    'assets/products/Packages/Arla-Natural-Mild-Low-Fat-Yoghurt_Iconic.jpg',
    'assets/products/Packages/Arla-Natural-Yoghurt_Iconic.jpg',
    'assets/products/Packages/Valio-Vanilla-Yoghurt_Iconic.jpg',
    'assets/products/Packages/Yoggi-Strawberry-Yoghurt_Iconic.jpg',
    'assets/products/Packages/Yoggi-Vanilla-Yoghurt_Iconic.jpg',
    'assets/products/Vegetables/Asparagus_Iconic.jpg',
    'assets/products/Vegetables/Aubergine_Iconic.jpg',
    'assets/products/Vegetables/Cabbage_Iconic.jpg',
    'assets/products/Vegetables/Carrots_Iconic.jpg',
    'assets/products/Vegetables/Cucumber_Iconic.jpg',
    'assets/products/Vegetables/Garlic_Iconic.jpg',
    'assets/products/Vegetables/Ginger_Iconic.jpg',
    'assets/products/Vegetables/Leek_Iconic.jpg',
    'assets/products/Vegetables/Brown-Cap-Mushroom_Iconic.jpg',
    'assets/products/Vegetables/Yellow-Onion_Iconic.jpg',
    'assets/products/Vegetables/Green-Bell-Pepper_Iconic.jpg',
    'assets/products/Vegetables/Orange-Bell-Pepper_Iconic.jpg',
    'assets/products/Vegetables/Red-Bell-Pepper_Iconic.jpg',
    'assets/products/Vegetables/Yellow-Bell-Pepper_Iconic.jpg',
    'assets/products/Vegetables/Floury-Potato_Iconic.jpg',
    'assets/products/Vegetables/Solid-Potato_Iconic.jpg',
    'assets/products/Vegetables/Sweet-Potato_Iconic.jpg',
    'assets/products/Vegetables/Red-Beet_Iconic.jpg',
    'assets/products/Vegetables/Beef-Tomato_Iconic.jpg',
    'assets/products/Vegetables/Regular-Tomato_Iconic.jpg',
    'assets/products/Vegetables/Vine-Tomato_Iconic.jpg',
    'assets/products/Vegetables/Zucchini_Iconic.jpg',
  ];
}
