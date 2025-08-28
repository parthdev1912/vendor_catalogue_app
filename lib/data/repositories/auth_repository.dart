import 'package:vendor_catalogue_app/config_data/api_config.dart';
import 'package:vendor_catalogue_app/constants/preference_helper.dart';
import 'package:vendor_catalogue_app/constants/preference_key.dart';
import 'package:vendor_catalogue_app/data/services/api_service.dart';
import 'package:vendor_catalogue_app/logic/models/products/product_model.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<String?> login(String username, String password) async {

    await Future.delayed(Duration(seconds: 2));

    if (username.isNotEmpty && password.isNotEmpty) {
      const mockToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEyMywidXNlcm5hbWUiOiJkZW1vVXNlciIsImV4cCI6MTk5OTk5OTk5OX0.abc123xyzMockSignature";
      await PreferenceHelper.setStringPrefValue(key: SharedPreferencesConstants.accessToken, value: mockToken);
      ApiService().setAuthToken(mockToken);
      return mockToken;
    }
    return null;
  }

  Future<void> logout() async {
    await PreferenceHelper.removePrefValue(key: SharedPreferencesConstants.accessToken);
    _apiService.clearAuthToken();
  }

  Future <List<ProductModel>> getProducts() async {
    try {
      final response = await _apiService.get(ApiConfig.fetchProductsList);

      if (response.containsKey('products') && response['products'] is List) {
        final productsList = response['products'] as List;
        return productsList
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException('Invalid response format for products. Expected "products" field.', 0);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Some error occurred at our end. Please try again or contact support team', 0);
    }
  }
}


