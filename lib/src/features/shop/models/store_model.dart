import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  String storeImage;
  String storeImageBackground;
  String description;
  List<String> listOfCategoryId;
  double rating;
  bool import;
  bool isFamous;
  int productCount;
  bool isOnline;

  StoreModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.phoneNumber,
      this.storeImage = '',
      this.storeImageBackground = '',
      required this.description,
      required this.listOfCategoryId,
      required this.rating,
      required this.import,
      required this.isFamous,
      required this.productCount,
      this.isOnline = false});

  static StoreModel empty() => StoreModel(
        id: '',
        name: '',
        email: '',
        phoneNumber: '',
        storeImage: '',
        storeImageBackground: '',
        description: '',
        listOfCategoryId: [],
        rating: 5.0,
        import: false,
        isFamous: false,
        productCount: 0,
      );

  Map<String, dynamic> toJon() {
    return {
      'Id': id,
      'Name': name,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'StoreImage': storeImage,
      'StoreImageBackground': storeImageBackground,
      'Description': description,
      'ListOfCategoryId': listOfCategoryId,
      'Rating': rating,
      'Import': import,
      'IsFamous': isFamous,
      'ProductCount': productCount,
      'IsOnline': isOnline,
    };
  }

  factory StoreModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StoreModel(
        id: document.id,
        name: data['Name'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        storeImage: data['StoreImage'] ?? '',
        storeImageBackground: data['StoreImageBackground'] ?? '',
        description: data['Description'] ?? '',
        listOfCategoryId: data['ListOfCategoryId'] != null
            ? List<String>.from(data['ListOfCategoryId'])
            : [],
        rating: double.parse((data['Rating'] ?? 5.0).toString()),
        import: data['Import'] ?? false,
        isFamous: data['IsFamous'] ?? false,
        productCount: int.parse((data['ProductCount'] ?? 0).toString()),
        isOnline: data['IsOnline'] ?? false);
  }
}


