part of '../custom_dropdown.dart';

class _AnimatedSection extends StatefulWidget {
  const _AnimatedSection({
    required this.animationDismissed,
    required this.child,
    required this.axisAlignment,
    this.expand = false,
  });
  final bool expand;
  final VoidCallback animationDismissed;
  final Widget child;
  final double axisAlignment;

  @override
  State<_AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<_AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    runExpand();
  }

  void prepareAnimations() {
    animController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        )..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.dismissed) {
            widget.animationDismissed();
          }
        });

    animation = CurvedAnimation(
      parent: animController,
      curve: Curves.linearToEaseOut,
    );
  }

  void runExpand() {
    if (widget.expand) {
      unawaited(animController.forward());
    } else {
      unawaited(animController.reverse());
    }
  }

  @override
  void didUpdateWidget(_AnimatedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    runExpand();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
      opacity: animation,
      child: SizeTransition(
        axisAlignment: widget.axisAlignment,
        sizeFactor: animation,
        child: widget.child,
      ),
    );
}
