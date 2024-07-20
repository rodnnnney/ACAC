import 'package:http/http.dart' as http;

class GetDistance {
  Future<String> createHttpUrl(double originLat, double originLng,
      double destinationLat, double destinationLng) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
    String origin = '$originLat,$originLng';
    String destination = '$destinationLat,$destinationLng';
    String url =
        '$baseUrl?origin=$origin&destination=$destination&key=AIzaSyCw23kDf2jJs7sUILVm2vk6oIki8n8zymY';
    try {
      final parsedURL = Uri.parse(url);
      http.Response response = await http.get(parsedURL);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Http error: ${response.statusCode}');
      }
    } catch (e) {
      print('General error:$e');
    }
    return 'ERROR';
  }
}
