import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/widges/expenses.dart';
import 'package:flutter/services.dart';

// ColorScheme.fromSeed() is used to generate random colors
// ColorScheme.fromSeed()は、ランダムな色を生成するために使用されます。
// seedColor is used to set the color of the app
// seedColorは、アプリの色を設定するために使用されます。
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 5, 81, 100),
);
// var kColorScheme = const ColorScheme.light(
//   primary: Color.fromARGB(225, 230, 15, 0),
//   secondary: Color.fromARGB(225, 230, 15, 0),
// );

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 48, 1, 102),
);

void main() {
  // WidgetsFlutterBinding.ensureInitialized() is used to initialize the app
  // WidgetsFlutterBinding.ensureInitialized()は、アプリを初期化するために使用されます。
  // -------------------------------------------------------- //
  // Returns an instance of the binding that implements [WidgetsBinding]. If no binding has yet been initialized, the [WidgetsFlutterBinding] class is used to create and initialize one.
  // [WidgetsBinding]を実装するバインディングのインスタンスを返します。まだバインディングが初期化されていない場合は、[WidgetsFlutterBinding]クラスが使用されて、1つが作成されて初期化されます。
  // -------------------------------------------------------- //
  // WidgetsFlutterBinding.ensureInitialized();
  // setPreferredOrientations() is used to set the orientation of the app
  // setPreferredOrientations()は、アプリの向きを設定するために使用されます。
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp, // 縦固定
  //   ],
  // ).then((_) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          // margin: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            // foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      // copyWith() is used to override the default theme
      // copyWithとは、デフォルトのテーマを上書きするために使用されます。
      theme: ThemeData().copyWith(
        useMaterial3: true,
        // colorScheme is used to change the color of the app
        // colorSchemeは、アプリの色を変更するために使用されます。
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          // backgroundとは、背景色のことです。
          backgroundColor: kColorScheme.onPrimaryContainer,
          // foregroundとは、前景色のことです。
          foregroundColor: kColorScheme.primaryContainer,
        ),
        // secondary => An accent color used for less prominent components in the UI, such as filter chips, while expanding the opportunity for color expression.
        // secondary => フィルターチップなどのUI内の目立たないコンポーネントに使用されるアクセントカラーであり、色の表現の機会を拡大します。
        // secondaryContainer => A color used for elements needing less emphasis than [secondary].
        // secondaryContainer => [secondary]よりも強調する必要の少ない要素に使用される色。
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          // margin: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                // appBarThemeのforegroundColorを指定したため、colorを指定しても変わらない。
                // expense_item.dartのTextのstyleを指定すると変更可能 (style: Theme.of(context).textTheme.titleLarge)
                fontWeight: FontWeight.bold,
                color: kColorScheme.onSecondaryContainer,
                // color: Colors.red,
                fontSize: 16,
                // fontWeight: FontWeight.bold,
              ),
            ),
        // scaffoldBackgroundColor: const Color.fromARGB(225, 230, 15, 0),
      ),
      home: const Expenses(),
      themeMode: ThemeMode.system,
    );
  }
}
