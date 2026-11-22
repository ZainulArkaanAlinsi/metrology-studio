import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metrology_studio/shared/l10n/app_localizations.dart';
import 'package:metrology_studio/shared/providers/locale_provider.dart';

import 'inti/lingkungan_studio.dart';
import 'l10n/studio_l10n.dart';
import 'layar/gerbang_masuk.dart';
import 'tema/tema_studio.dart';

/// Akar Metrology Studio.
///
/// Beda dari `MetrologyApp` lapangan dengan sengaja: TIDAK menonton
/// `pendaftaranPushSyncProvider` (Studio tanpa push), tanpa `navigatorKey`
/// global untuk ketukan notifikasi, tanpa onboarding.
class MetrologyStudioApp extends ConsumerWidget {
  const MetrologyStudioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Metrology Studio',
      debugShowCheckedModeBanner: false,
      theme: TemaStudio.terang,
      darkTheme: TemaStudio.gelap,
      themeMode: ref.watch(modeTemaStudioProvider),
      // Pilihan bahasa milik perangkat (paket bersama, bawaan ID). Disimpan
      // di prefs Studio sendiri — aplikasinya terpisah, prefs-nya juga.
      locale: ref.watch(localeProvider),
      localizationsDelegates: const [
        StudioL10n.delegate,
        // Layar bersama (data acuan M2) membaca AppLocalizations paket.
        ...AppLocalizations.localizationsDelegates,
      ],
      supportedLocales: StudioL10n.supportedLocales,
      home: const GerbangMasukStudio(),
    );
  }
}
