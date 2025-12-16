import 'package:flutter/material.dart';
import 'package:cirrus/assets/constants.dart';

abstract class AppTheme {
  // Thèmes
  Color get getPrimary;
  Color get getSecondary;
  Color get getTertiary;
  Color get getButtonColor;
  Color get getButtonTextColor;
  Color get getFrameColor;

  // Styles
  TextStyle get getPopupGenericTitle;
  TextStyle get getPopupGenericLabel;
  TextStyle get getPupGenericTextButton;

  static int clamp(int value) => value.clamp(0, 255);

  static int offsetAlpha(Color color, double alphaFactor) =>
      clamp((color.a * 255 * alphaFactor).round());

  static int offsetR(Color color, int r) => clamp((color.r * 255).round() + r);

  static int offsetG(Color color, int g) => clamp((color.g * 255).round() + g);

  static int offsetB(Color color, int b) => clamp((color.b * 255).round() + b);

  static Color addToColor({
    required Color color,
    int? r,
    int? g,
    int? b,
    double? alphaFactor,
  }) {
    var result = color;

    if (alphaFactor != null) {
      result = result.withAlpha(offsetAlpha(result, alphaFactor));
    }
    if (r != null) {
      result = result.withRed(offsetR(result, r));
    }
    if (g != null) {
      result = result.withGreen(offsetG(result, g));
    }
    if (b != null) {
      result = result.withBlue(offsetB(result, b));
    }

    return result;
  }
}

// =============================================
// =====-----------------------------------=====
// =====--------   WEATHER THEME   --------=====
// =====-----------------------------------=====
// =============================================
class WeatherTheme implements AppTheme {
  final ColorCode currentWeather;

  // Gestion des fonds colorés
  late final AssetImage _background;
  late final AssetImage _backgroundMenu;
  AssetImage get getBackground => _background;
  AssetImage get getBackgroundMenu => _backgroundMenu;

  // Thèmes générales
  Color _primary = const Color.fromARGB(255, 109, 109, 109);
  Color _secondary = const Color.fromARGB(255, 198, 198, 198);
  Color _tertiary = const Color.fromARGB(60, 144, 138, 138);
  Color _buttonColor = Color.fromARGB(255, 145, 145, 158);
  final Color _buttonTextColor = Colors.white;
  Color _frameColor = Color.fromARGB(255, 0, 0, 0);

