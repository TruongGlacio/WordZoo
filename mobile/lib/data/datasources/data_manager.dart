
import 'package:flutter/cupertino.dart';
import 'package:wordzoo/data/models/audio_paths.dart';
import 'package:wordzoo/data/models/category.dart';
import 'package:wordzoo/data/models/entity.dart';
import 'package:wordzoo/data/models/localized_names.dart';
import 'package:wordzoo/data/models/subcategory.dart';
import 'package:wordzoo/data/models/word_zoo_data.dart';
import 'package:wordzoo/generated/assets.dart';

class DataManager {
  static final DataManager _singletonDummyData = DataManager._internal();
  static DataManager get getInstance => _singletonDummyData;
  factory DataManager() {
    return _singletonDummyData;
  }
  DataManager._internal();
  List<Category> _categories = [];
  String _rootPath='';
  void setRootPath(String? rootPath)
  {
    _rootPath = rootPath??'';
  }
  String getRootPath(){
    return _rootPath;
  }
  Locale _currentLocale = Locale('vi');
  Locale _currentLocaleForEntity = Locale('vi');

  void setCurrentLocale(Locale locale){
    _currentLocale = locale;
  }
  Locale getCurrentLocale(){
    return _currentLocale;
  }
  void setCurrentLocaleForEntity(Locale locale){
    _currentLocaleForEntity = locale;
  }
  Locale getCurrentLocaleForEntity(){
    return _currentLocaleForEntity;
  }
  List<Category> getCategories() {
    if(_categories.isEmpty) {
      _categories = [
       Category(
           id: CategoryType.animals.name,
           type: CategoryType.animals,
           names: LocalizedNames(vi: 'Động vật', en: 'Animals', zh: '动物'),
           icon: Assets.assets.categoryCard.animalCard2.path,
           background: Assets.assets.background.animalsCategoryMap2k.path,
           signpostStyle: '',
           subcategories: [
             Subcategory(id: "Wild", order: 1, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: false, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 2, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: false, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 3, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: false, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 4, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: false, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 5, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: false, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 6, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: false, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 7, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: false, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 8, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: false, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 9, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: false, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 10, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: false, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 11, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: false, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 12, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: false, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 13, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: false, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 14, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: true, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 15, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: true, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 16, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: true, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 17, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: true, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 18, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: true, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 19, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: true, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),
             Subcategory(id: "Wild", order: 20, icon: Assets.assets.subCategoryAvata.animals.wildAnimals.path, names: const LocalizedNames(vi: 'Động vật hoang dã', en: 'Wild Animals', zh: 'Wild Animals'),
                 entities: [
                   Entity(id: "Dog", isPremium: true, names: LocalizedNames(vi: 'Chó', en: 'Dog', zh: '狗'), animationImage: "",
                       realImage: Assets.assets.subCategoryAvata.animals.wildAnimals.path,
                       audio:AudioPaths(vi:  Assets.assets.audio.dragonStudioCowMoo390282, en:  Assets.assets.audio.dragonStudioCowMoo390282, zh:  Assets.assets.audio.dragonStudioCowMoo390282),
                       soundEffect:  Assets.assets.audio.dragonStudioCowMoo390282,
                       typeTags: [], difficulty: 1)
                 ]
             ),

           ]
      ),
      Category(
          id: CategoryType.plants.name,
          type: CategoryType.plants,
          names: const LocalizedNames(vi: 'Thực vật', en: 'Plants', zh: '植物'),
          icon: Assets.assets.categoryCard.plantCard2.path,
          background: Assets.assets.background.plantsCategoryMap2k.path,
          signpostStyle: '',
          subcategories: [
            Subcategory(id: "Flowers", order: 1, icon: Assets.assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
            Subcategory(id: "Flowers", order: 2, icon: Assets.assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
            Subcategory(id: "Flowers", order: 3, icon: Assets.assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
            Subcategory(id: "Flowers", order: 4, icon: Assets.assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
            Subcategory(id: "Flowers", order: 5, icon: Assets.assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
            Subcategory(id: "Flowers", order: 6, icon: Assets.assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
            Subcategory(id: "Flowers", order: 7, icon: Assets.assets.subCategoryAvata.plants.flowers.path, names: const LocalizedNames(vi: 'Hoa', en: 'Flowers', zh: 'Flowers'), entities: []),
          ]
      ),
      Category(
          id: CategoryType.vehicles.name,
          type: CategoryType.vehicles,
          names: const LocalizedNames(vi: 'Phương tiện', en: 'Vehicles', zh: ' Vehicles'),
          icon: Assets.assets.categoryCard.vehicleCard2.path,
          background: Assets.assets.background.vehiclesCategoryMap2k.path,
          signpostStyle: '',
          subcategories: [
            Subcategory(id: "Air Vehicles", order: 1, icon: Assets.assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
            Subcategory(id: "Air Vehicles", order: 2, icon: Assets.assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
            Subcategory(id: "Air Vehicles", order: 3, icon: Assets.assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
            Subcategory(id: "Air Vehicles", order: 4, icon: Assets.assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
            Subcategory(id: "Air Vehicles", order: 5, icon: Assets.assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
            Subcategory(id: "Air Vehicles", order: 6, icon: Assets.assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
            Subcategory(id: "Air Vehicles", order: 7, icon: Assets.assets.subCategoryAvata.vehicles.air.path, names: const LocalizedNames(vi: 'Phương tiện trên không', en: 'Air Vehicles', zh: 'Air Vehicles'), entities: []),
          ]
      ),
      Category(
          id: CategoryType.humanrelations.name,
          type: CategoryType.humanrelations,
          names: const LocalizedNames(vi: 'Con người', en: 'Humans', zh: '人类'),
          icon: Assets.assets.categoryCard.humanRelationsCard2.path,
          background: Assets.assets.background.peopleCategoryMap2k.path,
          signpostStyle: '',
          subcategories: [
            Subcategory(id: "Family", order: 1, icon: Assets.assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
            Subcategory(id: "Family", order: 2, icon: Assets.assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
            Subcategory(id: "Family", order: 3, icon: Assets.assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
            Subcategory(id: "Family", order: 4, icon: Assets.assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
            Subcategory(id: "Family", order: 5, icon: Assets.assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
            Subcategory(id: "Family", order: 6, icon: Assets.assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
            Subcategory(id: "Family", order: 7, icon: Assets.assets.subCategoryAvata.humanRelations.family.path, names: const LocalizedNames(vi: 'Gia đình', en: 'Family', zh: 'Family'), entities: []),
          ]
      ),
    ];
    }
    return _categories;
  }
  final DownloadProgressModel downloadProgressModel = DownloadProgressModel();

  void setCategories({required WordZooData wordZooData}){
    _categories = wordZooData.categories;
  }
}

class DownloadProgressModel extends ChangeNotifier {
  int _downloadProgress = 0;
  bool needDownloadFile = false;

  // Getter to expose the private variable safely
  int get downloadProgress => _downloadProgress;
  void notiDownloadProgress(int downloadProgress,bool needDownload) {
    _downloadProgress = downloadProgress;
    needDownloadFile = needDownload;
    notifyListeners();
  }
}