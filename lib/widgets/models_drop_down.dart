import 'package:ai_bot/constants/constants.dart';
import 'package:ai_bot/providers/model_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModelsDropDownWidget extends StatefulWidget {
  const ModelsDropDownWidget({super.key});

  @override
  State<ModelsDropDownWidget> createState() => _ModelsDropDownWidgetState();
}

class _ModelsDropDownWidgetState extends State<ModelsDropDownWidget> {
  late ModelsProvider _modelsProvider;
  String? _currentModel;

  @override
  void initState() {
    _modelsProvider = context.read<ModelsProvider>();
    _currentModel = _modelsProvider.getCurrentModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _modelsProvider.getAvailableModels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (snapshot.data == null) {
          return const CircularProgressIndicator(
            color: Colors.greenAccent,
            strokeWidth: 3,
          );
        }

        if (snapshot.data != null) {
          return DropdownButton(
            value: _currentModel,
            items: snapshot.data!
                .map(
                  (model) => DropdownMenuItem(
                    value: model.id!,
                    alignment: AlignmentDirectional.center,
                    child: Text(model.id!),
                  ),
                )
                .toList(),
            iconEnabledColor: Colors.white,
            dropdownColor: scaffoldBackgroundColor,
            onChanged: (value) {
              setState(() => _currentModel = value as String);
              _modelsProvider.setCurrentModel(value!);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
