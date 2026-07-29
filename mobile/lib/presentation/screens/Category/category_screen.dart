import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/data/models/subcategory.dart';
import 'package:wordzoo/generated/assets.dart';
import '../../../data/models/category.dart';
import '../../theme/app_colors.dart';
import '../../../utils/size_manager.dart';
import 'category_map_layout.dart';

double nodeSize = SizeManager().iconXXLarge;

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
                  icon: Icon(Icons.arrow_back_ios, color: AppColors.sunnyYellow, weight: 1, size: SizeManager().iconMedium),
                ),
              ],
            ),
          ),
        ],
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
    return Card(
      elevation: 2,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage(Assets.categoryCard.subCategoryCard.path),
              fit: BoxFit.fill,
              //colorFilter: const ColorFilter.mode(Colors.black12, BlendMode.dstOut)
            ),
            borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge),
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
                  height: SizeManager().iconMediumX,
                  width: SizeManager().iconMediumX,
                  margin: EdgeInsets.only(top: SizeManager().spacingExtraSmall),
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(subcategory.icon),fit:BoxFit.fill ),
                    borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge)
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                   // color: AppColors.brown,
                    borderRadius: BorderRadius.circular(SizeManager().borderRadiusSmall)
                  ),
                  constraints: BoxConstraints(
                    minHeight: SizeManager().spacing40
                  ),
                  margin: EdgeInsets.only(bottom: SizeManager().spacingSmall),
                  padding: EdgeInsets.symmetric(horizontal: SizeManager().spacingExtraSmall, vertical: SizeManager().spacingExtraSmall),
                  child: Text(
                    subcategory.names.getBy('en'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: SizeManager().extraSmallFontSize, fontWeight: FontWeight.bold, color: Colors.black),
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
