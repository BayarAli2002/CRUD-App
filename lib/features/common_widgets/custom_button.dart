import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../translations/local_keys.g.dart';
import '../favorite/provider/favorite_provider.dart';
import '../home/model/product_model.dart';

class FavoriteButton extends StatelessWidget {
  final ProductModel productModel;
  final Function(String message) showFlushBar;

  const FavoriteButton({
    super.key,
    required this.productModel,
    required this.showFlushBar,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, _) {
        final isFav = favoriteProvider.isFavorite(productModel.id ?? '');
        return GestureDetector(
          onTap: () async {
            if (isFav) {
              await favoriteProvider.removeFavorite(productModel.id ?? '');
              showFlushBar(LocaleKeys.favorite_removed.tr());
            } else {
              await favoriteProvider.addFavorite(productModel);
              showFlushBar(LocaleKeys.favorite_added.tr());
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.7 * 255).round()),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            padding: EdgeInsets.all(8.w),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.black26,
              size: 28.sp,
            ),
          ),
        );
      },
    );
  }
}
