import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  const AppConfig({
    super.key,
    required this.primary,
    required this.accent,
    required this.secondary,
    required this.flavorName,
    required super.child,
  });

  static const String nameApp = 'DP Motors';

  final Color primary;
  final Color accent;
  final Color secondary;
  final String flavorName;

  /// Obtiene el AppConfig desde el árbol de widgets.
  /// Lanza un error claro si no existe.
  static AppConfig of(BuildContext context) {
    final AppConfig? result = context
        .dependOnInheritedWidgetOfExactType<AppConfig>();
    assert(result != null, 'No AppConfig found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant AppConfig oldWidget) {
    // Si tus colores/flavor pueden cambiar en runtime, compara:
    return primary != oldWidget.primary ||
        accent != oldWidget.accent ||
        secondary != oldWidget.secondary ||
        flavorName != oldWidget.flavorName;
  }
}
