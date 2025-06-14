import 'package:crud_app/core/static_texts/language.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../translations/local_keys.g.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.teal.shade300,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal.shade400),
            child: Center(
              child: Text(
                LocaleKeys.appName.tr(),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 35.h),
                _buildLanguageButton(
                  context,
                  label: LocaleKeys.english.tr(),
                  locale: const Locale(Language.englishLocale),
                ),
                SizedBox(height: 12.h),
                _buildLanguageButton(
                  context,
                  label: LocaleKeys.arabic.tr(),
                  locale: const Locale(Language.arabicLocale),
                ),
                SizedBox(height: 12.h),
                _buildLanguageButton(
                  context,
                  label: LocaleKeys.kurdish.tr(),
                  locale: const Locale(Language.kurdishLocale),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context, {
    required String label,
    required Locale locale,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: () {
          context.setLocale(locale);
        },
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
