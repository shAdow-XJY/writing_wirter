// All events defined here

/// <!-- Theme -->

/// ChangeThemeEvent
class ChangeThemeEvent {
  bool isDarkMode;
  String themeName;

  ChangeThemeEvent({
    required this.isDarkMode,
    required this.themeName,
  });
}

