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

  static const String students = "/students";
  static String studentById(String id) => "/students/$id";
  static String assignStudent(String id) => "/students/$id/assign";
  static String removeStudentFromClass(String id) =>
      "/students/$id/remove-class";
  static String toggleStudentStatus(String id) => "/students/$id/toggle-status";
  static String resetStudentPassword(String id) =>
      "/students/$id/reset-password";
}
