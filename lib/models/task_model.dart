import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String id;
  String title;
  String decerption;
  DateTime date;
  bool isDone;
  DateTime dateAdded;

  TaskModel(
      {this.id = '',
      required this.title,
      required this.decerption,
      required this.date,
      this.isDone = false,
      required this.dateAdded // تعيين الحالة الافتراضية على أنها غير مكتملة
      });

  TaskModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          title: json['title'],
          decerption: json['decerption'],
          date: (json['date'] as Timestamp).toDate(),
          isDone: json['isDone'] ?? false,
          dateAdded: DateTime.parse(json['dateAdded']), // استرجاع حالة المهمة
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'decerption': decerption,
        'date': Timestamp.fromDate(date),
        'isDone': isDone,
        'dateAdded': dateAdded.toIso8601String() // تضمين الحالة في JSON
      };
}
