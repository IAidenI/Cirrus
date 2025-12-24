import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:cirrus/assets/constants.dart';
import 'package:cirrus/modeles/weatherAPI.dart';
import 'package:cirrus/ui/theme.dart';

// ==================================
// ====-------  DARWINGS  -------====
// ==================================

/*
  Crée un rond de couleur en fonction de la météo du jour
*/
class WeatherCircle extends CustomPainter {
  final WeatherTheme theme;

  WeatherCircle(this.theme);

  @override
  void paint(Canvas canvas, Size size) {
    // Initialise les couleurs

    // Crée les deux parties du cercle, la bordure et le centre
    final strokeWidth = 12.0;
    Paint borderCircle = Paint()
      ..strokeWidth = strokeWidth
      ..color = theme.getTertiary
      ..style = PaintingStyle.stroke;
    Paint fillCircle = Paint()
      ..color = theme.getPrimary
      ..style = PaintingStyle.fill;

    // Centre le cercle
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    // Dessine le cercle
    canvas.drawCircle(center, radius, fillCircle);
    canvas.drawCircle(center, radius + strokeWidth / 2, borderCircle);
  }

  // Pas utile car le cercle ne changera pas
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

/*
  Crée une ligne horizontal équitablement bicolor
*/
class DividedLine extends CustomPainter {
  final bool day;

  DividedLine(this.day);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 7.0;

    // Crée les deux parties de la ligne et assigne une couleur
    // en fonction d'une variable qui change lors d'un appuie sur un bouton
    Color colorDay = day
        ? Colors.white
        : const Color.fromARGB(225, 104, 76, 124);
    Color colorWeek = day
        ? const Color.fromARGB(225, 104, 76, 124)
        : Colors.white;

    Paint lineDay = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap
          .round // Rend les bouts de la ligne rond
      ..color = colorDay
      ..style = PaintingStyle.fill;

    Paint lineWeek = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap
          .round // Rend les bouts de la ligne rond
      ..color = colorWeek
      ..style = PaintingStyle.fill;

    // Calcul les dimenssion des lignes pour être équitablement divisé
    Offset p1Day = Offset(0, 0);
    Offset p2Day = Offset(size.width / 2, 0);
    Offset p1Week = Offset(size.width / 2, 0);
    Offset p2Week = Offset(size.width, 0);

    // Les bouts des lignes sont arrondis, la ligne qui est dessiné en dernier
    // chevauchera la première. De cette manière c'est toujours celui séléctionné
    // qui a le focus
    if (day) {
      canvas.drawLine(p1Week, p2Week, lineWeek);
      canvas.drawLine(p1Day, p2Day, lineDay);
    } else {
      canvas.drawLine(p1Day, p2Day, lineDay);
      canvas.drawLine(p1Week, p2Week, lineWeek);
    }
  }

  // Permet de recharger l'affichage au changement de la variable day
  @override
  bool shouldRepaint(covariant DividedLine oldDelegate) {
    return oldDelegate.day != day;
  }
}

/*
  Permet de créer un cadre arrondi de couleur
*/
class FrameRounded extends CustomPainter {
  final Color colorFrame;

  FrameRounded(this.colorFrame);

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 2;

    // Crée un cadre rectangulaire
    Paint rectangle = Paint()
      ..strokeWidth = strokeWidth
      ..color = colorFrame
      ..style = PaintingStyle.stroke;

    // Ajoute les contraintes pour les bords arrondis
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Dessine le rectangle
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(5)),
      rectangle,
    );
  }

  // Pas utile car le cercle ne changera pas
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

/*
  Permet de créer un rectangle avec bordure et avec une ombre
*/
class FrameTitle extends CustomPainter {
  final double padding;
  final WeatherTheme theme;
  Color border = const Color.fromARGB(255, 140, 140, 140);
  Color shadowColor = const Color.fromARGB(127, 162, 162, 162);

