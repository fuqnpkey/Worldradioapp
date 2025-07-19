import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _stations = [];
  bool _isLoading = true;
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    fetchStations();
  }

  Future<void> fetchStations() async {
    setState(() => _isLoading = true);
    try {
      final response = await HttpClient().getUrl(
        Uri.parse('https://de1.api.radio-browser.info/json/stations/topclick/100'),
      );
      final result = await response.close();
      final body = await result.transform(utf8.decoder).join();
      setState(() {
        _stations = jsonDecode(body);
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _play(String url) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WorldRadio')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search stations',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() {}),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _stations.length,
                    itemBuilder: (_, i) {
                      final s = _stations[i];
                      if (_searchController.text.isNotEmpty &&
                          !s['name']
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase())) {
                        return SizedBox.shrink();
                      }
                      return ListTile(
                        leading: s['favicon'] != ''
                            ? Image.network(s['favicon'], width: 40)
                            : Icon(Icons.radio),
                        title: Text(s['name'] ?? 'Unknown'),
                        subtitle: Text(s['country'] ?? 'N/A'),
                        onTap: () => _play(s['url']),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}