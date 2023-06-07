class AiModel {
  String? id;
  String? object;
  int? created;
  String? ownedBy;
  String? root;
  String? parent;

  AiModel({this.id, this.object, this.created, this.ownedBy, this.root, this.parent});

  factory AiModel.fromJson(Map<String, dynamic> json) => AiModel(
        id: json['id'],
        object: json['object'],
        created: json['created'],
        ownedBy: json['owned_by'],
        root: json['root'],
        parent: json['parent'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    data['created'] = created;
    data['owned_by'] = ownedBy;
    data['root'] = root;
    data['parent'] = parent;
    return data;
  }

  static List<AiModel> modelsFromSnapshot(List modelsSnapshot) =>
      modelsSnapshot.map((model) => AiModel.fromJson(model)).toList();
}
