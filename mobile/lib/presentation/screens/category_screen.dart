import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/category.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import 'package:wordzoo/presentation/widgets/signpost_widget.dart';
import 'entity_list_screen.dart';

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(category.background),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
                    ),
                    Expanded(
                      child: Text(
                        category.names.vi,
                        style: AppTextStyles.title,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    // Background decoration
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.skyBlue.withOpacity(0.3),
                              AppColors.grassGreen.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Random positioned signposts
                    ...category.subcategories.map((sub) {
                      final random = Random(sub.id.hashCode);
                      final left = 50 + random.nextDouble() * (MediaQuery.of(context).size.width - 200);
                      final top = 50 + random.nextDouble() * (MediaQuery.of(context).size.height - 200);
                      return Positioned(
                        left: left,
                        top: top,
                        child: SignpostWidget(
                          title: sub.names.vi,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EntityListScreen(
                                  category: category,
                                  subcategory: sub,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
