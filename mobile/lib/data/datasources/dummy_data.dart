
import 'package:wordzoo/data/models/category.dart';
import 'package:wordzoo/data/models/localized_names.dart';
import 'package:wordzoo/data/models/subcategory.dart';
import 'package:wordzoo/generated/assets.dart';

class DummyData {
  static final DummyData _singletonDummyData = DummyData._internal();
  static DummyData get getInstance => _singletonDummyData;
  factory DummyData() {
    return _singletonDummyData;
  }
  DummyData._internal();

  List<Category> getCategories() {
    return [
       Category(
           id: CategoryType.animals.name,
           type: CategoryType.animals,
           names: LocalizedNames(vi: 'Động vật', en: 'Animals', zh: '动物'),
           icon: Assets.categoryCard.animalCard2.path,
           background: Assets.background.animalsCategoryMap2k.path,
           signpostStyle: '',
           subcategories: [
             Subcategory(id: "Wild", order: 1, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 2, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 3, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 4, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 5, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 6, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 7, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 8, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 9, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 10, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 11, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 12, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 13, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 14, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 15, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 16, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 17, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),
             Subcategory(id: "Wild", order: 18, icon: Assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'), entities: []),

           ]
      ),
      Category(
          id: CategoryType.plants.name,
          type: CategoryType.plants,
          names: const LocalizedNames(vi: 'Thực vật', en: 'Plants', zh: '植物'),
          icon: Assets.categoryCard.plantCard2.path,
          background: Assets.background.plantsCategoryMap2k.path,
          signpostStyle: '',
          subcategories: [
            Subcategory(id: "Flowers", order: 1, icon: Assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
            Subcategory(id: "Flowers", order: 2, icon: Assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
            Subcategory(id: "Flowers", order: 3, icon: Assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
            Subcategory(id: "Flowers", order: 4, icon: Assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
            Subcategory(id: "Flowers", order: 5, icon: Assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
            Subcategory(id: "Flowers", order: 6, icon: Assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
            Subcategory(id: "Flowers", order: 7, icon: Assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
          ]
      ),
      Category(
          id: CategoryType.vehicles.name,
          type: CategoryType.vehicles,
          names: const LocalizedNames(vi: 'Phương tiện giao thông', en: 'Vehicles', zh: ' Vehicles'),
          icon: Assets.categoryCard.vehicleCard2.path,
          background: Assets.background.vehiclesCategoryMap2k.path,
          signpostStyle: '',
          subcategories: [
            Subcategory(id: "Air Vehicles", order: 1, icon: Assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
            Subcategory(id: "Air Vehicles", order: 2, icon: Assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
            Subcategory(id: "Air Vehicles", order: 3, icon: Assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
            Subcategory(id: "Air Vehicles", order: 4, icon: Assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
            Subcategory(id: "Air Vehicles", order: 5, icon: Assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
            Subcategory(id: "Air Vehicles", order: 6, icon: Assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
            Subcategory(id: "Air Vehicles", order: 7, icon: Assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
          ]
      ),
      Category(
          id: CategoryType.humanRelations.name,
          type: CategoryType.humanRelations,
          names: const LocalizedNames(vi: 'Con người', en: 'Humans', zh: '人类'),
          icon: Assets.categoryCard.humanRelationsCard2.path,
          background: Assets.background.peopleCategoryMap2k.path,
          signpostStyle: '',
          subcategories: [
            Subcategory(id: "Family", order: 1, icon: Assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
            Subcategory(id: "Family", order: 2, icon: Assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
            Subcategory(id: "Family", order: 3, icon: Assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
            Subcategory(id: "Family", order: 4, icon: Assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
            Subcategory(id: "Family", order: 5, icon: Assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
            Subcategory(id: "Family", order: 6, icon: Assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
            Subcategory(id: "Family", order: 7, icon: Assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
          ]
      ),
    ];

  }
}