import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:live_coding/services/get_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Live coding'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GetImageService getImageService = GetImageService();

  Future<void> getUrlImage() async {
    setState(() {
      isLoading = true;
    });
    try {
      final randomIndex = Random().nextInt(nouns.length);
      String newPrompt = nouns[randomIndex];
      final url = await getImageService.getImage(newPrompt);
      setState(() {
        items.add((url: url, prompt: newPrompt));
        index++;
        left--;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void previous() {
    setState(() {
      index--;
    });
  }

  void next() {
    if (left > 0) {
      getUrlImage();
    } else {
      setState(() {
        index++;
      });
    }
  }

  String? promptValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  bool isLoading = false;
  int index = -1;
  int left = 5;
  Map<String, String> images = {};
  List<({String url, String prompt})> items = [];

  bool get canGetCurrentItem => index != -1 && index < items.length;

  bool get canNext => (left > 0 || index < items.length - 1) && !isLoading;

  bool get canPrevious => index > 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const SizedBox(
                  height: 300,
                  width: 300,
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (canGetCurrentItem && !isLoading)
                Image.network(
                  height: 300,
                  width: 300,
                  items[index].url,
                ),
              if (!canGetCurrentItem && !isLoading)
                const SizedBox(
                  height: 300,
                  width: 300,
                  child: Center(child: Text('No image')),
                ),
              const SizedBox(height: 30),
              Text(
                canGetCurrentItem ? items[index].prompt : 'No prompt',
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: canPrevious ? previous : null,
                    child: const Text('Prev'),
                  ),
                  ElevatedButton(
                    onPressed: canNext ? next : null,
                    child: const Text('Next'),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Left: $left',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
