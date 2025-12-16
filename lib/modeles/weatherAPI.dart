import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:cirrus/dbug.dart';
import 'package:cirrus/ui/generalUI.dart';

import '../assets/constants.dart';
import 'package:http/http.dart' as http;
/*
// Donnée du actuelle
curl "https://api.meteo-concept.com/api/forecast/nextHours?token=${TOKEN}&insee=31395" | jq '{name: .city.name} + (.forecast[0] | {datetime, temp2m, rh2m, wind10m, weather})'

// Données pour les 12 prochaines heures (de 00h à 11h ou 12h à 23h en fonction de l'heure actuelle)
curl "https://api.meteo-concept.com/api/forecast/nextHours?token=${TOKEN}&insee=31395&hourly=true" | jq '.forecast[] | {datetime, temp2m, rh2m, weather, wind10m, gust10m, rr10}'

// Données pour les 14 prochaines jours
curl "https://api.meteo-concept.com/api/forecast/daily?token=${TOKEN}&insee=31395" | jq '.forecast[] | {datetime, day, tmin, tmax, probarain, weather, wind10m, gust10m}'
*/

enum CodeErrorAPI {
  GEOLOC_SERVICE_DISABLE,
  GEOLOC_PERMISSION_DENIED,
  GEOLOC_FOREVER_DENIED,
  GEOLOC_OK,
  DEFAULT,
}

class Weatherapi {
  // Données pour la connexion à l'api
  static const String _token =
      "fd59e845bda91b5102cd99cf81c99783a28cfcff98d683dc1f9f44c7c60e3c33";
  String _insee = "75056"; // Par défaut la localisation est Paris
  static const String _url = "https://api.meteo-concept.com/api";
  static const Map<When, String> _endpoints = {
    When.NOW: "/forecast/nextHours",
    When.HOURLY: "/forecast/nextHours",
    When.DAILY: "/forecast/daily",
  };

  // Il est possible de passer en paramètre &lating à l'api de météo mais c'est assez bancale
  // le résultat des coordonées ne corresponds pas (ex curl "https://api.meteo-concept.com/api/forecast/nextHours?token=${TOKEN}&latlng=43.4303,1.3536" | jq '.city[]')
  // Donc je passe par une api gouvernemental afin de convertir la position gps en code insee
  static const String _urlGPSInsee = "https://geo.api.gouv.fr/communes?";
  static const String _urlArguments =
      "&fields=code&format=json&geometry=centre";

  String get getCodeInsee => _insee;
  set setCodeInsee(String insee) => _insee = insee;

  // Pour stocker la position gps de l'appareil si demandé
  Position? _gpsPosition;
  Position? get getGPSPosition => _gpsPosition;
  bool _enableGPS = true;
  CodeErrorAPI flag = CodeErrorAPI.DEFAULT;

  bool get isPositionGPS => _enableGPS;
  void enableGPS() {
    _enableGPS = true;
  }

  void disableGPS() {
    _enableGPS = false;
  }

  bool isReady = false;
  bool isDataOk = false;

  String? _cityName;

  // Données pour le stockage de la météo actuelle
  int? _currentTemp;
  int? _currentWind;
  int? _currentHumidity;
  int? _currentWeather;

  // Pour les informations supplémentaires
  int? _gustWind;
  int? _probaRain;
  int? _probaFrost;
  int? _probaFog;

  // Données pour les 12 prochaines heures
  List<HourlyData> _hourlyData = [
    HourlyData(
      hour: null,
      temp: null,
      weather: null,
      gustWind: null,
      probaRain: null,
      probaFrost: null,
      probaFog: null,
    ),
    HourlyData(
      hour: null,
      temp: null,
      weather: null,
      gustWind: null,
      probaRain: null,
      probaFrost: null,
      probaFog: null,
    ),
    HourlyData(
      hour: null,
      temp: null,
      weather: null,
      gustWind: null,
      probaRain: null,
      probaFrost: null,
      probaFog: null,
    ),
  ];

