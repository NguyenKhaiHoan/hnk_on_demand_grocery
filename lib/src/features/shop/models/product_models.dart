// List<ProductModel> listProduct = [];

class ProductModel {
  int productId;
  int storeId;
  String category;
  String name;
  int price;
  int salePersent;
  int priceSale;
  String imgPath;
  String imgStore;
  String nameStore;
  String unit;
  int countBuyed;
  int quantity;
  String status;
  String wishlistName;
  double rating;
  String origin;

  ProductModel({
    required this.productId,
    required this.storeId,
    required this.category,
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
    required this.status,
    required this.wishlistName,
    required this.rating,
    required this.origin,
  });
}

List<String> categories = [
  'Trái cây',
  'Ăn vặt',
  'Bánh mỳ',
  'Đồ uống',
  'Mỳ, Gạo & Ngũ cốc',
  'Thực phẩm đông lạnh',
  'Làm bánh',
  'Chăm sóc cá nhân',
  'Đồ gia dụng',
  'Dành cho bé',
  'Rau củ',
  'Đồ hộp',
  'Sữa',
  'Thịt',
  'Cá & Hải sản',
  'Trứng',
  'Đồ nguội',
  'Dầu ăn & Gia vị'
];

List<String> names = [
  'Bánh quy',
  'Nước ngọt',
  'Bột canh',
  'Táo',
  'Cam',
  'Bim bim',
  'Nước mắm',
  'Sữa chua',
];

List<String> otherCountry = [
  'Trung Quốc',
  'Hàn Quốc',
  'Nhật Bản',
  'Thái Lan',
  'Lào',
  'Mỹ',
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
