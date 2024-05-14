import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipeDetailPage extends StatefulWidget {
  final String title;

  const RecipeDetailPage({Key? key, required this.title}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late Map<String, dynamic> _recipeData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecipeData();
  }

  void _fetchRecipeData() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8001/getRecipe/${widget.title}'));
    if (response.statusCode == 200) {
      setState(() {
        _recipeData = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load recipe data');
    }
  }

  Future<String> _getImage(String imageName) async {
    //print('$imageName.jpg');
    final ref = _storage.ref().child('$imageName.jpg');
    return await ref.getDownloadURL().catchError((error) {
      if (kDebugMode) {
        print('Error getting download URL: $error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE9C8),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
              child: Text(
                '${_recipeData['title']}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              child: FutureBuilder(
                future: _getImage(_recipeData['image_name']),
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final imageUrl = snapshot.data;
                      if (imageUrl != null) {
                        return Center(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 250,
                          ),
                        );
                      } else {
                        return const Text('Image not found');
                      }
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
              child: const Text(
                'Ingredients',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
            for (final ingredient in _recipeData['ingredients'])
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                child: Text(
                  ingredient,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            Container(
              padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 5.0),
              child: const Text(
                'Instructions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
            for (int i = 0; i < _recipeData['instructions'].length; i++)
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${_recipeData['instructions'][i]}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
