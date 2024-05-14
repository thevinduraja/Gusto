import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:gusto/pages/recipeGeneration/recipe_detail_page.dart';
import 'package:http/http.dart' as http;

import '../models/content_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<ContentModel> content = [];
  bool _isLoading = true;

  Future<void> getRecipes() async {
    try {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:8001/topRecipes'));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as List<dynamic>;
        content = jsonData.map((item) {
          return ContentModel(
            title: item['title'],
            image_name: item['image_name'],
          );
        }).toList();
        setState(() {});
      } else {
        print('Failed to load recipe data: ${response.statusCode} ${response
            .reasonPhrase}');
      }
    } catch (e) {
      print('Failed to load recipe data: $e');
    }
  }

  Future<String> _getImage(String imageName) async {
    // if (kDebugMode) {
    //   print('$imageName.jpg');
    // }
    final ref = _storage.ref().child('$imageName.jpg');
    return await ref.getDownloadURL().catchError((error) {
      if (kDebugMode) {
        print('Error getting download URL: $error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getRecipes();
    return Scaffold(
        backgroundColor: const Color(0xFFFFE9C8),
        body: Column(
          children: [
          const SizedBox(
          height: 60,
        ),
        const Center(
            child: Text("Trending Recipes",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),)
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          height: 350,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
            ),
            itemCount: content.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Scaffold(
                            appBar: AppBar(
                              title: const Text("Recipe Details"),
                            ),
                            body: RecipeDetailPage(
                              title: content[index].title,
                            ),
                          ),
                    ),
                  );
                },
                child: GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black45,
                    title: Text(
                      content[index].title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  child: FutureBuilder(
                    future: _getImage(content[index].image_name),
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final imageUrl = snapshot.data;
                          if (imageUrl != null) {
                            return Center(
                              child: Image.network(imageUrl),
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
              );
            },
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        const Center(
            child: Text("Favourite Recipes",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),)
        ),
        _isLoading
        ? const Padding(padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),child: Text("Your favourite recipes will be displayed here."))
        : const Text("data")
    ],
    )
    ,
    );
  }
}
