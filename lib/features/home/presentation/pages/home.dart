import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/theme/app_padding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  bool isFavouritesSelected = true;

  @override
  bool get wantKeepAlive => true;

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // Update your state with the new data
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // child: Container(
      //   clipBehavior: Clip.antiAlias,
      //     // decoration: ShapeDecoration(
      //     //   gradient: AppColor.backgroundColorgradient,
      //       // shape: RoundedRectangleBorder(
      //       //   borderRadius: BorderRadius.circular(30),
      //       // ),
      //     ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: AppPadding.pagePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section (greeting and quick access buttons)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenSize.height * 0.05),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
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
                        _buildQuickAccessButton(
                          'Favourites',
                          isFavouritesSelected,
                          'heart-active.svg',
                          'heart.svg',
                        ),
                        SizedBox(width: 24),
                        _buildQuickAccessButton(
                          'Active',
                          !isFavouritesSelected,
                          'lightning-active.svg',
                          'lightning.svg',
                        ),
                      ],
                    ),
                  ],
                ),

                // Main content section
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RefreshIndicator(
                        onRefresh: _refreshData,
                        color: AppColor.whiteColor,
                        backgroundColor: Colors.transparent,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child: SizedBox(
                              child: Center(
                                child: Text(
                                  isFavouritesSelected
                                      ? "Nothing to show here.\nGo to Devices or Nodes page and add a device to favorites list."
                                      : "No currently active devices",
                                  style: TextStyle(
                                    color: AppColor.whiteColor.withOpacity(0.8),
                                    fontSize: AppFontSizes.bodyText,
                                    fontFamily: 'Ubuntu',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(String label, bool isActive, String activeIcon, String inactiveIcon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFavouritesSelected = (label == 'Favourites');
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            isActive ? 'assets/icons/home/$activeIcon' : 'assets/icons/home/$inactiveIcon',
            width: 20,
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
