import 'dart:io';

import 'package:client/features/home/current_route.dart';
import 'package:client/router.dart';
import 'package:client/utils/expanded_slider_track_shape.dart';
import 'package:client/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.g.dart';

import 'utils/bloc_provider.dart';
import 'features/settings/settings_bloc.dart';
import 'features/settings/settings_events_states.dart';

import 'utils/constants.dart';
import 'services/repo.dart';
import 'package:window_size/window_size.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Restaurant POS');
    setWindowMinSize(const Size(600, 500));
    setWindowMaxSize(Size.infinite);
  }

  final configBloc = AppConfigBloc();
  await configBloc.loadConfig();

  runApp(MultiProvider(
    providers: [
      Provider<Repo>(create: (context) => Repo()),
      Provider<Constants>(create: (context) => Constants()),
    ],
    child: MyApp(configBloc: configBloc)
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.configBloc});
  
  final AppConfigBloc configBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => configBloc,
      child: BlocBuilder<AppConfigBloc, SettingsBlocState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: state.locale,

            onGenerateRoute: generateRootRoute,

            title: 'Restaurant POS',
            // navigatorObservers: [
            //   CurrentRouteNavigatorObserver()
            // ],
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.pink,
              brightness: state.brightness,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder()
              ),
              sliderTheme: SliderThemeData(
                trackShape: ExpandedRoundedRectSliderTrackShape(),
                rangeTrackShape: ExpandedRoundedRectRangeSliderTrackShape()
              ),
              bottomAppBarTheme: const BottomAppBarTheme(
                height: p56
              )
            ),
          );
        }
      ),
    );
  }
}