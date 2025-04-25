// lib/services/plant_recognition_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:medicinal_plants_id/utils/romanian_text.dart';

class PlantRecognitionService {
  /// Identifică planta din imagine și întoarce câmpurile parse-ate.
  static Future<Map<String, dynamic>> identifyPlant(File imageFile) async {
    try {
      // 1️⃣  Codăm imaginea în base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // 2️⃣  Endpoint + API-key
      final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
      final apiKey = dotenv.env['GROQ_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('Lipsește GROQ_API_KEY în fișierul .env');
      }

      // 3️⃣  Prompt în limba română
      const prompt = '''
Identifică această plantă medicinală din imagine. 
Te rog să oferi toate informațiile în limba română, cu diacritice, exact în următorul format:

NUME_ȘTIINȚIFIC: (numele latin complet al plantei)
NUME_COMUN: (numele în română al plantei)
DESCRIERE: (descriere detaliată a plantei)
PROPRIETĂȚI_MEDICINALE: (proprietățile medicinale)
UTILIZĂRI_TERAPEUTICE: (utilizările terapeutice)

Este FOARTE IMPORTANT ca informațiile să corespundă exact plantei identificate în imagine. 
Nu oferi informații despre alte plante dacă nu ești sigur de identificare.
Dacă nu poți identifica planta cu certitudine, scrie "Nedeterminat" la numele științific și comun.
''';
      final body = jsonEncode({
        "messages": [
          {
            "role": "user",
            "content": [
              {"type": "text", "text": prompt},
              {
                "type": "image_url",
                "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
              }
            ]
          }
        ],
        "model": "meta-llama/llama-4-scout-17b-16e-instruct",
        "temperature": 0.7,
        "max_tokens": 1024
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final content =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        return _extractPlantInfo(cleanRomanianDiacritics(content));
      } else {
        throw Exception(
            'Identificarea plantei a eșuat: ${response.statusCode}');
      }
    } catch (e) {
      return {
        'scientificName': 'Nedeterminat',
        'commonName': 'Nedeterminat',
        'description':
            'Nu am putut identifica planta din imagine. Vă rugăm să încercați cu o altă fotografie.',
        'medicinalProperties': 'Nedeterminat',
        'therapeuticUses': 'Nedeterminat',
        'confidence': 0.0,
      };
    }
  }

  // ------------ Parsare text din răspuns ------------
  static Map<String, dynamic> _extractPlantInfo(String content) {
    String scientificName = 'Nedeterminat';
    String commonName = 'Nedeterminat';
    String description = '';
    String medicinalProperties = '';
    String therapeuticUses = '';

    scientificName = RegExp(r'NUME_ȘTIINȚIFIC:\s*([^\n]+)', caseSensitive: false)
            .firstMatch(content)
            ?.group(1)
            ?.trim() ??
        scientificName;

    commonName = RegExp(r'NUME_COMUN:\s*([^\n]+)', caseSensitive: false)
            .firstMatch(content)
            ?.group(1)
            ?.trim() ??
        commonName;

    description = RegExp(
                r'DESCRIERE:\s*([\s\S]*?)(?=PROPRIETĂȚI_MEDICINALE:|UTILIZĂRI_TERAPEUTICE:|$)',
                caseSensitive: false)
            .firstMatch(content)
            ?.group(1)
            ?.trim() ??
        '';

    medicinalProperties = RegExp(
                r'PROPRIETĂȚI_MEDICINALE:\s*([\s\S]*?)(?=UTILIZĂRI_TERAPEUTICE:|$)',
                caseSensitive: false)
            .firstMatch(content)
            ?.group(1)
            ?.trim() ??
        '';

    therapeuticUses = RegExp(r'UTILIZĂRI_TERAPEUTICE:\s*([\s\S]*)',
                caseSensitive: false)
            .firstMatch(content)
            ?.group(1)
            ?.trim() ??
        '';

    return {
      'scientificName': cleanRomanianDiacritics(scientificName),
      'commonName': cleanRomanianDiacritics(commonName),
      'description': cleanRomanianDiacritics(description),
      'medicinalProperties': cleanRomanianDiacritics(medicinalProperties),
      'therapeuticUses': cleanRomanianDiacritics(therapeuticUses),
      'confidence': scientificName != 'Nedeterminat' ? 0.9 : 0.3,
    };
  }
}
