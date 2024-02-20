import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



class WebhookData {
  final String property1;
  final int property2;

  WebhookData({
    required this.property1,
    required this.property2,
  });

  factory WebhookData.fromJson(Map<String, dynamic> json) {
    return WebhookData(
      property1: json['property1'],
      property2: json['property2'],
    );
  }
}

class WebhookService {
  final StreamController<WebhookData> _dataStreamController = StreamController<WebhookData>();

  Stream<WebhookData> get dataStream => _dataStreamController.stream;

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://us-central1-tehine-d69bf.cloudfunctions.net/webhook'));

    if (response.statusCode == 200) {
      final data = WebhookData.fromJson(json.decode(response.body)); // Adjust based on your data model
      _dataStreamController.add(data);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void dispose() {
    _dataStreamController.close();
  }
}

