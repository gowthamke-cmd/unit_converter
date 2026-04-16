part of '../custom_dropdown.dart';

class _OverlayBuilder extends StatefulWidget {

  const _OverlayBuilder({
    required this.overlay,
    required this.child,
    this.overlayPortalController,
    this.visibility,
  });
  final Widget Function(Size, VoidCallback hide) overlay;
  final Widget Function(VoidCallback show) child;
  final OverlayPortalController? overlayPortalController;
  final Function({required bool visibility})? visibility;

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<_OverlayBuilder> {
  late OverlayPortalController overlayController;

  @override
  void initState() {
    super.initState();
    overlayController =
        widget.overlayPortalController ?? OverlayPortalController();
  }

  void showOverlay() {
    overlayController.show();

    if (widget.visibility != null) {
      widget.visibility?.call(visibility:true);
    }
  }

  void hideOverlay() {
    overlayController.hide();

    if (widget.visibility != null) {
      widget.visibility?.call(visibility:false);
    }
  }

  @override
  Widget build(BuildContext context) => OverlayPortal(
      controller: overlayController,
      overlayChildBuilder: (_) {
        final RenderObject? renderObject1 = context.findRenderObject();
        if(renderObject1 is RenderBox){
          final RenderBox renderBox = renderObject1;
          final Size size = renderBox.size;
          return widget.overlay(size, hideOverlay);
        }return widget.overlay(Size.zero, hideOverlay);
      },
      child: widget.child(showOverlay),
    );
}
