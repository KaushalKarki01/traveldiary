import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:traveldiary/screens/demo_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _lottieAnimation;
  final transitionDuration = const Duration(seconds: 1);
  var expanded = false;
  final double _bigFontSize = kIsWeb ? 234 : 178;

  @override
  void initState() {
    // TODO: implement initState

    _lottieAnimation =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    Future.delayed(Duration(seconds: 1))
        .then((value) => setState(() => expanded = true))
        .then((value) => Duration(seconds: 1))
        .then(
          (value) => Future.delayed(Duration(seconds: 1)).then(
            (value) => _lottieAnimation.forward().then(
                  (value) => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => DemoHomeScreen(),
                    ),
                    (route) => false,
                  ),
                ),
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: const Color(0xffdda15e),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              AnimatedDefaultTextStyle(
                duration: transitionDuration,
                curve: Curves.fastOutSlowIn,
                style: TextStyle(
                  color: const Color(0xffbc6c25),
                  fontSize: expanded ? 50 : _bigFontSize,
                  fontWeight: FontWeight.w600,
                ),
                child: const Text('T'),
              ),
              AnimatedCrossFade(
                firstCurve: Curves.fastOutSlowIn,
                crossFadeState: expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: transitionDuration,
                firstChild: Container(),
                secondChild: _logoRemainder(),
                alignment: Alignment.centerLeft,
                sizeCurve: Curves.easeInOut,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoRemainder() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'RAVEL DIARY',
          style: TextStyle(
            color: Color(0xffbc6c25),
            fontSize: 50,
            fontWeight: FontWeight.w600,
          ),
        ),
        LottieBuilder.asset(
          'assets/images/diary.json',
          onLoaded: (composition) {
            _lottieAnimation.duration = composition.duration;
          },
          frameRate: FrameRate.max,
          repeat: false,
          animate: false,
          height: 100,
          width: 100,
          controller: _lottieAnimation,
        )
      ],
    );
  }
}
