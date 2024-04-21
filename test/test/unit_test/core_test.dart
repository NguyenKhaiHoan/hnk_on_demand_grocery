import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/data/dummy_data.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/features/personalization/models/user_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/category_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_address_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_note_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/voucher_model.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import '../../controllers/cart_controller_test.dart';
import '../../controllers/order_controller_test.dart';
import '../../controllers/type_button_controller_test.dart';
import '../../controllers/voucher_controller_test.dart';
import '../../repositories/address_repository_test.dart';
import '../../repositories/category_repository_test.dart';
import '../../repositories/order_repository_test.dart';
import '../../repositories/product_repository_test.dart';
import '../../repositories/store_repository_test.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';

import '../../repositories/user_repository_test.dart';
import '../../repositories/voucher_repository_test.dart';

void main() {
  group('Core test', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirebaseDatabase firebaseDatabase;

    late CategoryRepositoryTest categoryRepository;
    late StoreRepositoryTest storeRepository;
    late ProductRepositoryTest productRepository;
    late UserRepositoryTest userRepositoryTest;
    late AddressRepositoryTest addressRepositoryTest;
    late VoucherRepositoryTest voucherRepositoryTest;
    late OrderRepositoryTest orderRepositoryTest;

    late CartControllerTest cartController;
    late TypeButtonControllerTest typeButtonControllerTest;
    late VoucherControllerTest voucherControllerTest;
    late OrderControllerTest orderControllerTest;

    late ProductModel product0;
    late ProductModel product1;
    late ProductModel product2;

    late UserModel currentUser;
    late AddressModel currentUserAddress;

    setUpAll(() async {
      fakeFirestore = FakeFirebaseFirestore();
      firebaseDatabase = MockFirebaseDatabase.instance;
      categoryRepository = CategoryRepositoryTest(db: fakeFirestore);
      var categories = DummyData.getAllCategory();
      for (var category in categories) {
        await fakeFirestore.collection('Categories').add(category.toJson());
      }

      storeRepository = StoreRepositoryTest(db: fakeFirestore);
      Get.put(StoreRepositoryTest(db: fakeFirestore));
      var stores = DummyData.getAllStore(categories);
      for (var store in stores) {
        await fakeFirestore.collection('Stores').add(store.toJson());
      }

      addressRepositoryTest = AddressRepositoryTest(db: fakeFirestore);
      Get.put(AddressRepositoryTest(db: fakeFirestore));
      for (var store in stores) {
        var storeAddress = StoreAddressModel(
            id: '',
            district: '',
            ward: '',
            street: '',
            latitude: 0,
            longitude: 0);
        await fakeFirestore
            .collection('Stores')
            .doc(store.id)
            .collection('Addresses')
            .add(storeAddress.toJson());
      }

      productRepository = ProductRepositoryTest(db: fakeFirestore);
      var products = DummyData.getAllProducts(stores);
      for (var product in products) {
        await fakeFirestore.collection('Products').add(product.toJson());
      }

      Get.put(VoucherRepositoryTest(db: fakeFirestore));
      voucherControllerTest = Get.put(VoucherControllerTest());

      typeButtonControllerTest = Get.put(TypeButtonControllerTest());

      cartController =
          Get.put(CartControllerTest(firebaseDatabase: firebaseDatabase));
      cartController.clearCart();

      currentUser = UserModel(
          id: '1',
          name: 'Nguyễn Khải Hoàn',
          email: '',
          phoneNumber: '',
          profileImage: '',
          creationDate: '',
          authenticationBy: '');

      userRepositoryTest = UserRepositoryTest(db: fakeFirestore);
      userRepositoryTest.saveUserRecord(currentUser);

      voucherRepositoryTest = VoucherRepositoryTest(db: fakeFirestore);
      var vouchers = DummyData.getAllVoucher();
      for (var voucher in vouchers) {
        await fakeFirestore.collection('Vouchers').add(voucher.toJson());
      }

      orderRepositoryTest = OrderRepositoryTest(db: fakeFirestore);
      Get.put(OrderRepositoryTest(db: fakeFirestore));
      orderControllerTest = Get.put(OrderControllerTest());

      product0 = ProductModel(
          id: '2',
          name: 'Chuối',
          image: 'assets/products/Vegetables/Red-Beet_Iconic.jpg',
          categoryId: '13',
          description:
              'Conduco indux, ire ago sermo. Labia pre. Quos vinco audio.',
          status: 'Tạm hết hàng',
          price: 531000,
          salePersent: 39,
          priceSale: 324000,
          unit: 'cái',
          countBuyed: 401,
          rating: 4.647663521336262,
          origin: 'Việt Nam',
          storeId: '0',
          uploadTime: DateTime.fromMillisecondsSinceEpoch(1713546795716));
      product1 = ProductModel(
          id: '8',
          name: 'Xuân đào',
          image:
              'assets/products/Packages/Arla-Natural-Mild-Low-Fat-Yoghurt_Iconic.jpg',
          categoryId: '15',
          description:
              'At, pueriliter cito adnuo audio cessum hactenus. Denuo estus pulsus.',
          status: 'Còn hàng',
          price: 64000,
          salePersent: 82,
          priceSale: 12000,
          unit: 'kg',
          countBuyed: 171,
          rating: 4.350499409202966,
          origin: 'Việt Nam',
          storeId: '0',
          uploadTime: DateTime.fromMillisecondsSinceEpoch(1712250795718));
      product2 = ProductModel(
          id: '1',
          name: 'Bơ',
          image: 'assets/products/Fruit/Pink-Lady_Iconic.jpg',
          categoryId: '14',
          description:
              'Mane explicatus ut. Vicissitudo tardus pulvis putesco usque edi dives.',
          status: 'Còn hàng',
          price: 885000,
          salePersent: 31,
          priceSale: 611000,
          unit: 'vỉ',
          countBuyed: 455,
          rating: 3.7068188591066975,
          origin: 'Nhật Bản',
          storeId: '1',
          uploadTime: DateTime.fromMillisecondsSinceEpoch(1712769195716));
    });

    group('Get data', () {
      test('Get all categories', () async {
        final categories = await categoryRepository.getAllCategories();

        expect(categories, isA<List<CategoryModel>>());
        expect(categories.length, 18);
      });

      test('Get all stores', () async {
        final stores = await storeRepository.getAllStores();

        expect(stores, isA<List<StoreModel>>());
        expect(stores.length, 2);
      });

      test('Get all products (10 products)', () async {
        final products = await productRepository.getAllProducts();

        expect(products, isA<List<ProductModel>>());
        expect(products.length, 10);
      });

      test('Get all vouchers', () async {
        final vouchers =
            await voucherRepositoryTest.getAllGroFastVoucher(currentUser.id);

        expect(vouchers, isA<List<VoucherModel>>());
        expect(vouchers.length, 3);
      });
    });

    group('Order', () {
      test('Add products in cart', () {
        // Check cart is empty
        expect(cartController.cartProducts.length, 0);

        // Add a product that are temporarily out of stock
        cartController.addToCart(product0);

        // Check the number of quantity and products in the cart
        expect(cartController.numberOfCart.value, 0);
        expect(cartController.cartProducts.length, 0);

        // Add product in  with availability
        cartController.addToCart(product1);
        cartController.addToCart(product2);

        // Check the number of quantity and products in the cart
        expect(cartController.numberOfCart.value, 2);
        expect(cartController.cartProducts.length, 2);
      });

      test('Change quantity of a product or remove a product in cart', () {
        // Change the quantity of product1 from 1 to 3
        var product1InCart = cartController.convertToCartProduct(product1, 1);
        cartController.addSingleProductInCart(product1InCart);
        cartController.addSingleProductInCart(product1InCart);

        // Remove product2
        var product2InCart = cartController.convertToCartProduct(product2, 1);
        cartController.removeSingleProductInCart(product2InCart);

        // Check the number of quantity and products in the cart
        expect(cartController.numberOfCart.value, 3);
        expect(cartController.cartProducts.length, 1);
      });

      group('Enable/disable payment for products in the cart', () {
        test('Disable payment', () {
          // First product in cart
          var product = cartController.cartProducts.first;

          // Disable payment
          cartController.storeOrderMap[product.storeId]!.checkChooseInCart =
              false;
          cartController.calculateCart();

          expect(cartController.totalCartPrice.value, 0);
          expect(cartController.numberOfCart.value, 0);
        });

        test('Enable payment', () {
          // First product in cart
          var product = cartController.cartProducts.first;

          // Enable payment
          cartController.storeOrderMap[product.storeId]!.checkChooseInCart =
              true;
          cartController.calculateCart();

          expect(cartController.totalCartPrice.value, 36000);
          expect(cartController.numberOfCart.value, 3);
        });
      });

      test(
          'Add/remove a note to the store where the product needs to be ordered',
          () {
        // First product in cart
        var product = cartController.cartProducts.first;

        // Add note
        StoreOrderModel storeOrder =
            cartController.storeOrderMap[product.storeId]!;
        storeOrder.note = 'Chu y HSD';

        expect(
            cartController.storeOrderMap[product.storeId]!.note, 'Chu y HSD');

        // // Remove note
        // storeOrder.note = '';
        // expect(cartController.storeOrderMap[product.storeId]!.note, '');
      });

      test('Add and choose new address', () async {
        currentUserAddress = AddressModel(
            id: '',
            city: "Hà Nội",
            district: "Huyện Thanh Trì",
            latitude: 20.980754958045633,
            longitude: 105.79708456993103,
            name: "Nguyễn Khải Hoàn",
            phoneNumber: "0388586955",
            selectedAddress: true,
            street: "Số nhà 25, ngõ 143, đường Chiến Thắng",
            ward: "Xã Tân Triều");

        await addressRepositoryTest.addAndFindIdForNewAddress(
            currentUserAddress, currentUser.id);

        var addresses =
            await addressRepositoryTest.getAllUserAddress(currentUser.id);
        var address = addresses.first;
        expect(address, currentUserAddress);
      });

      group('Select delivery method', () {
        test('Use priority delivery method', () {
          typeButtonControllerTest.setType('uu_tien', true);

          expect(cartController.getTotalPrice(), 51000);
        });

        test('Use standard delivery method', () {
          typeButtonControllerTest.setType('tieu_chuan', true);

          expect(cartController.getTotalPrice(), 41000);
        });

        test('Use the scheduled delivery method with peak hours', () {
          typeButtonControllerTest.setType('dat_lich', true);
          typeButtonControllerTest.setTimeType('16:00 - 17:00');

          expect(cartController.getTotalPrice(), 46000);
        });

        test('Use the scheduled delivery method without peak hours', () {
          typeButtonControllerTest.setType('dat_lich', true);
          typeButtonControllerTest.setTimeType('14:00 - 15:00');
          cartController.calculateCart();

          expect(cartController.getTotalPrice(), 41000);
        });
      });

      group('Select a payment method', () {
        setUp(() {
          typeButtonControllerTest.setType('tieu_chuan', true);
        });

        test('Use cash', () {
          typeButtonControllerTest.setType('tien_mat', false);
        });

        test('Use credit card', () {
          typeButtonControllerTest.setType('tin_dung', false);
        });
      });

      group('Select a voucher', () {
        test('Use a voucher with a minimum value greater than the cart price',
            () async {
          var vouchers =
              await voucherRepositoryTest.getAllGroFastVoucher(currentUser.id);
          var voucher =
              vouchers.firstWhere((voucher) => voucher.name == 'DEMOSALE20');
          await voucherControllerTest.checkVoucherButton(
              voucher,
              voucher.name,
              cartController.totalCartPrice.value,
              cartController.cartProducts,
              currentUser.id);

          expect(voucherControllerTest.checkVoucherText.value,
              'Mã ưu đãi này không được áp dụng do không đủ điểu kiện.');
        });

        test('Use a voucher', () async {
          var vouchers =
              await voucherRepositoryTest.getAllGroFastVoucher(currentUser.id);
          var voucher =
              vouchers.firstWhere((voucher) => voucher.name == 'DEMOSALE30');
          await voucherControllerTest.checkVoucherButton(
              voucher,
              voucher.name,
              cartController.totalCartPrice.value,
              cartController.cartProducts,
              currentUser.id);

          var discountCost = HAppUtils.roundValue(
              (cartController.totalCartPrice.value *
                      (voucher.discountValue / 100))
                  .floor());
          expect(voucherControllerTest.checkVoucherText.value, 'Success');
          expect(voucherControllerTest.selectedVoucher.value, voucher.name);
          expect(voucherControllerTest.useVoucher.value.name, voucher.name);
          expect(cartController.getDiscountCost(), discountCost);
        });
      });

      test('Place an order', () async {
        // Reset all
        typeButtonControllerTest.setType('', true);
        typeButtonControllerTest.setType('', false);
        typeButtonControllerTest.setTimeType('');
        voucherControllerTest.resetVoucher();

        typeButtonControllerTest.setType('tieu_chuan', true);
        typeButtonControllerTest.setType('tien_mat', false);
        var vouchers =
            await voucherRepositoryTest.getAllGroFastVoucher(currentUser.id);
        var voucher =
            vouchers.firstWhere((voucher) => voucher.name == 'DEMOSALE30');
        await voucherControllerTest.checkVoucherButton(
            voucher,
            voucher.name,
            cartController.totalCartPrice.value,
            cartController.cartProducts,
            currentUser.id);

        cartController.calculateCart();

        var addresses =
            await addressRepositoryTest.getAllUserAddress(currentUser.id);
        var selectAddress =
            addresses.firstWhere((address) => address.selectedAddress);
        await orderControllerTest.processOrder(currentUser, selectAddress);

        expect(orderControllerTest.statusOrder.value,
            'Đã xong kiểm tra các điều kiện đơn hàng');
        expect(cartController.status.value, 'Đặt hàng thành công');
      });
    });

    group('Search for products by name', () {
      test('No products found', () async {
        var list = await productRepository.getSearchAllProducts('demo');

        expect(list.isNotEmpty, false);
      });

      test('Product found', () async {
        var list = await productRepository.getSearchAllProducts('Chanh');

        expect(list.isNotEmpty, true);
      });
    });
  });
}
