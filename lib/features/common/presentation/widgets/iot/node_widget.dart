import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stapes_home/core/common/widgets/snackbar.dart';
import 'package:stapes_home/core/models/node_model.dart';

class NodeComponentWidget extends StatelessWidget {
  final NodeModel node;
  final bool isOnline;

  const NodeComponentWidget({super.key, required this.node, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 68.72,
      margin: EdgeInsets.only(bottom: 19.63),
      padding: EdgeInsets.symmetric(horizontal: 20.62, vertical: 2.95),
      decoration: ShapeDecoration(
        color: Color(0xFF1D1D1D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(29.45),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 39.27,
                height: 39.27,
                padding: EdgeInsets.all(6.87),
                decoration: ShapeDecoration(
                  color: isOnline ? Color(0x33FF9F1C) : Color.fromARGB(68, 236, 50, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(29.45),
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/icons/nodes/node.svg',
                  width: 25.53,
                  height: 25.53,
                ),
              ),
              SizedBox(width: 9.82),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    node.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19.63.sp,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${node.numEntities} devices linked',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 9.82,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              CustomSnackbar(
                context,
                '3 dots implement karde @gauransh',
              );
            },
          ),
        ],
      ),
    );
  }
}
