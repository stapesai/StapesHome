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
          initialChildSize: 0.5,
          maxChildSize: 0.7,
          expand: true,
          minChildSize: 0.5,
          snap: true,
          snapSizes: [
            50/contraints.maxHeight,
            0.5,
          ],
          builder: (BuildContext buider, ScrollController scrollController) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, spreadRadius: 5)],
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
