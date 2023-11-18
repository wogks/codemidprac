import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? title;
  final Widget? bottomNavigationBar;
  const DefaultLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar(),
      backgroundColor: backgroundColor ?? Colors.white,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppbar() {
    if (title == null) {
      return null;
    } else {}
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        title!,
        style: const TextStyle(fontSize: 16),
      ),
      foregroundColor: Colors.black,
    );
  }
}
