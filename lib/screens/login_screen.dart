import 'package:encuesta/models/survey.dart';
import 'package:encuesta/screens/fill_survey_screen.dart';
import 'package:encuesta/screens/home_screen.dart';
import 'package:encuesta/screens/register_screen.dart';
import 'package:encuesta/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseServices _auth = FirebaseServices();
  List<Survey>? surveys;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSurveys();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Iniciar sesión en Acme',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              _login();
            },
            child: const Text('Iniciar sesión'),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()));
            },
            child: const Text('¿No tienes cuenta? Regístrate'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _codeController,
            decoration:
                const InputDecoration(labelText: 'Código de la encuesta '),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              _validationCode(surveys!);
            },
            child: const Text('Ingresar a la encuesta'),
          ),
        ],
      ),
    ));
  }

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bienvenido ${user.email}'),
          ),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario o contraseña incorrectos'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingrese usuario y/o contraseña.'),
        ),
      );
    }
  }

  void _validationCode(List<Survey> surveys) {
    String code = _codeController.text.trim();
    Survey? matchingSurvey;
    print(code);
    print(surveys.length);
    // Buscar la encuesta con el código correspondiente
    if (surveys.isNotEmpty) {
      try {
        matchingSurvey = surveys.firstWhere((survey) => survey.code == code);
      } catch (e) {
        matchingSurvey = null;
      }
    }

    print(matchingSurvey);

    if (matchingSurvey != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FillSurveyScreen(survey: matchingSurvey!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código de encuesta no existe'),
        ),
      );
    }
  }

  Future<void> _getSurveys() async {
    List<Survey> fetchedSurveys = await _auth.getSurveys();
    setState(() {
      surveys = fetchedSurveys;
    });
  }
}
