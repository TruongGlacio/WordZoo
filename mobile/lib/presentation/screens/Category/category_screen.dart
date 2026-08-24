import 'dart:io';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/data/models/subcategory.dart';
import 'package:wordzoo/generated/assets.dart';
import 'package:wordzoo/presentation/screens/entity_list_screen.dart';
import 'package:wordzoo/presentation/theme/app_theme.dart';
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
        nodeSize = MediaQuery.of(context).size.height/4;
        if(nodeSize> Dimens().iconXXXXXLarge)
          {
            nodeSize = Dimens().iconXXXXXLarge;
          }
        else if(nodeSize < Dimens().iconXXXLarge)
          {
            nodeSize = Dimens().iconXXXLarge;
          }
        categoriesLayout = CategoryMapLayout(
            mapSize: Size(MediaQuery.of(context).size.width * 1.5, MediaQuery.of(context).size.height - 24 * 2),
            nodeSize: Size(nodeSize, nodeSize)).generate(category.subcategories);
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
    return LayoutBuilder(builder: (context, constraints) {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: nodeSize*7/10,
          height: nodeSize,
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage(Assets.assets.categoryCard.subCategoryCard.path),
              fit: BoxFit.fitHeight,
              //colorFilter: const ColorFilter.mode(Colors.black12, BlendMode.dstOut)
            ),
            borderRadius: BorderRadius.circular(Dimens().borderRadiusLarge),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: nodeSize/3,
                width: nodeSize/3,
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
                   //color: ColorConst.brown.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(Dimens().borderRadiusSmall)
                ),
                height: nodeSize/3,
                width: nodeSize*7/10,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: Dimens().spacingExtraSmall, vertical: Dimens().spacingExtraSmall),
                child: AutoSizeText(
                  subcategory.names.getBy(DataManager().getCurrentLocale().languageCode)??'',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  stepGranularity: Dimens().extraSmallXXXFontSize/12,
                  minFontSize: Dimens().extraSmallXXXFontSize,
                  maxFontSize: Dimens().signpostFontSize,
                  style: TextStyle(fontSize: Dimens().extraSmallFontSize, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    },).animate().scale(duration: 200.ms);
  }

}
