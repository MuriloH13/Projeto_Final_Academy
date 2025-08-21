import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final_academy/domain/entities/stop.dart';

class StopsRepository extends ChangeNotifier {
  final List<Stop> _cities = [
    Stop(
      name: "Lince Tech",
      address: "R. Dr. Nereu Ramos, n° 750 - Coloninha, Gaspar - SC, 89110-110",
      latitude: -26.925873245325082,
        longitude: -48.96606718468556,
      departure: DateTime.now(),
      arrival: DateTime.now().add(const Duration(days: 7)),
      photo: "https://static.ndmais.com.br/2022/02/img-20201208-161658jpg-scaled.jpg",
      tripId: 0,
    ),
  ];
  get cities => _cities;
}