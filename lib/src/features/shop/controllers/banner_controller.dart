import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/banner_model.dart';
import 'package:on_demand_grocery/src/repositories/banner_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find();

  final CarouselController controller = CarouselController();
  var currentIndex = 0.obs;

  onPageChanged(int index) {
    currentIndex.value = index;
    update();
  }

  final bannerRepository = Get.put(BannerRepository());

  var isLoading = false.obs;
  var listOfBanner = <BannerModel>[].obs;

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      final banners = await bannerRepository.getAllBanners();
      listOfBanner.assignAll(banners);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }
}
