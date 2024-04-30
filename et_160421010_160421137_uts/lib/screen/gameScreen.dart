import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> images = [
    "assets/images/image1.jpeg",
    "assets/images/image2.jpeg",
    "assets/images/image3.jpeg",
    "assets/images/image4.jpeg",
    "assets/images/image5.jpeg",
    
  ];

  late List<String> correctImages;
  late List<String> options;
  late int currentIndex;
  late bool showImages;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startGame() {
    currentIndex = 0;
    showImages = true;
    correctImages = [];
    options = [];
    timer = Timer(Duration(seconds: 3), () {
      setState(() {
        showImages = false;
        loadNextQuestion();
      });
    });
  }

  void loadNextQuestion() {
    if (currentIndex < images.length) {
      correctImages.add(images[currentIndex]);
      options = generateOptions(correctImages.last);
      startTimer();
    } else {
      // Navigate to Result Screen
      Navigator.pushReplacementNamed(context, '/result');
    }
  }

  void startTimer() {
    timer = Timer(Duration(seconds: 30), () {
      setState(() {
        currentIndex++;
        loadNextQuestion();
      });
    });
  }

 List<String> generateOptions(String correctImage) {
  List<String> tempOptions = [correctImage];
  Random random = Random();
  while (tempOptions.length < 4) {
    int randomIndex = random.nextInt(images.length);
    String randomImage = images[randomIndex];
    if (!tempOptions.contains(randomImage)) {
      tempOptions.add(randomImage);
    }
  }
  tempOptions.shuffle();
  return tempOptions;
}

  Widget buildGameUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        showImages
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  images.length,
                  (index) => Image.asset(
                    images[index],
                    height: 100,
                    width: 100,
                  ),
                ),
              )
            : SizedBox(height: 100), // Placeholder for images
        SizedBox(height: 20),
        Column(
          children: List.generate(
            options.length,
            (index) => ElevatedButton(
              onPressed: () {
                if (options[index] == correctImages.last) {
                  // Correct answer
                  timer.cancel();
                  setState(() {
                    currentIndex++;
                    loadNextQuestion();
                  });
                } else {
                  // Wrong answer
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Wrong answer!")),
                  );
                }
              },
              child: Image.asset(
                options[index],
                height: 100,
                width: 100,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Screen"),
      ),
      body: currentIndex < images.length ? buildGameUI() : Container(),
    );
  }
}
