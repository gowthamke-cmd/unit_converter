part of '../custom_dropdown.dart';


/// list item decreation class
class ListItemDecoration {

  /// constructor
  const ListItemDecoration({
    this.splashColor,
    this.highlightColor,
    this.selectedColor,
    this.selectedIconColor,
    this.selectedIconBorder,
    this.selectedIconShape,
  });
  /// Splash color for [CustomDropdown] list item area.
  ///
  /// Default to [Colors.transparent].
  final Color? splashColor;

  /// Highlight color for [CustomDropdown] list item area.
  ///
  /// Default to Color(0xFFEEEEEE).
  final Color? highlightColor;

  /// Selected color for [CustomDropdown] list item area.
  ///
  /// Default to Color(0xFFF5F5F5).
  final Color? selectedColor;

  /// Selected icon color for [CustomDropdown] list item area..
  final Color? selectedIconColor;

  /// Selected icon border for [CustomDropdown] list item area.
  final BorderSide? selectedIconBorder;

  /// Selected icon shape for [CustomDropdown] list item area.
  final OutlinedBorder? selectedIconShape;

  static const Color _defaultSplashColor = Colors.transparent;
  static const Color _defaultHighlightColor = Color(0xFFEEEEEE);
  static const Color _defaultSelectedColor = Color(0xFFF5F5F5);
}
