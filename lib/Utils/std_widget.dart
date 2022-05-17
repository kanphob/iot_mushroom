import 'package:flutter/material.dart';

class STDWidget {
  final SizedBox h10 = const SizedBox(
    height: 10,
  );
  final EdgeInsets edgeAll8 = const EdgeInsets.all(8.0);
  final Duration duration400m = const Duration(milliseconds: 400);

  Widget waitCenter() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // OutlineList Product
  Widget outlineListProd({
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: duration400m,
      margin: edgeAll8,
      padding: edgeAll8,
      child: child,
      decoration: BoxDecoration(
        color: Colors.blue.shade800.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Image Icon
  Widget imageIcon(String path) {
    return Image.asset(
      path,
      height: 50,
      width: 50,
      filterQuality: FilterQuality.medium,
      fit: BoxFit.contain,
    );
  }

  Widget outlineListItem({
    required Widget child,
    double? height,
  }) {
    return AnimatedContainer(
      duration: duration400m,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      padding: edgeAll8,
      width: double.infinity,
      height: height,
      child: child,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.blue.shade800,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
