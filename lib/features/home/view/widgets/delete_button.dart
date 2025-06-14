import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../translations/local_keys.g.dart';
import '../../provider/product_provider.dart';

class DeleteButton extends StatelessWidget {
  final String productId;
  final Function(String message) showFlushbar;

  const DeleteButton({
    super.key,
    required this.productId,
    required this.showFlushbar,
  });

  Future<void> _confirmAndDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          LocaleKeys.confirm_delete_title.tr(),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700,
          ),
        ),
        content: Text(
          LocaleKeys.confirm_delete_message.tr(),
          style: TextStyle(fontSize: 16.sp, color: Colors.black87),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              LocaleKeys.no.tr(),
              style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              LocaleKeys.yes.tr(),
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      if (!context.mounted) return;
      final provider = Provider.of<ProductProvider>(context, listen: false);
      await provider.deleteProduct(productId);
      showFlushbar(LocaleKeys.productDeleted.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirmAndDelete(context),
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
        child: Icon(Icons.delete_outline, color: Colors.black26, size: 28.sp),
      ),
    );
  }
}
