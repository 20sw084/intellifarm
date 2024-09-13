import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intellifarm/models/land.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class getUserData {
  Future<User> getUser() async {
    final usersRef = FirebaseFirestore.instance
        .collection(
          "users",
        )
        .doc(
          (await SharedPreferences.getInstance()).getString(
            "userId",
          ),
        );
    final userLand = await usersRef.collection("land").get();

    final land = userLand.docs.map((doc) {
      return Land(
        surveyNo: doc['SurveyNum'],
        area: doc['area'],
      );
    }).toList();

    final userData = await usersRef.get();

    return User(
      email: userData['email'],
      phone: userData['phonenum'],
      password: userData['password'],
      land: land,
    );
  }

  Future<List<DocumentSnapshot>> getLands() async {
    print('${(await SharedPreferences.getInstance()).getString("userId")} - klsdhgjkdhgf');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(
          "users",
        )
        .doc(
          (await SharedPreferences.getInstance()).getString(
            "userId",
          ),
        )
        .collection(
          "land",
        )
        .get().whenComplete(() async => print('${(await SharedPreferences.getInstance()).getString("userId")} - sdhgjkdhgf'));
    return querySnapshot.docs;
  }
}
