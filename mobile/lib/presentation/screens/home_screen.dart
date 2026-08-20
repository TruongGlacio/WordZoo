import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wordzoo/blocs/language/language_bloc.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/data/models/category.dart';
import 'package:wordzoo/features/ads/google_mobile_ads/google_mobile_ads_manager.dart';
import 'package:wordzoo/features/iap/iap_page.dart';
import 'package:wordzoo/generated/assets.dart';
import 'package:wordzoo/presentation/widgets/my_point_widget.dart';
import 'package:wordzoo/utils/audio_service.dart';
import 'package:wordzoo/utils/font_manager.dart';
import 'package:wordzoo/utils/premium_entity_manager.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../../utils/size_manager.dart';
import 'package:wordzoo/generated/l10n.dart';
import 'Category/category_screen.dart';

class HomeScreen extends StatefulWidget {
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
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userName = authState is Authenticated ? (authState.user.displayName ?? '') : '';
    categoryListWidget = [];
    for (Category category in DataManager().getCategories()) {
      categoryListWidget.add(
        _CategoryCard(
          iconAsset: category.icon,
          title: category.names.getBy(DataManager().getCurrentLocale().languageCode),
          onTap: () {
            AudioService().playAssetSource(Assets.assets.sounds.ui.click);
            gotoCategoryScreen(context, category: category);
          },
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(0),
          image: DecorationImage(
              image: AssetImage(Assets.assets.background.home1.path),
              fit: BoxFit.cover),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          fit: StackFit.expand,
          children: [
            Column(
            children: [
              Expanded(
                child: SafeArea(
                top: true,
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height/24),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxHeight >= SizeManager().iconXXXXXLarge * 2) {
                        return Center(
                          child: GridView.count(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              dragStartBehavior: DragStartBehavior.start,
                              crossAxisCount: 2,
                              crossAxisSpacing: SizeManager().spacing16,
                              mainAxisSpacing: SizeManager().spacing16,
                              children: categoryListWidget),
                        );
                      } else {
                        return Center(
                          child: Container(
                            constraints: BoxConstraints(
                                maxHeight: constraints.maxHeight
                            ),
                            child: ListView(shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                dragStartBehavior: DragStartBehavior.start,
                                children: categoryListWidget),
                          ),
                        );
                      }
                    },
                  ),
                ),
                                ),
              ),
              Gap(SizeManager().spacing32),
              SafeArea(
                top: false,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: SizeManager().iconLarge * 3,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              customButton: Center(
                                child: Image.asset(
                                  DataManager().getCurrentLocale().languageCode == 'vi'
                                      ? Assets.assets.icons.vietnam.path
                                      : DataManager().getCurrentLocale().languageCode == 'en'
                                      ? Assets.assets.icons.england.path
                                      : Assets.assets.icons.china.path,
                                  width: 80,
                                  height: 60,
                                ),
                              ),
                              items: [..._LanguageMenuItems.languageItems.map((item) => DropdownItem<_MenuItem>(value: item, height: 48, child: _LanguageMenuItems.buildItem(item)))],
                              onChanged: (value) {
                                _LanguageMenuItems.onChanged(context, value!);
                              },
                              dropdownStyleData: DropdownStyleData(
                                width: SizeManager().size200,
                                padding: EdgeInsets.symmetric(vertical: SizeManager().spacing8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(SizeManager().spacing8), color: Colors.white),
                                offset: const Offset(-32, -120),
                              ),
                              menuItemStyleData:  MenuItemStyleData(padding: EdgeInsets.only(left: SizeManager().spacing16, right:  SizeManager().spacing16)),
                            ),
                          ),
                        ),
                        Gap(SizeManager().spacing8),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.sunnyYellow,
                              border: Border.all(color: AppColors.earthBrown, width: 1),
                              borderRadius: BorderRadius.circular(SizeManager().borderRadiusMedium),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(S().helloUser(userName), style: AppTextStyles.body),
                                Gap(SizeManager().spacing8),
                                Text(S().todayIsNewDay, style: AppTextStyles.title),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(const LogoutRequested());
                          },
                          icon: Image.asset(Assets.assets.icons.logout.path, width: SizeManager().iconLarge * 2, height: SizeManager().iconLarge * 2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
            SafeArea(child: buildSettingMenu(context: context))

          ]
        ),
      ),
    );
  }

  Widget buildSettingMenu({required BuildContext context}){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children:[
        SizedBox(
          width: SizeManager().iconLarge * 3,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Center(
                child: MyPointWidget()
              ),
              items: [..._SettingMenuItems.settingItems.map((item) => DropdownItem<_MenuItem>(value: item, height: SizeManager().imageSmall, child: _SettingMenuItems.buildItem(item)))],
              onChanged: (value) {
                _SettingMenuItems.onSelected(context, value!);
              },
              dropdownStyleData: DropdownStyleData(
                width: SizeManager().size200,
                padding:  EdgeInsets.symmetric(vertical: SizeManager().spacing8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(SizeManager().spacing8), color: Colors.white),
                offset: const Offset(0, 0),
              ),
              menuItemStyleData:  MenuItemStyleData(padding: EdgeInsets.only(left: SizeManager().spacing16, right:  SizeManager().spacing16)),
            ),
          ),
        )
      ],
    );

  }

  void gotoCategoryScreen(BuildContext context, {required Category category}) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => CategoryScreen(category: category)));
  }
}

