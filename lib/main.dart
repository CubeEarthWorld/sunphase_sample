// main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sunphase/sunphase.dart'; // parse() function is included here

void main() {
  runApp(const SunphaseDemoApp());
}

class SunphaseDemoApp extends StatelessWidget {
  const SunphaseDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunphase Demo',
      theme: ThemeData.dark(), // Use dark theme
      home: const SunphaseDemoPage(),
    );
  }
}

class SunphaseDemoPage extends StatefulWidget {
  const SunphaseDemoPage({Key? key}) : super(key: key);

  @override
  _SunphaseDemoPageState createState() => _SunphaseDemoPageState();
}

class _SunphaseDemoPageState extends State<SunphaseDemoPage> {
  // Input text for parsing.
  String _inputText = "";
  // List of parsing results.
  List<ParsingResult> _results = [];
  // Current time used as reference.
  DateTime _currentTime = DateTime.now();
  // Toggle for range_mode.
  bool _rangeMode = false;
  // Toggle for timezone mode.
  bool _timezoneMode = false;
  // Timezone offset value (in minutes, as string).
  String _timezoneOffset = "0";

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update the current time every second.
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
        // If input text exists, update parsing results.
        if (_inputText.isNotEmpty) {
          _updateParsingResults();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Update parsing results based on input text and current settings.
  void _updateParsingResults() {
    // If timezone mode is on, pass the offset value; otherwise, null.
    String? tz = _timezoneMode ? _timezoneOffset : null;
    List<ParsingResult> results = parse(
      _inputText,
      referenceDate: _currentTime,
      rangeMode: _rangeMode,
      timezone: tz,
    );
    setState(() {
      _results = results;
    });
  }

  // Build a dynamically updated parse() code snippet reflecting current settings.
  String _buildParseCodeSnippet() {
    // The sample code shows how parse() is being called with the current settings.
    String tzValue = _timezoneMode ? "'$_timezoneOffset'" : "null";
    String snippet = '''
// Example usage of parse() in sunphase.dart:
import 'package:sunphase/sunphase.dart';

// Call parse() with the following parameters:
List<ParsingResult> results = parse(
  '$_inputText',
  referenceDate: DateTime.parse("${_currentTime.toIso8601String()}"),
  rangeMode: ${_rangeMode.toString()},
  timezone: $tzValue
);
print(results);
''';
    return snippet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sunphase Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display current time.
            Text(
              'Current Time: ${_currentTime.toLocal().toString()}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Range Mode toggle.
            Row(
              children: [
                const Text('Range Mode:'),
                const SizedBox(width: 8),
                Switch(
                  value: _rangeMode,
                  onChanged: (bool value) {
                    setState(() {
                      _rangeMode = value;
                      _updateParsingResults();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Timezone Mode toggle.
            Row(
              children: [
                const Text('Timezone Mode:'),
                const SizedBox(width: 8),
                Switch(
                  value: _timezoneMode,
                  onChanged: (bool value) {
                    setState(() {
                      _timezoneMode = value;
                      _updateParsingResults();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Timezone Offset input (only visible if Timezone Mode is enabled).
            if (_timezoneMode)
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Timezone Offset (minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _timezoneOffset = value;
                    _updateParsingResults();
                  });
                },
              ),
            const SizedBox(height: 16),
            // Input text field.
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter text to parse',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _inputText = value;
                  _updateParsingResults();
                });
              },
            ),
            const SizedBox(height: 16),
            // Display current settings.
            Text(
              'Current Settings:\nRange Mode: $_rangeMode\nTimezone Mode: $_timezoneMode\nTimezone Offset: ${_timezoneMode ? _timezoneOffset : "None"}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            // Display raw parsing results.
            const Text(
              'Raw Response Data:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _results.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final result = _results[index];
                return Text(
                  result.toString(),
                  style: const TextStyle(fontSize: 14),
                );
              },
            )
                : const Text('No result', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            // Display the dynamically updated parse() code snippet.
            const Text(
              'parse() Code Sample:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[800],
              width: double.infinity,
              child: Text(
                _buildParseCodeSnippet(),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
