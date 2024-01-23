import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/base/models/tag_model.dart';

class TagController extends GetxController {
  static TagController get instance => Get.find();

  void toggleActive(int index) {
    if (index != 0) {
      tags[index].active = !tags[index].active;
      if (tags[index].active == true) {
        tags[0].active = false;
      } else {
        var listNoActive = tags.where((tag) => tag.active == false);
        if (listNoActive.length == tags.length) {
          tags[0].active = true;
        }
      }
    }
  }

  List<Tag> tags = [
    Tag(0, 'Tất Cả', active: true),
    Tag(1, 'Xung quanh'),
    Tag(2, 'Thương hiệu nổi tiếng'),
    Tag(3, 'Nhà cung cấp lớn'),
    Tag(4, 'Đánh giá cao'),
    Tag(5, 'Nhập Khẩu'),
    Tag(6, 'Tiệm Bánh'),
    Tag(7, 'Rượu & Bia'),
    Tag(8, 'Sữa'),
    Tag(9, 'Đồ uống')
  ].obs;
}
