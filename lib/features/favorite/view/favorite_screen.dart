import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../translations/local_keys.g.dart';
import '../../common_widgets/product_details.dart';
import '../provider/favorite_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favoriteProducts = favoriteProvider.favoriteProducts;

    return favoriteProducts.isEmpty
        ? Center(
            child: Text(
              LocaleKeys.favoriteEmpty.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(12.w),
            itemCount: favoriteProducts.length,
            itemBuilder: (ctx, index) {
              final favoriteModel = favoriteProducts[index];
              return ProductDetails(
                productModel: favoriteModel,
                showFlushbar: (message) {
                  Flushbar(
                    message: message,
                    duration: const Duration(seconds: 3),
                    flushbarPosition: FlushbarPosition.TOP,
                    backgroundColor: Colors.black87,
                    margin: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(8),
                  ).show(context);
                },
              );
            },
          );
  }
}
