class Tag {
  int id;
  String title;
  bool active;

  Tag(this.id, this.title, this.active);
}

List<Tag> tags = [
  Tag(0, 'Gần đây', false),
  Tag(1, 'Cửa hàng nổi tiếng', false),
  Tag(2, 'Đánh giá cao', false),
  Tag(3, 'Nhập khẩu', false)
];

List<Tag> tagsCategory = [
  Tag(0, 'Trái cây', false),
  Tag(1, 'Ăn vặt', false),
  Tag(2, 'Bánh mỳ', false),
  Tag(3, 'Đồ uống', false),
  Tag(4, 'Mỳ, Gạo & Ngũ cốc', false),
  Tag(5, 'Thực phẩm đông lạnh', false),
  Tag(6, 'Làm bánh', false),
  Tag(7, 'Chăm sóc cá nhân', false),
  Tag(8, 'Đồ gia dụng', false),
  Tag(9, 'Dành cho bé', false),
  Tag(10, 'Rau củ', false),
  Tag(11, 'Đồ hộp', false),
  Tag(12, 'Sữa', false),
  Tag(13, 'Thịt', false),
  Tag(14, 'Cá & Hải sản', false),
  Tag(15, 'Trứng', false),
  Tag(16, 'Đồ nguội', false),
  Tag(17, 'Dầu ăn & Gia vị', false),
];

List<Tag> tagsSearch = [
  Tag(0, 'Tất cả', true),
  Tag(1, 'Gần đây', false),
  Tag(2, 'Miễn phí giao hàng', false),
  Tag(3, 'Đánh giá cao', false),
];

List<Tag> tagsProduct = [
  Tag(0, 'Gần đây', false),
  Tag(1, 'Đánh giá cao', false),
  Tag(2, 'Nhập khẩu', false)
];
