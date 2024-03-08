// class HaNoiData {
//   List<Data>? data;

//   HaNoiData({this.data});

//   HaNoiData.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(Data.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Data {
//   String? level1Id;
//   String? name;
//   String? type;
//   List<Level2s>? level2s;

//   Data({this.level1Id, this.name, this.type, this.level2s});

//   Data.fromJson(Map<String, dynamic> json) {
//     level1Id = json['level1_id'];
//     name = json['name'];
//     type = json['type'];
//     if (json['level2s'] != null) {
//       level2s = <Level2s>[];
//       json['level2s'].forEach((v) {
//         level2s!.add(Level2s.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['level1_id'] = level1Id;
//     data['name'] = name;
//     data['type'] = type;
//     if (level2s != null) {
//       data['level2s'] = level2s!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Level2s {
//   String? level2Id;
//   String? name;
//   String? type;
//   List<Level3s>? level3s;

//   Level2s({this.level2Id, this.name, this.type, this.level3s});

//   Level2s.fromJson(Map<String, dynamic> json) {
//     level2Id = json['level2_id'];
//     name = json['name'];
//     type = json['type'];
//     if (json['level3s'] != null) {
//       level3s = <Level3s>[];
//       json['level3s'].forEach((v) {
//         level3s!.add(Level3s.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['level2_id'] = level2Id;
//     data['name'] = name;
//     data['type'] = type;
//     if (level3s != null) {
//       data['level3s'] = level3s!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Level3s {
//   String? level3Id;
//   String? name;
//   String? type;

//   Level3s({this.level3Id, this.name, this.type});

//   Level3s.fromJson(Map<String, dynamic> json) {
//     level3Id = json['level3_id'];
//     name = json['name'];
//     type = json['type'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['level3_id'] = level3Id;
//     data['name'] = name;
//     data['type'] = type;
//     return data;
//   }
// }
