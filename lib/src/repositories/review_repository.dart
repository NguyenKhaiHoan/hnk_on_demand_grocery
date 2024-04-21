import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_exception.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/review_model.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';

class ReviewRepository extends GetxController {
  static ReviewRepository get instance => Get.find();

  final db = FirebaseFirestore.instance;

  Future<List<ReviewModel>> getAllProductReviews(String productId) async {
    try {
      final snapshot = await db
          .collection('Reviews')
          .doc(productId)
          .collection('ProductReview')
          .limit(10)
          .get();
      final list = snapshot.docs
          .map((document) => ReviewModel.fromDocumentSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<void> updateReview(
      String productId, String reviewId, Map<String, dynamic> json) async {
    try {
      await db
          .collection('Reviews')
          .doc(productId)
          .collection('ProductReview')
          .doc(reviewId)
          .update(json);
    } catch (e) {
      throw 'Đã xảy ra sự cố. Không thể cập nhật lựa chọn đánh giá của bạn. Vui lòng thử lại sau.';
    }
  }

  Future<String> addAndFindIdForNewReview(
      String productId, ReviewModel rating) async {
    try {
      final newReview = await db
          .collection('Reviews')
          .doc(productId)
          .collection('ProductReview')
          .add(rating.toJson());
      return newReview.id;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<bool> checkUserReviewProductInOrder(
      String productId, String orderId) async {
    bool isReviewed = false;
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await db
          .collection('Reviews')
          .doc(productId)
          .collection('ProductReview')
          .where('UserId', isEqualTo: userId)
          .where('OrderId', isEqualTo: orderId)
          .get()
          .then((value) {
        value.size > 0 ? isReviewed = true : isReviewed = false;
      });
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
    return isReviewed;
  }

  Future<List<String>> uploadImage(String path, List<XFile> images) async {
    try {
      List<String> imageUrl = [];
      for (var image in images) {
        final ref = FirebaseStorage.instance.ref(path).child(image.name);
        await ref.putFile(File(image.path));
        final url = await ref.getDownloadURL();
        imageUrl.add(url);
      }
      return imageUrl;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  // Consumer<RatingProvider> ratingWidget(
  //     TextTheme textTheme, double height, double width) {
  //   return Consumer<RatingProvider>(builder: (context, productRating, child) {
  //     if (productRating.productPurchased == true) {
  //       return StreamBuilder(
  //           stream: RatingServices.fetchReview(
  //               productID: widget.productModel.productID!),
  //           builder: (context, snapshot) {
  //             if (snapshot.hasData) {
  //               if (productRating.userRatedTheProduct == false) {
  //                 return Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       'Review & Rating',
  //                       style: textTheme.bodyMedium!.copyWith(
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                     CommonFunctions.blankSpace(
  //                       height * 0.005,
  //                       0,
  //                     ),
  //                     Text(
  //                       'Review the Product',
  //                       style: textTheme.labelMedium!.copyWith(
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                     CommonFunctions.blankSpace(
  //                       height * 0.005,
  //                       0,
  //                     ),
  //                     Builder(builder: (context) {
  //                       if (productRating.productImages.isEmpty) {
  //                         return InkWell(
  //                           onTap: () {
  //                             context
  //                                 .read<RatingProvider>()
  //                                 .fetchProductImagesFromGallery(
  //                                     context: context);
  //                           },
  //                           child: Container(
  //                             height: height * 0.1,
  //                             width: width,
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(
  //                                 10,
  //                               ),
  //                             ),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 Icon(
  //                                   Icons.add_circle_outline,
  //                                   color: grey,
  //                                 ),
  //                                 Text(
  //                                   'Add Images',
  //                                   style: textTheme.bodyMedium!
  //                                       .copyWith(color: grey),
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         );
  //                       } else {
  //                         List<File> productImages =
  //                             productRating.productImages;
  //                         return GridView.builder(
  //                           shrinkWrap: true,
  //                           itemCount: productImages.length,
  //                           gridDelegate:
  //                               const SliverGridDelegateWithFixedCrossAxisCount(
  //                             crossAxisCount: 5,
  //                             mainAxisSpacing: 10,
  //                             crossAxisSpacing: 4,
  //                           ),
  //                           itemBuilder: (context, index) {
  //                             return Image(
  //                               image: FileImage(
  //                                 File(
  //                                   productImages[index].path,
  //                                 ),
  //                               ),
  //                               fit: BoxFit.contain,
  //                             );
  //                           },
  //                         );
  //                       }
  //                     }),
  //                     RatingBar(
  //                       initialRating: 0,
  //                       direction: Axis.horizontal,
  //                       allowHalfRating: true,
  //                       itemCount: 5,
  //                       itemSize: width * 0.07,
  //                       ratingWidget: RatingWidget(
  //                         full: Icon(
  //                           Icons.star,
  //                           color: amber,
  //                         ),
  //                         half: Icon(
  //                           Icons.star_half,
  //                           color: amber,
  //                         ),
  //                         empty: Icon(
  //                           Icons.star_outline_sharp,
  //                           color: amber,
  //                         ),
  //                       ),
  //                       itemPadding: EdgeInsets.zero,
  //                       onRatingUpdate: (rating) {
  //                         usersRating = rating;
  //                       },
  //                     ),
  //                     CommonFunctions.blankSpace(
  //                       height * 0.01,
  //                       0,
  //                     ),
  //                     TextField(
  //                       controller: reviewTextController,
  //                       decoration: InputDecoration(
  //                         hintText: 'Review here',
  //                         contentPadding: EdgeInsets.symmetric(
  //                           horizontal: width * 0.03,
  //                         ),
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(
  //                             10,
  //                           ),
  //                           borderSide: BorderSide(
  //                             color: grey,
  //                           ),
  //                         ),
  //                         enabledBorder: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(
  //                             10,
  //                           ),
  //                           borderSide: BorderSide(
  //                             color: grey,
  //                           ),
  //                         ),
  //                         disabledBorder: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(
  //                             10,
  //                           ),
  //                           borderSide: BorderSide(
  //                             color: grey,
  //                           ),
  //                         ),
  //                         focusedBorder: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(
  //                             10,
  //                           ),
  //                           borderSide: BorderSide(
  //                             color: amber,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     CommonFunctions.blankSpace(
  //                       height * 0.01,
  //                       0,
  //                     ),
  //                     ElevatedButton(
  //                       onPressed: () async {
  //                         Uuid uuid = const Uuid();
  //                         if (usersRating >= 0) {
  //                           if (context
  //                               .read<RatingProvider>()
  //                               .productImages
  //                               .isNotEmpty) {
  //                             await RatingServices.uploadImageToFirebaseStorage(
  //                               images: context
  //                                   .read<RatingProvider>()
  //                                   .productImages,
  //                               context: context,
  //                             );

  //                             ReviewModel reviewModel = ReviewModel(
  //                               rating: usersRating,
  //                               imagesURL: context
  //                                   .read<RatingProvider>()
  //                                   .productImagesURL,
  //                               reviewID: uuid.v1(),
  //                               review: reviewTextController.text.trim(),
  //                               userID: auth.currentUser!.phoneNumber!,
  //                             );
  //                             await RatingServices.addReview(
  //                               context: context,
  //                               productID: widget.productModel.productID!,
  //                               reviewModel: reviewModel,
  //                               userID: auth.currentUser!.phoneNumber!,
  //                             );
  //                           } else {
  //                             ReviewModel reviewModel = ReviewModel(
  //                               rating: usersRating,
  //                               imagesURL: context
  //                                   .read<RatingProvider>()
  //                                   .productImagesURL,
  //                               reviewID: uuid.v1(),
  //                               review: reviewTextController.text.trim(),
  //                               userID: auth.currentUser!.phoneNumber!,
  //                             );
  //                             await RatingServices.addReview(
  //                               context: context,
  //                               productID: widget.productModel.productID!,
  //                               reviewModel: reviewModel,
  //                               userID: auth.currentUser!.phoneNumber!,
  //                             );
  //                             context.read<RatingProvider>().reset();
  //                             setState(() {
  //                               usersRating = -1;
  //                             });
  //                             context.read<RatingProvider>().checkUserRating(
  //                                 productID: widget.productModel.productID!);
  //                             context
  //                                 .read<RatingProvider>()
  //                                 .checkProductPurchase(
  //                                     productID:
  //                                         widget.productModel.productID!);
  //                           }
  //                         } else {
  //                           CommonFunctions.showWarningToast(
  //                               context: context, message: 'Invalid Rating');
  //                         }
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         minimumSize: Size(
  //                           width,
  //                           height * 0.05,
  //                         ),
  //                         backgroundColor: amber,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(
  //                             10,
  //                           ),
  //                         ),
  //                       ),
  //                       child: Text(
  //                         'Submit Review',
  //                         style: textTheme.bodyMedium,
  //                       ),
  //                     ),
  //                     CommonFunctions.blankSpace(
  //                       height * 0.03,
  //                       0,
  //                     ),
  //                     StreamBuilder(
  //                         stream: RatingServices.fetchReview(
  //                             productID: widget.productModel.productID!),
  //                         builder: (context, snapshot) {
  //                           log('Total Ratings =  ${snapshot.data!.length}');
  //                           if (snapshot.hasData && snapshot.data!.isNotEmpty) {
  //                             List<ReviewModel> reviewData = snapshot.data!;
  //                             return ListView.builder(
  //                                 itemCount: reviewData.length,
  //                                 shrinkWrap: true,
  //                                 physics: const PageScrollPhysics(),
  //                                 itemBuilder: (context, index) {
  //                                   ReviewModel currentReview =
  //                                       reviewData[index];
  //                                   return Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: [
  //                                       if (currentReview.imagesURL!.isNotEmpty)
  //                                         SizedBox(
  //                                           height: height * 0.1,
  //                                           width: width,
  //                                           child: ListView.builder(
  //                                               physics:
  //                                                   const PageScrollPhysics(),
  //                                               itemCount: currentReview
  //                                                   .imagesURL!.length,
  //                                               scrollDirection:
  //                                                   Axis.horizontal,
  //                                               shrinkWrap: true,
  //                                               itemBuilder: (context, index) {
  //                                                 return Image(
  //                                                   image: NetworkImage(
  //                                                     currentReview
  //                                                         .imagesURL![index],
  //                                                   ),
  //                                                 );
  //                                               }),
  //                                         ),
  //                                       CommonFunctions.blankSpace(
  //                                         height * 0.005,
  //                                         0,
  //                                       ),
  //                                       RatingBar(
  //                                         initialRating: currentReview.rating,
  //                                         direction: Axis.horizontal,
  //                                         allowHalfRating: true,
  //                                         itemCount: 5,
  //                                         itemSize: width * 0.04,
  //                                         ignoreGestures: true,
  //                                         ratingWidget: RatingWidget(
  //                                           full: Icon(
  //                                             Icons.star,
  //                                             color: amber,
  //                                           ),
  //                                           half: Icon(
  //                                             Icons.star_half,
  //                                             color: amber,
  //                                           ),
  //                                           empty: Icon(
  //                                             Icons.star_outline_sharp,
  //                                             color: amber,
  //                                           ),
  //                                         ),
  //                                         itemPadding: EdgeInsets.zero,
  //                                         onRatingUpdate: (rating) {
  //                                           usersRating = rating;
  //                                         },
  //                                       ),
  //                                       CommonFunctions.blankSpace(
  //                                         height * 0.005,
  //                                         0,
  //                                       ),
  //                                       Text(
  //                                         currentReview.review!,
  //                                         style: textTheme.labelMedium,
  //                                       ),
  //                                       CommonFunctions.blankSpace(
  //                                         height * 0.02,
  //                                         0,
  //                                       ),
  //                                       const Divider()
  //                                     ],
  //                                   );
  //                                 });
  //                           }
  //                           if (snapshot.hasError) {
  //                             return const SizedBox();
  //                           } else {
  //                             return const SizedBox();
  //                           }
  //                         })
  //                   ],
  //                 );
  //               } else {
  //                 return Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       'Review & Rating ',
  //                       style: textTheme.bodyMedium!.copyWith(
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                     CommonFunctions.blankSpace(
  //                       height * 0.005,
  //                       0,
  //                     ),
  //                     StreamBuilder(
  //                         stream: RatingServices.fetchReview(
  //                             productID: widget.productModel.productID!),
  //                         builder: (context, snapshot) {
  //                           log('Total Ratings =  ${snapshot.data!.length}');
  //                           if (snapshot.hasData && snapshot.data!.isNotEmpty) {
  //                             List<ReviewModel> reviewData = snapshot.data!;
  //                             return ListView.builder(
  //                                 itemCount: reviewData.length,
  //                                 shrinkWrap: true,
  //                                 physics: const PageScrollPhysics(),
  //                                 itemBuilder: (context, index) {
  //                                   ReviewModel currentReview =
  //                                       reviewData[index];
  //                                   return Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: [
  //                                       if (currentReview.imagesURL!.isNotEmpty)
  //                                         SizedBox(
  //                                           height: height * 0.1,
  //                                           width: width,
  //                                           child: ListView.builder(
  //                                               physics:
  //                                                   const PageScrollPhysics(),
  //                                               itemCount: currentReview
  //                                                   .imagesURL!.length,
  //                                               scrollDirection:
  //                                                   Axis.horizontal,
  //                                               shrinkWrap: true,
  //                                               itemBuilder: (context, index) {
  //                                                 return Image(
  //                                                   image: NetworkImage(
  //                                                     currentReview
  //                                                         .imagesURL![index],
  //                                                   ),
  //                                                 );
  //                                               }),
  //                                         ),
  //                                       CommonFunctions.blankSpace(
  //                                         height * 0.005,
  //                                         0,
  //                                       ),
  //                                       RatingBar(
  //                                         initialRating: currentReview.rating,
  //                                         direction: Axis.horizontal,
  //                                         allowHalfRating: true,
  //                                         itemCount: 5,
  //                                         itemSize: width * 0.04,
  //                                         ignoreGestures: true,
  //                                         ratingWidget: RatingWidget(
  //                                           full: Icon(
  //                                             Icons.star,
  //                                             color: amber,
  //                                           ),
  //                                           half: Icon(
  //                                             Icons.star_half,
  //                                             color: amber,
  //                                           ),
  //                                           empty: Icon(
  //                                             Icons.star_outline_sharp,
  //                                             color: amber,
  //                                           ),
  //                                         ),
  //                                         itemPadding: EdgeInsets.zero,
  //                                         onRatingUpdate: (rating) {
  //                                           usersRating = rating;
  //                                         },
  //                                       ),
  //                                       CommonFunctions.blankSpace(
  //                                         height * 0.005,
  //                                         0,
  //                                       ),
  //                                       Text(
  //                                         currentReview.review!,
  //                                         style: textTheme.labelMedium,
  //                                       ),
  //                                       CommonFunctions.blankSpace(
  //                                         height * 0.02,
  //                                         0,
  //                                       ),
  //                                       const Divider()
  //                                     ],
  //                                   );
  //                                 });
  //                           }
  //                           if (snapshot.hasError) {
  //                             return const SizedBox();
  //                           } else {
  //                             return const SizedBox();
  //                           }
  //                         })
  //                   ],
  //                 );
  //               }
  //             }
  //             if (snapshot.hasError) {
  //               return SizedBox();
  //             } else {
  //               return const SizedBox();
  //             }
  //           });
  //     } else {
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Review & Rating',
  //             style: textTheme.bodyMedium!.copyWith(
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           CommonFunctions.blankSpace(
  //             height * 0.005,
  //             0,
  //           ),
  //           StreamBuilder(
  //               stream: RatingServices.fetchReview(
  //                   productID: widget.productModel.productID!),
  //               builder: (context, snapshot) {
  //                 log('Total Ratings =  ${snapshot.data!.length}');
  //                 if (snapshot.data!.isEmpty) {
  //                   return Text(
  //                     'No Ratings yet',
  //                     style: textTheme.labelMedium!.copyWith(color: grey),
  //                   );
  //                 }
  //                 if (snapshot.hasData && snapshot.data!.isNotEmpty) {
  //                   List<ReviewModel> reviewData = snapshot.data!;
  //                   return ListView.builder(
  //                       itemCount: reviewData.length,
  //                       shrinkWrap: true,
  //                       physics: const PageScrollPhysics(),
  //                       itemBuilder: (context, index) {
  //                         ReviewModel currentReview = reviewData[index];
  //                         return Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             if (currentReview.imagesURL!.isNotEmpty)
  //                               GridView.builder(
  //                                   physics: const PageScrollPhysics(),
  //                                   itemCount: currentReview.imagesURL!.length,
  //                                   gridDelegate:
  //                                       const SliverGridDelegateWithFixedCrossAxisCount(
  //                                           crossAxisCount: 5,
  //                                           mainAxisExtent: 10,
  //                                           crossAxisSpacing: 10),
  //                                   shrinkWrap: true,
  //                                   itemBuilder: (context, index) {
  //                                     return Image(
  //                                       image: NetworkImage(
  //                                         currentReview.imagesURL![index],
  //                                       ),
  //                                     );
  //                                   }),
  //                             CommonFunctions.blankSpace(
  //                               height * 0.005,
  //                               0,
  //                             ),
  //                             RatingBar(
  //                               initialRating: currentReview.rating,
  //                               direction: Axis.horizontal,
  //                               allowHalfRating: true,
  //                               itemCount: 5,
  //                               itemSize: width * 0.04,
  //                               ignoreGestures: true,
  //                               ratingWidget: RatingWidget(
  //                                 full: Icon(
  //                                   Icons.star,
  //                                   color: amber,
  //                                 ),
  //                                 half: Icon(
  //                                   Icons.star_half,
  //                                   color: amber,
  //                                 ),
  //                                 empty: Icon(
  //                                   Icons.star_outline_sharp,
  //                                   color: amber,
  //                                 ),
  //                               ),
  //                               itemPadding: EdgeInsets.zero,
  //                               onRatingUpdate: (rating) {
  //                                 usersRating = rating;
  //                               },
  //                             ),
  //                             CommonFunctions.blankSpace(
  //                               height * 0.005,
  //                               0,
  //                             ),
  //                             Text(
  //                               currentReview.review!,
  //                               style: textTheme.labelMedium,
  //                             ),
  //                             CommonFunctions.blankSpace(
  //                               height * 0.02,
  //                               0,
  //                             ),
  //                           ],
  //                         );
  //                       });
  //                 }
  //                 if (snapshot.hasError) {
  //                   return const SizedBox();
  //                 } else {
  //                   return const SizedBox();
  //                 }
  //               }),
  //           CommonFunctions.blankSpace(
  //             height * 0.01,
  //             0,
  //           ),
  //           CommonFunctions.divider(),
  //           CommonFunctions.blankSpace(
  //             height * 0.01,
  //             0,
  //           ),
  //         ],
  //       );
  //     }
  //   });
  // }
}
