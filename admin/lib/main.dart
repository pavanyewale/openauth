import 'package:admin/screens/home/home.dart';
import 'package:admin/screens/login/login.dart';
import 'package:admin/screens/login/service.dart';
import 'package:admin/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => LoginService.instance,
    child:const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenAuth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 86, 44, 158)),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginService>(context);
    return FutureBuilder(future: provider.loadAuthTokenFromLocal(), builder: (context,snapshot){
      if (snapshot.connectionState == ConnectionState.done){
        if (provider.isLoggedIn){
        return const HomeScreen();
        }else{
          return  const LoginScreen();
        }
      }else{
        return const SplashScreen();
      }
    });
  }
}