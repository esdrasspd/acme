import 'package:encuesta/models/field.dart';
import 'package:encuesta/models/response.dart';
import 'package:encuesta/models/survey.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<List<Survey>> getSurveys() async {
    QuerySnapshot querySnapshot = await db.collection('survey').get();
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Survey(
        id: doc.id,
        name: data['name'],
        description: data['description'],
        link: data['link'],
        code: data['code'],
        fields: (data['fields'] as List).map((field) {
          return Field(
            name: field['name'],
            title: field['title'],
            isRequired: field['isRequired'],
            type: field['type'],
          );
        }).toList(),
      );
    }).toList();
  }

  Future<void> createSurvey(Survey survey) async {
    try {
      await db.collection('survey').add({
        'name': survey.name,
        'description': survey.description,
        'link': survey.link,
        'code': survey.code,
        'fields': survey.fields.map((field) {
          return {
            'name': field.name,
            'title': field.title,
            'isRequired': field.isRequired,
            'type': field.type,
          };
        }).toList(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateSurvey(Survey survey) async {
    try {
      print(survey.id);
      print(survey.name);
      print(survey.description);
      print(survey.fields);
      await db.collection('survey').doc(survey.id).update({
        'name': survey.name,
        'description': survey.description,
        'fields': survey.fields.map((field) {
          return {
            'name': field.name,
            'title': field.title,
            'isRequired': field.isRequired,
            'type': field.type,
          };
        }).toList(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteSurvey(Survey survey) async {
    try {
      print(survey.id);
      await db.collection('survey').doc(survey.id).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveResponses(Response response) async {
    try {
      await db.collection('responses').add({
        'surveyCode': response.surveyCode,
        'answers': response.answers.map((answer) {
          return {
            'fieldName': answer.fieldName,
            'value': answer.value,
          };
        }).toList(),
      });
    } catch (e) {
      print(e);
    }
  }
}
