import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class CustomSearchableDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final bool isLoading;
  final String Function(T)? itemAsString;
  final bool Function(T, T)? compareFn;
  final double height;

  const CustomSearchableDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isLoading = false,
    this.itemAsString,
    this.compareFn,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onChanged != null;

    if (isLoading) {
      return Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F2F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1F2F6)),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Color(0xFF1565C0),
              strokeWidth: 2.5,
            ),
          ),
        ),
      );
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFFF8F9FB) : const Color(0xFFF1F2F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: DropdownSearch<T>(
        enabled: isEnabled,
        selectedItem: value,
        items: items,
        itemAsString: itemAsString,
        compareFn: compareFn,
        popupProps: PopupProps.menu(
          showSearchBox: true,
          showSelectedItems: compareFn != null || T == String || T == int || T == double,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Search...',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFF1F2F6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFF1F2F6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF1565C0)),
              ),
            ),
          ),
          menuProps: const MenuProps(
            backgroundColor: Colors.white,
            elevation: 4,
          ),
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: hint,
            hintStyle: AppFont.style(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isEnabled ? const Color(0xFFA5ABB7) : const Color(0xFFCBD5E1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: InputBorder.none,
          ),
          baseStyle: AppFont.style(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isEnabled ? const Color(0xFF0D121F) : const Color(0xFFA5ABB7),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
