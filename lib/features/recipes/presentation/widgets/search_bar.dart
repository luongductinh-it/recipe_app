
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap; 
  const SearchBarWidget({
    Key? key,
    this.controller,
    this.autoFocus = false,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (onTap != null && controller == null && !autoFocus) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Text("Tìm kiếm sản phẩm", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    return TextField(
      controller: controller,
      autofocus: autoFocus,
      decoration: InputDecoration(
        hintText: "Tìm kiếm sản phẩm",
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
