import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_s/screens/home_page.dart';
import 'package:todo_s/settings/ThemeSettings.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
  final isDark = sharedPreferences.getBool("is_dark") ?? false;

  runApp(  MyApp(isDark: isDark,));
}


class MyApp extends StatelessWidget {
  final bool isDark;
  const MyApp({Key? key, required this.isDark}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => ThemeSettings(isDark),
      builder: (context , snapshot) {
        final settings = Provider.of<ThemeSettings> (context);

        return  MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: settings.currentTheme ,
        home: HomePage(),

        );
      },

    );
  }
}
