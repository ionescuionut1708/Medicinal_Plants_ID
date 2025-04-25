# 🌿 Plante Medicinale – Flutter App
> Identifică plante medicinale cu AI · vezi proprietăți și utilizări terapeutice · istoric local · fără cont

Aplicatie creată de **Ionescu Ionuț**.

---

## ✨ Caracteristici / Features
| Funcție | Detalii |
|---------|---------|
| 📸 Fotografiere sau încărcare imagine | Poți face poză din aplicație sau selecta din galerie |
| 🧠 Identificare AI (Llama 4 via Groq) | Primești **nume științific**, **nume comun**, descriere, proprietăți și utilizări – în limba română, cu diacritice |
| 💾 Istoric local SQflite | Toate identificările se salvează pe dispozitiv, offline |
| 🔍 Interfață modernă Flutter | Temă verde naturală, fonturi Google Fonts, fallback Noto Sans |
| 🔐 Fără cont, fără cloud | Cheia API rămâne locală în fișierul `.env` (nu se comite în Git) |

---

## 📦 Requirements
- **Flutter 3.10+** (Dart 3)
- Android SDK (API 34+) / Xcode 14+ dacă compilezi pentru iOS
- Un cont Groq + **GROQ_API_KEY** *(salvat în `.env`)*

---

## 🚀 Getting Started

```bash
git clone https://github.com/ionescuionut1708/Medicinal_Plants_ID.git
cd Medicinal_Plants_ID
flutter pub get

# copiază exemplul .env și adaugă cheia ta
cp .env.example .env
# editează: GROQ_API_KEY=sk_XXXXXXXXXXXXXXXXXXXXXXXX

flutter run       # device/emulator conectat
```

### Structură proiect

```
lib/
 ├─ constants/          # AppTheme, culori
 ├─ models/             # Plant.dart
 ├─ screens/            # UI screens (home, camera, history, details)
 ├─ services/           # API & DB (plant_recognition_service, database_service)
 ├─ utils/              # romanian_text.dart (fix diacritice)
 └─ widgets/            # componente reutilizabile
```

---

## 🔧 Build & Release

### Android (APK)

```bash
flutter build apk --release
# -> build/app/outputs/flutter-apk/app-release.apk
```

### Android (AAB – Google Play)

```bash
flutter build appbundle --release
# -> build/app/outputs/bundle/release/app-release.aab
```

> Aplicațiile noi pe Google Play trebuie să țintească **targetSdk 34** și să folosească **Android App Bundle**.

### iOS

```bash
flutter build ios --release     
```

---

## 🔑 Env & Secrets

| Fișier | Scop | Ignorat în Git |
|--------|------|---------------|
| `.env` | `GROQ_API_KEY=<your_key>` | ✅ `.gitignore → *.env` |
| `*.jks / *.keystore` | Upload-key Android | ✅ |
| `key.properties` | parole gradle optional | ✅ |

---

## 🛡️ Permissions

| Android Permission | Motiv |
|--------------------|-------|
| `CAMERA`           | Fotografiere plantă |
| `READ_EXTERNAL_STORAGE` | Selectare imagine din galerie |
| `WRITE_EXTERNAL_STORAGE` | Salvare imagini/istoric (scoped storage) |

---

## 💡 Roadmap / TODO

- 🔄 Live camera preview cu detecție în timp real  
- 🌐 Traducere interfață EN/RO folosind `flutter_localizations`  
- ☁️ Firebase Crashlytics & Analytics (opțional)

---

## 🤝 Contribuții

PR-urile și issue-urile sunt binevenite!  
1. Fork → Branch → PR  
2. Respectă `flutter format .`  
3. Scrie mesaj clar de commit.

---

## 📜 License

MIT © 2025 Ionescu Ionuț 
