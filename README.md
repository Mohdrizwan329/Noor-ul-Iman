# Noor-ul-Iman

A comprehensive Islamic mobile application built with Flutter, providing essential Islamic resources and tools for Muslims worldwide.

## Features

### 📖 Islamic Books
- **Quran**: Complete Quran with Arabic text, translations (Urdu & English), and audio recitation
- **Hadith Collections**: Sahih Bukhari, Sahih Muslim, Sunan Nasai, Sunan Abu Dawud, and Jami Tirmidhi
- **Duas**: Categorized collection of daily prayers and supplications

### 🕌 Prayer & Worship
- **Prayer Times**: Accurate prayer times based on your location
- **Qibla Compass**: Find the direction to Mecca from anywhere
- **Tasbih Counter**: Digital counter for dhikr and tasbeeh
- **Adhan Notifications**: Prayer time reminders with customizable adhan sounds

### 📅 Islamic Calendar & Events
- **Hijri Calendar**: Islamic calendar with important dates
- **Ramadan Tracker**: Track fasting, prayers, and good deeds during Ramadan
- **Fasting Times**: Sehri and Iftar timings

### 🕋 Hajj & Umrah
- **Hajj Guide**: Complete step-by-step guide for Hajj pilgrimage
- **Islamic Names**: Names of Allah, Prophets, Sahaba, Khalifa, 12 Imams, Panjatan, and Ahlebait

### 📚 Islamic Knowledge
- **7 Kalma**: Learn the seven essential Islamic declarations
- **Basic Amal**:
  - All types of Namaz (Salah)
  - Wazu (Ablution) & Ghusl
  - Azan, Khutba, Fatiha
  - Nazar Karika & Nazar-e-Bad
  - Islamic teachings on Jannat, Jahannam, Family, Relatives
  - Fazilat of Namaz, Zamzam, Islamic months, and good deeds

### 🛠️ Utilities
- **Zakat Calculator**: Calculate your Zakat obligations
- **Mosque Finder**: Locate nearby mosques using GPS
- **Halal Finder**: Find halal restaurants and food options
- **Greeting Cards**: Islamic greeting cards for special occasions
- **Prayer Requests**: Share and receive prayer requests
- **AI Chat**: Get Islamic guidance and answers to your questions

## Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / Xcode for mobile development

### Installation

1. Clone the repository
```bash
git clone https://github.com/Mohdrizwan329/nooruliman.git
cd nooruliman
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── constants/     # App-wide constants (colors, strings, assets)
│   ├── services/      # Core services (location, prayer times)
│   ├── theme/         # App theming
│   └── utils/         # Utility functions
├── data/
│   ├── models/        # Data models
│   └── dua_data.dart  # Dua data
├── providers/         # State management (Provider pattern)
├── screens/           # UI screens
│   ├── home/
│   ├── quran/
│   ├── hadith/
│   ├── prayer_times/
│   └── ...
├── services/          # Additional services
├── widgets/           # Reusable widgets
│   └── common/        # Common UI components
└── main.dart          # App entry point
```

## Dependencies

Key packages used in this project:
- `provider`: State management
- `geolocator` & `geocoding`: Location services
- `flutter_compass`: Qibla direction
- `hive`: Local storage
- `flutter_local_notifications`: Prayer time notifications
- `google_maps_flutter`: Maps integration
- `just_audio` & `flutter_tts`: Audio playback and text-to-speech
- `hijri`: Hijri calendar
- `speech_to_text`: Voice search functionality

## Features Highlights

- 🌙 Dark mode support
- 🎨 Beautiful gradient UI with Islamic aesthetics
- 🔍 Voice-enabled search functionality
- 📍 GPS-based location services
- 🔔 Smart prayer time notifications
- 💾 Offline support with local storage
- 🌐 Multi-language support (Arabic, Urdu, English)
- 🎵 Audio recitation with multiple reciters

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

## Contact

For any queries or suggestions, please contact:
- GitHub: [@Mohdrizwan329](https://github.com/Mohdrizwan329)

---

Made with ❤️ for the Muslim Ummah