  // Données pour les 7 prochains jours
  List<DailyData> _dailyData = [
    DailyData(
      day: null,
      tempMax: null,
      tempMin: null,
      weather: null,
      gustWind: null,
      probaRain: null,
      probaFrost: null,
      probaFog: null,
    ),
    DailyData(
      day: null,
      tempMax: null,
      tempMin: null,
      weather: null,
      gustWind: null,
      probaRain: null,
      probaFrost: null,
      probaFog: null,
    ),
    DailyData(
      day: null,
      tempMax: null,
      tempMin: null,
      weather: null,
      gustWind: null,
      probaRain: null,
      probaFrost: null,
      probaFog: null,
    ),
  ];

  // Première instance récupèration de la position gps
  Future<void> initAPI() async {
    // Si GPS désactivé ne rien faire
    if (!_enableGPS) return;

    // Si on a déjà une position pré-utilisé alors l'utiliser
    if (InitialData.gpsPosition != null) {
      _gpsPosition = InitialData.gpsPosition;
      return;
    }

    // Sinon, tente la dernière position connue
    final last = await Geolocator.getLastKnownPosition();
    if (last != null) {
      _gpsPosition = last;
      return;
    }

    // Sinon, tente un fix rapide avec timeout court
    try {
      _gpsPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 5),
        ),
      ).timeout(const Duration(seconds: 5));
    } catch (_) {
      _gpsPosition =
          null; // Si rien n'a marcher alors utilisation de l'insee par défault
    }
  }

  Future<CodeErrorAPI> checkAndEnableGPS() async {
    // Service GPS activé ?
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      flag = CodeErrorAPI.GEOLOC_SERVICE_DISABLE;
      return flag;
    }

    // Permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        flag = CodeErrorAPI.GEOLOC_PERMISSION_DENIED;
        return flag;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      flag = CodeErrorAPI.GEOLOC_FOREVER_DENIED;
      return flag;
    }

    _enableGPS = true;
    flag = CodeErrorAPI.GEOLOC_OK;
    return flag;
  }

  // Appelle l'api
  Future<void> fetchWeather() async {
    try {
      printDebug("===========================================");
      printDebug("[ DEBUG ] Fetching data...");

      // Si l'utilisateur demande la position gps, alors convertir en code insee
      if (_enableGPS && _gpsPosition != null) {
        await fetchGPSToInsee();
      }

      printDebug("[ DEBUG ] Using insee code $_insee");
      await fetchWeatherHourly();
      await fetchWeatherDaily();
      printDebug("[ OK ] Data feched.");
      isDataOk = true;
      printDebug("");
      printDebug("===========================================");
    } on Exception catch (_) {
      isDataOk = false;
    }
    isReady = true;
  }

  Future<void> fetchGPSToInsee() async {
    String url =
        "$_urlGPSInsee&lat=${_gpsPosition!.latitude}&lon=${_gpsPosition!.longitude}$_urlArguments";

    // Appele de l'api
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _insee = json.first['code'];
    } else {
      throw Exception("Failed to load weather");
    }
  }

  /*
    Permet d'appeler l'api et de récuperer les informations de la journée
    Permet donc également de récupèrer les informations actuelle
  */
  Future<void> fetchWeatherHourly() async {
    String url =
        "$_url${_endpoints[When.HOURLY]}?token=$_token&insee=$_insee&hourly=true";

    // Appele de l'api
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _cityName = json['city']['name'];

      final List forecasts = json['forecast'];

      // Formatte la date actuelle
      final now = DateTime.now();
      final DateTime currentDate = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
      );
      _hourlyData = [];

      // Récupère tout les informations sur les 12 prochaines heures
      for (var forecast in forecasts) {
        String dateStr = forecast['datetime'];

        // Récupère et formatte la date reçue
        DateTime date = DateTime.parse(
          dateStr.replaceFirstMapped(RegExp(r'(\+|-)(\d{2})(\d{2})$'), (m) {
            return '${m[1]}${m[2]}:${m[3]}';
          }),
        ).toLocal();

        // Récupère les données actuelle
        if (date == currentDate) {
          // Stock les infos du jour
          _currentTemp = forecast['temp2m'];
          _currentWind = forecast['wind10m'];
          _currentHumidity = forecast['rh2m'];
          _currentWeather = forecast['weather'];

          // Stock les infos supplémentaires
          _gustWind = forecast['gust10m'];
          _probaRain = forecast['probarain'];
          _probaFrost = forecast['probafrost'];
          _probaFog = forecast['probafog'];

          // Change la valeur actuelle pour que la regex casse
          // et pouvoir afficher NOW pour la date actuelle
          dateStr = "X";
        }

        // Filtre pour supprimé les prévisions passées
        if (!date.isBefore(currentDate)) {
          // Récupère les données pour les 12 prochaines heures
          final match = RegExp(r'T(\d{2}):').firstMatch(dateStr);
          _hourlyData.add(
            HourlyData(
              hour: match != null ? int.parse(match.group(1)!) : -1,
              temp: forecast['temp2m'],
              weather: forecast['weather'],
              gustWind: forecast['gust10m'],
              probaRain: forecast['probarain'],
              probaFrost: forecast['probafrost'],
              probaFog: forecast['probafog'],
            ),
          );
        }
      }
    } else {
      throw Exception("Failed to load weather");
    }
  }

  /*
    Permet d'appeler l'api et de récuperer les informations sur les 7 prochains jours
  */
  Future<void> fetchWeatherDaily() async {
    String url = "$_url${_endpoints[When.DAILY]}?token=$_token&insee=$_insee";

    // Appele de l'api
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final List forecasts = json['forecast'];

      // Converti le jour actuelle en un nombre (ex Lundi: 1, Mardi: 2...)
      final now = DateTime.now();
      final int dayNumber = now.weekday;
      _dailyData = [];

      // Récupère les données pour les 7 prochains jours
      for (var forecast in forecasts) {
        // Ajoute au jour actuelle le jour reçue (ex on est mardi donc Mardi: 2, on reçoit 3,
        // donc pour déterminer de quel jour il s'agit, il faut faire 2 + 3 = 5 = Vendredi)
        int dayIndex = ((dayNumber - 1 + (forecast['day'] as int)) % 7) + 1;

        // Stock les informations reçue
        _dailyData.add(
          DailyData(
            day: dayIndex,
            tempMax: forecast['tmax'],
            tempMin: forecast['tmin'],
            weather: forecast['weather'],
            gustWind: forecast['gust10m'],
            probaRain: forecast['probarain'],
            probaFrost: forecast['probafrost'],
            probaFog: forecast['probafog'],
          ),
        );

        // L'api va jusqu'à 14 jours donc à 7 on arrête (6 car il commence à 0)
        if (forecast['day'] == 6) {
          break;
        }
      }
    } else {
      throw Exception("Failed to load weather");
    }
  }

  void printData() {
    printDebug("=== WEATHER DATA ===");
    printDebug("City       : $_cityName");
    printDebug(
      "Now        : $_currentTemp°C, $_currentHumidity% hum, $_currentWind km/h wind, weather code $_currentWeather",
    );

    printDebug("---------------------");

    for (final h in _hourlyData) {
      final hourStr = h.hour.toString().padLeft(2, '0');
      printDebug("$hourStr h : ${h.temp}°C | weather code: ${h.weather}");
    }

    printDebug("---------------------");

    for (final h in _dailyData) {
      final hourStr = dayTable[h.day];
      printDebug(
        "$hourStr : ${h.tempMin}°C - ${h.tempMax}°C | weather code: ${h.weather}",
      );
    }

    printDebug("=====================");
    printDebug("");
  }

  // Getters

  // Temps actuelle
  String get getCityName => _cityName?.toUpperCase() ?? "";
  String get getTemperature => "${_currentTemp ?? "--"}°";
  int? get getWeather => _currentWeather;
  String get getWeatherDescription =>
      weatherDescriptions[_currentWeather] ?? "Inconnu";
  String get getHumidity => "${_currentHumidity ?? "--"}%";
  String get getWind => "${_currentWind ?? "--"}km/h";

  // Infos supplémentaires
  String get getGustWind => "${_gustWind ?? "--"}km/h";
  String get getProbaRain => "${_probaRain ?? "--"}%";
  String get getProbaFrost => "${_probaFrost ?? "--"}%";
  String get getProbaFog => "${_probaFog ?? "--"}%";

  // Les 12 prochaines heures
  List<HourlyData> get getHourlyData => _hourlyData;

  // Les 7 prochains jours
  List<DailyData> get getDailyData => _dailyData;
}

