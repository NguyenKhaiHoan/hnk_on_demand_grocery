class Tag {
  int id;
  String title;
  bool active;

  Tag(this.id, this.title, this.active);
}

List<Tag> tags = [
  Tag(0, 'Tất Cả', true),
  Tag(1, 'Gần đây', false),
  Tag(2, 'Cửa hàng nổi tiếng', false),
  Tag(3, 'Đánh giá cao', false),
];

List<Tag> tagsSearch = [
  Tag(0, 'Tất cả', false),
  Tag(1, 'Gần đây', false),
  Tag(2, 'Miễn phí giao hàng', false),
  Tag(3, 'Đánh giá cao', false),
];

List<Tag> tagsCategory = [
  Tag(0, 'Tất Cả', true),
  Tag(1, 'Trái cây', false),
  Tag(2, 'Rau củ', false),
  Tag(3, 'Thịt tươi', false),
  Tag(4, 'Hải sản', false),
  Tag(5, 'Trứng', false),
  Tag(6, 'Sữa', false),
  Tag(7, 'Gia vị', false),
  Tag(8, 'Hạt', false),
  Tag(9, 'Bánh mỳ', false),
  Tag(10, 'Đồ uống', false),
  Tag(11, 'Ăn vặt', false),
  Tag(12, 'Mỳ & Gạo', false),
];
