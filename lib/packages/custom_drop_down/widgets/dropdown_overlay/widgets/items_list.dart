part of '../../../custom_dropdown.dart';

class _ItemsList<T> extends StatelessWidget {
  const _ItemsList({
    required this.scrollController,
    required this.selectedItem,
    required this.items,
    required this.onItemSelect,
    required this.excludeSelected,
    required this.itemsListPadding,
    required this.listItemPadding,
    required this.listItemBuilder,
    required this.selectedItems,
    required this.decoration,
    required this.dropdownType,
    super.key,
  });
  final ScrollController scrollController;
  final T? selectedItem;
  final List<T> items;
  final List<T> selectedItems;
  final Function(T) onItemSelect;
  final bool excludeSelected;
  final EdgeInsets itemsListPadding;
  final EdgeInsets listItemPadding;
  final ListItemBuilder<T> listItemBuilder;
  final ListItemDecoration? decoration;
  final _DropdownType dropdownType;

  @override
  Widget build(BuildContext context) => Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        padding: itemsListPadding,
        itemCount: items.length,
        itemBuilder: (_, int index) {
          final bool selected = switch (dropdownType) {
            _DropdownType.singleSelect =>
              !excludeSelected && selectedItem == items[index],
            _DropdownType.multipleSelect =>
              selectedItems is List<NameId> &&
                  items[index] is NameId &&
                  (selectedItems as List<NameId>).any(
                    (NameId e) => e.id == (items[index] as NameId).id,
                  ),
          };

          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor:
                  decoration?.splashColor ??
                  ListItemDecoration._defaultSplashColor,
              highlightColor:
                  decoration?.highlightColor ??
                  ListItemDecoration._defaultHighlightColor,
              onTap: () => onItemSelect(items[index]),
              child: Ink(
                color: selected
                    ? (decoration?.selectedColor ??
                          ListItemDecoration._defaultSelectedColor)
                    : Colors.transparent,
                padding: listItemPadding,
                child: listItemBuilder(
                  context,
                  items[index],
                  isSelected:selected,
                  () {
                    // logger.debugLog('items[index]',items[index]);
                    onItemSelect(items[index]);
                },
                ),
              ),
            ),
          );
        },
      ),
    );
}
