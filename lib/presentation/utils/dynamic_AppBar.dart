import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;

  const DynamicAppBar({
    super.key,
    required this.title,
    this.subtitle,
});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(title),
          if(subtitle != null)
            Text(
                subtitle!,
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}