import 'package:http/http.dart' as http;

Future<bool> isImageUrlValid(String imageUrl) async {
  http.Response res;
  try {
    res = await http.get(Uri.parse(imageUrl));

    if (res.statusCode != 200) {
      return false;
    }

    Map<String, dynamic> data = res.headers;

    return (data['content-type'] == 'image/jpeg' ||
        data['content-type'] == 'image/png' ||
        data['content-type'] == 'image/gif');
  } catch (e) {
    return false;
  }
}

bool isEmailValid(String email) {
  final bool emailValid = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(email);

  return emailValid;
}
