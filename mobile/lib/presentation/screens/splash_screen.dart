import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/generated/assets.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../../utils/size_manager.dart';
import 'package:wordzoo/l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
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
            const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.leafGreen))),
            ListenableBuilder(
              listenable: DataManager().downloadProgressModel,
              builder: (BuildContext context, Widget? child) {
                return Visibility(
                  visible: DataManager().downloadProgressModel.needDownloadFile == true,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LinearPercentIndicator(
                            width: 450,
                            lineHeight: 30,
                            percent: (DataManager().downloadProgressModel.downloadProgress / 100.0).toDouble(),
                            center: Text('Loading data ${DataManager().downloadProgressModel.downloadProgress.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12.0)),
                            barRadius: const Radius.circular(10),
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
