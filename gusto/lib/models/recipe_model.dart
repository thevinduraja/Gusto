class RecipeModel {
  final String title;
  final String ingredients;
  final String instructions;
  final String image_name;

  RecipeModel({required this.title, required this.ingredients, required this.instructions, required this.image_name});

  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson) {
    return RecipeModel(
        title: parsedJson["title"],
        ingredients: parsedJson["ingredients"],
        instructions: parsedJson["instructions"],
        image_name: parsedJson["image_name"]);
  }
}