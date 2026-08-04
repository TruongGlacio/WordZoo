import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/data/models/category.dart';
import 'package:wordzoo/data/models/localized_names.dart';
import 'package:wordzoo/generated/assets.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../../utils/size_manager.dart';
import 'package:wordzoo/l10n/app_localizations.dart';

import 'Category/category_screen.dart';
class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeScreenState();
  }

}

class HomeScreenState extends State<HomeScreen> {

  List<Widget> categoryListWidget = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(Category category in DataManager().getCategories())
      {
        categoryListWidget.add(
            _CategoryCard(
              iconAsset: category.icon, title: category.names.vi, onTap: () {
              gotoCategoryScreen(context, category: category);
            },
            )
        );
      }

  }
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userName = authState is Authenticated
        ? (authState.user.displayName ?? '')
        : '';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.gradientSkyGrass,
          image: DecorationImage(image: AssetImage(Assets.assets.background.home1.path), fit: BoxFit.fill)
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(top: SizeManager().spacing32),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  dragStartBehavior: DragStartBehavior.start,
                  children: categoryListWidget
                ),
              ),
            ),
            Gap(SizeManager().spacing32),
            SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Gap( SizeManager().iconLarge*3),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color:AppColors.sunnyYellow,
                            border: Border.all(color: AppColors.earthBrown, width: 1),
                            borderRadius: BorderRadius.circular(SizeManager().borderRadiusMedium)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center ,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.helloUser(userName),
                                style: AppTextStyles.body,
                              ),
                              Gap(SizeManager().spacing8),
                              Text(
                                AppLocalizations.of(context)!.todayIsNewDay,
                                style: AppTextStyles.title,
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const LogoutRequested());
                        },
                        icon: Image.asset(Assets.assets.icons.logout.path, width: SizeManager().iconLarge*2, height: SizeManager().iconLarge*2,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void gotoCategoryScreen(BuildContext context, {required Category category}) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) =>  CategoryScreen(category: category,),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String iconAsset;
  final String title;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.iconAsset,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              SizeManager().borderRadiusLarge)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(iconAsset), fit: BoxFit.fill),
            borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge),
          ),
          child: SizedBox(
            width: SizeManager().iconXXXXXXLarge,
            height: SizeManager().iconXXXXLarge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: SizeManager().iconXXXXXLarge/2- SizeManager().iconSmall,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 12, right: SizeManager().spacing8, left: SizeManager().spacing4),
                  padding: EdgeInsets.only(left: SizeManager().spacing4),

                  //color: Colors.white,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeManager().captionFontSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().scale(duration: 200.ms);
  }
}
