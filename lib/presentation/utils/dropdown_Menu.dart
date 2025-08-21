import 'package:flutter/material.dart';
import 'package:projeto_final_academy/presentation/utils/translation_Util.dart';

class DynamicDropdownButton extends StatelessWidget {
  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;

  const DynamicDropdownButton({
    Key? key,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      value: items.contains(value) ? value : items.first,
      icon: const Icon(Icons.arrow_downward),
      onChanged: onChanged,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            TranslationUtil.translateDropDownMenu(context, item),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}