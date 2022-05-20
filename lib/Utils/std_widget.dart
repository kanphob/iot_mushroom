import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Utils/font_thai.dart';

class STDWidget {
  final SizedBox h10 = const SizedBox(
    height: 10,
  );
  final SizedBox w5 = const SizedBox(
    width: 5,
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

  // Form
  Widget rowCol2({
    Widget? child,
    double width1 = 100,
    Widget? child2,
  }) {
    return Padding(
      padding: edgeAll8,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: width1,
            child: child,
          ),
          w5,
          Expanded(child: child2!),
        ],
      ),
    );
  }

  Widget rowCol3({
    Widget? child,
    double width1 = 150,
    Widget? child2,
    Widget? child3,
  }) {
    return Padding(
      padding: edgeAll8,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: width1,
            child: child,
          ),
          w5,
          Expanded(child: child2!),
        ],
      ),
    );
  }

  Widget txtBlack16({
    String? sText,
    TextAlign textAlign = TextAlign.end,
  }) {
    return Tooltip(
      showDuration: duration400m,
      message: sText,
      child: Text(
        sText!,
        style: FontThai.text16BlackNormal,
        textAlign: textAlign,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
