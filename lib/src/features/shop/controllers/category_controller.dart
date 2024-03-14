import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/category_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/tag_model.dart';
import 'package:on_demand_grocery/src/repositories/category_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final categoryRepository = Get.put(CategoryRepository());

  var isLoading = false.obs;
  var listOfCategory = <CategoryModel>[].obs;
  var tagsCategory = <Tag>[];

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final categories = await categoryRepository.getAllCategories();
      listOfCategory.assignAll(categories);
      tagsCategory =
          categories.map((e) => Tag(int.parse(e.id), e.name, false)).toList();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }
}
