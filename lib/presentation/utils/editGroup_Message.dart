import 'package:flutter/material.dart';

import '../../core/routes/app_Routes.dart';

class EditgroupMessage extends StatelessWidget {
  const EditgroupMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final int groupId = ModalRoute.of(context)!.settings.arguments as int;

    return Dialog(
      child: SizedBox(
        height: 150,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('Você tem certeza que deseja editar este grupo?'),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.editgroupScreen,
                        arguments: groupId,
                      );
                    },
                    child: Text('Sim'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
