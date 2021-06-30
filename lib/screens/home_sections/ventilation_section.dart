import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VentilationSection extends StatelessWidget {
  final DatabaseReference ventilationRef;

  const VentilationSection(this.ventilationRef);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildSensorsSection(context),
            buildControllersSection(context)
          ],
        ),
      ),
    );
  }

  Widget buildSensorsSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildTempSensor(),
        buildHumiditySensor(),
        buildAirQualitySensor(),
      ],
    );
  }

  Widget buildTempSensor() {
    return StreamBuilder<Event>(
        stream: ventilationRef.child("temperature").onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading...");
          final temp = double.parse(snapshot.data.snapshot.value as String);
          return Row(
            children: [
              Image.asset(
                "images/thermometer.png",
                width: 24,
              ),
              Text(
                "$temp °C",
                style: TextStyle(
                  color: decideTempColor(temp),
                ),
              )
            ],
          );
        });
  }

  Color decideTempColor(double temp) {
    if (temp < 22) return Colors.blue;

    if (temp < 30) return Colors.green;

    if (temp < 35) return Colors.orange;

    return Colors.red;
  }

  Widget buildHumiditySensor() {
    return StreamBuilder<Event>(
        stream: ventilationRef.child("humidity").onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading...");
          final humidity = double.parse(snapshot.data.snapshot.value as String) * 100;
          return Row(
            children: [
              Image.asset(
                "images/humidity.png",
                width: 24,
              ),
              SizedBox(
                width: 4,
              ),
              Text("$humidity %")
            ],
          );
        });
  }

  Widget buildAirQualitySensor() {
    return StreamBuilder<Event>(
        stream: ventilationRef.child("air_quality").onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading...");
          final airQuality = double.parse(snapshot.data.snapshot.value as String) * 100;
          return Row(
            children: [
              Image.asset(
                "images/air.png",
                width: 24,
              ),
              SizedBox(
                width: 4,
              ),
              Text("$airQuality %")
            ],
          );
        });
  }

  Widget buildControllersSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildFan1Controller(),
        buildFan2Controller(),
      ],
    );
  }

  Widget buildFan1Controller() {
    final fanRef = ventilationRef.child("is_fan1_on");
    return StreamBuilder<Event>(
        stream: fanRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading...");
          final isFanOn = (snapshot.data.snapshot.value as bool);
          return Column(
            children: [
              Switch(
                value: isFanOn,
                onChanged: (isOn) async {
                  await fanRef.set(isOn);
                },
              ),
              Text("Fan1"),
            ],
          );
        });
  }

  Widget buildFan2Controller() {
    final fanRef = ventilationRef.child("is_fan2_on");
    return StreamBuilder<Event>(
        stream: fanRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading...");
          final isFanOn = (snapshot.data.snapshot.value as bool);
          return Column(
            children: [
              Switch(
                value: isFanOn,
                onChanged: (isOn) async {
                  await fanRef.set(isOn);
                },
              ),
              Text("Fan2"),
            ],
          );
        });
  }
}