  FrameTitle({required this.padding, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    const double borderWidth = 2;
    // Crée un rectange plein
    Paint rectangle = Paint()
      ..color = theme.getSecondary
      ..style = PaintingStyle.fill;
    Rect rect = Rect.fromLTRB(-padding, 0, size.width + padding, size.height);

    // Crée le cadre exterieur du rectangle plein
    Paint frameExt = Paint()
      ..strokeWidth = borderWidth
      ..color = border
      ..style = PaintingStyle.stroke;
    // Ajoute les contraintes pour les bords arrondis
    Rect rectFrameExt = Rect.fromLTRB(
      -padding,
      0,
      size.width + padding,
      size.height,
    );

    // Crée un cadre intérieur du rectange plein
    Paint frameInt = Paint()
      ..strokeWidth = borderWidth
      ..color = border
      ..style = PaintingStyle.stroke;
    double offset = 4;
    // Ajoute les contraintes pour les bords arrondis
    Rect rectFrameInt = Rect.fromLTRB(
      offset - padding,
      offset,
      size.width - offset + padding,
      size.height - offset,
    );

    // Crée un effet d'ombre pour le rectangle plein
    Paint shadow = Paint()
      ..strokeWidth = borderWidth
      ..color = shadowColor
      ..style = PaintingStyle.fill;
    // Ajoute les contraintes pour les bords arrondis
    Rect rectShadow = Rect.fromLTRB(
      offset - padding,
      offset,
      size.width + offset + padding,
      size.height + offset,
    );

    // Dessin les rectangles dans l'ordre pour avoir le compsent final
    canvas.drawRRect(
      RRect.fromRectAndRadius(rectShadow, Radius.circular(5)),
      shadow,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(5)),
      rectangle,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rectFrameExt, Radius.circular(5)),
      frameExt,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rectFrameInt, Radius.circular(5)),
      frameInt,
    );
  }

  // Pas utile car le cercle ne changera pas
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ===================================================
// ====-------  CUSTOM EXISTING COMPONANT  -------====
// ===================================================

/*
  Crée un carte pour afficher les prévisions météo
*/
class WeatherCard extends StatelessWidget {
  final String title;
  final String temperature;
  final WeatherTheme theme;
  final ColorCode weather;
  final void Function()? onTap;

  const WeatherCard({
    super.key,
    required this.title,
    required this.temperature,
    required this.weather,
    required this.theme,
    this.onTap,
  });

  // Associe chaque temps à un icon
  Image getCorrectIcon() {
    final String path;
    switch (weather) {
      case ColorCode.SUN:
        path = "assets/icons/sun.png";
        break;
      case ColorCode.SOME_CLOUDS:
        path = "assets/icons/some_clouds.png";
        break;
      case ColorCode.CLOUDS:
        path = "assets/icons/clouds.png";
        break;
      case ColorCode.RAIN:
        path = "assets/icons/rain.png";
        break;
      case ColorCode.SNOW:
        path = "assets/icons/snow.png";
        break;
      case ColorCode.THUNDERSTORM:
        path = "assets/icons/thunderstorm.png";
        break;
      case ColorCode.HAIL:
        path = "assets/icons/hail.png";
        break;
      case ColorCode.UNKNOW:
        path = "assets/icons/no_signal.png";
        break;
    }
    return Image.asset(path, fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      shadowColor: const Color.fromARGB(62, 212, 212, 212),
      color: const Color.fromARGB(25, 255, 255, 255),
      // Forme de capsule avec des fin bords blancs
      shape: const StadiumBorder(
        side: BorderSide(color: Color.fromARGB(51, 255, 255, 255), width: 1.2),
      ),
      clipBehavior: Clip.antiAlias, // Découpe en suivant la forme
      // Comme GestureDetector mais avec un effet de splash
      child: InkWell(
        onTap: onTap,
        customBorder:
            const StadiumBorder(), // Fait en sorte que le splash soit en forme de capsule
        splashFactory:
            InkRipple.splashFactory, // Animation d'onde de choc au clic
        splashColor: const Color.fromARGB(
          76,
          255,
          255,
          255,
        ), // Couleur de l'onde
        highlightColor: const Color.fromARGB(
          5,
          255,
          255,
          255,
        ), // Couleur lors du maintient du clic
        child: SizedBox(
          width: 100,
          height: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Affiche l'heure, l'icon et la température souhaité
              Text(title, style: theme.weatherCard()),
              const SizedBox(height: 12),
              SizedBox(width: 60, height: 60, child: getCorrectIcon()),
              const SizedBox(height: 12),
              Text(temperature, style: theme.weatherCard()),
            ],
          ),
        ),
      ),
    );
  }
}

