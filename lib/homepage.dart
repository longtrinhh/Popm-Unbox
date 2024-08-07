import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:popm/nyota.dart';
import 'package:popm/gotham.dart';
import 'package:popm/kungfu.dart';
import 'package:popm/pixar.dart';
import 'package:popm/collection.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> unboxedCharacters = [];
  final List<Map<String, String>> _types = [
    {'name': 'Nyota Fluffy Life', 'image': 'assets/nyota.webp'},
    {'name': 'DC Gotham City', 'image': 'assets/batman.webp'},
    {'name': 'Kung Fu Panda', 'image': 'assets/kungfu.webp'},
    {'name': '100th Anniversary Pixar', 'image': 'assets/disney.webp'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCharacterState();
  }

  _saveCharacterState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> characterList = unboxedCharacters.map((character) => jsonEncode(character)).toList();
    prefs.setStringList('unboxedCharacters', characterList);
    print('Characters saved: $characterList');
  }

  _loadCharacterState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? characterList = prefs.getStringList('unboxedCharacters');
    if (characterList != null) {
      setState(() {
        unboxedCharacters = characterList.map((character) => jsonDecode(character)).toList().cast<Map<String, dynamic>>();
      });
      print('Characters loaded: $unboxedCharacters');
    }
  }

  void _updateUnboxedCharacters(List<Map<String, dynamic>> newCharacters) {
    setState(() {
      unboxedCharacters = newCharacters;
    });
    _saveCharacterState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pop Mart Unboxing Simulator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono',
          ),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Please choose Type of Boxs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoMono',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _types.length,
                itemBuilder: (BuildContext context, int index) {
                  final type = _types[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the corresponding page
                      switch (type['name']) {
                        case 'Nyota Fluffy Life':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NyotaPage(unboxedCharacters: unboxedCharacters, updateCharacters: _updateUnboxedCharacters)),
                          );
                          break;
                        case 'DC Gotham City':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GothamPage(unboxedCharacters: unboxedCharacters, updateCharacters: _updateUnboxedCharacters)),
                          );
                          break;
                        case 'Kung Fu Panda':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => KungfuPage(unboxedCharacters: unboxedCharacters, updateCharacters: _updateUnboxedCharacters)),
                          );
                          break;
                        case '100th Anniversary Pixar':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PixarPage(unboxedCharacters: unboxedCharacters, updateCharacters: _updateUnboxedCharacters)),
                          );
                          break;
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                type['image']!,
                                width: 350,
                                height: 350,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                type['name']!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'RobotoMono',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CollectionPage(unboxedCharacters: unboxedCharacters),
                  ),
                );
              },
              child: const Text('View Collection'),
            ),
          ],
        ),
      ),
    );
  }
}