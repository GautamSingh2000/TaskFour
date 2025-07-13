import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:word_generator/word_generator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? imageUrl;
  String randomName = '';

  final wordGenerator = WordGenerator();

  @override
  void initState() {
    super.initState();
    fetchDogImage();
    generateRandomName();
  }

  void generateRandomName() {
    setState(() {
      randomName = wordGenerator.randomName();
    });
  }

  Future<void> fetchDogImage() async {
    final response =
    await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        imageUrl = data['message'];
      });
    } else {
      throw Exception('Failed to load dog image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageUrl == null
                ? Container(
                height:300,
                width: 300,
                child: const CircularProgressIndicator())
                : Image.network(imageUrl!,
                height: 300,
                fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(
              randomName,
              style: const TextStyle(
                decoration: TextDecoration.none,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: GestureDetector(
                onTap: () {
                  imageUrl = null;
                  fetchDogImage();
                  generateRandomName();
                },
                child: const Text(
                  "Click me!",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
