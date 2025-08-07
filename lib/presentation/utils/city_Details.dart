import 'package:flutter/material.dart';
import 'package:projeto_final_academy/domain/entities/city.dart';
import 'package:projeto_final_academy/presentation/states/city_State.dart';
import 'package:provider/provider.dart';

class CityDetails extends StatelessWidget {
  final City city;
  final int groupId;
  CityDetails({super.key, required this.city, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CityState>(context, listen: false);
    return Container(
      child: Wrap(
        children: [
          city.photo.isNotEmpty
              ? Image.network(
            city.photo,
            height: 250,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          )
              : Image.asset(
            'assets/naoDisponivel.jpg',
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
              child: ElevatedButton(onPressed: () async {
                await state.insert(groupId);
                Navigator.pop(context);
              }, child: Text('Adicionar Destino')),
            ),
          )
        ],
      ),
    );
  }
}
