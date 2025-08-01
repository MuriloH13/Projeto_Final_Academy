import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final_academy/domain/entities/city.dart';

class CitiesRepository extends ChangeNotifier {
  final List<City> _cities = [
    City(
      name: "Lince Tech",
      address: "R. Dr. Nereu Ramos, n° 750 - Coloninha, Gaspar - SC, 89110-110",
      photo: "https://static.ndmais.com.br/2022/02/img-20201208-161658jpg-scaled.jpg",
      latitude: -26.925873245325082,
        longitude: -48.96606718468556
    ),
  ];
  get cities => _cities;
}