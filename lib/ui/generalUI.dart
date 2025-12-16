import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class InitialData {
  static Position? gpsPosition;
}

/*
  Crée une snackbar personalisable
*/
class InfoDisplayer {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
  buildInfoDisplayer(
    BuildContext context,
    String data, {
    SnackBarAction? action,
    EdgeInsets? margin,
    Duration? duration,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar(); // Supprime l'ancien popup si existant

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: action,
        content: GestureDetector(
          behavior: HitTestBehavior.opaque, // prend toute la surface
          onTap: () {
            messenger.hideCurrentSnackBar();
          },
          child: Center(child: Text(data)),
        ),
        duration: duration ?? const Duration(seconds: 1),
        margin:
            margin ?? const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
