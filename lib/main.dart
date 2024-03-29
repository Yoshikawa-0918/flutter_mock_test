import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

void main() {
  //DIの設定
  GetIt.I.registerLazySingleton<http.Client>(() => http.Client());
  GetIt.I
      .registerLazySingleton<GithubApiRepository>(() => GithubApiRepository());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    final repository = GetIt.I<GithubApiRepository>();
    repository.countRepositories().then((result) {
      setState(() {
        _counter = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

//データベースやWebAPIなど外部に繋がる時にはRepositoryをつける
class GithubApiRepository {
  static const String kApiUrl =
      'https://api.github.com/search/repositories?q=flutter';

  ///検索してヒットしたリポジトリの数を返す
  Future<int> countRepositories() async {
    final http.Client client = GetIt.I<http.Client>();
    final response = await client.get(Uri.parse(kApiUrl));
    final map = json.decode(response.body) as Map<String, dynamic>;
    return map["total_count"] ?? -1;
  }
}
