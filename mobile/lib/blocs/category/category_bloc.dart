import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/category.dart';
import '../../data/repositories/data_sync_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final DataSyncRepository dataSyncRepo;

  CategoryBloc({required this.dataSyncRepo}) : super(const CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      final data = await dataSyncRepo.getCachedData();
      if (data != null) {
        emit(CategoryLoaded(categories: data.categories));
      } else {
        emit(const CategoryError('Không có dữ liệu danh mục'));
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
