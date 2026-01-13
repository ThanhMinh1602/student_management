class ApiEndpoints {
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String me = "/auth/me";

  static const String sets = "/sets";
  static String setById(String id) => "/sets/$id";

  static const String classes = "/classes";
  static String classById(String id) => "/classes/$id";

  static const String questions = "/questions";
  static String questionById(String id) => "/questions/$id";

  static const String user = "/user";
  static String studentById(String id) => "/user/$id";
  static String assignStudent(String id) => "/user/$id/assign";
  static String removeStudentFromClass(String id) => "/user/$id/remove-class";
  static String toggleusertatus(String id) => "/user/$id/toggle-status";
  static String resetStudentPassword(String id) => "/user/$id/reset-password";
}
