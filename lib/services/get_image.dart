import 'package:dio/dio.dart';
import 'package:live_coding/token.dart';

class GetImageService {
  final Dio _dio = Dio();

  Future<String> getImage(String prompt) async {
    _dio.options.headers = {
      "Authorization": 'Bearer ${Token.openAiToken}',
      "Content-Type": 'application/json',
    };
    Response response =
        await _dio.post('https://api.openai.com/v1/images/generations', data: {
      "prompt": prompt,
      "n": 1,
      "size": "256x256",
    });
    var data = response.data['data'];
    var url = data[0]['url'];

    return url;
  }
}