abstract class WeatherEntry {
  String formattedTime();
  String get formattedTemp;
  String get getFormattedGustWind;
  String get getFormattedProbaRain;
  String get getFormattedProbaFrost;
  String get getFormattedProbaFog;
  int? get getWeather;
}

// Permet de stocker les données pour les 12 prochaines heures
class HourlyData implements WeatherEntry {
  final int? hour;
  final int? temp;
  final int? gustWind;
  final int? probaRain;
  final int? probaFrost;
  final int? probaFog;
  final int? weather;

  HourlyData({
    required this.hour,
    required this.temp,
    required this.gustWind,
    required this.probaRain,
    required this.probaFrost,
    required this.probaFog,
    required this.weather,
  });

  @override
  int? get getWeather => weather;

  @override
  String get formattedTemp => temp == null ? '--°' : '$temp°';

  @override
  String formattedTime() {
    String data;
    if (hour == null) {
      data = "--h";
    } else if (hour == -1) {
      data = "NOW";
    } else {
      data = "${hour}h";
    }
    return data;
  }

  @override
  String get getFormattedGustWind => "${gustWind ?? "--"}km/h";

  @override
  String get getFormattedProbaRain => "${probaRain ?? "--"}%";

  @override
  String get getFormattedProbaFrost => "${probaFrost ?? "--"}%";

