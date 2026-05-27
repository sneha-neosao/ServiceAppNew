enum AppRoute {
  splash(path: "/splash_screen"),
  nextScreen(path: "/next_screen"),
  loginScreen(path: "/login"),
  forgotPasswordScreen(path: "/forgot-password"),
  homeScreen(path: "/home_screen");

  final String path;

  const AppRoute({required this.path});
}