  final TextStyle _popupGenericTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  final TextStyle _popupGenericLabel = TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontWeight: FontWeight.w400,
  );
  final TextStyle _pupGenericTextButton = TextStyle(
    fontFamily: 'BebasNeue',
    fontSize: 20,
    color: Colors.white,
  );

  @override
  Color get getPrimary => _primary;

  @override
  Color get getSecondary => _secondary;

  @override
  Color get getTertiary => _tertiary;

  @override
  Color get getButtonColor => _buttonColor;

  @override
  Color get getButtonTextColor => _buttonTextColor;

  @override
  Color get getFrameColor => _frameColor;

  @override
  TextStyle get getPopupGenericTitle => _popupGenericTitle;

  @override
  TextStyle get getPopupGenericLabel => _popupGenericLabel;

  @override
  TextStyle get getPupGenericTextButton => _pupGenericTextButton;

  WeatherTheme(this.currentWeather) {
    final file = _fileName();
    _background = AssetImage("assets/background/$file.png");
    _backgroundMenu = AssetImage("assets/menu/$file.png");

    _setTheme();
  }

  String _fileName() {
    switch (currentWeather) {
      case ColorCode.SUN:
        return "sun";
      case ColorCode.SOME_CLOUDS:
        return "some_clouds";
      case ColorCode.CLOUDS:
        return "clouds";
      case ColorCode.RAIN:
        return "rain";
      case ColorCode.SNOW:
        return "snow";
      case ColorCode.THUNDERSTORM:
        return "thunderstorm";
      case ColorCode.HAIL:
        return "hail";
      case ColorCode.UNKNOW:
        return "no_signal";
    }
  }

  void _setTheme() {
    _tertiary = const Color.fromARGB(60, 255, 255, 255);

    switch (currentWeather) {
      case ColorCode.SUN:
        _primary = const Color.fromARGB(255, 68, 163, 220);
        _secondary = const Color.fromARGB(255, 199, 234, 255);
        _buttonColor = Color.fromARGB(255, 56, 52, 223);
        _frameColor = Color.fromARGB(255, 32, 84, 116);
        break;
      case ColorCode.SOME_CLOUDS:
        _primary = const Color.fromARGB(255, 232, 124, 132);
        _secondary = const Color.fromARGB(255, 248, 199, 200);
        _buttonColor = Color.fromARGB(255, 225, 93, 99);
        _frameColor = Color.fromARGB(255, 177, 50, 59);
        break;
      case ColorCode.CLOUDS:
        _primary = const Color.fromARGB(255, 32, 204, 178);
        _secondary = const Color.fromARGB(255, 168, 255, 242);
        _buttonColor = Color.fromARGB(255, 62, 198, 210);
        _frameColor = Color.fromARGB(255, 27, 94, 84);
        break;
      case ColorCode.RAIN:
        _primary = const Color.fromARGB(255, 32, 204, 178);
        _secondary = const Color.fromARGB(255, 168, 255, 242);
        _buttonColor = Color.fromARGB(255, 62, 198, 210);
        _frameColor = Color.fromARGB(255, 27, 94, 84);
        break;
      case ColorCode.SNOW:
        _primary = Color.fromARGB(255, 66, 175, 209);
        _secondary = const Color.fromARGB(255, 148, 230, 255);
        _buttonColor = Color.fromARGB(255, 52, 118, 223);
        _frameColor = Color.fromARGB(255, 0, 54, 125);
        break;
      case ColorCode.THUNDERSTORM:
        _primary = const Color.fromARGB(255, 72, 44, 92);
        _secondary = const Color.fromARGB(255, 198, 171, 216);
        _buttonColor = Color.fromARGB(255, 126, 52, 223);
        _frameColor = Color.fromARGB(255, 92, 30, 138);
        break;
      case ColorCode.HAIL:
        _primary = const Color.fromARGB(255, 72, 68, 76);
        _secondary = const Color.fromARGB(255, 221, 221, 221);
        _buttonColor = Color.fromARGB(255, 145, 145, 158);
        _frameColor = Color.fromARGB(255, 117, 108, 124);
        break;
      case ColorCode.UNKNOW:
        break;
    }
  }

  // =================================================
  // =====--------   FONTS PRESONALISE   --------=====
  // =================================================

  /*
    Fonts pour le temps du jour
  */
  TextStyle cityStyle(bool isLoaded) {
    return TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: isLoaded ? 25 : 25,
      color: isLoaded
          ? const Color.fromARGB(255, 110, 110, 110)
          : const Color.fromARGB(255, 160, 146, 20),
    );
  }

  TextStyle weatherStyle() {
    TextStyle template = TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 15,
      color: const Color.fromARGB(255, 234, 217, 217),
    );

    // Permet de modifier la couleur en fonction de la météo du jour
    if (currentWeather == ColorCode.CLOUDS) {
      template = template.copyWith(
        color: const Color.fromARGB(255, 240, 236, 236),
      );
    } else if (currentWeather == ColorCode.RAIN) {
      template = template.copyWith(
        color: const Color.fromARGB(255, 240, 236, 236),
      );
    } else if (currentWeather == ColorCode.SNOW) {
      template = template.copyWith(
        color: const Color.fromARGB(255, 240, 236, 236),
      );
    }
    return template;
  }

  TextStyle temperatureStyle() {
    TextStyle template = TextStyle(
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w700,
      fontSize: 75,
      color: Colors.white,
    );

    // Permet de modifier la couleur en fonction de la météo du jour
    if (currentWeather == ColorCode.CLOUDS) {
      template = template.copyWith(
        color: const Color.fromARGB(255, 240, 236, 236),
      );
    } else if (currentWeather == ColorCode.RAIN) {
      template = template.copyWith(
        color: const Color.fromARGB(255, 240, 236, 236),
      );
    }
    return template;
  }

  TextStyle moreInfosStyle() {
    TextStyle template = TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w900,
      fontSize: 11,
      color: const Color.fromARGB(255, 234, 217, 217),
    );

    // Permet de modifier la couleur en fonction de la météo du jour
    if (currentWeather == ColorCode.CLOUDS) {
      template = template.copyWith(
        color: const Color.fromARGB(255, 240, 236, 236),
      );
    } else if (currentWeather == ColorCode.RAIN) {
      template = template.copyWith(
        color: const Color.fromARGB(255, 240, 236, 236),
      );
    } else if (currentWeather == ColorCode.SNOW) {
      template = template.copyWith(
        color: const Color.fromARGB(255, 240, 236, 236),
      );
    }
    return template;
  }

  TextStyle dateStyle() {
    TextStyle template = TextStyle(
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w600,
      fontSize: 15,
      color: const Color.fromARGB(255, 244, 232, 232),
    );

    // Permet de modifier la couleur en fonction de la météo du jour
    if (currentWeather == ColorCode.SNOW) {
      template = template.copyWith(
        color: const Color.fromARGB(255, 184, 184, 184),
      );
    }
    return template;
  }

  /*
    Fonts pour le menu indiquant les précvision météo
  */
  TextStyle customSwitch(bool on) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: on ? Colors.white : const Color.fromARGB(225, 104, 76, 124),
    );
  }

  TextStyle weatherCard() {
    return TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 20,
      color: const Color.fromARGB(255, 233, 228, 228),
    );
  }

  /*
    Fonts pour les informations supplémentaires
  */
  TextStyle popupTitle() {
    TextStyle template = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    // Permet de modifier la couleur en fonction de la météo du jour
    switch (currentWeather) {
      case ColorCode.SUN:
        template = template.copyWith(
          color: const Color.fromARGB(255, 65, 138, 182),
        );
        break;
      case ColorCode.SOME_CLOUDS:
        template = template.copyWith(
          color: const Color.fromARGB(255, 237, 85, 97),
        );
        break;
      case ColorCode.CLOUDS:
        template = template.copyWith(
          color: const Color.fromARGB(255, 34, 141, 125),
        );
        break;
      case ColorCode.RAIN:
        template = template.copyWith(
          color: const Color.fromARGB(255, 34, 141, 125),
        );
        break;
      case ColorCode.SNOW:
        template = template.copyWith(
          color: const Color.fromARGB(255, 30, 40, 138),
        );
        break;
      case ColorCode.THUNDERSTORM:
        template = template.copyWith(
          color: const Color.fromARGB(255, 92, 30, 138),
        );
        break;
      case ColorCode.HAIL:
        template = template.copyWith(
          color: const Color.fromARGB(255, 117, 108, 124),
        );
        break;
      case ColorCode.UNKNOW:
        template = template.copyWith(color: Colors.black);
        break;
    }
    return template;
  }

  TextStyle popupLabel() {
    return TextStyle(
      fontSize: 15,
      color: Colors.black,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle popupVariable() {
    return TextStyle(
      fontSize: 15,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle textButtonStyle() {
    return TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 20,
      color: Colors.white,
    );
  }
}

// Permet de selectionner les bonnes couleurs en fonction
// de la météo pour le popup des informations supplémentaires
class PopupColorCode {
  final WeatherTheme theme;

  late TextStyle _styleTitle;
  late TextStyle _styleLabel;
  late TextStyle _styleVariable;
  late Color _frame;
  late Color _background;
  late Color _colorButton;
  late TextStyle _colorButtonText;

  PopupColorCode(this.theme) {
    _styleTitle = theme.popupTitle();
    _styleLabel = theme.popupLabel();
    _styleVariable = theme.popupVariable();
    _frame = theme.getFrameColor;
    _background = theme.getSecondary;
    _colorButton = theme.getButtonColor;
    _colorButtonText = theme.textButtonStyle();
  }

  TextStyle get getTitleStyle => _styleTitle;
  TextStyle get getLabelStyle => _styleLabel;
  TextStyle get getVariableStyle => _styleVariable;
  Color get getFrameColor => _frame;
  Color get getBackgroundColor => _background;
  Color get getButtonColor => _colorButton;
  TextStyle get getButtonTextColor => _colorButtonText;
}

// ===========================================
// =====---------------------------------=====
// =====--------   GAMES THEME   --------=====
// =====---------------------------------=====
// ===========================================

class GameLifeThemes implements AppTheme {
  // Gestion des couleurs de la grille
  final Color _gridBackground = const Color.fromARGB(255, 27, 24, 19);
  final Color _gridLine = Colors.black;
  final Color _cellsColor = Colors.white;
  final Color _cellsPatternColor = const Color.fromARGB(200, 125, 125, 125);
  Color get getGridBackgroundColor => _gridBackground;
  Color get getGridLineColor => _gridLine;
  Color get getCellsColor => _cellsColor;
  Color get getCellsPatternColor => _cellsPatternColor;

  // Gestion des couleurs des boutons de validation/annulation
  final Color _buttonColorOK = const Color.fromARGB(255, 160, 100, 50);
  final Color _buttonColorExit = const Color.fromARGB(255, 106, 94, 81);
  Color get getButtonColorOK => _buttonColorOK;
  Color get getButtonColorExit => _buttonColorExit;

  // Gestion des couleurs de séléction/déselection du menu pour le workshop
  final Color _selectedMenu = const Color.fromARGB(255, 178, 120, 48);
  final Color _unselectedMenu = const Color.fromARGB(255, 120, 100, 70);
  Color get getSelectedMenu => _selectedMenu;
  Color get getUnselectedMenu => _unselectedMenu;

  // Gestion des couleurs de séléction/déselection des objets pour le workshop
  final Color _selectedCard = const Color.fromARGB(255, 198, 160, 112);
  final Color _unselectedCard = const Color.fromARGB(255, 164, 148, 128);
  Color get getSelectedCard => _selectedCard;
  Color get getUnselectedCard => _unselectedCard;

  // Gestion des couleurs de séléction/déselection pour les icons de menu du bandeau inférieur
  final Color _iconSettings = const Color.fromARGB(255, 192, 192, 192);
  final Color _selectedIconSettings = Colors.deepPurple;
  Color get getIconSettings => _iconSettings;
  Color get getselectedIconSettings => _selectedIconSettings;

  // Gestion des couleurs pour le bandeau supérieur informatif
  final Color _informationBackground = const Color.fromARGB(100, 0, 0, 0);
  Color get getInformationBackground => _informationBackground;

  // Thèmes générales
  final Color _primary = const Color.fromARGB(255, 56, 52, 52);
  final Color _secondary = const Color.fromARGB(255, 200, 190, 160);
  final Color _tertiary = const Color.fromARGB(60, 255, 255, 255);
  final Color _buttonColor = const Color.fromARGB(255, 106, 94, 81);
  final Color _buttonTextColor = Colors.white;
  final Color _frameColor = const Color.fromARGB(255, 225, 225, 200);

  @override
  Color get getPrimary => _primary;

  @override
  Color get getSecondary => _secondary;

  @override
  Color get getTertiary => _tertiary;

  @override
  Color get getButtonColor => _buttonColor;

  @override
  Color get getButtonTextColor => _buttonTextColor;

  @override
  Color get getFrameColor => _frameColor;

  @override
  TextStyle get getPopupGenericTitle => popupTitle();

  @override
  TextStyle get getPopupGenericLabel => popupMenuLabel();

  @override
  TextStyle get getPupGenericTextButton => textButtonStyle();

  GameLifeThemes() {
    _setTheme();
  }

  void _setTheme() {
    // Au besoin mettre ici le code pour d'autres thèmes
  }

  /*
    Fonts pour les informations supplémentaires
  */
  Color get getPopupTitleColor => const Color.fromARGB(255, 192, 192, 192);
  TextStyle popupTitle() {
    return TextStyle(
      fontFamily: 'Orbitron',
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: getPopupTitleColor,
    );
  }

  TextStyle popupContentLabel() {
    return TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 12,
      color: const Color.fromARGB(255, 237, 237, 237),
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle popupMenuLabel() {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 15,
      color: const Color.fromARGB(255, 237, 237, 237),
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle textButtonStyle() {
    return TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 20,
      color: Colors.white,
    );
  }
}
