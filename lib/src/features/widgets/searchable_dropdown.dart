import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:shimmer/shimmer.dart';
import 'package:service_app/src/core/theme/app_color.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String hintText;
  final String Function(T) itemAsString;
  final void Function(T?)? onChanged;
  final void Function(String)? onSearchChanged;
  final void Function(String)? onLoadMore;
  final bool Function(T, String)? filterFn;
  final void Function()? onClear;
  final bool isLoading;
  final bool isFilter;
  final bool isSearchable;
  final bool showArrow;
  final bool readOnly;
  final bool enabled;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.hintText,
    required this.itemAsString,
    this.onChanged,
    this.onSearchChanged,
    this.onLoadMore,
    this.filterFn,
    this.onClear,
    this.isLoading = false,
    // this.icon,
    this.isFilter = false,
    this.isSearchable = true,
    this.showArrow = true,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  late ValueNotifier<List<T>> _itemsNotifier;
  late ValueNotifier<bool> _loadingNotifier;
  String _lastSearch = '';
  bool _hasRenderedOnce = false;

  @override
  void initState() {
    super.initState();
    _itemsNotifier = ValueNotifier(widget.items);
    _loadingNotifier = ValueNotifier(widget.isLoading);
  }

  @override
  void didUpdateWidget(covariant SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items ||
        widget.isLoading != oldWidget.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (widget.filterFn != null) {
            _itemsNotifier.value = widget.items
                .where((item) => widget.filterFn!(item, _lastSearch))
                .toList();
          } else {
            _itemsNotifier.value = widget.items
                .where(
                  (item) => widget
                      .itemAsString(item)
                      .toLowerCase()
                      .contains(_lastSearch.toLowerCase()),
                )
                .toList();
          }
          _loadingNotifier.value = widget.isLoading;
        }
      });
    }
  }

  @override
  void dispose() {
    _itemsNotifier.dispose();
    _loadingNotifier.dispose();
    super.dispose();
  }

  void _showBottomSheet() {
    final scrollController = ScrollController();
    final searchController = TextEditingController(text: _lastSearch);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        widget.onLoadMore?.call(_lastSearch);
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              height: MediaQuery.of(ctx).size.height * 0.5,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  // Search Field
                  if (widget.isSearchable) ...[
                    TextField(
                      controller: searchController,
                      autofocus: true,
                      onChanged: (val) {
                        _lastSearch = val;
                        if (widget.onSearchChanged != null) {
                          _loadingNotifier.value = true;
                          widget.onSearchChanged?.call(val);
                        }
                        if (widget.filterFn != null) {
                          _itemsNotifier.value = widget.items
                              .where((item) => widget.filterFn!(item, val))
                              .toList();
                        } else {
                          _itemsNotifier.value = widget.items
                              .where(
                                (item) => widget
                                    .itemAsString(item)
                                    .toLowerCase()
                                    .contains(val.toLowerCase()),
                              )
                              .toList();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: AppFont.style(
                          fontSize: 10,
                          color: AppColor.colorFFA5ABB7,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColor.colorFFE5E7EB,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColor.colorFFE5E7EB,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColor.colorFF1565C0,
                          ),
                        ),
                      ),
                      style: AppFont.style(
                        fontSize: 10,
                        color: AppColor.colorFF0D121F,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // List View
                  Expanded(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _loadingNotifier,
                      builder: (context, isLoading, _) {
                        return ValueListenableBuilder<List<T>>(
                          valueListenable: _itemsNotifier,
                          builder: (context, items, _) {
                            if (isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.colorFF0B68B9,
                                ),
                              );
                            }

                            if (items.isEmpty) {
                              return Center(
                                child: Text(
                                  'No data found',
                                  style: AppFont.style(
                                    fontSize: 12,
                                    color: AppColor.colorFFA5ABB7,
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              controller: scrollController,
                              itemCount: items.length + (isLoading ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == items.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColor.colorFF0B68B9,
                                      ),
                                    ),
                                  );
                                }

                                final item = items[index];
                                final isSelected = item == widget.value;

                                return InkWell(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    widget.onChanged?.call(item);
                                    Navigator.pop(ctx);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      widget.itemAsString(item),
                                      style: AppFont.style(
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.w900
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? AppColor.colorFF1565C0
                                            : AppColor.colorFF0D121F,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && !_hasRenderedOnce) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[50]!,
        child: Container(
          height: widget.isFilter ? 44 : 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.isFilter ? 10 : 12),
            border: Border.all(color: AppColor.colorFFE5E7EB),
          ),
        ),
      );
    }

    _hasRenderedOnce = true;

    return GestureDetector(
      onTap: (widget.readOnly || !widget.enabled) ? null : _showBottomSheet,
      child: Container(
        height: widget.isFilter ? 44 : 56,
        decoration: BoxDecoration(
          color: widget.enabled ? Colors.white : AppColor.colorFFF1F2F6,
          borderRadius: BorderRadius.circular(widget.isFilter ? 10 : 12),
          border: Border.all(color: AppColor.colorFFE5E7EB),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isFilter ? 12 : 20,
          vertical: widget.isFilter ? 0 : 4,
        ),
        child: Row(
          children: [
            // if (widget.icon != null) ...[
            //   widget.icon!,
            //   const SizedBox(width: 8),
            // ],
            Expanded(
              child: Text(
                widget.value != null
                    ? widget.itemAsString(widget.value as T)
                    : widget.hintText,
                style: AppFont.style(
                  fontSize: widget.isFilter ? 12 : 13,
                  fontWeight: widget.value != null
                      ? (widget.isFilter ? FontWeight.w500 : FontWeight.w900)
                      : FontWeight.w500,
                  color: widget.value != null
                      ? (widget.isFilter
                            ? AppColor.colorFFA5ABB7
                            : AppColor.colorFF0D121F)
                      : AppColor.colorFFA5ABB7,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.onClear != null && widget.value != null)
              GestureDetector(
                onTap: () {
                  widget.onClear?.call();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    Icons.close,
                    color: AppColor.colorFFA5ABB7,
                    size: 18,
                  ),
                ),
              )
            else if (widget.showArrow && !widget.readOnly)
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColor.colorFFA5ABB7,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
