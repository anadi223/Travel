import 'dart:math';
import 'package:flare_loading/flare_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterappbam/styles.dart';
import 'package:provider/provider.dart';
import 'leopard_page.dart';
import 'main.dart' as math;

class PageOffsetNotifier with ChangeNotifier {
  double _offset = 0;
  double _page = 0;

  PageOffsetNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page;
      notifyListeners();
    });
  }
  double get offset => _offset;
  double get page => _page;
}

class MapAnimationNotifier with ChangeNotifier {
  final AnimationController _animationController;
  MapAnimationNotifier(this._animationController) {
    _animationController.addListener(_onAnimationControllerChanged);
  }
  double get value => _animationController.value;
  void forward() => _animationController.forward();
  void _onAnimationControllerChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _animationController.removeListener(_onAnimationControllerChanged);
    super.dispose();
  }
}

double Starttop = 90.0 + 400 + 32 + 4;
double endTop = (90.0 + 20 + 8);
double oneThird = (Starttop - endTop) / 3;
double startTop(context) =>
    topMargin(context) + mainSquareSize(context) + 32 + 16 + 32 + 4;

double topMargin(BuildContext context) =>
    MediaQuery.of(context).size.height > 700 ? 128 : 64;

double mainSquareSize(BuildContext context) =>
    MediaQuery.of(context).size.height / 2;

double dotsTopMargin(BuildContext context) =>
    topMargin(context) + mainSquareSize(context) + 32 + 16 + 32 + 4;

double bottom(BuildContext context) =>
    MediaQuery.of(context).size.height - dotsTopMargin(context) - 8;

EdgeInsets mediaPadding;


class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _mapAnimationController;
  final PageController _pageController = PageController();

  double get maxHeight => 400.0 + 35;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _mapAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _mapAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaPadding = MediaQuery.of(context).padding;
    return ChangeNotifierProvider(
      create: (_) => PageOffsetNotifier(_pageController),
      child: ListenableProvider.value(
        value: _animationController,
        child: ChangeNotifierProvider(
          create: (_) => MapAnimationNotifier(_mapAnimationController),
          child: Scaffold(
            body: GestureDetector(
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              child: Stack(
                children: <Widget>[
                  MapImage(),
                  SafeArea(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        PageView(
                          controller: _pageController,
                          physics: ClampingScrollPhysics(),
                          children: <Widget>[
                            LeopardPage(),
                            VulturePage(),
                          ],
                        ),
                        ShareButton(),
                        AppBar(),
                        LeopardImage(),
                        VultureImage(),
                        PageIndicator(),
                        Arrow(),
                        Traveldetails(),
                        StartCampLabel(),
                        StartCampTime(),
                        BaseCampLabel(),
                        BaseCampTime(),
                        DistanceLabel(),
                        HorizontalTravelDots(),
                        MapButton(),
                        VerticalTravelDots(),
                        VultureIconLabel(),
                        LeopardIconLabel(),
                        CurvedRoute(),
                        MapBaseCamp(),
                        MapLeopard(),
                        MapVulture(),
                        MapStartCamp(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _animationController.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0)
      _animationController.fling(velocity: max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _animationController.fling(velocity: min(-2.0, -flingVelocity));
    else
      _animationController.fling(
          velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
  }
}

class MapImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context, notifier, child) {
        double scale = 1 + 0.3 * (1-notifier.value);
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateZ(0.05 * pi * (1 - notifier.value))
            ..scale(scale, scale),
          child: Opacity(opacity: notifier.value,child: child),
        );
      },
      child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assets/map.png',
            fit: BoxFit.cover,
          )),
    );
  }
}

class VultureImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
        builder: (context, notifier, animation, child) {
          return Positioned(
            left: 1.15 * MediaQuery.of(context).size.width -
                0.85 * notifier.offset,
            child: Transform.scale(
              scale: 1 - 0.2 * animation.value,
              child: Opacity(
                opacity: 1 - 0.6 * animation.value,
                child: child,
              ),
            ),
          );
        },
        child: MapHider(
          child: IgnorePointer(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 90.0),
            child: Image.asset(
              'assets/vulture.png',
              height: MediaQuery.of(context).size.height / 3,
            ),
          )),
        ));
  }
}

class AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Text(
              "AM",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Icon(Icons.menu),
          ],
        ),
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24,
      bottom: 16,
      child: Icon(Icons.share),
    );
  }
}

class Arrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child) {
        return Positioned(
          top: 90 + (1 - animation.value) * (400),
          right: 12,
          child: child,
        );
      },
      child: MapHider(
        child: Icon(
          Icons.keyboard_arrow_down,
          size: 35,
          color: Colors.grey[500],
        ),
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapHider(
      child: Consumer<PageOffsetNotifier>(
        builder: (context, notifier, _) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: notifier.page.round() == 0 ? white : lightGrey,
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Container(
                    width: 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: notifier.page.round() != 0 ? white : lightGrey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VulturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: MapHider(child: VultureCircle()),
      ),
    );
  }
}

class Traveldetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          left: 20 + MediaQuery.of(context).size.width - notifier.offset,
          top: 90.0 + (1 - animation.value) * 390,
          child: Opacity(
            opacity: max(0, 4 * notifier.page - 3),
            child: child,
          ),
        );
      },
      child: MapHider(
        child: Text(
          'Travel details',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

class StartCampLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Positioned(
          width: MediaQuery.of(context).size.width / 3,
          left: max(0, 4 * notifier.page - 3) * 24.0,
          top: 90.0 + 400 + 32,
          child: Opacity(
            opacity: max(0, 4 * notifier.page - 3),
            child: child,
          ),
        );
      },
      child: MapHider(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Start Camp',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
          ),
        ),
      ),
    );
  }
}

class StartCampTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Positioned(
          width: MediaQuery.of(context).size.width / 3,
          left: max(0, 4 * notifier.page - 3) * 24.0,
          top: 90.0 + 400 + 32 + 22,
          child: Opacity(
            opacity: max(0, 4 * notifier.page - 3),
            child: child,
          ),
        );
      },
      child: MapHider(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            '12:00 pm',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}

class BaseCampLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          width: MediaQuery.of(context).size.width / 3,
          right: max(0, 4 * notifier.page - 3) * 24.0,
          top: (90.0 + 20) + (1 - animation.value) * (400 + 32 - 20),
          child: Opacity(
            opacity: max(0, 4 * notifier.page - 3),
            child: child,
          ),
        );
      },
      child: MapHider(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Base Camp',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
          ),
        ),
      ),
    );
  }
}

class BaseCampTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          width: MediaQuery.of(context).size.width / 3,
          right: max(0, 4 * notifier.page - 3) * 24.0,
//          90.0+400+32,
          top: (90.0 + 20 + 24) + (1 - animation.value) * (400 + 32 - 20),
          child: Opacity(
            opacity: max(0, 4 * notifier.page - 3),
            child: child,
          ),
        );
      },
      child: MapHider(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '8:00 am',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}

class DistanceLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Positioned(
          width: MediaQuery.of(context).size.width,
          top: 90.0 + 400 + 32 + 20,
          child: Opacity(
            opacity: max(0, 4 * notifier.page - 3),
            child: child,
          ),
        );
      },
      child: MapHider(
        child: Align(
          alignment: Alignment.center,
          child: Text(
            '72 km',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class VerticalTravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AnimationController,MapAnimationNotifier>(builder: (context, animation, notifier,child) {
      if (animation.value < 1 / 5 || notifier.value >0) {
        return Container();
      }
      double Starttop = 90.0 + 400 + 32 + 4;
      double bottom = MediaQuery.of(context).size.height - Starttop - 30;
      double endTop = (90.0 + 20 + 8);
      double top;
      top = endTop + (1 - (1.25 * (animation.value - 1 / 5))) * (400 + 32 - 20);
      return Positioned(
        top: top,
        bottom: bottom,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 2.0,
                height: double.infinity,
                color: Colors.white,
              ),
              Align(
                alignment: Alignment(0, -1),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.0),
                    color: mainBlack,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.33),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    color: mainBlack,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0.33),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    color: mainBlack,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 1),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class CurvedRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context, animation, child) {
        if (animation.value == 0) {
          return Container();
        }
        double startTop =
            topMargin(context) + mainSquareSize(context) + 32 + 16 + 32 + 4;
        double endTop = topMargin(context) + 32 + 16 + 8;
        double oneThird = (startTop - endTop) / 3;
        double width = MediaQuery.of(context).size.width;

        return Positioned(
          top: endTop,
          bottom: bottom(context) - mediaPadding.vertical,
          left: 0,
          right: 0,
          child: CustomPaint(
            painter: CurvePainter(animation.value),
            child: Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Positioned(
                    top: oneThird,
                    right: width / 2 - 4 - animation.value * 60,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: white, width: 2.5),
                        color: mainBlack,
                      ),
                      height: 8,
                      width: 8,
                    ),
                  ),
                  Positioned(
                    top: 2 * oneThird,
                    right: width / 2 - 4 - animation.value * 50,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: white, width: 2.5),
                        color: mainBlack,
                      ),
                      height: 8,
                      width: 8,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 1),
                    child: Container(
                      margin: EdgeInsets.only(right: 100 * animation.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: white, width: 1),
                        color: mainBlack,
                      ),
                      height: 8,
                      width: 8,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -1),
                    child: Container(
                      margin: EdgeInsets.only(left: 40 * animation.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: white,
                      ),
                      height: 8,
                      width: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class HorizontalTravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        if(animation.value==1){
          return Container();
        }
        double spacingFactor;
        double opacity;
        if (animation.value == 0) {
          spacingFactor = max(0, 4 * notifier.page - 3);
          opacity = spacingFactor;
        } else {
          spacingFactor = max(0, 1 - 5 * animation.value);
          opacity = 1;
        }
        return Positioned(
          top: 90.0 + 400 + 32 + 4,
          left: 0,
          right: 0,
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15.0 * spacingFactor),
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightGrey,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 25.0 * spacingFactor),
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightGrey,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 30.0 * spacingFactor),
                    width: 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 35.0 * spacingFactor),
                    width: 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class VultureCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double multiplier;
        if (animation.value == 0) {
          multiplier = max(0, 4 * notifier.page - 3);
        } else {
          multiplier = max(0, 1 - 5 * animation.value);
        }
        return Container(
          margin: EdgeInsets.only(bottom: 150, right: 70),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: lightGrey,
          ),
          width: MediaQuery.of(context).size.width * 0.5 * multiplier,
          height: MediaQuery.of(context).size.width * 0.5 * multiplier,
        );
      },
    );
  }
}

class MapHider extends StatelessWidget {
  final Widget child;

  const MapHider({Key key, @required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context,notifier,child){
        return Opacity(
          opacity: max(0, 1- (2*notifier.value)),
          child: child,
        );
      },
      child: child,
    );
  }
}



class MapButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8,
      bottom: 8,
      child: Consumer<PageOffsetNotifier>(
        builder: (context, notifier, child) {
          return Opacity(
            opacity: max(0, 4 * notifier.page - 3),
            child: child,
          );
        },
        child: FlatButton(
          onPressed: () {
            final notifier = Provider.of<MapAnimationNotifier>(context, listen: false);
            notifier.value ==0? notifier.forward() : notifier._animationController.reverse();
          },
          child: Text(
            "ON MAP",
            style: TextStyle(),
          ),
        ),
      ),
    );
  }
}

class VultureIconLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AnimationController,MapAnimationNotifier>(
      builder: (context, animation, notifier, child) {
        double Starttop = 90.0 + 400 + 32 + 4;
        double bottom = MediaQuery.of(context).size.height - Starttop - 30;
        double endTop = (90.0 + 20 + 8);
        double opacity;
        if (animation.value < 2 / 3) {
          opacity = 0;
        } else if(notifier.value ==0)
        {
          opacity = 3 * (animation.value - 2 / 3);
        }else if(notifier.value<0.33){
          opacity = 1 - 3*notifier.value;
        }else {
          opacity =0;
        }
        double top;
        top =
            endTop + (1 - (1.25 * (animation.value - 1 / 5))) * (400 + 32 - 20);
        double right = 26 + 3 - 2 * animation.value;
        double oneThird = (Starttop - endTop) / 3;
        return Positioned(
          top: endTop + 2 * oneThird - 36,
          right: 55 + opacity * 10,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: SmallAnimalIconLabel(
        isVulture: true,
        showLine: true,
      ),
    );
  }
}

class LeopardIconLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AnimationController,MapAnimationNotifier>(
      builder: (context, animation,notifier, child) {
        double Starttop = 90.0 + 400 + 32 + 4;
        double endTop = (90.0 + 20 + 8);
        double oneThird = (Starttop - endTop) / 3;
        double opacity;
        if (animation.value < 3 / 4) {
          opacity = 0;
        } else if(notifier.value ==0) {
          opacity = 4 * (animation.value - 3 / 4);
        }else if(notifier.value<0.33){
        opacity = 1 - 3*notifier.value;
        }else {
        opacity =0;
        }
        double top;
        top =
            endTop + (1 - (1.25 * (animation.value - 1 / 5))) * (400 + 32 - 20);
        double right = 26 + 3 - 2 * animation.value;

        return Positioned(
          top: endTop + oneThird - 36,
          left: 30 + opacity * 10,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: SmallAnimalIconLabel(
        isVulture: false,
        showLine: true,
      ),
    );
  }
}

class SmallAnimalIconLabel extends StatelessWidget {
  final bool isVulture;
  final bool showLine;

  const SmallAnimalIconLabel(
      {Key key, @required this.isVulture, @required this.showLine})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (showLine && isVulture)
          Container(
            width: 24,
            height: 1,
          ),
        SizedBox(
          width: 24,
        ),
        Column(
          children: <Widget>[
            Image.asset(
              isVulture ? 'assets/vultures.png' : 'assets/leopards.png',
              width: 36,
              height: 36,
            ),
            SizedBox(
              height: showLine? 8:0,
            ),
            Text(
              isVulture ? 'Vultures' : 'Leopards',
              style: TextStyle(fontSize: showLine? 14:12),
            ),
          ],
        ),
      ],
    );
  }
}


class CurvePainter extends CustomPainter {
  final double animationValue;
  double width;

  CurvePainter(this.animationValue);

  double interpolate(double x) {
    return width / 2 + (x - width / 2) * animationValue;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    width = size.width;
    paint.color = white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    var path = Path();

//    print(interpolate(size, x))
    var startPoint = Offset(interpolate(width / 2 + 20), 4);
    var controlPoint1 = Offset(interpolate(width / 2 + 60), size.height / 4);
    var controlPoint2 = Offset(interpolate(width / 2 + 20), size.height / 4);
    var endPoint = Offset(interpolate(width / 2 + 55 + 4), size.height / 3);

    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    startPoint = endPoint;
    controlPoint1 = Offset(interpolate(width / 2 + 100), size.height / 2);
    controlPoint2 = Offset(interpolate(width / 2 + 20), size.height / 2 + 40);
    endPoint = Offset(interpolate(width / 2 + 50 + 2), 2 * size.height / 3 - 1);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    startPoint = endPoint;
    controlPoint1 =
        Offset(interpolate(width / 2 - 20), 2 * size.height / 3 - 10);
    controlPoint2 =
        Offset(interpolate(width / 2 + 20), 5 * size.height / 6 - 10);
    endPoint = Offset(interpolate(width / 2), 5 * size.height / 6 + 2);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    startPoint = endPoint;
    controlPoint1 = Offset(interpolate(width / 2 - 100), size.height - 80);
    controlPoint2 = Offset(interpolate(width / 2 - 40), size.height - 50);
    endPoint = Offset(interpolate(width / 2 - 50), size.height - 4);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurvePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}


class MapBaseCamp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context, notifier, child) {
        double opactiy = max(0, 4*(notifier.value - 3/4));
        return Positioned(
          width: MediaQuery.of(context).size.width / 3,
          right: 24.0,
          top: (90.0 + 20),
          child: Opacity(
            opacity:opactiy,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Base Camp',
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

class MapLeopard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context, notifier, child) {

        double opactiy = max(0, 4*(notifier.value - 3/4));
        return Positioned(
          top: (90.0 + 20)+oneThird,
          child: Opacity(
            opacity:opactiy,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.center,
        child: SmallAnimalIconLabel(isVulture: false, showLine: false)
      ),
    );
  }
}


class MapVulture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context, notifier, child) {

        double opactiy = max(0, 4*(notifier.value - 3/4));
        return Positioned(
          top: (90.0 + 20)+ 2*oneThird,
          right: 60,
          child: Opacity(
            opacity:opactiy,
            child: child,
          ),
        );
      },
      child: Align(
          alignment: Alignment.center,
          child: SmallAnimalIconLabel(isVulture: true, showLine: true)
      ),
    );
  }
}

class MapStartCamp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context, notifier, child) {
        double opactiy = max(0, 4*(notifier.value - 3/4));
        return Positioned(
          width: MediaQuery.of(context).size.width / 3,
          top: Starttop-4,
          child: Opacity(
            opacity:opactiy,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Start Camp',
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}