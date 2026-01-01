# 📺 FixTube - Smart YouTube Filter App

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android"/>
  <img src="https://img.shields.io/badge/YouTube_API-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="YouTube API"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License"/>
  <img src="https://img.shields.io/badge/Version-1.0.0-blue?style=flat-square" alt="Version"/>
  <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen?style=flat-square" alt="PRs Welcome"/>
  <img src="https://img.shields.io/badge/Maintained-Yes-success?style=flat-square" alt="Maintained"/>
</p>

<p align="center">
  <b>Your personalized YouTube feed.</b><br>
  Filter videos by keywords • Block shorts • Get notified when creators upload
</p>

---

## 🤔 Why FixTube?

<table>
<tr>
<td width="50%">

### ❌ The Problem
YouTube subscriptions are broken. You subscribe to a creator for their gaming content, but your feed gets flooded with:
- Vlogs you don't care about
- Shorts that waste your time
- Off-topic content that clutters your feed

</td>
<td width="50%">

### ✅ The Solution
**FixTube** gives you surgical control over your YouTube experience:
- **Include filters** - Only see specific content
- **Exclude filters** - Hide unwanted videos
- **Shorts blocking** - No 60-second time wasters
- **Smart notifications** - Know when matching videos drop

</td>
</tr>
</table>

---

## ✨ Features

<table>
<tr>
<td align="center" width="25%">
<img src="https://img.shields.io/badge/🎯-Keyword_Filtering-FF6B6B?style=for-the-badge" alt="Filtering"/>
<br><br>
<b>Smart Filtering</b><br>
Show only or hide videos by keywords
</td>
<td align="center" width="25%">
<img src="https://img.shields.io/badge/🚫-Block_Shorts-4ECDC4?style=for-the-badge" alt="Block Shorts"/>
<br><br>
<b>No Shorts</b><br>
Auto-hide videos under 60 seconds
</td>
<td align="center" width="25%">
<img src="https://img.shields.io/badge/🔔-Notifications-FFE66D?style=for-the-badge" alt="Notifications"/>
<br><br>
<b>Smart Alerts</b><br>
Channel-specific upload alerts
</td>
<td align="center" width="25%">
<img src="https://img.shields.io/badge/🎨-5_Themes-95E1D3?style=for-the-badge" alt="Themes"/>
<br><br>
<b>Beautiful UI</b><br>
Gold, Dark, Rose, Ocean, Mint
</td>
</tr>
</table>

### 📋 Full Feature List

