
import 'package:joy_society/data/model/response/common_list_model.dart';

import 'network_utils.dart';

/// GET method demo
Future<AppListingModel> getUserList(int page) async {
  return AppListingModel.fromJson(await (handleResponse(await getRequest('/master/location?page_size=20&page=$page'))));
}

/// POST method demo
Future createEmployee(Map req) async {
  return await handleResponse(await postRequest('api/users', req));
}

/// Put method
Future updateUser(Map req) async {
  return await handleResponse(await putRequest("api/users/2", req));
}

///Delete method
Future<AppListingModel> deleteUser(int id) async {
  return AppListingModel.fromJson(await (handleResponse(await deleteRequest('api/users/$id'))));
}
