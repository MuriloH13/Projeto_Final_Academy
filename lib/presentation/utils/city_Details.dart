import 'package:flutter/material.dart';
import 'package:projeto_final_academy/domain/entities/city.dart';

class CityDetails extends StatelessWidget {
  City city;
  CityDetails({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          Image.network(
            city.photo,
            height: 250,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(top: 24, left: 24),
            child: Text(city.name),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 60, left: 24),
            child: Text(city.address),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(onPressed: () {}, child: Text('Adicionar Destino')),
            ),
          )
        ],
      ),
    );
  }
}
