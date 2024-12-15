import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notabox/loading_widget.dart';
import 'package:notabox/models/task_model.dart';
import 'package:notabox/models/user_model.dart';
import 'package:notabox/tabs/tasks/tasks_provider.dart';
import 'package:provider/provider.dart';

class FirebaseFuncations {
  static CollectionReference<TaskModel> getTasksCollection(String userId) =>
      getUserCollection()
          .doc(userId)
          .collection('tasks')
          .withConverter<TaskModel>(
            fromFirestore: (docSnapshot, _) =>
                TaskModel.fromJson(docSnapshot.data()!),
            toFirestore: (taskModel, _) => taskModel.toJson(),
          );

  static CollectionReference<UserModel> getUserCollection() =>
      FirebaseFirestore.instance.collection('users').withConverter<UserModel>(
            fromFirestore: (docSnapshot, _) =>
                UserModel.fromJson(docSnapshot.data()!),
            toFirestore: (userModel, _) => userModel.toJson(),
          );

  static Future<void> showLoadingDialog(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const LoadingWidget(),
      );
    });
  }

  static Future<void> closeLoadingDialog(BuildContext context) async {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  static Future<void> addTaskFirestore(
      TaskModel task, String userId, BuildContext context) async {
    await showLoadingDialog(context);
    try {
      CollectionReference<TaskModel> tasksCollection =
          getTasksCollection(userId);
      DocumentReference<TaskModel> docRef = tasksCollection.doc();

      // إضافة بيانات الـ Task
      task.id = docRef.id;
      task.dateAdded = DateTime.now();
      await docRef.set(task);

      // تحديث قائمة المهام في TasksProvider
      Provider.of<TasksProvider>(context, listen: false).addTask(task);
    } finally {
      closeLoadingDialog(context);
    }
  }

  static Future<List<TaskModel>> getAllTasksFromFirestore(
      String userId, BuildContext context) async {
    await showLoadingDialog(context);
    try {
      CollectionReference<TaskModel> tasksCollection =
          getTasksCollection(userId);
      QuerySnapshot<TaskModel> querySnapshot =
          await tasksCollection.orderBy('dateAdded', descending: true).get();
      return querySnapshot.docs
          .map((docSnapshot) => docSnapshot.data())
          .toList();
    } finally {
      closeLoadingDialog(context);
    }
  }

  static Future<void> deleteTaskFirestore(
      String taskId, String userId, BuildContext context) async {
    await showLoadingDialog(context);
    try {
      CollectionReference<TaskModel> tasksCollection =
          getTasksCollection(userId);
      await tasksCollection.doc(taskId).delete();
    } finally {
      closeLoadingDialog(context);
    }
  }

  static Future<void> updateTaskFirestore(
      TaskModel task, String userId, BuildContext context) async {
    await showLoadingDialog(context);
    try {
      CollectionReference<TaskModel> tasksCollection =
          getTasksCollection(userId);
      await tasksCollection.doc(task.id).set(task);
    } finally {
      closeLoadingDialog(context);
    }
  }

  static Future<void> updateTaskStatus(
      String taskId, String userId, bool isDone, BuildContext context) async {
    await showLoadingDialog(context);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(taskId)
          .update({'isDone': isDone});
    } finally {
      closeLoadingDialog(context);
    }
  }

  static Future<void> logout(BuildContext context) async {
    await showLoadingDialog(context);
    try {
      await FirebaseAuth.instance.signOut();
    } finally {
      closeLoadingDialog(context);
    }
  }

  static Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    await showLoadingDialog(context);
    try {
      final credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user =
          UserModel(id: credentials.user!.uid, email: email, name: name);
      final userCollection = getUserCollection();
      await userCollection.doc(user.id).set(user);
      return user;
    } finally {
      closeLoadingDialog(context);
    }
  }

  static Future<UserModel> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    await showLoadingDialog(context);
    try {
      final credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final userCollection = getUserCollection();
      final docSnapshot = await userCollection.doc(credentials.user!.uid).get();
      return docSnapshot.data()!;
    } finally {
      closeLoadingDialog(context);
    }
  }
}
