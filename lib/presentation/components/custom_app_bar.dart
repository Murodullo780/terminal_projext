import 'package:flutter/material.dart';
import 'package:terminal_project/presentation/components/custom_outlined_button.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBar child;
  final double? leadingWidth;
  final Widget? leading;
  final Color? bgColor;
  final void Function()? onPop;

  const CustomAppBar({
    super.key,
    required this.child,
    this.leadingWidth,
    this.leading,
    this.bgColor,
    this.onPop,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => child.preferredSize;
}

class _CustomAppBarState extends State<CustomAppBar> {
  Color _getBackIconColor(BuildContext context) {
    final bgColor = widget.bgColor ??
        widget.child.backgroundColor ??
        Theme.of(context).appBarTheme.backgroundColor ??
        Colors.white;
    final luminance = bgColor.computeLuminance();
    return luminance < 0.5 ? Colors.white : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return AppBar(
      leadingWidth: widget.leadingWidth ?? (70.0),
      leading: widget.leading ??
          (canPop
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                  child: CustomOutlinedButton(
                    onPressed: () {
                      widget.onPop ?? Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: _getBackIconColor(context),
                      size: 24,
                    ),
                  ),
                )
              : null),
      automaticallyImplyLeading: true,
      title: widget.child.title,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 8,
            children: widget.child.actions ?? [],
          ),
        ),
      ],
      // actions: widget.child.actions,
      flexibleSpace: widget.child.flexibleSpace,
      bottom: widget.child.bottom,
      elevation: 0,
      scrolledUnderElevation: 0,
      notificationPredicate: widget.child.notificationPredicate,
      shadowColor: Colors.transparent,
      surfaceTintColor: widget.child.surfaceTintColor,
      shape: widget.child.shape,
      backgroundColor: widget.bgColor ?? widget.child.backgroundColor,
      foregroundColor: widget.child.foregroundColor,
      iconTheme: widget.child.iconTheme,
      actionsIconTheme: widget.child.actionsIconTheme,
      primary: widget.child.primary,
      centerTitle: widget.child.centerTitle,
      excludeHeaderSemantics: widget.child.excludeHeaderSemantics,
      titleSpacing: 5,
      toolbarOpacity: widget.child.toolbarOpacity,
      bottomOpacity: widget.child.bottomOpacity,
      toolbarHeight: widget.child.toolbarHeight,
      toolbarTextStyle: widget.child.toolbarTextStyle,
      titleTextStyle: widget.child.titleTextStyle,
      systemOverlayStyle: widget.child.systemOverlayStyle,
      forceMaterialTransparency: widget.child.forceMaterialTransparency,
      clipBehavior: widget.child.clipBehavior,
      key: widget.key,
    );
  }
}
