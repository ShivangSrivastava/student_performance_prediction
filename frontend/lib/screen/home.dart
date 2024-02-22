import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/widget/slider.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numberOfCourse = 0;
  double time = 0;
  double marks = 0;

  TextEditingController hourController = TextEditingController(text: "0");
  TextEditingController minuteController = TextEditingController(text: "0");
  TextEditingController secondController = TextEditingController(text: "0");
  calculateTime() {
    int hrs = int.parse(hourController.text);
    int mint = int.parse(minuteController.text);
    int sec = int.parse(secondController.text);
    time = hrs + (mint / 60) + (sec / 3600);
    setState(() {});
  }

  predictMarks() async {
    calculateTime();
    http.Response response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/perfomance"),
      headers: {"Content-Type": "application/json"},
      body: '{"number_of_courses": $numberOfCourse,"time_study": $time}',
    );
    if (response.statusCode == 200) {
      marks = jsonDecode(response.body)['marks'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MarksForecast"),
      ),
      body: Stack(
        alignment: const Alignment(0, -1),
        children: [
          Positioned(
            top: 20,
            child: Text(
              "$marks",
              textScaler: const TextScaler.linear(3),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MySlider(
                value: numberOfCourse,
                label: "Number of courses",
                range: const [0, 10, 10],
                onChanged: (value) {
                  numberOfCourse = value.toInt();
                  setState(() {});
                },
                unit: "Courses",
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Study time (in hr/day)",
                      textScaler: TextScaler.linear(1.35),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: hourController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: "Hours", suffixText: "hrs"),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2)
                            ],
                            onChanged: (value) {
                              if (double.parse(value) > 23) {
                                hourController.value = TextEditingValue(
                                    text: hourController.text.split("").first);
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: minuteController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: "Minutes", suffixText: "min"),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2)
                            ],
                            onChanged: (value) {
                              if (double.parse(value) > 59) {
                                minuteController.value = TextEditingValue(
                                    text:
                                        minuteController.text.split("").first);
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: secondController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: "Seconds", suffixText: "sec"),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2)
                            ],
                            onChanged: (value) {
                              if (double.parse(value) > 59) {
                                secondController.value = TextEditingValue(
                                    text:
                                        secondController.text.split("").first);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    predictMarks();
                  },
                  child: const Text("Forecast"))
            ],
          ),
        ],
      ),
    );
  }
}
