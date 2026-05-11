enum AppRoute {
  splash(path: "/"),
  nextScreen(path: "/next_screen"),
  loginScreen(path: "/login"),
  forgotPasswordScreen(path: "/forgot-password"),
  homeScreen(path: "/home");

  final String path;

  const AppRoute({required this.path});
}
