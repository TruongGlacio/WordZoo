import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/data/models/subcategory.dart';
import 'package:wordzoo/generated/assets.dart';
import 'package:wordzoo/presentation/screens/entity_list_screen.dart';
import 'package:wordzoo/utils/audio_service.dart';
import '../../../data/models/category.dart';
import 'package:wordzoo/base/theme/colors_app.dart';
import '../../../base/resizer/size_manager.dart';
import 'category_map_layout.dart';

double nodeSize = Dimens().iconXXXLarge;

class CategoryScreen extends StatefulWidget {
  final Category category;
  const CategoryScreen({super.key, required this.category});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryScreenState();
  }
}

class CategoryScreenState extends State<CategoryScreen> {
  late Category category;
  List<CategoryLayout> categoriesLayout = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    category = widget.category;
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      setState(() {
        categoriesLayout = CategoryMapLayout(mapSize: Size(MediaQuery.of(context).size.width * 1.5, MediaQuery.of(context).size.height - 24 * 2), nodeSize: Size(nodeSize, nodeSize)).generate(category.subcategories);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: null,
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 1.5,
              height: MediaQuery.of(context).size.height,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(image: AssetImage(category.background), fit: BoxFit.fitHeight),
                ),
                child: SafeArea(
                  child: Stack(
                    //fit: StackFit.loose,
                    children: [
                      ...categoriesLayout.map((layout) {
                        return Positioned(
                          left: layout.position.dx,
                          top: layout.position.dy,
                          child: _SubCategoryItem(
                            subcategory: layout.category,
                            onTap: () {
                              // Handle tap event for subcategory
                              AudioService().playAssetSource(Assets.assets.sounds.ui.click);
                              gotoEntityList(context, category: category, subcategory: layout.category);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Image.asset(Assets.assets.icons.backPage.path, width: Dimens().iconXLarge, height: Dimens().iconXLarge),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void gotoEntityList(BuildContext context, {required Category category, required Subcategory subcategory}) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) =>  EntityListScreen(category: category,subcategory: subcategory,),
      ),
    );
  }
}

class _SubCategoryItem extends StatelessWidget {
  final Subcategory subcategory;
  final VoidCallback onTap;

  const _SubCategoryItem({required this.subcategory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage(Assets.assets.categoryCard.subCategoryCard.path),
            fit: BoxFit.fill,
            //colorFilter: const ColorFilter.mode(Colors.black12, BlendMode.dstOut)
          ),
          borderRadius: BorderRadius.circular(Dimens().borderRadiusLarge),
        ),
        child: SizedBox(
          width: nodeSize,
          height: nodeSize,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: Dimens().iconMediumX,
                width: Dimens().iconMediumX,
                margin: EdgeInsets.only(top: Dimens().spacingExtraSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens().iconMediumX)
                ),
                clipBehavior: Clip.hardEdge,
                //alignment: Alignment.center,
                child: Image.file(
                  File(subcategory.getLocalIcon()),
                  fit: BoxFit.fill,
                ) ,
              ),
              Container(
                decoration: BoxDecoration(
                 // color: AppColors.brown,
                  borderRadius: BorderRadius.circular(Dimens().borderRadiusSmall)
                ),
                constraints: BoxConstraints(
                  minHeight: Dimens().spacing40
                ),
                margin: EdgeInsets.only(bottom: Dimens().spacingSmall),
                padding: EdgeInsets.symmetric(horizontal: Dimens().spacingExtraSmall, vertical: Dimens().spacingExtraSmall),
                child: Text(
                  subcategory.names.getBy(DataManager().getCurrentLocale().languageCode),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Dimens().extraSmallFontSize, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(duration: 200.ms);
  }

}
