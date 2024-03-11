import 'package:flutter_mock_test/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'github_api_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<http.Client>(),
  MockSpec<GithubApiRepository>(),
])
main() {
  test("Mockのテスト", () async {
    final client = MockClient();

    //clientのgetメソッドを実行した時に決め打ちしたResponseを返す
    when(client.get(any))
        .thenAnswer((_) async => http.Response('{"total_count":659730}', 200));

    expect(
      (await client.get(Uri.parse(
              'https://api.github.com/search/repositories?q=flutter')))
          .body,
      '{"total_count":659730}',
    );
  });

  test("DIでモックを使用してテスト", () async {
    //モックの設定
    final client = MockClient();

    //clientのgetメソッドを実行した時に決め打ちしたResponseを返す
    when(client.get(any))
        .thenAnswer((_) async => http.Response('{"total_count":659730}', 200));

    //DIの設定(MockClientのインスタンスのhttp.Clientを返す)
    GetIt.I.registerLazySingleton<http.Client>(() => client);

    //GithubApiRepositoryをモックを使用してテスト
    final repository = GithubApiRepository();
    final result = await repository.countRepositories();
    expect(result, 659730);
  });
}
