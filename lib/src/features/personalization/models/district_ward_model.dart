class DistrictModel {
  String? districtId;
  String? name;
  String? type;
  List<WardModel>? children;

  DistrictModel({this.districtId, this.name, this.type, this.children});

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    List<WardModel>? children;
    if (json['children'] != null) {
      children = <WardModel>[];
      json['children'].forEach((v) {
        children!.add(WardModel.fromJson(v));
      });
    }
    return DistrictModel(
        districtId: json['district_id'] ?? '',
        name: json['name'] ?? '',
        type: json['type'] ?? '',
        children: children ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['district_id'] = districtId;
    data['name'] = name;
    data['type'] = type;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WardModel {
  String? wardId;
  String? name;
  String? type;

  WardModel({this.wardId, this.name, this.type});

  factory WardModel.fromJson(Map<String, dynamic> json) {
    return WardModel(
        wardId: json['ward_id'] ?? '',
        name: json['name'] ?? '',
        type: json['type'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ward_id'] = wardId;
    data['name'] = name;
    data['type'] = type;
    return data;
  }
}
