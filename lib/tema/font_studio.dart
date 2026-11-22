import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Font Studio: Inter (teks) dan IBM Plex Mono (angka), dibundel di `assets/fonts/`.
abstract final class FontStudio {
  static const paket = 'metrology_studio';

  /// Teks antarmuka.
  static const inter = 'Inter';

  /// Angka: nilai acuan, nomor versi, sha.
  static const mono = 'IBMPlexMono';

  /// Berkas yang dideklarasikan pubspec paket (`assets/fonts/<Keluarga>-<Ragam>.ttf`).
  static const _ragam = ['Regular', 'Medium', 'SemiBold', 'Bold'];
  static const _keluarga = ['Inter', 'IBMPlexMono'];

  /// Kunci aset bundel untuk satu berkas font paket.
  static String kunciAset(String keluarga, String ragam) =>
      'assets/fonts/$keluarga-$ragam.ttf';
}

/// Daftarkan nama polos `Inter` & `IBMPlexMono` dari berkas yang SAMA di bundel
/// paket, supaya widget bersama yang menulis nama polos tetap memakai font
/// yang benar. Mengembalikan jumlah berkas yang termuat.
///
/// Gagal memuat TIDAK menghentikan aplikasi: yang hilang cuma bentuk huruf
/// (jatuh ke font sistem), bukan data. Kegagalannya dicatat, tidak ditelan
/// diam-diam.
Future<int> daftarkanAliasFont({AssetBundle? bundel}) async {
  final sumber = bundel ?? rootBundle;
  var termuat = 0;
  for (final keluarga in FontStudio._keluarga) {
    final pemuat = FontLoader(keluarga);
    for (final ragam in FontStudio._ragam) {
      final kunci = FontStudio.kunciAset(keluarga, ragam);
      try {
        // Dimuat dulu di sini supaya aset yang hilang ketahuan per berkas,
        // bukan sebagai kegagalan `load()` tanpa nama.
        final data = await sumber.load(kunci);
        pemuat.addFont(Future.value(data));
        termuat++;
      } catch (e) {
        debugPrint('Font $kunci tidak termuat: $e');
      }
    }
    await pemuat.load();
  }
  return termuat;
}
