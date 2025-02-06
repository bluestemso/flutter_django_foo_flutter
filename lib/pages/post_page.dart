import 'dart:math';
import 'dart:developer';

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
  final Dio dio = Dio()
    ..options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

  Future<Map<String, dynamic>> postRequest(String number) async {
    try {
      final response = await dio.post(
        'http://127.0.0.1:9000/pokedex/api/',
        data: {'number': number},
        options: Options(
          headers: {'contentType': 'application/json'},
        ),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        print('Connection error occurred: ${e.message}');
      }
      throw e;
    } catch (e) {
      throw e;
    }
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
            log.debug('Loading Pokemon data...');
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            log.warning('Error in FutureBuilder: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error loading Pokemon'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            try {
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
            } catch (e) {
              log.error('Error parsing Pokemon data: $e');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error displaying Pokemon'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
          } else {
            log.warning('No data found in snapshot');
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
