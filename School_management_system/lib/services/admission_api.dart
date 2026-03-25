import 'dart:convert';
import 'package:http/http.dart' as http;

class AdmissionApi {
  // IMPORTANT: correct base URL
  static const baseUrl = "http://127.0.0.1:8000/api/admissions";

  /// -------------------------------
  /// STEP 1 – Basic Info (Start App)
  /// -------------------------------
  static Future<Map<String, dynamic>> AdmissionStepOneView(Map data) async {
    final url = Uri.parse("$baseUrl/start/");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    print("STEP 1 RESPONSE: ${res.statusCode} | ${res.body}");

    if (res.statusCode == 201) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Step 1 failed: ${res.body}");
    }
  }

  /// --------------------------------
  /// STEP 2 – Parent / Guardian Info
  /// --------------------------------
  static Future<bool> submitParent(int id, Map data) async {
    final url = Uri.parse("$baseUrl/$id/parent-details/");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    print("STEP 2 RESPONSE: ${res.statusCode}");
    return res.statusCode == 200;
  }

  /// -------------------------------
  /// STEP 3 – Contact Address
  /// -------------------------------
  static Future<bool> submitContact(int id, Map data) async {
    final url = Uri.parse("$baseUrl/$id/contact-address/");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    print("STEP 3 RESPONSE: ${res.statusCode}");
    return res.statusCode == 200;
  }

  /// -------------------------------
  /// STEP 4 – Document Upload
  /// -------------------------------
  static Future<bool> uploadDocuments(
    int id,
    Map<String, String> fields,
    Map<String, String> files,
  ) async {
    final url = Uri.parse("$baseUrl/$id/upload-documents/");
    var request = http.MultipartRequest('POST', url);

    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    for (var entry in files.entries) {
      request.files.add(
        await http.MultipartFile.fromPath(entry.key, entry.value),
      );
    }

    final res = await request.send();
    print("DOCUMENT UPLOAD RESPONSE: ${res.statusCode}");

    return res.statusCode == 200;
  }

  /// -------------------------------
  /// PAYMENT
  /// -------------------------------
  static Future<bool> makePayment(int id, String txnId) async {
    final url = Uri.parse("$baseUrl/pay/$id/");

    final res = await http.post(url, body: {"transaction_id": txnId});

    print("PAYMENT RESPONSE: ${res.statusCode}");
    return res.statusCode == 200;
  }

  /// -------------------------------
  /// FINAL SUBMIT
  /// -------------------------------
  static Future<bool> finalSubmit(int id) async {
    final url = Uri.parse("$baseUrl/submit/$id/");

    final res = await http.post(url);

    print("FINAL SUBMIT RESPONSE: ${res.statusCode}");
    return res.statusCode == 200;
  }
}
