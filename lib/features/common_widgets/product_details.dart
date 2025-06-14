import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../home/model/product_model.dart';
import '../home/view/product_details/product_details_screen.dart';
import '../home/view/widgets/delete_button.dart';
import 'custom_button.dart';
import '../home/view/widgets/update_button.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel productModel;
  final Function(String message) showFlushbar;

  const ProductDetails({
    super.key,
    required this.productModel,
    required this.showFlushbar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(productId: productModel.id!),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: productModel.image ?? '',
                    width: double.infinity,
                    height: 200.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: double.infinity,
                        height: 200.h,
                        color: Colors.grey,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/placeholder.jpg",
                      width: double.infinity,
                      height: 200.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: DeleteButton(
                    productId: productModel.id!,
                    showFlushbar: showFlushbar,
                  ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: FavoriteButton(
                    productModel: productModel,
                    showFlushBar: showFlushbar,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: UpdateButton(productModel: productModel),
            ),
          ],
        ),
      ),
    );
  }
}
