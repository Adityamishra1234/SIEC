import 'package:flutter/material.dart';

class AnimalListScreen extends StatelessWidget {
  final List<String> animals = [
    'Dog',
    'Cat',
    'Sparrow',
    'Pigeon',
    'Octopus',
    'Rhino',
    'Leopard',
    'Lion',
    'Jaguar',
  ];

  AnimalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal List'),
      ),
      body: ListView.builder(
        itemCount: animals.length,
        itemBuilder: (context, index) {
          final animal = animals[index];
          return ListTile(
            title: Text(animal),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AnimalDetailsScreen(animal: animal)));
            },
          );
        },
      ),
    );
  }
}

class AnimalDetailsScreen extends StatelessWidget {
  final String animal;
  const AnimalDetailsScreen({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> animalDetails = {
      'Dog': 'Dogs are loyal companions and often referred to as man\'s best friend.',
      'Cat': 'Cats are independent creatures known for their agility and hunting skills.',
      'Sparrow': 'Sparrows are small, social birds often found in urban environments.',
      'Pigeon': 'Pigeons are known for their homing abilities and often used in messenger services.',
      'Octopus': 'Octopuses are intelligent sea creatures with eight arms and a soft body.',
      'Rhino': 'Rhinos are large mammals with thick, protective skin and a single horn on their nose.',
      'Leopard': 'Leopards are agile hunters known for their spotted fur and stealthy behavior.',
      'Lion': 'Lions are majestic predators and the kings of the jungle.',
      'Jaguar': 'Jaguars are powerful big cats native to the Americas.',
    };

    final details = animalDetails[animal] ?? 'Details not available';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              animal,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              details ?? 'Details not available',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}