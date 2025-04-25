// lib/utils/romanian_text.dart
//
// Funcție utilitară care repară dublul-encoding + artefactele tipice
// pentru diacriticele românești.

import 'dart:convert';

String cleanRomanianDiacritics(String text) {
  if (text.isEmpty) return text;

  // 1️⃣  Încercăm întâi un „round-trip” UTF-8 → Latin-1 → UTF-8
  try {
    text = utf8.decode(latin1.encode(text));
  } catch (_) {
    /* dacă nu e dublu-encodat, ignorăm */
  }

  // 2️⃣  Înlocuiri manuale (map constant)
  const fix = {
    // UTF-8 citit ca ISO-8859-1
    'Ã¢': 'â', 'Ã‚': 'Â',
    'Ã®': 'î', 'ÃŽ': 'Î',
    'Äƒ': 'ă', 'Ä‚': 'Ă',
    'È™': 'ș', 'È˜': 'Ș',
    'È›': 'ț', 'Èš': 'Ț',

    // Windows-1250 / CP1252
    'Å£': 'ț', 'Å¢': 'Ț',
    'ÅŸ': 'ș', 'Å': 'Ș',

    // Artefacte / OCR
    'Å¸': 'ț', 'Å§': 'ș',
    'Â ': ' ',  'ÂÂ': '',
    'Ã':  'Ă',  '□': '',
  };

  fix.forEach((k, v) => text = text.replaceAll(k, v));
  return text;
}
