# Catholic

A new Tamil Breviary App.

## Getting Started

## Languages

The app supports English and Tamil. Choose a language from **Settings → Language**;
the selection is saved on the device. Translations live in `lib/l10n/app_en.arb`
and `lib/l10n/app_ta.arb`; after editing them, regenerate the localization classes
with `flutter gen-l10n`.

The calendar translates its liturgical labels and commonly used celebrations.
Feast names without a Tamil entry in the translation catalog continue to use
their English name because the bundled feast database currently stores English
names only.
