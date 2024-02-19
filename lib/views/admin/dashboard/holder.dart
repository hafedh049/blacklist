import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/category_list.dart';
import 'package:blacklist/views/admin/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class Holder extends StatefulWidget {
  const Holder({super.key});

  @override
  State<Holder> createState() => _HolderState();
}

class _HolderState extends State<Holder> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _screens = const <Map<String, dynamic>>[
    <String, dynamic>{
      "screen": Dashboard(),
      "title": "Dashboard",
    },
    <String, dynamic>{
      "screen": CategoryList(),
      "title": "Categories List",
    },
  ];
  String _selectedScreen = "Dashboard";

  final ZoomDrawerController _zoomController = ZoomDrawerController();
  final PageController _screensController = PageController();
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _screensController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
        androidCloseOnBackTap: true,
        mainScreenTapClose: true,
        controller: _zoomController,
        style: DrawerStyle.defaultStyle,
        menuScreen: Container(
          color: purpleColor,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (final Map<String, dynamic> item in _screens)
                      GestureDetector(
                        onTap: () async {
                          if (_selectedScreen != item["title"]) {
                            _(() => _selectedScreen = item["title"]);
                            _screensController.jumpToPage(_screens.indexOf(item));
                          }
                          await Future.delayed(100.ms);
                          await _zoomController.toggle!();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: _selectedScreen == item["title"] ? darkColor : transparentColor),
                          child: Text(item["title"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: greyColor)),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
        mainScreen: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) _) {
                return IconButton(
                  onPressed: () async {
                    _(() {});
                    _zoomController.toggle!();
                  },
                  icon: AnimatedIcon(icon: _zoomController.isOpen!() ? AnimatedIcons.close_menu : AnimatedIcons.menu_close, progress: _animationController),
                );
              },
            ),
            PageView.builder(
              controller: _screensController,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) => _screens[index]["screen"],
              itemCount: _screens.length,
            ),
          ],
        ),
        borderRadius: 24.0,
        showShadow: true,
        angle: -12.0,
        drawerShadowsBackgroundColor: greyColor,
        slideWidth: MediaQuery.of(context).size.width * .3,
        openCurve: Curves.linear,
        closeCurve: Curves.linear,
        duration: 300.ms,
        reverseDuration: 500.ms,
      ),
    );
  }
}
