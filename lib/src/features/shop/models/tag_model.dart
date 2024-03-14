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