// final listStore = [
//   StoreModel(
//     imageStore:
//         'https://yt3.ggpht.com/a-/AN66SAzssXbRK3evQCiAI0rVxNX8AtYYO2Q_50lQJg=s900-mo-c-c0xffffffff-rj-k-no',
//     imageBackground:
//         'https://th.bing.com/th/id/R.ee18a6f92ca5084015368ca41a226eb4?rik=hfph0qMOoUNGNQ&pid=ImgRaw&r=0',
//     name: 'Big C',
//     listOfCategoryId: pickRandomItems(DummyData.randomInt(10, 18)),
//     rating: DummyData.randomDouble(3.0, 5.0),
//     import: DummyData.randomBool(),
//     isFamous: DummyData.randomBool(),
//     id: '0',
//     productCount: 0,
//   ),
//   StoreModel(
//     imageStore:
//         'https://th.bing.com/th?id=OIP.rhMcFA3HOLw-r2F4ydA2EQHaFJ&w=299&h=208&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
//     imageBackground:
//         'https://th.bing.com/th/id/R.c7deb0f814f496dba3ad7e837889aeab?rik=oauwLKF5J0S5tA&pid=ImgRaw&r=0',
//     name: 'Win Mart',
//     listOfCategoryId: pickRandomItems(DummyData.randomInt(1, 18)),
//     rating: DummyData.randomDouble(3.0, 5.0),
//     import: DummyData.randomBool(),
//     isFamous: DummyData.randomBool(),
//     id: '1',
//     productCount: 0,
//   ),
//   StoreModel(
//     imageStore:
//         'https://cdn.freebiesupply.com/logos/large/2x/coop-1-logo-png-transparent.png',
//     imageBackground:
//         'https://images.baoquangnam.vn/dataimages/201709/original/images1380268_CO.OP_MART_TAM__KY_3.JPG',
//     name: 'Coop Mart',
//     listOfCategoryId: pickRandomItems(DummyData.randomInt(1, 18)),
//     rating: DummyData.randomDouble(3.0, 5.0),
//     import: DummyData.randomBool(),
//     isFamous: DummyData.randomBool(),
//     id: '2',
//     productCount: 0,
//   ),
//   StoreModel(
//     imageStore:
//         'https://th.bing.com/th/id/R.b52292d9ba6ca1ab47b895ac21746eae?rik=%2fUNw5ViX6kfZQw&riu=http%3a%2f%2fthucphamduchanh.com%2fwp-content%2fuploads%2f2016%2f10%2flan-chi.jpg&ehk=l12M%2bpHOfm8KGf6QPYnVdThrh8YvwoZW5ZcmCjz1u8A%3d&risl=&pid=ImgRaw&r=0',
//     imageBackground:
//         'https://th.bing.com/th/id/OIP.vHcWXk7bJn3IyKk4yct0LwHaFL?w=295&h=207&c=7&r=0&o=5&dpr=1.3&pid=1.7',
//     name: 'Lan Chi Mart',
//     listOfCategoryId: pickRandomItems(DummyData.randomInt(1, 18)),
//     rating: DummyData.randomDouble(3.0, 5.0),
//     import: DummyData.randomBool(),
//     isFamous: DummyData.randomBool(),
//     id: '3',
//     productCount: 0,
//   ),
//   StoreModel(
//     imageStore:
//         'https://th.bing.com/th/id/OIP.OHV7oMOukqYB6oasPVI0YQHaFG?rs=1&pid=ImgDetMain',
//     imageBackground:
//         'https://th.bing.com/th/id/OIP.gbNq0tbBDUmCdwM6d2MOrwHaE7?w=227&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
//     name: 'Aeon Mall',
//     listOfCategoryId: pickRandomItems(DummyData.randomInt(1, 18)),
//     rating: DummyData.randomDouble(3.0, 5.0),
//     import: DummyData.randomBool(),
//     isFamous: DummyData.randomBool(),
//     id: '4',
//     productCount: 0,
//   ),
//   StoreModel(
//     imageStore:
//         'https://th.bing.com/th?id=OIP.6nSoBQ4w_cfYoc7ANyYz-wAAAA&w=212&h=212&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
//     imageBackground:
//         'https://th.bing.com/th/id/OIP.J2BrW2c7ZgOC2kHvu73QSAHaEK?w=313&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
//     name: 'Mega Mart',
//     listOfCategoryId: pickRandomItems(DummyData.randomInt(1, 18)),
//     rating: DummyData.randomDouble(3.0, 5.0),
//     import: DummyData.randomBool(),
//     isFamous: DummyData.randomBool(),
//     id: '5',
//     productCount: 0,
//   ),
//   StoreModel(
//     imageStore:
//         'https://th.bing.com/th?id=OIP.883Dwbut3eSn63c8fjkCbwHaEd&w=322&h=193&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
//     imageBackground:
//         'https://th.bing.com/th/id/OIP.gTMP960uKQes3OrtLvyyZwHaFb?w=252&h=185&c=7&r=0&o=5&dpr=1.3&pid=1.7',
//     name: 'Lotte Mart',
//     listOfCategoryId: pickRandomItems(DummyData.randomInt(1, 18)),
//     rating: DummyData.randomDouble(3.0, 5.0),
//     import: DummyData.randomBool(),
//     isFamous: DummyData.randomBool(),
//     id: '6',
//     productCount: 0,
//   ),
//   StoreModel(
//     imageStore:
//         "https://www.capitaland.com/content/dam/capitaland-sites/singapore/shop/malls/bukit-panjang-plaza/tenants/BPP%20K-market.jpg.transform/cap-midres/image.jpg",
//     name: 'K - Market',
//     imageBackground:
//         'https://images.toplist.vn/images/800px/k-market-979195.jpg',
//     listOfCategoryId: pickRandomItems(DummyData.randomInt(1, 18)),
//     rating: DummyData.randomDouble(3.0, 5.0),
//     import: true,
//     isFamous: DummyData.randomBool(),
//     id: '7',
//     productCount: 0,
//   ),
//   StoreModel(
//     imageStore:
//         'https://timesamui.com/upload/places/62/01/tops-market-lg.jpg?1548769656',
//     imageBackground:
//         'https://assets.brandinside.asia/uploads/2021/03/1615451070356.jpg',
//     name: 'Top Market',
//     listOfCategoryId: pickRandomItems(DummyData.randomInt(1, 18)),
//     rating: DummyData.randomDouble(3.0, 5.0),
//     import: DummyData.randomBool(),
//     isFamous: DummyData.randomBool(),
//     id: '8',
//     productCount: 0,
//   )
// ];
