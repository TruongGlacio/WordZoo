import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordzoo/base/theme/text_stype_constant.dart';
import 'package:wordzoo/base/update_app/app_version_checker.dart';
import 'package:wordzoo/blocs/language/language_bloc.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/data/models/category.dart';
import 'package:wordzoo/features/ads/google_mobile_ads/google_mobile_ads_manager.dart';
import 'package:wordzoo/features/iap/iap_page.dart';
import 'package:wordzoo/generated/assets.dart';
import 'package:wordzoo/presentation/widgets/my_point_widget.dart';
import 'package:wordzoo/utils/audio_service.dart';
import 'package:wordzoo/utils/premium_entity_manager.dart';
import '../../blocs/auth/auth_bloc.dart';
import 'package:wordzoo/base/theme/colors_app.dart';
import '../../base/resizer/size_manager.dart';
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
          title: category.names.getBy(DataManager().getCurrentLocale().languageCode)??'',
          onTap: () {
            AudioService().playAssetSource(Assets.assets.sounds.ui.click);
            gotoCategoryScreen(context, category: category);
          },
        ),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_){
      AppVersionCheckerManager().checkAppNewVersion(context);
    });
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
                      if (constraints.maxHeight >= Dimens().iconXXXXXLarge * 2) {
                        return Center(
                          child: GridView.count(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              dragStartBehavior: DragStartBehavior.start,
                              crossAxisCount: 2,
                              crossAxisSpacing: Dimens().spacing16,
                              mainAxisSpacing: Dimens().spacing16,
                              children: categoryListWidget),
                        );
                      } else {
                        return Center(
                          child: Container(
                            alignment: Alignment.center,
                            child: ListView(
                                shrinkWrap: true,
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
              Gap(Dimens().spacing32),
              SafeArea(
                top: false,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Dimens().iconLarge * 3,
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
                                width: Dimens().size200,
                                padding: EdgeInsets.symmetric(vertical: Dimens().spacing8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens().spacing8), color: Colors.white),
                                offset: const Offset(-32, -120),
                              ),
                              menuItemStyleData:  MenuItemStyleData(padding: EdgeInsets.only(left: Dimens().spacing16, right:  Dimens().spacing16)),
                            ),
                          ),
                        ),
                        Gap(Dimens().spacing8),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorConst.sunnyYellow,
                              border: Border.all(color: ColorConst.earthBrown, width: 1),
                              borderRadius: BorderRadius.circular(Dimens().borderRadiusMedium),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(S().helloUser(userName), style: TextStyleConstant.body),
                                Gap(Dimens().spacing8),
                                Text(S().todayIsNewDay, style: TextStyleConstant.title),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(const LogoutRequested());
                          },
                          icon: Image.asset(Assets.assets.icons.logout.path, width: Dimens().iconLarge * 2, height: Dimens().iconLarge * 2),
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
          width: Dimens().iconLarge * 3,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Center(
                child: MyPointWidget()
              ),
              items: [
                ..._SettingMenuItems.settingItems.map((item) => DropdownItem<_MenuItem>(value: item, height: Dimens().imageSmall, child: _SettingMenuItems.buildItem(item)))],
              onChanged: (value) {
                _SettingMenuItems.onSelected(context, value!);
              },
              dropdownStyleData: DropdownStyleData(
                width: Dimens().size200,
                padding:  EdgeInsets.symmetric(vertical: Dimens().spacing8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens().spacing8), color: Colors.white),
                offset: const Offset(0, 0),
              ),
              menuItemStyleData:  MenuItemStyleData(padding: EdgeInsets.only(left: Dimens().spacing16, right:  Dimens().spacing16)),
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
      double height = MediaQuery.of(context).size.height/3;
      return Card(
        elevation: 1,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens().borderRadiusLarge)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Dimens().borderRadiusLarge),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(image: AssetImage(iconAsset), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(Dimens().borderRadiusLarge),
            ),
            width: height,
            height: height,
            alignment: Alignment.bottomRight,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth/2-constraints.maxWidth/12,
                height: constraints.maxHeight/6,
                alignment: Alignment.centerRight,
                padding: EdgeInsetsGeometry.symmetric(horizontal: Dimens().spacing4),
                child: Center(
                  child: AutoSizeText(
                    title,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 2,
                    stepGranularity: Dimens().extraSmallXXXFontSize/12,
                    minFontSize: Dimens().extraSmallXXXFontSize,
                    maxFontSize: Dimens().signpostFontSize,
                    style: TextStyle(fontSize: Dimens().captionFontSize, fontWeight: FontWeight.bold, color: ColorConst.white),
                  ),
                ),
              );
            },),
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
        Expanded(child: Text(item.text, style: TextStyleConstant.body)),
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
    openads,
    share
  ];

  static _MenuItem iap = _MenuItem(text: S().buy_premium, icon: Assets.assets.icons.iap.path);
  static _MenuItem openads = _MenuItem(text: S().watching_ads, icon: Assets.assets.icons.ads.path);
  static _MenuItem share = _MenuItem(text: S().shareApp, icon: Assets.assets.icons.share.path);

  static Widget buildItem(_MenuItem item) {

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens().borderRadiusSmall)
          ),
            clipBehavior: Clip.hardEdge,
            width: Dimens().imageXtraSmall,
            height: Dimens().imageXtraSmall,
            child: Image.asset(
                item.icon,
                width: Dimens().imageXtraSmall, height: Dimens().imageXtraSmall)),
        Gap(Dimens().spacing8),
        Expanded(child: Text(item.text, style: TextStyleConstant.body)),
      ],
    );
  }

  static Future<void> onSelected(BuildContext context, _MenuItem item) async {
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
    } else if(item == _SettingMenuItems.share)
      {
        final link = DataManager().getWordZooStoreLink();

        final message = '''
          🦁 WordZoo
          Học từ vựng thật vui cùng WordZoo!
          📚 Hình ảnh
          🔊 Phát âm
          🌍 Nhiều ngôn ngữ
          👉 Tải WordZoo:
          $link
          ''';
        await SharePlus.instance.share(
          ShareParams(
            text: message,
            title: 'Chia sẻ WordZoo',
          ),
        );
      }
  }
}
