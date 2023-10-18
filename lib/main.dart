import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() {
  runApp(CrossFitApp());
}

class CrossFitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue, // Cor principal do aplicativo
      ),
      home: CrossFitList(),
    );
  }
}

class CrossFitList extends StatefulWidget {
  @override
  _CrossFitListState createState() => _CrossFitListState();
}

class _CrossFitListState extends State<CrossFitList> {
  List<CrossFitWorkout> workouts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treinos de CrossFit'),
        centerTitle: true, // Centraliza o título na barra de navegação
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2, // Sombra do cartão
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(workouts[index].date),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CrossFitDetails(workouts[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newWorkout = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CrossFitWorkoutForm()),
          );

          if (newWorkout != null) {
            setState(() {
              workouts.add(newWorkout);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CrossFitDetails extends StatelessWidget {
  final CrossFitWorkout workout;

  CrossFitDetails(this.workout);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.date),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mobilidade:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16, // Tamanho da fonte
              ),
            ),
            Text(workout.mobilidade),
            SizedBox(height: 16),
            Text(
              "Warm UP:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(workout.warmUp),
            SizedBox(height: 16),
            Text(
              "SKILL:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(workout.skill),
            SizedBox(height: 16),
            Text(
              "WOD:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(workout.wod),
          ],
        ),
      ),
    );
  }
}

class CrossFitWorkout {
  final String date;
  final String mobilidade;
  final String warmUp;
  final String skill;
  final String wod;

  CrossFitWorkout(
      this.date,
      this.mobilidade,
      this.warmUp,
      this.skill,
      this.wod,
      );
}

class CrossFitWorkoutForm extends StatefulWidget {
  @override
  _CrossFitWorkoutFormState createState() => _CrossFitWorkoutFormState();
}

class _CrossFitWorkoutFormState extends State<CrossFitWorkoutForm> {
  var maskFormatter = new MaskTextInputFormatter(
      mask: '##/##/####',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _mobilidadeController = TextEditingController();
  final _warmUpController = TextEditingController();
  final _skillController = TextEditingController();
  final _wodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Treino de CrossFit'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                inputFormatters: [maskFormatter],
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Data do treino',
                  icon: Icon(Icons.date_range), // Ícone para o campo
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mobilidadeController,
                decoration: InputDecoration(
                  labelText: 'Mobilidade',
                  icon: Icon(Icons.directions_run),
                ),
                maxLines: null,
              ),
              TextFormField(
                controller: _warmUpController,
                decoration: InputDecoration(
                  labelText: 'Warm UP',
                  icon: Icon(Icons.directions_run),
                ),
                maxLines: null,
              ),
              TextFormField(
                controller: _skillController,
                decoration: InputDecoration(
                  labelText: 'SKILL',
                  icon: Icon(Icons.fitness_center),
                ),
                maxLines: null,
              ),
              TextFormField(
                controller: _wodController,
                decoration: InputDecoration(
                  labelText: 'WOD',
                  icon: Icon(Icons.fitness_center),
                ),
                maxLines: null,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey != null && _formKey.currentState != null) {
                    if (_formKey.currentState!.validate()) {
                      final newWorkout = CrossFitWorkout(
                        _dateController.text,
                        _mobilidadeController.text,
                        _warmUpController.text,
                        _skillController.text,
                        _wodController.text,
                      );
                      Navigator.pop(context, newWorkout);
                    }
                  }
                },
                child: Text('Registrar Treino'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
