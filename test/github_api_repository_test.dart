import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../lib/main.dart';

import 'github_api_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
main() {
  test('Mockのテスト', () async {
    final client = MockClient();
    when(client.get(any))
        .thenAnswer((_) async => http.Response('{"total_count":467417}', 200));
    expect(
      (await client.get(Uri.parse(
              'https://api.github.com/search/repositories?q=flutter')))
          .body,
      '{"total_count":467417}',
    );
  });

  test('DIでモックを使用してテスト', () async {
    // モックの設定
    final client = MockClient();
    when(client.get(any))
        .thenAnswer((_) async => http.Response('{"total_count":467417}', 200));

    // DIの設定
    GetIt.I.registerLazySingleton<http.Client>(() => client);

    // GithubApiRepositoryをモックを使用してテスト
    final repository = GithubApiRepository();
    final result = await repository.countRepositories();
    expect(result, 467417);
  });
}
