import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? suffixIcon; // Dùng cho các icon khác (nếu không phải password)
  final bool isPassword;    // Thêm cờ này để xác định là ô mật khẩu
  final TextInputAction ? textInputAction;
  final void Function(String)? onSubmitted;


  const CustomTextField({
    super.key,
    required this.labelText,
     this.prefixIcon,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.isPassword = false, // Mặc định là false (nhập văn bản thường)
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // Biến trạng thái để quản lý ẩn/hiện
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    // Nếu là password thì mặc định ban đầu sẽ ẩn text
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    // Định nghĩa border
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.grey),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    );

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onSubmitted,
      
      // Sử dụng biến state nội bộ để ẩn hiện
      obscureText: _obscureText, 
      
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: widget.prefixIcon != null ? Icon(
          widget.prefixIcon,
          color: AppColors.primary,
        ) : null,

        // LOGIC QUAN TRỌNG Ở ĐÂY:
        // Nếu là password -> Hiện nút con mắt để toggle
        // Nếu không phải -> Hiện suffixIcon do người dùng truyền (nếu có)
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  // Đổi icon dựa trên trạng thái _obscureText
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  // Cập nhật lại giao diện khi bấm nút
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon,

        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: focusedBorder,
        labelStyle: TextStyle(color: Colors.grey[600]),
  floatingLabelStyle: const TextStyle(color: AppColors.primary),
      ),
    );
  }
}