/*
  Crée un bouton switch personalisé
*/
class SwitchLine extends StatelessWidget {
  final WeatherTheme theme;
  final double width;
  final bool day; // Reçoit l’état du parent
  final VoidCallback onTap; // Callback pour informer le parent du tap

  const SwitchLine({
    super.key,
    required this.theme,
    required this.width,
    required this.day,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap, // Appelle le parent
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("DAY", style: theme.customSwitch(day)),
                Text("WEEK", style: theme.customSwitch(!day)),
              ],
            ),
            const SizedBox(height: 5),
            CustomPaint(
              painter: DividedLine(day),
              child: SizedBox(width: width),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================
// ====-------  POPUP  -------====
// ===============================

/*
  Crée un popup informatif pour des données supplémentaires
*/
class PopupDisplayInfos extends StatefulWidget {
  final String title;
  final Map<String, String?> content;
  final PopupColorCode style;

  const PopupDisplayInfos({
    super.key,
    required this.title,
    required this.content,
    required this.style,
  });

  @override
  State<StatefulWidget> createState() => _PopupDisplayInfosState();
}

class _PopupDisplayInfosState extends State<PopupDisplayInfos> {
  // Construit une section de texte pour avoir un label avec un style (ex regular)
  // et la variable associé avec un autre style (ex bold)
  RichText _buildDataSection(String label, String? variable) {
    return RichText(
      text: TextSpan(
        children: [
          // Affichage du label
          TextSpan(text: label, style: widget.style.getLabelStyle),
          // Sur la même ligne affichage de la variable
          TextSpan(text: variable ?? "", style: widget.style.getVariableStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.style.getBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Crée un cadre et place à l'interieur les données passé en paramètre
              CustomPaint(
                painter: FrameRounded(widget.style.getFrameColor),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 15),
                      Text(widget.title, style: widget.style.getTitleStyle),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          for (var data in widget.content.entries)
                            _buildDataSection(data.key, data.value),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Crée un bouton personalisé qui prend la même largeur que le cadre
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.style.getButtonColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Center(
                      child: Text("OK", style: widget.style.getButtonTextColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
  Crée une zone d'auto-completion à partir d'une valeur initial et d'une liste
*/
class CityAutoComplete<T> extends StatelessWidget {
  final T currentData;
  final Map<T, String> dataList;
  final TextStyle style;
  final void Function(City)? onSelected;
  final String? initialText;
  final VoidCallback? onUserTyping;

  const CityAutoComplete({
    super.key,
    required this.currentData,
    required this.dataList,
    required this.style,
    this.onSelected,
    this.initialText,
    this.onUserTyping,
  });

  static String _displayStringForOption(City option) => option.name;

  @override
  Widget build(BuildContext context) {
    final List<City<T>> cities = dataList.entries
        .map((entry) => City<T>(name: entry.value, codeInsee: entry.key))
        .toList();

    final String fallback = dataList.entries
        .firstWhere(
          (entry) => entry.key == currentData,
          orElse: () => MapEntry<T, String>(currentData, "Inconnue"),
        )
        .value;

    return Autocomplete<City<T>>(
      initialValue: TextEditingValue(
        text: initialText ?? fallback,
      ),
      displayStringForOption: _displayStringForOption,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable.empty();
        }
        return cities.where((City option) {
          return option.getName.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              onSubmitted: (value) => onFieldSubmitted(),

              onChanged: (_) => onUserTyping?.call(),

              decoration: const InputDecoration.collapsed(hintText: ''),
              style: style,
              textAlign: TextAlign.center,
            );
          },
      onSelected: (City selection) {
        if (onSelected != null) onSelected!(selection);
      },
    );
  }
}

/*
  Crée un popup de chargement
*/
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 120,
        height: 120,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: LoadingIndicator(
                  indicatorType: Indicator.lineSpinFadeLoader,
                  colors: [
                    Colors.black,
                    Colors.grey[800]!,
                    Colors.grey[600]!,
                    Colors.grey[400]!,
                    Colors.grey[200]!,
                  ],
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Loading...",
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
