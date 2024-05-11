import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key, required this.height, this.title});
  final double height;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton.small(
            onPressed: () => (Navigator.pop(context)),
            elevation: 1,
            child: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      title: title != null ? Text(
          title!,
        overflow: TextOverflow.ellipsis,
      ) : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
