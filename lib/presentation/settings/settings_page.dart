import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_language_controller.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/bottom_nav_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final language = context.watch<AppLanguageController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EB),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
          children: [
            Text(
              strings.settingsTitle,
              style: const TextStyle(
                color: Color(0xFF153A30),
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 26),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFEFB),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFEAE5DB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.language,
                    style: const TextStyle(
                      color: Color(0xFF153A30),
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    strings.languageDescription,
                    style: const TextStyle(
                      color: Color(0xFF68766F),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _LanguageOption(
                    locale: const Locale('en'),
                    title: strings.english,
                    selected: language.locale.languageCode == 'en',
                  ),
                  const Divider(height: 1, color: Color(0xFFEAE5DB)),
                  _LanguageOption(
                    locale: const Locale('ta'),
                    title: strings.tamil,
                    selected: language.locale.languageCode == 'ta',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedTab: 'settings'),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.locale,
    required this.title,
    required this.selected,
  });

  final Locale locale;
  final String title;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? const Color(0xFF245B49) : const Color(0xFF9AA49D),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF263A32),
          fontWeight: FontWeight.w700,
        ),
      ),
      onTap: () => _selectLanguage(context, locale, strings),
    );
  }

  Future<void> _selectLanguage(
    BuildContext context,
    Locale locale,
    AppLocalizations strings,
  ) async {
    try {
      await context.read<AppLanguageController>().setLocale(locale);
    } on Exception {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.languageSaveError)));
    }
  }
}
