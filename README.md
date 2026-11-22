# Metrology Studio

Pusat kendali data & olah data laboratorium kalibrasi: aplikasi Flutter untuk
**Windows** dan **tablet Android**. Studio mengelola master workbook (impor,
validasi, versi data acuan, simulasi, pengesahan). Server tetap satu-satunya
tempat hitung; Studio tidak menghitung sendiri.

Proyek ini diekstrak dari monorepo yang lebih besar. Lapisan data bersama
(ApiClient, token, auth, izin, data acuan, layar data acuan) dulu berupa paket
tetangga dan sekarang disalin ke `lib/shared/`, supaya proyek bisa dibangun
mandiri. Studio butuh server API yang kompatibel; alamatnya diatur lewat
`--dart-define=API_BASE_URL=...` (default placeholder `https://api.example.com/api`).

| | Metrology Studio |
|---|---|
| Android applicationId | `com.metrology.studio` |
| Windows exe / ProductName | `metrology_studio.exe` / "Metrology Studio" |
| Push (Firebase) | tidak |
| Pembaru Windows | ya, manifest `versi-studio-windows.json` (URL lewat `urlManifestStudio`) |
| OCR / kamera / onboarding | tidak |

## Menjalankan

```bash
flutter pub get
flutter gen-l10n
flutter run -d windows --dart-define=APP_ENV=dev --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
```

Petunjuk akun uji di layar masuk cuma muncul bila `APP_ENV=dev` disebut eksplisit.

## Periksa

```bash
flutter analyze
flutter test
```

## Struktur

- `lib/main.dart`, `lib/app.dart` — titik masuk & akar (tanpa Firebase; pembaru Windows hanya di build rilis).
- `lib/inti/` — penimpaan provider paket bersama (push → `TanpaTokenPush`),
  lingkungan (`APP_ENV`), mode tema.
- `lib/tema/` — desain sistem Studio: `WarnaStudio` (ThemeExtension),
  `TemaStudio`, font Inter dan IBM Plex Mono (`assets/fonts/`).
- `lib/inti/sesi_studio.dart` — 401 → dialog sesi berakhir, 426 → layar versi
  usang, keluar + sapuan cache. `inti/penimpaan.dart` memasang header
  `X-Klien: metrology-studio` / `X-Versi-Klien` (= `version:` pubspec, dijaga test)
  lewat `KlienHttpBeridentitas` di `lib/shared/`.
- `lib/layar/` — masuk, gerbang, cangkang (sidebar ≥ 1024 meja / rail berlabel /
  rail ikon potret / drawer < 600), seksi, Beranda.
- `lib/widget/bilah_status.dart` — server, koneksi, realtime (`GET /health`),
  pengguna + peran; di tablet dilipat ke menu akun.
- `test/goldens/` — golden cangkang 1280/1138/711 × terang/gelap, dibuat di
  Windows (platform acuan, lihat `test/flutter_test_config.dart`).
- `assets/merek/ikon-studio.png` — tanda merek, sumber yang sama dengan ikon
  peluncur Android & `windows/runner/resources/app_icon.ico`.