  @override
  String get getFormattedProbaFog => "${probaFog ?? "--"}%";
}

// Permet de stocker les données pour les 7 prochains jours
class DailyData implements WeatherEntry {
  final int? day;
  final int? tempMax;
  final int? tempMin;
  final int? gustWind;
  final int? probaRain;
  final int? probaFrost;
  final int? probaFog;
  final int? weather;

  DailyData({
    required this.gustWind,
    required this.probaRain,
    required this.probaFrost,
    required this.probaFog,
    required this.day,
    required this.tempMax,
    required this.tempMin,
    required this.weather,
  });

  @override
  int? get getWeather => weather;

  @override
  String get formattedTemp =>
      tempMax == null || tempMin == null ? '--°/--°' : '$tempMin°/$tempMax°';

  @override
  String formattedTime() {
    return day == null ? "XXX" : "${dayTable[day]}";
  }

  @override
  String get getFormattedGustWind => "${gustWind ?? "--"}km/h";

  @override
  String get getFormattedProbaRain => "${probaRain ?? "--"}%";

  @override
  String get getFormattedProbaFrost => "${probaFrost ?? "--"}%";

  @override
  String get getFormattedProbaFog => "${probaFog ?? "--"}%";
}

// Permet d'identifier une ville comme étant un nom et un code insee
// De cette manière il est possible d'afficher le nom dans l'autocompletion
// à partir du code insee
class City<T> {
  final String name;
  final T codeInsee;

  City({required this.name, required this.codeInsee});

  String get getName => name;
  T get getCodeInsee => codeInsee;

  void printData() {
    printDebug("=== CITY DATA | name : $name - insee : $codeInsee ===");
  }
}
