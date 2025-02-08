// lib/home_screen.dart
import 'package:flutter/material.dart';
import 'package:sunphase/core/result.dart';
import 'package:sunphase/sunphase.dart'; // sunphase package import

/// HomeScreen is the main UI screen demonstrating sunphase package functionality.
/// HomeScreen は、sunphase パッケージの機能（解析、コードスニペット、応答データ表示など）を示すメイン画面です。
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Text field controller / テキスト入力欄のコントローラー
  final TextEditingController _controller = TextEditingController();

  // Selected language: 'all' (default), 'en', 'ja', or 'zh'
  // 選択された言語設定（デフォルトは 'all'：全言語）
  String _selectedLanguage = 'all';

  // Range mode flag (true: on, false: off)
  // レンジモードのオンオフフラグ
  bool _rangeMode = false;

  // Parsed results from the sunphase package / sunphase パッケージから得られた解析結果
  List<ParsingResult> _results = [];

  // Current time to display / 表示する現在時刻
  DateTime _currentTime = DateTime.now();

  // Code snippet string that shows the current parse() call / 現在の parse() 呼び出しコード
  String _codeSnippet = '';

  // Raw response data string from parse() output / 解析応答の生データ文字列
  String _rawResponse = '';

  @override
  void initState() {
    super.initState();
    // Add a listener to update results when text input changes
    // テキスト入力が変更された際に解析結果と表示内容を更新するリスナーを追加
    _controller.addListener(_onTextChanged);
  }

  // Callback when text input changes / テキスト入力変更時のコールバック
  void _onTextChanged() {
    _updateResults();
  }

  // Update the parsed results and the code snippet / 現在の入力と設定に基づいて解析結果とコード表示を更新する
  void _updateResults() {
    String input = _controller.text;
    DateTime now = DateTime.now();
    setState(() {
      _currentTime = now;
      // Determine language parameter: if 'all' is selected, pass null
      // 言語パラメータ：'all' の場合は null を指定する
      String? langParam = _selectedLanguage != 'all' ? _selectedLanguage : null;
      // Call the parse function from the sunphase package with options
      // オプションを指定して sunphase の parse() 関数を呼び出す
      _results = parse(input, language: langParam, rangeMode: _rangeMode);
      // Generate the code snippet for the parse() call
      // 現在の設定に基づく parse() 呼び出しコードを文字列として生成
      _codeSnippet = "parse(\"$input\", language: ${_selectedLanguage != 'all' ? '\"$_selectedLanguage\"' : 'null'}, rangeMode: $_rangeMode)";
      // Generate the raw response data string from _results
      // 解析結果の生データを生成（各 ParsingResult の toString() を連結）
      _rawResponse = _results.map((r) => r.toString()).join("\n");
    });
  }

  // Build language selection buttons (UI labels are in English)
  // 言語選択ボタン（UI 表示は英語）
  Widget _buildLanguageButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: Text('All'),
          onPressed: () {
            setState(() {
              _selectedLanguage = 'all';
            });
            _updateResults();
          },
        ),
        SizedBox(width: 8),
        ElevatedButton(
          child: Text('English'),
          onPressed: () {
            setState(() {
              _selectedLanguage = 'en';
            });
            _updateResults();
          },
        ),
        SizedBox(width: 8),
        ElevatedButton(
          child: Text('Japanese'),
          onPressed: () {
            setState(() {
              _selectedLanguage = 'ja';
            });
            _updateResults();
          },
        ),
        SizedBox(width: 8),
        ElevatedButton(
          child: Text('Chinese'),
          onPressed: () {
            setState(() {
              _selectedLanguage = 'zh';
            });
            _updateResults();
          },
        ),
      ],
    );
  }

  // Build a toggle switch for range mode
  // レンジモード切替スイッチのウィジェット
  Widget _buildRangeModeSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Range Mode: '),
        Switch(
          value: _rangeMode,
          onChanged: (bool value) {
            setState(() {
              _rangeMode = value;
            });
            _updateResults();
          },
        ),
      ],
    );
  }

  // Build a widget to display the current time and weekday
  // 現在時刻と曜日を表示するウィジェット
  Widget _buildCurrentTimeDisplay() {
    String weekday = _getWeekdayString(_currentTime.weekday);
    return Text(
      'Current Time: ${_currentTime.toLocal().toString().split('.')[0]} - Weekday: $weekday',
      textAlign: TextAlign.center,
    );
  }

  // Helper function to convert weekday number to string (English)
  // 曜日番号を英語に変換する補助関数
  String _getWeekdayString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  // Build a widget to display parsed results, code snippet, and raw response data
  // 解析結果、parse() 呼び出しコード、そして生の応答データを表示するウィジェット
  Widget _buildResultsDisplay() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parsed results list
            // 解析結果リスト
            Text(
              'Parsed Results:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final result = _results[index];
                return ListTile(
                  title: Text('Matched: ${result.text}'),
                  // 修正: result.component は存在しないため result.start を使用
                  subtitle: Text('Date: ${result.start.toDateTime(_currentTime).toLocal().toString().split('.')[0]}'),
                );
              },
            ),
            Divider(),
            // Code snippet display
            // parse() 呼び出しコードの表示
            Text(
              'Code: $_codeSnippet',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
            SizedBox(height: 8),
            // Raw response data display
            // 解析応答の生データ表示
            Text(
              'Raw Response Data:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              _rawResponse,
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sunphase Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCurrentTimeDisplay(),
            SizedBox(height: 16),
            _buildLanguageButtons(),
            SizedBox(height: 16),
            _buildRangeModeSwitch(),
            SizedBox(height: 16),
            // Text input field
            // テキスト入力欄
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter text',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _updateResults();
              },
            ),
            SizedBox(height: 16),
            _buildResultsDisplay(),
          ],
        ),
      ),
    );
  }
}
