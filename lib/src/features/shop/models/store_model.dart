import 'package:on_demand_grocery/src/data/dummy_data.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';

class StoreModel {
  String imgStore;
  String imgBackground;
  String name;
  bool isFavourite;
  List<String> category;
  List<ProductModel> products;
  double rating;
  double distance;
  bool import;
  bool isFamous;

  StoreModel(
      {required this.imgStore,
      required this.name,
      required this.isFavourite,
      required this.imgBackground,
      required this.category,
      required this.rating,
      required this.products,
      required this.distance,
      required this.import,
      required this.isFamous});
}

List<String> pickRandomItems(int count) {
  List<String> list = List.from(categories);
  list.shuffle();
  return list.take(count).toList();
}

final listStore = [
  StoreModel(
    imgStore:
        'https://yt3.ggpht.com/a-/AN66SAzssXbRK3evQCiAI0rVxNX8AtYYO2Q_50lQJg=s900-mo-c-c0xffffffff-rj-k-no',
    imgBackground:
        'https://th.bing.com/th/id/R.ee18a6f92ca5084015368ca41a226eb4?rik=hfph0qMOoUNGNQ&pid=ImgRaw&r=0',
    name: 'Big C',
    isFavourite: false,
    category: pickRandomItems(DummyData.randomInt(1, categories.length)),
    rating: DummyData.randomDouble(3.0, 5.0),
    products: [],
    distance: DummyData.randomDouble(0.5, 20.0),
    import: false,
    isFamous: DummyData.randomBool(),
  ),
  StoreModel(
    imgStore:
        'https://th.bing.com/th?id=OIP.rhMcFA3HOLw-r2F4ydA2EQHaFJ&w=299&h=208&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
    imgBackground:
        'https://th.bing.com/th/id/R.c7deb0f814f496dba3ad7e837889aeab?rik=oauwLKF5J0S5tA&pid=ImgRaw&r=0',
    name: 'Win Mart',
    isFavourite: false,
    category: pickRandomItems(DummyData.randomInt(1, categories.length)),
    rating: DummyData.randomDouble(3.0, 5.0),
    products: [],
    distance: DummyData.randomDouble(0.5, 20.0),
    import: false,
    isFamous: DummyData.randomBool(),
  ),
  StoreModel(
    imgStore:
        'https://cdn.freebiesupply.com/logos/large/2x/coop-1-logo-png-transparent.png',
    imgBackground:
        'https://images.baoquangnam.vn/dataimages/201709/original/images1380268_CO.OP_MART_TAM__KY_3.JPG',
    name: 'Coop Mart',
    isFavourite: false,
    category: pickRandomItems(DummyData.randomInt(1, categories.length)),
    rating: DummyData.randomDouble(3.0, 5.0),
    products: [],
    distance: DummyData.randomDouble(0.5, 20.0),
    import: false,
    isFamous: DummyData.randomBool(),
  ),
  StoreModel(
    imgStore:
        'https://th.bing.com/th/id/R.b52292d9ba6ca1ab47b895ac21746eae?rik=%2fUNw5ViX6kfZQw&riu=http%3a%2f%2fthucphamduchanh.com%2fwp-content%2fuploads%2f2016%2f10%2flan-chi.jpg&ehk=l12M%2bpHOfm8KGf6QPYnVdThrh8YvwoZW5ZcmCjz1u8A%3d&risl=&pid=ImgRaw&r=0',
    imgBackground:
        'https://th.bing.com/th/id/OIP.vHcWXk7bJn3IyKk4yct0LwHaFL?w=295&h=207&c=7&r=0&o=5&dpr=1.3&pid=1.7',
    name: 'Lan Chi Mart',
    isFavourite: false,
    category: pickRandomItems(DummyData.randomInt(1, categories.length)),
    rating: DummyData.randomDouble(3.0, 5.0),
    products: [],
    distance: DummyData.randomDouble(0.5, 20.0),
    import: false,
    isFamous: DummyData.randomBool(),
  ),
  StoreModel(
    imgStore:
        'https://th.bing.com/th/id/OIP.OHV7oMOukqYB6oasPVI0YQHaFG?rs=1&pid=ImgDetMain',
    imgBackground:
        'https://th.bing.com/th/id/OIP.gbNq0tbBDUmCdwM6d2MOrwHaE7?w=227&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
    name: 'Aeon Mall',
    isFavourite: false,
    category: pickRandomItems(DummyData.randomInt(1, categories.length)),
    rating: DummyData.randomDouble(3.0, 5.0),
    products: [],
    distance: DummyData.randomDouble(0.5, 20.0),
    import: false,
    isFamous: DummyData.randomBool(),
  ),
  StoreModel(
    imgStore:
        'https://th.bing.com/th?id=OIP.6nSoBQ4w_cfYoc7ANyYz-wAAAA&w=212&h=212&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
    imgBackground:
        'https://th.bing.com/th/id/OIP.J2BrW2c7ZgOC2kHvu73QSAHaEK?w=313&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
    name: 'Mega Mart',
    isFavourite: false,
    category: pickRandomItems(DummyData.randomInt(1, categories.length)),
    rating: DummyData.randomDouble(3.0, 5.0),
    products: [],
    distance: DummyData.randomDouble(0.5, 20.0),
    import: false,
    isFamous: DummyData.randomBool(),
  ),
  StoreModel(
    imgStore:
        'https://th.bing.com/th?id=OIP.883Dwbut3eSn63c8fjkCbwHaEd&w=322&h=193&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
    imgBackground:
        'https://th.bing.com/th/id/OIP.gTMP960uKQes3OrtLvyyZwHaFb?w=252&h=185&c=7&r=0&o=5&dpr=1.3&pid=1.7',
    name: 'Lotte Mart',
    isFavourite: false,
    category: pickRandomItems(DummyData.randomInt(1, categories.length)),
    rating: DummyData.randomDouble(3.0, 5.0),
    products: [],
    distance: DummyData.randomDouble(0.5, 20.0),
    import: false,
    isFamous: DummyData.randomBool(),
  ),
  StoreModel(
      imgStore:
          "https://scontent.fhan20-1.fna.fbcdn.net/v/t39.30808-1/290205270_1746628129024711_2742663194988418041_n.jpg?stp=dst-jpg_p320x320&_nc_cat=108&ccb=1-7&_nc_sid=596444&_nc_ohc=MBfbienF0sQAX9cF8CU&_nc_ht=scontent.fhan20-1.fna&oh=00_AfCLBbfx7WnZUiKWSLjQ2XD2bWAtwXqiyvt3WTtTFgO9kg&oe=65DDF17B",
      name: 'K - Market',
      isFavourite: false,
      imgBackground:
          'https://images.toplist.vn/images/800px/k-market-979195.jpg',
      category: pickRandomItems(DummyData.randomInt(1, categories.length)),
      rating: DummyData.randomDouble(3.0, 5.0),
      products: [],
      distance: DummyData.randomDouble(0.5, 20.0),
      import: true,
      isFamous: DummyData.randomBool())
];
