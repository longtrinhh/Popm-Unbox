import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionPage extends StatefulWidget {
  final List<Map<String, dynamic>> unboxedCharacters;

  const CollectionPage({super.key, required this.unboxedCharacters});

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<Map<String, dynamic>> _savedCharacters = [];

  @override
  void initState() {
    super.initState();
    _loadCharacterState();
  }

  _saveCharacterState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> characterList = widget.unboxedCharacters.map((character) => jsonEncode(character)).toList();
    prefs.setStringList('unboxedCharacters', characterList);
  }

  _loadCharacterState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? characterList = prefs.getStringList('unboxedCharacters');
    if (characterList != null) {
      setState(() {
        _savedCharacters = characterList.map((character) => jsonDecode(character)).toList().cast<Map<String, dynamic>>();
      });
    }
  }

  _clearCharacterState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('unboxedCharacters');
    setState(() {
      _savedCharacters.clear();
      widget.unboxedCharacters.clear();
    });
  }

  void _showZoomableImage(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: InteractiveViewer(
            child: Image.asset(imagePath),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Collection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearCharacterState,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _savedCharacters.length,
        itemBuilder: (context, index) {
          final character = _savedCharacters[index];
          return GestureDetector(
            onTap: () => _showZoomableImage(character['image']),
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset(
                    character['image'],
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(character['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }
}