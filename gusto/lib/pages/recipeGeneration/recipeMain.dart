// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gusto/pages/recipeGeneration/recipe_generation.dart';

class RecipeMain extends StatefulWidget {
  const RecipeMain({super.key});

  @override
  _RecipeMainState createState() => _RecipeMainState();
}

class _RecipeMainState extends State<RecipeMain> {
  int _numberOfFields = 1;
  final List<String> _inputValues = [];

  @override
  void initState() {
    super.initState();
    // Initialize _inputValues with an element for each text field
    _inputValues.addAll(List.generate(_numberOfFields, (_) => ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE9C8),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text('Select the number of ingredients:', textScaleFactor: 1.2,),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.fromLTRB(100.0, 0.0, 100.0, 0),
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButton<int>(
                  value: _numberOfFields,
                  items: List.generate(5, (index) => index + 1)
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Center(
                        child: Text(value.toString()),
                      ),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      _numberOfFields = value ?? 1;
                      // If the number of text fields increased, add new elements to _inputValues
                      while (_inputValues.length < _numberOfFields) {
                        _inputValues.add('');
                      }
                      // If the number of text fields decreased, remove elements from _inputValues
                      while (_inputValues.length > _numberOfFields) {
                        _inputValues.removeLast();
                      }
                    });
                  },
                  isExpanded: true,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _numberOfFields,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Ingredient ${index + 1}',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onChanged: (value) {
                        _inputValues[index] = value;
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  bool hasEmptyField =
                      _inputValues.any((element) => element.isEmpty);
                  if (hasEmptyField) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                  } else {
                    for (final item in _inputValues) {
                      if (kDebugMode) {
                        print(item);
                      }
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: const Text('Generated Recipes'),
                          ),
                          body: RecipeGeneration(_inputValues),
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Generate Recipes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
