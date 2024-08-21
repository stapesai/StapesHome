import 'package:flutter/material.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/constants/padding.dart';

class HomeScreen extends StatefulWidget {
  final String sessionId;
  final String userId;

  const HomeScreen({
    Key? key,
    required this.sessionId,
    required this.userId,
  }) : super(key: key);

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: AppPadding.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenSize.height * 0.05),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning,',
                          style: TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: AppFontSizes.bodyText,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Devasheesh',
                          style: TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: AppFontSizes.pageHeading,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  Row(
                    children: [
                      _buildQuickAccessButton('Favourites', true),
                      SizedBox(width: 24),
                      _buildQuickAccessButton('Active', false),
                    ],
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(String label, bool isActive) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: isActive ? AppColor.whiteColor : AppColor.whiteColor.withOpacity(0.5),
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColor.whiteColor : AppColor.whiteColor.withOpacity(0.5),
              fontSize: AppFontSizes.bodyText,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
