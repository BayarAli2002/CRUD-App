import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crud_app/translations/local_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../provider/product_provider.dart';
import '../../../favorite/provider/favorite_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String? productId;

  const ProductDetailsScreen({super.key,  this.productId});

  @override
  Widget build(BuildContext context) {
    // Fetch product if not already fetched
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    if (productProvider.selectedProduct?.id != productId) {
      productProvider.fetchProductById(productId ?? '');
    }

    return Scaffold(
      body: Consumer2<ProductProvider, FavoriteProvider>(
        builder: (context, productProvider, favoriteProvider, _) {
          final productDetailModel = productProvider.selectedProduct;

          if (productDetailModel == null) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }

          void showFlushbar(String message) {
            Flushbar(
              message: message,
              duration: const Duration(seconds: 3),
              flushbarPosition: FlushbarPosition.TOP,
              backgroundColor: Colors.black87,
              margin: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
            ).show(context);
          }

          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                children: [
                  // Image with buttons container
                  SizedBox(
                    height: 280.h,
                    child: Stack(
                      children: [
                        // Image Card
                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            imageUrl: productDetailModel.image ?? '',
                            width: double.infinity,
                            height: 280.h,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: double.infinity,
                                height: 280.h,
                                color: Colors.grey,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 280.h,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image, color: Colors.red, size: 50),
                            ),
                          ),
                        ),

                        // Delete button top-left


                        // Favorite button top-right
                        Positioned(
                          top: 12.h,
                          right: 12.w,
                          child: Material(
                            color: Colors.black45,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () async {
                                final isFav = favoriteProvider.isFavorite(productDetailModel.id ?? '');
                                if (isFav) {
                                  await favoriteProvider.removeFavorite(productDetailModel.id ?? '');
                                  showFlushbar(LocaleKeys.favorite_removed.tr());
                                } else {
                                  await favoriteProvider.addFavorite(productDetailModel);
                                  showFlushbar(LocaleKeys.favorite_added.tr());
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Icon(
                                  favoriteProvider.isFavorite(productDetailModel.id ?? '')
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: favoriteProvider.isFavorite(productDetailModel.id ?? '') ? Colors.red : Colors.white,
                                  size: 28.sp,
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Product title & price row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          productDetailModel.title ?? '',
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade600,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          '${productDetailModel.price} USD',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  Divider(color: Colors.grey.shade300, thickness: 2),

                  SizedBox(height: 12.h),

                  Text(
                    productDetailModel.id ?? '',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  Text(
                    LocaleKeys.description.tr(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Text(
                    productDetailModel.description ?? '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 80.h), // Add some bottom padding for FAB space
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
