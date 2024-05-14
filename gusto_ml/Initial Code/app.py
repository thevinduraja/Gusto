import pandas as pd
import numpy as np
import json
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from flask import Flask, request, jsonify

# Load the dataset
dataset = pd.read_csv('Gusto Dataset - Cleaned.csv')

# Preprocess the dataset
dataset["text"] = dataset["Title"] + " " + dataset["Instructions"] + " " + dataset["Cleaned_Ingredients"]

# Vectorize the text column using TF-IDF vectorizer
vectorizer = TfidfVectorizer(stop_words="english")
x = vectorizer.fit_transform(dataset['text'].apply(lambda x: np.str_(x)))

# Create a Flask app
app = Flask(__name__)


# Define an endpoint for recipe search
@app.route('/recipes', methods=['POST'])
def search_recipes():
    # Get user input from the request body in JSON format
    user_input = request.get_json()
    if user_input is None or "ingredients" not in user_input:
        return jsonify({"error": "Invalid input. Please provide a JSON object with 'ingredients' array."}), 400
    
    # Vectorize the user input
    user_input_text = " ".join(user_input["ingredients"]).lower()
    user_input_matrix = vectorizer.transform([user_input_text])
    
    # Calculate cosine similarity between user input and all recipes in the dataset
    similarity_scores = cosine_similarity(user_input_matrix, x).flatten()
    
    # Get the indices of top 50 most similar recipes
    top_indices = np.argsort(similarity_scores)[-50:][::-1]
    
    # Generate recipe output in JSON format
    recipe_output = []
    for index in top_indices:
        recipe = {}
        recipe["title"] = dataset.loc[index, "Title"]
        recipe['ingredients'] = dataset.loc[index, 'Cleaned_Ingredients'].split(',')
        recipe['instructions'] = dataset.loc[index, 'Instructions'].split('.')
        recipe['image_name'] = dataset.loc[index, 'Image_Name']
        recipe_output.append(recipe)
    
    # Return recipe output in JSON format
    return jsonify(recipe_output)


# Define an endpoint for getting a specific recipe by title
@app.route('/getRecipe/<string:title>', methods=['GET'])
def get_recipe(title):
    # Find the index of the recipe with the given title
    try:
        index = dataset.index[dataset['Title'] == title].tolist()[0]
    except:
        return jsonify({"error": f"No recipe found with title '{title}'."}), 404
    
    # Generate recipe output in JSON format
    recipe = {}
    recipe["title"] = dataset.loc[index, "Title"]
    recipe['ingredients'] = dataset.loc[index, 'Cleaned_Ingredients'].split(',')
    recipe['instructions'] = dataset.loc[index, 'Instructions'].split('.')
    recipe['image_name'] = dataset.loc[index, 'Image_Name']
    
    # Return recipe output in JSON format
    return jsonify(recipe)


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8001, debug=True)
