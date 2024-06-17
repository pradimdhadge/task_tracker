import 'package:get_it/get_it.dart';

import '../constants/api_paths.dart';
import '../network/api_client_interface.dart';

mixin RepoHelper {
  final ApiClientInterface client = GetIt.instance.get<ApiClientInterface>();
  final ApiPaths paths = ApiPaths();
}
