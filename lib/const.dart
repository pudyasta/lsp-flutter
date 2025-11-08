class Const {
  // API URLs
  // auth
  static const String baseUrl = "localhost:8000/api/v1";
  static const String loginUrl = "$baseUrl/auth/login";
  static const String registerUrl = "$baseUrl/auth/register";
  static const String refreshTokenUrl = "$baseUrl/auth/refresh-token";
  static const String forgotPasswordUrl = "$baseUrl/auth/password/forgot";

  // course
  static const String coursesUrl = "$baseUrl/courses";

  // user management
  static const String profileUrl = "$baseUrl/profile";
}
