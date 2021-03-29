import 'package:dark_light_theme/components/z_animated_toggle.dart';
import 'package:dark_light_theme/models_providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    super.initState();
  }

  changeThemeMode(bool theme) {
    if (!theme) {
      _animationController.forward(from: 0.0);
    } else {
      _animationController.reverse(from: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: height * 0.1),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: width * 0.35,
                    height: width * 0.35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: themeProvider.themeMode().gradient,
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(40, 0),
                    child: ScaleTransition(
                      scale: _animationController.drive(
                        Tween<double>(begin: 0.0, end: 1.0)
                            .chain(CurveTween(curve: Curves.decelerate)),
                      ),
                      alignment: Alignment.topRight,
                      child: Container(
                        width: width * 0.26,
                        height: width * 0.26,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeProvider.isLightTheme
                                ? Colors.white
                                : Color(0xFF26242e)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.09),
              Text(
                'Choose a style',
                style: TextStyle(
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.03),
              Container(
                width: width * 0.5,
                child: Text(
                  'Pop or subtle. Day or night. Customize your interface.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: width * 0.038),
                ),
              ),
              SizedBox(height: height * 0.06),
              ZAnimatedToggle(
                values: ['Light', 'Dark'],
                onToggleCallback: (v) async {
                  await themeProvider.toogleThemeData();
                  setState(() {
                    changeThemeMode(themeProvider.isLightTheme);
                  });
                },
              ),
              SizedBox(height: height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildDot(
                    width: width * 0.022,
                    height: width * 0.022,
                    color: const Color(0xFFd9d9d9),
                  ),
                  buildDot(
                    width: width * 0.055,
                    height: width * 0.022,
                    color: themeProvider.isLightTheme
                        ? Color(0xFF26242e)
                        : Colors.white,
                  ),
                  buildDot(
                    width: width * 0.022,
                    height: width * 0.022,
                    color: const Color(0xFFd9d9d9),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: height * 0.02,
                    horizontal: width * 0.04,
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 0.025),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: width * 0.045,
                            color: const Color(0xFF7c7b7e),
                            fontFamily: 'Rubik',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          primary: themeProvider.isLightTheme
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFF35303f),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(width * 0.05),
                          child: Icon(
                            Icons.arrow_forward,
                            color: themeProvider.isLightTheme
                                ? const Color(0xFF000000)
                                : const Color(0xFFFFFFFF),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildDot({double width, double height, Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: width,
      height: height,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: color,
      ),
    );
  }
}
