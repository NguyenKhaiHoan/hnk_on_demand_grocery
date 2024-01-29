// List<ProductModel> listProduct = [];

class ProductModel {
  String category;
  String name;
  String price;
  String salePersent;
  String priceSale;
  String imgPath;
  String imgStore;
  String nameStore;
  String unit;
  String countBuyed;
  int quantity;
  String status;

  ProductModel(
      {required this.category,
      required this.price,
      required this.salePersent,
      required this.priceSale,
      required this.imgPath,
      required this.name,
      required this.imgStore,
      required this.nameStore,
      required this.unit,
      required this.countBuyed,
      required this.quantity,
      required this.status});
}

List<String> categories = [
  'Trái cây',
  'Rau củ',
  'Thịt tươi',
  'Hải sản',
  'Trứng',
  'Sữa',
  'Gia vị',
  'Hạt',
  'Bánh mỳ',
  'Đồ uống',
  'Ăn vặt',
  'Mỳ & Gạo',
];

List<String> names = [
  'Bánh quy',
  'Nước ngọt',
  'Bột canh',
  'Táo',
  'Ổi',
  'Quýt',
  'Cam',
  'Bánh mỳ que',
  'Bim bim',
  'Nước mắm',
  'Sữa chua'
];

List<String> units = ['kg', 'cái', 'vỉ', 'chai', 'gói'];

List<String> imgPaths = [
  'https://img2.thuthuatphanmem.vn/uploads/2019/03/14/anh-qua-tao-dep-nhat_095349569.jpg',
  'https://cdn.tgdd.vn/Products/Images/3357/147616/bhx/files/banh-quy-bo-danisa.JPG',
  'https://i5.walmartimages.com/asr/90e2866c-0fe7-498e-a5b9-7d5230ffee10.7e305c0c3853c5eac918626757ca8a22.jpeg',
  'https://img.hoidap247.com/picture/question/20221023/large_1666496979569.jpg',
  'https://bizweb.dktcdn.net/thumb/grande/100/057/061/products/c289361347ee334f30a226c41d309810.jpg?v=1571540245050',
  'https://th.bing.com/th/id/R.290238b2d113277880ff8c7bb3d6b3cd?rik=8OuwW1%2fYZ54V7g&riu=http%3a%2f%2fnhaphanphoihangtieudung.net%2fupload%2fimages%2fnuoc-mam-chinsu-ca-hoi-500ml.jpg&ehk=l9NmOqVWfxtsb%2beCXJP1a2sFOu3KY46d2w19fTwHfqI%3d&risl=&pid=ImgRaw&r=0'
      'https://www.bing.com/images/search?view=detailV2&ccid=w5ShwRY%2f&id=6D02D402CD6141B7845A1FFB367489F45A6D5FCA&thid=OIP.w5ShwRY_AKL-D_UUf-EN8gHaHa&mediaurl=https%3a%2f%2fth.bing.com%2fth%2fid%2fR.c394a1c1163f00a2fe0ff5147fe10df2%3frik%3dyl9tWvSJdDb7Hw%26riu%3dhttp%253a%252f%252fvncmart.com%252fwp-content%252fuploads%252f2021%252f05%252f14a9276b8ade39b465ce5ad768c2cbd0.jpg%26ehk%3dxQVJyMEWbAwnqGeyqckrXZygbqMIfn%252bhgOWqj3xKD3U%253d%26risl%3d%26pid%3dImgRaw%26r%3d0&exph=1200&expw=1200&q=bim+bim+oishi&simid=608012471755896172&FORM=IRPRST&ck=F881E59040D980DF85BC04950942E368&selectedIndex=0&itb=0',
  'https://cdn1.concung.com/2022/04/56609-86029-large_mobile/sua-chua-vinamilk-co-duong-100g.jpg',
];

List<String> imgStores = [
  'https://yt3.ggpht.com/a-/AN66SAzssXbRK3evQCiAI0rVxNX8AtYYO2Q_50lQJg=s900-mo-c-c0xffffffff-rj-k-no',
  'https://th.bing.com/th?id=OIP.rhMcFA3HOLw-r2F4ydA2EQHaFJ&w=299&h=208&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
  'https://cdn.freebiesupply.com/logos/large/2x/coop-1-logo-png-transparent.png',
  'https://th.bing.com/th/id/R.b52292d9ba6ca1ab47b895ac21746eae?rik=%2fUNw5ViX6kfZQw&riu=http%3a%2f%2fthucphamduchanh.com%2fwp-content%2fuploads%2f2016%2f10%2flan-chi.jpg&ehk=l12M%2bpHOfm8KGf6QPYnVdThrh8YvwoZW5ZcmCjz1u8A%3d&risl=&pid=ImgRaw&r=0',
  'https://th.bing.com/th/id/OIP.OHV7oMOukqYB6oasPVI0YQHaFG?rs=1&pid=ImgDetMain'
      'https://th.bing.com/th?id=OIP.6nSoBQ4w_cfYoc7ANyYz-wAAAA&w=212&h=212&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
  'https://th.bing.com/th?id=OIP.883Dwbut3eSn63c8fjkCbwHaEd&w=322&h=193&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2'
];
