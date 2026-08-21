import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/generated/assets.dart';
import 'package:wordzoo/presentation/screens/login_screen.dart';
import 'package:wordzoo/base/resizer/size_manager.dart';
import 'package:wordzoo/base/theme/colors_app.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Animation chạy liên tục trong lúc load data.
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat(reverse: true);

    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _load();
  }

  Future<void> _load() async {
    try {
      if (!mounted)
        return;

      // Chuyển sang màn hình chính.
      //Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const LoginScreen()));
    } catch (e) {
      if (!mounted) return;
      // Xử lý lỗi loading ở đây.
      debugPrint('Splash loading error: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(Assets.assets.background.loginLandScape.path), fit: BoxFit.fill),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(angle: _rotationAnimation.value, child: child);
                },
                child: ClipOval(
                    child: Image.asset(Assets.assets.icons.appIcon.path, width: Dimens().spacing128, height: Dimens().spacing128)),
              ),
            ),
            ListenableBuilder(
              listenable: DataManager().downloadProgressModel,
              builder: (BuildContext context, Widget? child) {
                return Visibility(
                  visible: DataManager().downloadProgressModel.needDownloadFile == true,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding:  EdgeInsets.only(bottom: Dimens().spacing16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LinearPercentIndicator(
                            width: Dimens().size450,
                            lineHeight: Dimens().spacing32,
                            percent: (DataManager().downloadProgressModel.downloadProgress / 100.0).toDouble(),
                            center: Text('Loading data ${DataManager().downloadProgressModel.downloadProgress.toStringAsFixed(0)}%', style:  TextStyle(fontSize: Dimens().spacing12)),
                            barRadius:  Radius.circular(Dimens().spacing12),
                            progressColor: Colors.green,
                            backgroundColor: Colors.white,
                            animation: true,
                            animationDuration: 5000,
                            animateFromLastPercent: true,
                            animateToInitialPercent: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
