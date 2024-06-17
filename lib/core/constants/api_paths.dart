class ApiPaths {
  static final ApiPaths _i = ApiPaths._();
  ApiPaths._();
  factory ApiPaths() {
    return _i;
  }

  static const String baseUrl = "https://api.todoist.com";
  static const String version = "/rest/v2";
  final String projects = "$baseUrl$version/projects";
  final String sections = "$baseUrl$version/sections";
  final String tasks = "$baseUrl$version/tasks";
  final String comments = "$baseUrl$version/comments";
}
