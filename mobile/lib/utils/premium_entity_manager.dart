import 'package:wordzoo/base/store/cache_storage.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/data/models/category.dart';
import 'package:wordzoo/data/models/entity.dart';
import 'package:wordzoo/data/models/subcategory.dart';
import 'package:wordzoo/data/models/word_zoo_data.dart';

class PremiumEntityManager {
  static final PremiumEntityManager _singletonAdsManager = PremiumEntityManager._internal();
  static PremiumEntityManager get getInstance => _singletonAdsManager;
  factory PremiumEntityManager() {
    return _singletonAdsManager;
  }
  PremiumEntityManager._internal();


  Map<String, bool>? _listOfPassEntity;
  final int _pointForOpenOneEntity = 1;
  final int _pointForWatchingOneAds = 5;
  final _freeEntityOneSubCategory = 10;

  Future<void> initialListOfPassEntity(Map<String, bool> list) async {
    await SharedPreferencesStorage().removeByKey(Storage.listOfPassEntity);
    Map<String, bool>? listOfPassEntityTemp = _listOfPassEntity??getListOfPassEntity();
    listOfPassEntityTemp.addAll(list);
    await SharedPreferencesStorage().saveMapByStringKey(map: listOfPassEntityTemp, key: Storage.listOfPassEntity);
    _listOfPassEntity = listOfPassEntityTemp;
  }
  Future<void> updateListOfPassEntity(Map<String, bool> list) async {
    Map<String, bool>? listOfPassEntityTemp = _listOfPassEntity??getListOfPassEntity();
    for(String key in list.keys)
      {
        if(!listOfPassEntityTemp.containsKey(key))
          {
            listOfPassEntityTemp[key]= list[key]??true;
            decreasePointForFreeEntityForOneOpenEntity();
          }
      }
    await SharedPreferencesStorage().saveMapByStringKey(map: listOfPassEntityTemp, key: Storage.listOfPassEntity);
    _listOfPassEntity = listOfPassEntityTemp;
  }

  Map<String, bool> getListOfPassEntity(){
    _listOfPassEntity ??=  Map<String, bool>.from(SharedPreferencesStorage().getMapByKey(key: Storage.listOfPassEntity)  as Map,);
    return _listOfPassEntity??{};
  }

  int getPointForFreeEntity(){
    int point = SharedPreferencesStorage().getInt(Storage.pointForFreeEntity);
    return point;
  }
  Future<void> _updatePointForFreeEntity({required int point}) async {
    await SharedPreferencesStorage().saveInteger(Storage.pointForFreeEntity, point);
    DataManager().myPointModel.notiPoint(point);
  }
  Future<void> increasePointForFreeEntityForOneAdsWatching() async {
    int pointFinal = getPointForFreeEntity() + _pointForWatchingOneAds;
    await _updatePointForFreeEntity(point: pointFinal);
  }
  Future<void> decreasePointForFreeEntityForOneOpenEntity() async {
    int pointFinal = getPointForFreeEntity() - _pointForOpenOneEntity;
    await _updatePointForFreeEntity(point: pointFinal);
  }

  bool isValidPoint(){
    int point = getPointForFreeEntity();
    return point >= _pointForOpenOneEntity;
  }
  bool checkOpenedEntity({required Entity entity}){
    bool result = getListOfPassEntity().containsKey(entity.id);
    return result;
  }

  WordZooData setUpWordZooDataWhenInitial({required WordZooData wordZooData}){
    Map<String, bool> listOfPassEntity = getListOfPassEntity();
    for(Category category in wordZooData.categories)
      {
        for(Subcategory subcategory in category.subcategories)
        {
          int index =0;
          for(Entity entity in subcategory.entities)
            {
              if(index<=_freeEntityOneSubCategory)
                {
                  entity.isPremium = false;
                }
              else
                {
                  if(listOfPassEntity.containsKey(entity.id))
                    {
                      entity.isPremium = false;
                    }
                  else
                    {
                      entity.isPremium = true;
                    }
                }
              index++;
            }
        }
      }
    return wordZooData;
  }
}
