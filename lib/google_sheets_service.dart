import 'dart:convert';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:flutter/services.dart' show rootBundle;

class GoogleSheetsService {
  static Future<void> insertIntoGoogleSheet(
    String nid,
    String name,
    String dob,
  ) async {
    // Load service account credentials
    final credentials = await rootBundle.loadString('assets/data.json');
    final jsonCredentials = jsonDecode(credentials);
    final accountCredentials = auth.ServiceAccountCredentials.fromJson(
      jsonCredentials,
    );

    // Create an authenticated HTTP client
    final client = await auth.clientViaServiceAccount(accountCredentials, [
      sheets.SheetsApi.spreadsheetsScope,
    ]);

    // Initialize Sheets API
    final sheetsApi = sheets.SheetsApi(client);
    final spreadsheetId =
        "16kPx6mXtJD07w7zW99WtSh8VwPWvsR16ld6wBge_rDI"; // Replace with your sheet ID
    final range = "NID Data!A1:C"; // Range to append data

    // Prepare the data to append
    final values = [
      [nid, name, dob],
    ];
    final valueRange = sheets.ValueRange(values: values);

    // Append data to the sheet
    await sheetsApi.spreadsheets.values.append(
      valueRange,
      spreadsheetId,
      range,
      valueInputOption: "RAW",
    );

    // Close the client
    client.close();
  }
}
