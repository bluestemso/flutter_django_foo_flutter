import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../functions/parse_pokemon.dart';
import '../functions/get_image_url.dart';
import '../models/pokemon_model.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final Dio dio = Dio();

  Future<Map<String, dynamic>> postRequest(String number) async {
    final response = await dio.post(
      'http://127.0.0.1:9000/pokedex/api/',
      data: {'number': number},
      options: Options(
        headers: {'contentType': 'application/json'},
      ),
    );
    return response.data;
  }

  TextEditingController field = TextEditingController();

  String pokemonNumber = "1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: postRequest(pokemonNumber),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data!;
            Pokemon pokemon = parsePokemon(data['pokemon'], pokemonNumber);
            String imagePath = getImageUrl(pokemon.type);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pokemon.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 200,
                  child: Image.asset(imagePath),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    pokemonNumber = (Random().nextInt(151) + 1).toString();
                    await postRequest(pokemonNumber);
                    setState(() {});
                  },
                  child: const Text('Randomize'),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: field,
                    decoration: InputDecoration(
                      hintText: "Enter number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 1),
                      ),
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () async {
                    pokemonNumber = field.text;
                    await postRequest(pokemonNumber);
                    setState(() {});
                  },
                  child: const Text('Search'),
                )
              ],
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
