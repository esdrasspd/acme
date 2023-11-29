import 'package:encuesta/models/survey.dart';
import 'package:encuesta/screens/detail_survey_screen.dart';
import 'package:encuesta/widgets/dialog_delet_survey.dart';
import 'package:flutter/material.dart';
import 'package:encuesta/services/firebase_services.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encuestas'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: FirebaseServices().getSurveys(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: ((context, index) {
                Survey survey = snapshot.data![index];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 8, right: 20, bottom: 0),
                        child: Text(
                          'Encuesta ${index + 1}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(survey.name),
                        subtitle: Text(survey.description),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(survey);
                          },
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailSurveyScreen(survey: survey)),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addSurvey');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Survey survey) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogDeletSurvey(survey: survey);
        });
  }
}