| Feature | Description |
|---------|-------------|
| ![Filter](https://img.shields.io/badge/-Include_Filters-28a745?style=flat-square) | Only show videos containing your keywords |
| ![Exclude](https://img.shields.io/badge/-Exclude_Filters-dc3545?style=flat-square) | Hide videos with unwanted keywords |
| ![Shorts](https://img.shields.io/badge/-Block_Shorts-6f42c1?style=flat-square) | Auto-filter videos under 60 seconds |
| ![Notify](https://img.shields.io/badge/-Notifications-fd7e14?style=flat-square) | Get alerts when matching videos upload |
| ![Theme](https://img.shields.io/badge/-5_Themes-17a2b8?style=flat-square) | Gold, Dark, Rose, Ocean, Mint |
| ![Widget](https://img.shields.io/badge/-Home_Widget-20c997?style=flat-square) | Quick glance at latest videos |
| ![Backup](https://img.shields.io/badge/-Backup_&_Restore-6c757d?style=flat-square) | Export/import your settings |
| ![Bookmark](https://img.shields.io/badge/-Bookmarks-e83e8c?style=flat-square) | Save videos for later |

---

## 🧠 Algorithm

### Filter Priority System

```
┌─────────────────────────────────────────────────────────────┐
│                     VIDEO FROM YOUTUBE                       │
└─────────────────────────────┬───────────────────────────────┘
                              │
                    ┌─────────▼─────────┐
                    │   Is it Short?    │
                    │    (< 60 sec)     │
                    └─────────┬─────────┘
                              │
              ┌───────────────┴───────────────┐
              │ YES                           │ NO
              ▼                               ▼
        ┌──────────┐              ┌───────────────────┐
        │  BLOCK   │              │  Check EXCLUDE    │
        │    ❌    │              │     keywords      │
        └──────────┘              └─────────┬─────────┘
                                            │
                           ┌────────────────┴────────────────┐
                           │ MATCHES                         │ NO MATCH
                           ▼                                 ▼
                     ┌──────────┐                 ┌───────────────────┐
                     │   HIDE   │                 │  Check INCLUDE    │
                     │    ❌    │                 │     keywords      │
                     └──────────┘                 └─────────┬─────────┘
                                                            │
                                        ┌───────────────────┴───────────────────┐
                                        │ NO FILTERS                            │ HAS FILTERS
                                        ▼                                       ▼
                                  ┌──────────┐                        ┌─────────────────┐
                                  │   SHOW   │                        │  Title Match?   │
                                  │    ✅    │                        └────────┬────────┘
                                  └──────────┘                                 │
                                                               ┌───────────────┴───────────────┐
                                                               │ YES                           │ NO
                                                               ▼                               ▼
                                                         ┌──────────┐                ┌─────────────────┐
                                                         │   SHOW   │                │ Desc Match?     │
                                                         │    ✅    │                │ (first 100 chr) │
                                                         └──────────┘                └────────┬────────┘
                                                                                              │
                                                                              ┌───────────────┴───────────────┐
                                                                              │ YES                           │ NO
                                                                              ▼                               ▼
                                                                        ┌──────────┐                   ┌──────────┐
                                                                        │   SHOW   │                   │   HIDE   │
                                                                        │    ✅    │                   │    ❌    │
                                                                        └──────────┘                   └──────────┘
```

### 🎯 Title-First Matching
- **Priority 1:** Search video **Title** for keywords
- **Priority 2:** Search first **100 characters** of Description only
- This prevents false positives from random tags in descriptions

---

## 🏗️ Tech Stack

<p align="center">
  <img src="https://img.shields.io/badge/UI-Flutter_3.x-02569B?style=for-the-badge&logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/State-Provider-4A154B?style=for-the-badge" alt="Provider"/>
  <img src="https://img.shields.io/badge/Database-Drift_(SQLite)-003B57?style=for-the-badge" alt="Drift"/>
  <img src="https://img.shields.io/badge/API-YouTube_Data_v3-FF0000?style=for-the-badge&logo=youtube" alt="YouTube"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Background-WorkManager-6750A4?style=for-the-badge" alt="WorkManager"/>
  <img src="https://img.shields.io/badge/Notifications-Local-FF9800?style=for-the-badge" alt="Notifications"/>
  <img src="https://img.shields.io/badge/Widget-Home_Widget-4CAF50?style=for-the-badge" alt="Widget"/>
</p>

### Project Structure
```
lib/
├── core/
│   ├── constants/       # API keys, colors
│   ├── database/        # Drift tables & queries
│   ├── services/        # YouTube API, Background, Widget
│   ├── theme/           # Theme provider & definitions
│   └── widgets/         # Reusable components
│
├── features/
│   ├── channels/        # Channel management
│   ├── home/            # Main feed, bookmarks, settings
│   └── onboarding/      # First-time user flow
│
└── main.dart            # App entry point
```

---

## 🚀 Getting Started

### Prerequisites
<p>
  <img src="https://img.shields.io/badge/Flutter-3.x+-02569B?style=flat-square&logo=flutter" alt="Flutter 3.x+"/>
  <img src="https://img.shields.io/badge/Dart-3.x+-0175C2?style=flat-square&logo=dart" alt="Dart 3.x+"/>
  <img src="https://img.shields.io/badge/Android_Studio-or_VS_Code-3DDC84?style=flat-square" alt="IDE"/>
</p>

### Installation

```bash
# Clone the repository
git clone https://github.com/Shovon021/FixTube---Smart-YouTube-Filter-App.git
cd FixTube---Smart-YouTube-Filter-App

# Install dependencies
flutter pub get

# Add your YouTube API key in lib/core/constants/api_keys.dart

# Generate database code
dart run build_runner build

# Run the app
flutter run

# Build release APK
flutter build apk --release
```

---

## 📊 API Usage

| Action | API Cost | Frequency |
|--------|----------|-----------|
| Fetch videos | ~3 units/channel | Every 5 mins |
| Get durations | ~1 unit/video | Once per video |
| Search channels | ~100 units | On search |

> **Daily Quota:** 10,000 units (free tier)  
> **Tip:** Limit to ~20 channels for comfortable usage

---

## 🤝 Contributing

<p>
  <img src="https://img.shields.io/badge/Contributions-Welcome-brightgreen?style=for-the-badge" alt="Contributions Welcome"/>
</p>

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

<p>
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License"/>
</p>

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

<p>
  <a href="https://github.com/Shovon021">
    <img src="https://img.shields.io/badge/GitHub-Shovon021-181717?style=for-the-badge&logo=github" alt="GitHub"/>
  </a>
</p>

---

<p align="center">
  <img src="https://img.shields.io/badge/Made_with-❤️_and_Flutter-02569B?style=for-the-badge&logo=flutter" alt="Made with Flutter"/>
</p>
