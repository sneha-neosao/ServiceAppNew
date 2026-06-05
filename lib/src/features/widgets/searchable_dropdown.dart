import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:shimmer/shimmer.dart';

class SearchableDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String hintText;
  final String Function(T) itemAsString;
  final void Function(T?)? onChanged;
  final bool isLoading;
  final Widget? icon;
  final bool isFilter;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.hintText,
    required this.itemAsString,
    this.onChanged,
    this.isLoading = false,
    this.icon,
    this.isFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[50]!,
        child: Container(
          height: isFilter ? 44 : 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isFilter ? 10 : 12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
        ),
      );
    }

    return Container(
      height: isFilter ? 44 : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isFilter ? 10 : 12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: EdgeInsets.symmetric(horizontal: isFilter ? 12 : 20, vertical: isFilter ? 0 : 4),
      child: DropdownSearch<T>(
              items: items,
              itemAsString: itemAsString,
              selectedItem: value,
              onChanged: onChanged,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppFont.style(
                    fontSize: isFilter ? 14 : 16,
                    fontWeight: isFilter ? FontWeight.w500 : FontWeight.w700,
                    color: const Color(0xFFA5ABB7),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: isFilter ? 14 : 6),
                ),
                baseStyle: AppFont.style(
                  fontSize: isFilter ? 14 : 16,
                  fontWeight: isFilter ? FontWeight.w500 : FontWeight.w900,
                  color: isFilter ? const Color(0xFFA5ABB7) : const Color(0xFF0D121F),
                ),
              ),
              dropdownButtonProps: DropdownButtonProps(
                icon: icon ?? const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFFA5ABB7),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: AppFont.style(
                      fontSize: 14,
                      color: const Color(0xFFA5ABB7),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF1565C0)),
                    ),
                  ),
                  style: AppFont.style(
                    fontSize: 14,
                    color: const Color(0xFF0D121F),
                  ),
                ),
                menuProps: MenuProps(
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 4,
                ),
                itemBuilder: (context, item, isSelected) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      itemAsString(item),
                      style: AppFont.style(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                        color: isSelected ? const Color(0xFF1565C0) : const Color(0xFF0D121F),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
