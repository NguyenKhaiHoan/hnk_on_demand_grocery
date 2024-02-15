class Tag {
  int id;
  String title;
  bool active;

  Tag(this.id, this.title, {this.active = false});
}

List<Tag> tags = [
  Tag(0, 'Tất Cả', active: true),
  Tag(1, 'Gần đây'),
  Tag(2, 'Cửa hàng nổi tiếng'),
  Tag(3, 'Đánh giá cao'),
  Tag(4, 'Nhập Khẩu'),
  Tag(5, 'Tiệm Bánh'),
  Tag(6, 'Sữa'),
];

List<Tag> tagsSearch = [
  Tag(0, 'Tất cả'),
  Tag(1, 'Gần đây'),
  Tag(2, 'Miễn phí giao hàng'),
  Tag(3, 'Đánh giá cao'),
];
