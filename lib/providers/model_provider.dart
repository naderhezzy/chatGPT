import 'package:flutter/material.dart';

import 'package:ai_bot/models/ai_model.dart';
import 'package:ai_bot/services/api_service.dart';

class ModelsProvider extends ChangeNotifier {
  List<AiModel> modelsList = [];
  String currentModel = "gpt-3.5-turbo";

  List<AiModel> get getModelsList => modelsList;

  String get getCurrentModel => currentModel;

  void setCurrentModel(String model) {
    currentModel = model;
    notifyListeners();
  }

  Future<List<AiModel>> getAvailableModels() async {
    final List fetchedModels = await ApiService.getModels();
    return AiModel.modelsFromSnapshot(fetchedModels);
  }
}
