import 'package:client/services/models.dart';
import 'package:client/supplys/supplys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/router.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10nn/app_localizations.dart';

import 'bloc_provider.dart';
import 'employees/employees.dart';
import 'main_bloc.dart';
import 'stats/stats_page.dart';
import 'widgets/main_button.dart';

import 'services/constants.dart';
import 'services/repo.dart';
import 'store/store.dart';
import 'widgets/navigation_drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  final MyRouter myRouter = MyRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Repo>(create: (context) => Repo()),
        Provider<Constants>(create: (context) => Constants()),
      ],
      child: Builder(
        builder: (context) {
          return BlocProvider(
            blocBuilder: () => MainBloc(Provider.of<Repo>(context)),
            blocDispose: (MainBloc bloc) => bloc.dispose(),
            child: Builder(
              builder: (context) {
                var bloc = BlocProvider.of<MainBloc>(context);
                return StreamBuilder<Object>(
                  stream: bloc.outState,
                  builder: (context, snapshot) {
                    
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      
                      localizationsDelegates: AppLocalizations.localizationsDelegates,
                      supportedLocales: AppLocalizations.supportedLocales,
                      locale: Locale.fromSubtags(languageCode: bloc.curLang),

                      title: 'restaurant',
                      theme: ThemeData(
                        primarySwatch: Colors.pink,
                        primaryColor: Colors.pink,
                        brightness: bloc.curBr,
                        appBarTheme: AppBarTheme(
                          titleTextStyle: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      onGenerateRoute: myRouter.onGenerateRoute,
                    );
                  }
                );
              }
            ),
          );
        }
      ),
    );
  }
}





class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(title: const Text("ресторан")),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MainButton(
              child: const Text("склад"),
              onPressed: () {
                Navigator.pushNamed(context, '/store');
              },
            ),
            MainButton(
              child: const Text("поставки"),
              onPressed: () {
                Navigator.pushNamed(context, '/supplys');
              },
            ),
            MainButton(
              child: const Text("меню"),
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
            ),
            MainButton(
              child: const Text("работники"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => Employees()));
              },
            ),
            MainButton(
              child: const Text("заказы"),
              onPressed: () async {
                print(DateTime.now());
                Navigator.pushNamed(context, '/orders');
              
              },
            ),
            MainButton(
              child: const Text("stats"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StatsPage()));
              },
            ),
            BackButton(onPressed: () {
              print(DateTime.now().toString().substring(0, 19));
              print(DateTime.parse('2000-01-01T22:22:22.005'));
            })
          ],
        ),
      ), 
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        onPressed: () {
          Navigator.pushNamed(context, '/settings');
        },
      ),
    );
  }
}