class _CategoryCard extends StatelessWidget {
  final String iconAsset;
  final String title;
  final VoidCallback onTap;

  const _CategoryCard({required this.iconAsset, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        elevation: 1,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(image: AssetImage(iconAsset), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge),
            ),
            child: SizedBox(
              width: SizeManager().iconXXXXXLarge,
              height: SizeManager().iconXXXXXLarge,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: SizeManager().iconXXXXLarge - SizeManager().iconSmall,
                    alignment: Alignment.centerRight,
                   // color: Colors.white,
                    margin: EdgeInsets.only(
                        bottom: 12,
                        right: SizeManager().spacing8,
                        left: SizeManager().spacing4),
                    padding: EdgeInsets.only(left: SizeManager().spacing4),
                    //color: Colors.white,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        title,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: SizeManager().captionFontSize, fontWeight: FontWeight.bold, color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate().scale(duration: 200.ms);
    },);

  }
}

class _MenuItem {
  const _MenuItem({required this.text, required this.icon});

  final String text;
  final String icon;
}

abstract class _LanguageMenuItems {
  static List<_MenuItem> languageItems = [vietnamese, english, chinese];

  static _MenuItem vietnamese = _MenuItem(text: 'Vietnamese', icon: Assets.assets.icons.vietnam.path);
  static _MenuItem english = _MenuItem(text: 'English', icon: Assets.assets.icons.england.path);
  static _MenuItem chinese = _MenuItem(text: 'Chinese', icon: Assets.assets.icons.china.path);

  static Widget buildItem(_MenuItem item) {
    return Row(
      children: [
        Image.asset(item.icon, width: 50, height: 40),
        const SizedBox(width: 10),
        Expanded(child: Text(item.text, style: FontManager().body)),
      ],
    );
  }

  static void onChanged(BuildContext context, _MenuItem item) {
    if (item == _LanguageMenuItems.vietnamese) {
      context.read<LanguageBloc>().add( const ChangeLanguage(Locale('vi')));
    } else if (item == _LanguageMenuItems.english) {
      context.read<LanguageBloc>().add( const ChangeLanguage(Locale('en')));
    } else if (item == _LanguageMenuItems.chinese) {
      context.read<LanguageBloc>().add( const ChangeLanguage(Locale('zh')));
    }
  }
}

abstract class _SettingMenuItems {
  static List<_MenuItem> settingItems =
  [
    //iap,
    openads
  ];

  static _MenuItem iap = _MenuItem(text: S().buy_premium, icon: Assets.assets.icons.iap.path);
  static _MenuItem openads = _MenuItem(text: S().watching_ads, icon: Assets.assets.icons.ads.path);

  static Widget buildItem(_MenuItem item) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeManager().borderRadiusSmall)
          ),
            clipBehavior: Clip.hardEdge,
            width: SizeManager().imageXSmall,
            height: SizeManager().imageXSmall,
            child: Image.asset(
                item.icon,
                width: SizeManager().imageXSmall, height: SizeManager().imageXSmall)),
        Gap(SizeManager().spacing8),
        Expanded(child: Text(item.text, style: FontManager().body)),
      ],
    );
  }

  static void onSelected(BuildContext context, _MenuItem item) {
    if (item == _SettingMenuItems.iap) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute<void>(
            builder: (_) {
              debugPrint('BUILD IAP PAGE');
              return const IAPPage();
            },
          ),
        );
      });
    } else if (item == _SettingMenuItems.openads) {
      GoogleMobileAdsManager().showRewardAds(
        onRewardEarned: (ad, reward) {
        },
        onAdFailedToShow: (error) {

        },
        onAdDismissed: () async {
          await PremiumEntityManager().increasePointForFreeEntityForOneAdsWatching();
        },
      );
    }
  }
}
