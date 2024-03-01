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

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  late List<Tag> tagsCategory;

  Future<void> fetchCategories() async {
    try {
      print('vào fetch');
      isLoading.value = true;
      final categories = await categoryRepository.getAllCategories();
      listOfCategory.assignAll(categories);
      isLoading.value = false;
      print('xong fetch');
    } catch (e) {
      isLoading.value = false;
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }
}
