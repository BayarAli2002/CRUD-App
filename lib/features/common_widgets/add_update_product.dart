import 'package:another_flushbar/flushbar.dart'; // <-- import flushbar
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // <-- import
import 'package:provider/provider.dart';

import '../../translations/local_keys.g.dart';
import '../home/provider/product_provider.dart';
import '../home/model/product_model.dart';

class AddUpdateProductScreen extends StatefulWidget {
  final ProductModel? product; // Nullable product for edit mode

  const AddUpdateProductScreen({super.key, this.product});

  @override
  State<AddUpdateProductScreen> createState() => _AddUpdateProductScreenState();
}

class _AddUpdateProductScreenState extends State<AddUpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // If editing, fill the fields with the passed product data
    if (widget.product != null) {
      _idController.text = widget.product!.id ?? '';
      _titleController.text = widget.product!.title ?? '';
      _priceController.text = widget.product!.price?.toString() ?? '';
      _descriptionController.text = widget.product!.description ?? '';
      _imageUrlController.text = widget.product!.image ?? '';
    }
  }

  Future<void> _showFlushbar(String message, {bool isError = false}) async {
    return Flushbar(
      message: message,
      backgroundColor: isError ? Colors.redAccent : Colors.teal,
      margin: EdgeInsets.all(8.w),
      borderRadius: BorderRadius.circular(12.r),
      duration: const Duration(seconds: 1),
      flushbarPosition: FlushbarPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 500),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
    ).show(context);
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = ProductModel(
        title: _titleController.text,
        price: int.tryParse(_priceController.text),
        description: _descriptionController.text,
        image: _imageUrlController.text,
      );

      try {
        await Provider.of<ProductProvider>(
          context,
          listen: false,
        ).addProduct(product);
        if (!mounted) return; // Check if widget is still mounted
        Navigator.of(context).pop();
        await _showFlushbar(LocaleKeys.product_added.tr());
        _clearFields();
      } catch (e) {
        await _showFlushbar(
          '${LocaleKeys.add_failed.tr()} $e'.tr(),
          isError: true,
        );
      }
    }
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      final id = _idController.text.trim();
      if (id.isEmpty) {
        _showFlushbar(
          LocaleKeys.enter_product_id_to_update.tr(),
          isError: true,
        );
        return;
      }

      final product = ProductModel(
        id: id,
        title: _titleController.text,
        price: int.tryParse(_priceController.text),
        description: _descriptionController.text,
        image: _imageUrlController.text,
      );

      try {
        await Provider.of<ProductProvider>(
          context,
          listen: false,
        ).updateProduct(id, product);
        if (!mounted) return; // Check if widget is still mounted
        Navigator.of(context).pop();
        _showFlushbar(LocaleKeys.product_updated.tr());
        _clearFields();
        // Optional: go back after update
      } catch (e) {
        await _showFlushbar(
          '${LocaleKeys.product_failed.tr()} $e'.tr(),
          isError: true,
        );
      }
    }
  }

  void _clearFields() {
    _idController.clear();
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r), // responsive radius
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.deepPurple),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.product != null;

    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Builder(
        builder: (context) {
          final _ = context.locale;
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(10.w), // responsive padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 18.h),
                    // Show ID field, disabled if editing
                    if (isEditMode)
                      TextFormField(
                        controller: _idController,
                        decoration: _inputDecoration(
                          LocaleKeys.enterProductId.tr(),
                        ),
                        enabled: false,
                      ),

                    SizedBox(height: 25.h),
                    TextFormField(
                      controller: _titleController,
                      decoration: _inputDecoration(
                        LocaleKeys.textFormFieldTitle.tr(),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? LocaleKeys.enter_title.tr()
                          : null,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 25.h),
                    TextFormField(
                      controller: _priceController,
                      decoration: _inputDecoration(
                        LocaleKeys.textFormFieldPrice.tr(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || val.isEmpty
                          ? LocaleKeys.enter_price.tr()
                          : null,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 25.h),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: _inputDecoration(
                        LocaleKeys.textFormFieldDescription.tr(),
                      ),
                      maxLines: 1,
                      validator: (val) => val == null || val.isEmpty
                          ? LocaleKeys.enter_description.tr()
                          : null,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 25.h),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: _inputDecoration(
                        LocaleKeys.textFormFieldImageUrl.tr(),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? LocaleKeys.enter_image_url.tr()
                          : null,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 60.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              backgroundColor: isEditMode
                                  ? Colors.blue
                                  : Colors.green.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: isEditMode
                                ? _updateProduct
                                : _addProduct,
                            child: Text(
                              isEditMode
                                  ? LocaleKeys.updateProductButtonText.tr()
                                  : LocaleKeys.addProductButtonText.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
