import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulate loading data with a delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RecipeListScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.orange, // Choose your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your splash screen content here
            Text(
              'Recipe App',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'FontMain'
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Or any other loading indicator
          ],
        ),
      ),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Recipe> recipes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRecipes(''); // Default search query
  }

  Future<void> fetchRecipes(String query) async {
    final String apiKey = '1'; // Replace with your API key
    final String url = 'https://www.themealdb.com/api/json/v1/$apiKey/search.php?s=$query';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> meals = data['meals'];

        setState(() {
          recipes = meals.map((meal) => Recipe.fromJson(meal)).toList();
        });
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error, show message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'What do you like to cook today?',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, fontFamily: 'FontMain'),
          ),
        ),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              fetchRecipes(searchController.text);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/backimg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Enter a recipe name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                          },
                        ),
                      ),
                      onSubmitted: (value) {
                        fetchRecipes(value);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Today's Special Dishes...",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, fontFamily: 'FontMain', color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: recipes.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 65,
                    child: ListTile(
                      leading: ClipOval(
                          child: Image.network(
                            recipes[index].strMealThumb,
                            fit: BoxFit.fill,
                            height: 65,
                            width: 65,
                          )),
                      title: Text(
                        recipes[index].strMeal,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(recipe: recipes[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Recipe {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strInstructions;
  final List<String> ingredients;
  final List<String> measures;

  Recipe({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strInstructions,
    required this.ingredients,
    required this.measures,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      if (json['strIngredient$i'] != null && json['strIngredient$i'].isNotEmpty) {
        ingredients.add(json['strIngredient$i']);
        measures.add(json['strMeasure$i']);
      }
    }

    return Recipe(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
      strInstructions: json['strInstructions'],
      ingredients: ingredients,
      measures: measures,
    );
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(recipe.strMeal, style: TextStyle(fontFamily: 'FontMain', fontSize: 34,fontWeight: FontWeight.w700),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: ClipOval(
                child: Image.network(
                  recipe.strMealThumb,
                  fit: BoxFit.fill,
                  height: 400,
                  width: 500,
                ))),
            SizedBox(height: 16.0),
            Center(child: Text(recipe.strMeal, style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold, fontFamily: 'FontMain',color: Colors.red))),
            SizedBox(height: 20.0),
            Text('Ingredients:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            for (int i = 0; i < recipe.ingredients.length; i++)
              Text('${recipe.measures[i]} ${recipe.ingredients[i]}', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 20.0),
            Text('Instructions:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            Text(recipe.strInstructions, style: TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}

