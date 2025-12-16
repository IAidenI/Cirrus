# 🌤️ Cirrus

**Cirrus** est une application mobile Flutter (Android / iOS) dédiée à la **consultation de la météo**.  
Elle propose une interface **simple, fluide et visuelle**, centrée exclusivement sur les données météo.

> 🔁 À l’origine, ce projet avait pour but de regrouper plusieurs fonctionnalités dans une seule application.  
> Ce choix a été abandonné au profit d’une approche **modulaire** :  
> **Cirrus** est désormais une application météo indépendante.

---

## ✨ Fonctionnalités

- 🌍 Météo en temps réel via l’[API Météo Concept](https://api.meteo-concept.com/documentation)
- 📍 Géolocalisation pour afficher la météo locale
- 🔎 Recherche de villes avec autocomplétion (codes INSEE)
- ⏱️ Prévisions horaires
- 📆 Prévisions journalières
- 🎨 Interface dynamique adaptée aux conditions météo
- 📱 UI optimisée mobile (carousel, popups d’infos, animations)

---

## 📱 Captures d’écran

<p align="center">
  <img src="./docs/Accueil_Day.jpg" alt="Vue jour" height="330">
  <img src="./docs/Accueil_Week.jpg" alt="Vue semaine" height="330">
  <img src="./docs/Accueil_Day_Variant.jpg" alt="Variante visuelle" height="330">
  <img src="./docs/More_Infos.jpg" alt="Détails météo" height="330">
  <img src="./docs/Autocomplete.jpg" alt="Recherche de ville" height="330">
</p>

---

## 🚀 Téléchargement

### 📦 Dernière version (Android APK)

Vous pouvez télécharger la dernière version stable de l’application directement via la section des **releases GitHub** :

➡️ [Télécharger l’APK – v1.0](https://github.com/IAidenI/Cirrus/releases/download/v1/cirrus.apk)

> ℹ️ Pensez à autoriser l’installation d’applications provenant de sources inconnues sur votre appareil Android.

---

## 🛠️ Stack technique

- Flutter (Dart ≥ 3.0)
- Android / iOS
- API : Météo Concept
- Géolocalisation : `geolocator`
- UI avancée : `CustomPainter`, `AutoSizeText`, animations

---

## 🧪 Lancer le projet en local

### Prérequis

- Flutter SDK  
- Dart ≥ 3.0  
- Android Studio / VS Code  
- Un appareil ou émulateur Android / iOS  

### Installation

```bash
git clone https://github.com/IAidenI/Cirrus.git
cd Cirrus
flutter pub get
flutter run
```
