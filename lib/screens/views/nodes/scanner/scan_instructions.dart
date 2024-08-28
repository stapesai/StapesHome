import 'package:StapesHome/constants/colors.dart';
import 'package:flutter/material.dart';

class Bottomsheet extends StatefulWidget {
  final Widget child;

  const Bottomsheet({super.key, required this.child});

  @override
  State<Bottomsheet> createState() => _BottomsheetState();
}

class _BottomsheetState extends State<Bottomsheet> {
  final sheet = GlobalKey();
  final controllet = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (buider, contraints) {
      return DraggableScrollableSheet(
          key: sheet,
          initialChildSize: 0.1,
          maxChildSize: 0.3,
          expand: true,
          minChildSize: 0.1,
          snap: true,
          snapSizes: [
            0.1,
            0.3,
          ],
          builder: (BuildContext buider, ScrollController scrollController) {
            return DecoratedBox(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                gradient: AppColor.backgroundColorgradient,
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: widget.child,
                  ),
                ],
              ),
            );
          });
    });
  }
}
