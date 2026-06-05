import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class SearchableDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String hintText;
  final String Function(T) itemAsString;
  final void Function(T?)? onChanged;
  final bool isLoading;
  final Widget? icon;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.hintText,
    required this.itemAsString,
    this.onChanged,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Color(0xFF1565C0),
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            )
          : DropdownSearch<T>(
              items: items,
              itemAsString: itemAsString,
              selectedItem: value,
              onChanged: onChanged,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppFont.style(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFA5ABB7),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                ),
                baseStyle: AppFont.style(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0D121F),
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
