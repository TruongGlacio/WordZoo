import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/blocs/language/language_bloc.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/data/models/category.dart';
import 'package:wordzoo/data/models/localized_names.dart';
import 'package:wordzoo/generated/assets.dart';
import 'package:wordzoo/utils/audio_service.dart';
import 'package:wordzoo/utils/font_manager.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../../utils/size_manager.dart';
import 'package:wordzoo/l10n/app_localizations.dart';

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
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SafeArea(
                top: true,
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height/8),
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
                            constraints: BoxConstraints(maxHeight: SizeManager().iconXXXXXLarge),
                            child: ListView(shrinkWrap: true, scrollDirection: Axis.horizontal, dragStartBehavior: DragStartBehavior.start, children: categoryListWidget),
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
                            items: [..._MenuItems.firstItems.map((item) => DropdownItem<_MenuItem>(value: item, height: 48, child: _MenuItems.buildItem(item)))],
                            onChanged: (value) {
                              _MenuItems.onChanged(context, value!);
                            },
                            dropdownStyleData: DropdownStyleData(
                              width: 200,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.white),
                              offset: const Offset(-32, -120),
                            ),
                            menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.only(left: 16, right: 16)),
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
                              Text(AppLocalizations.of(context)!.helloUser(userName), style: AppTextStyles.body),
                              Gap(SizeManager().spacing8),
                              Text(AppLocalizations.of(context)!.todayIsNewDay, style: AppTextStyles.title),
                            ],
                          ),
                        ),
                      ),
/*                      IconButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const LogoutRequested());
                        },
                        icon: Image.asset(Assets.assets.icons.logout.path, width: SizeManager().iconLarge * 2, height: SizeManager().iconLarge * 2),
                      ),*/
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(iconAsset), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge),
            ),
            child: SizedBox(
              width: SizeManager().iconXXXXLarge,
              height: SizeManager().iconXXXXLarge,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: SizeManager().iconXXXXLarge - SizeManager().iconSmall,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
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
                        textAlign: TextAlign.center,
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

abstract class _MenuItems {
  static List<_MenuItem> firstItems = [vietnamese, english, chinese];

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
    if (item == _MenuItems.vietnamese) {
      context.read<LanguageBloc>().add(ChangeLanguage(Locale('vi')));
    } else if (item == _MenuItems.english) {
      context.read<LanguageBloc>().add(ChangeLanguage(Locale('en')));
    } else if (item == _MenuItems.chinese) {
      context.read<LanguageBloc>().add(ChangeLanguage(Locale('zh')));
    }
  }
}
