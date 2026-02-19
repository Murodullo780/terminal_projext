import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terminal_project/core/constants/pref_const.dart';
import 'package:terminal_project/data/models/product_model/product_model.dart';
import 'package:terminal_project/presentation/custom_loading/custom_loading.dart';

part 'product_catalog_event.dart';

part 'product_catalog_state.dart';

final demoProduct = ProductModel(
  id: 0,
  name: 'null',
  price: 0,
  stock: 0,
  category: 'null',
  rating: 0,
  createdAt: DateTime(1000),
);

class ProductCatalogBloc extends Bloc<ProductCatalogEvent, ProductCatalogState> {
  final Dio dio = Dio();

  ProductCatalogBloc() : super(ProductCatalogInitial()) {
    on<ProductCatalogGetEvent>((event, emit) async {
      emit(ProductCatalogLoading());

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String host = prefs.getString(PrefConst.host) ?? '';
      final String port = prefs.getString(PrefConst.port) ?? '';

      if (host.isEmpty || port.isEmpty) {
        emit(ProductCatalogError('port_or_host_empty_error'));
        return;
      }
      try {
        print('getting: http://$host:$port/products');
        final response = await dio.get(
          'http://$host:$port/products',
        );
        final List<ProductModel> products =
            response.data['data'].map<ProductModel>((json) => ProductModel.fromJson(json)).toList();

        emit(ProductCatalogLoaded(data: products));
      } catch (e) {
        print("ERROR: $e");

        if (e is DioException) {
          switch (e.type) {
            case DioExceptionType.connectionError:
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              emit(ProductCatalogError('connection_error'));
              break;

            case DioExceptionType.badResponse:
              emit(ProductCatalogError('server_error'));
              break;

            default:
              emit(ProductCatalogError('unknown_error'));
          }
        } else {
          emit(ProductCatalogError('unknown_error'));
        }
      }
    });
    on<ProductCatalogAddEvent>((event, emit) async {
      if (state is ProductCatalogLoaded) {
        final currentState = state as ProductCatalogLoaded;
        List<ProductModel> prods = List.from(currentState.data);

        final existingIndex = prods.indexWhere(
          (product) => product.id == event.model.id,
        );
        if (existingIndex != -1) {
          final List<String> prodMarks =
              List<String>.from(prods[existingIndex].marks ?? const <String>[]);
          if (!prodMarks.contains(event.mark)) {
            prodMarks.add(event.mark);
            prods[existingIndex] = prods[existingIndex].copyWith(marks: prodMarks);
            emit(ProductCatalogLoaded(data: prods));
          } else {
            CustomEasyLoading.showError('cant_double_mark'.tr());
          }
        }
      }
    });
    on<ProductCatalogClearEvent>((event, emit) async {
      if (state is ProductCatalogLoaded) {
        final currentState = state as ProductCatalogLoaded;
        List<ProductModel> prods = List.from(currentState.data);

        final existingIndex = prods.indexWhere(
          (product) => product.id == event.model.id,
        );
        if (existingIndex != -1) {
          prods[existingIndex] = prods[existingIndex].copyWith(marks: []);
          emit(ProductCatalogLoaded(data: prods));
        }
      }
    });
    on<ProductCatalogSendEvent>((event, emit) async {
      if (state is ProductCatalogLoaded) {
        final crnState = state as ProductCatalogLoaded;
        final List<ProductModel> prods = List.from(crnState.data);

        /// sending only products that have marks
        /// todo: have to finish this
        final List<ProductModel> prodWithMarks =
            prods.where((prod) => prod.marks?.isNotEmpty ?? false).toList();
      }
    });
    on<ProductCatalogDeleteEvent>((event, emit) async {
      final currentState = state as ProductCatalogLoaded;
      List<ProductModel> prods = List.from(currentState.data);

      final existingIndex = prods.indexWhere(
        (product) => product.id == event.model.id,
      );
      if (existingIndex != -1) {
        final List<String> updatedMarks = List<String>.from(prods[existingIndex].marks ?? []);
        updatedMarks.remove(event.mark);
        prods[existingIndex] = prods[existingIndex].copyWith(marks: updatedMarks);
        emit(ProductCatalogLoaded(data: prods));
      }
    });
  }
}
