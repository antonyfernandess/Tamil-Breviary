import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../modules/liturgical_engine/application/celebration_generator.dart';
import '../modules/liturgical_engine/application/liturgical_engine_impl.dart';
import '../modules/liturgical_engine/application/services/calendar_service.dart';
import '../modules/liturgical_engine/application/services/calendar_service_impl.dart';
import '../modules/liturgical_engine/application/services/liturgical_precedence.dart';
import '../modules/liturgical_engine/domain/value_objects/calendar_settings.dart';
import '../modules/liturgical_engine/infrastructure/calendars/general_roman_calendar.dart';
import '../modules/liturgical_engine/infrastructure/calendars/sqlite_fixed_feast_calendar.dart';
import '../modules/liturgical_engine/infrastructure/database/feast_repository.dart';
import 'app_language_controller.dart';
import 'router.dart';

class CatholicApp extends StatefulWidget {
  const CatholicApp({super.key});

  @override
  State<CatholicApp> createState() => _CatholicAppState();
}

class _CatholicAppState extends State<CatholicApp> {
  late final Future<_AppServices> _appServicesFuture;
  _AppServices? _appServices;

  @override
  void initState() {
    super.initState();
    _appServicesFuture = _loadAppServices();
  }

  Future<_AppServices> _loadAppServices() async {
    final calendarServiceFuture = _buildCalendarService();
    final languageControllerFuture = AppLanguageController.load();
    final calendarService = await calendarServiceFuture;
    final languageController = await languageControllerFuture;
    _appServices = _AppServices(calendarService, languageController);
    return _appServices!;
  }

  Future<CalendarService> _buildCalendarService() async {
    final feastRows = await FeastRepository().loadAll();

    final generator = CelebrationGenerator(
      calendars: [
        GeneralRomanCalendar(),
        SqliteFixedFeastCalendar(rows: feastRows),
      ],
      precedence: const LiturgicalPrecedence(),
      settings: CalendarSettings.india,
    );

    return CalendarServiceImpl(
      engine: LiturgicalEngineImpl(
        generator: generator,
        settings: CalendarSettings.india,
      ),
    );
  }

  @override
  void dispose() {
    _appServices?.languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AppServices>(
      future: _appServicesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text('Failed to load calendar: ${snapshot.error}'),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final services = snapshot.data!;
        return MultiProvider(
          providers: [
            Provider<CalendarService>.value(value: services.calendarService),
            ChangeNotifierProvider<AppLanguageController>.value(
              value: services.languageController,
            ),
          ],
          child: Consumer<AppLanguageController>(
            builder: (context, language, _) => MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appTitle,
              locale: language.locale,
              localizationsDelegates:
                  AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorSchemeSeed: Colors.deepPurple,
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorSchemeSeed: Colors.deepPurple,
                brightness: Brightness.dark,
                useMaterial3: true,
              ),
              onGenerateRoute: AppRouter.onGenerateRoute,
              initialRoute: AppRouter.home,
            ),
          ),
        );
      },
    );
  }
}

class _AppServices {
  const _AppServices(this.calendarService, this.languageController);

  final CalendarService calendarService;
  final AppLanguageController languageController;
}
