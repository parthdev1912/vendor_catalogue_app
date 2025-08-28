import 'package:bloc/bloc.dart';
import 'package:vendor_catalogue_app/data/repositories/auth_repository.dart';
import 'package:vendor_catalogue_app/logic/bloc/product/product_event.dart';
import 'package:vendor_catalogue_app/logic/bloc/product/product_state.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final AuthRepository authRepository;

  ProductBloc({required this.authRepository}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await authRepository.getProducts();
      emit(ProductSuccess(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onRefreshProducts(RefreshProducts event, Emitter<ProductState> emit) async {
    try {
      final products = await authRepository.getProducts();
      emit(ProductSuccess(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
