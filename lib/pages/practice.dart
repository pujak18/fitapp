import 'package:flutter/material.dart';
import 'practice_workout_detail.dart';

class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  static final List<Map<String, dynamic>> workoutList = [
    {
      'title': 'Strength Training',
      'description': 'Build muscle and increase power',
      'duration': '45 min',
      'sets': '4 sets x 8 reps',
      'difficulty': 'Intermediate',
      'icon': Icons.fitness_center,
      'color': Colors.red[400]!,
      'category': 'Strength',
    },
    {
      'title': 'Cardio Blast',
      'description': 'High-intensity cardio workout',
      'duration': '30 min',
      'sets': '5 rounds',
      'difficulty': 'High',
      'icon': Icons.trending_up,
      'color': Colors.orange[400]!,
      'category': 'Cardio',
    },
    {
      'title': 'Flexibility Flow',
      'description': 'Improve flexibility and mobility',
      'duration': '25 min',
      'sets': '3 sets x 12 reps',
      'difficulty': 'Beginner',
      'icon': Icons.accessibility_new,
      'color': Colors.blue[400]!,
      'category': 'Flexibility',
    },
    {
      'title': 'HIIT Intervals',
      'description': 'High-intensity interval training',
      'duration': '20 min',
      'sets': '8 intervals x 30s',
      'difficulty': 'High',
      'icon': Icons.flash_on,
      'color': Colors.purple[400]!,
      'category': 'HIIT',
    },
    {
      'title': 'Core Strength',
      'description': 'Target your abs and core muscles',
      'duration': '15 min',
      'sets': '4 sets x 15 reps',
      'difficulty': 'Intermediate',
      'icon': Icons.self_improvement,
      'color': Colors.teal[400]!,
      'category': 'Core',
    },
    {
      'title': 'Legs & Glutes',
      'description': 'Build lower body strength',
      'duration': '35 min',
      'sets': '5 sets x 10 reps',
      'difficulty': 'Intermediate',
      'icon': Icons.directions_run,
      'color': Colors.pink[400]!,
      'category': 'Lower Body',
    },
    {
      'title': 'Upper Body Pump',
      'description': 'Strengthen arms, chest, and shoulders',
      'duration': '40 min',
      'sets': '4 sets x 12 reps',
      'difficulty': 'Intermediate',
      'icon': Icons.handyman,
      'color': Colors.deepOrange[400]!,
      'category': 'Upper Body',
    },
    {
      'title': 'Full Body Burn',
      'description': 'Complete body workout in one session',
      'duration': '50 min',
      'sets': '3 sets x 20 reps',
      'difficulty': 'Advanced',
      'icon': Icons.local_fire_department,
      'color': Colors.red[600]!,
      'category': 'Full Body',
    },
    {
      'title': 'Recovery & Stretch',
      'description': 'Gentle movement for recovery days',
      'duration': '20 min',
      'sets': '2 sets x 10 reps',
      'difficulty': 'Beginner',
      'icon': Icons.healing,
      'color': Colors.green[400]!,
      'category': 'Recovery',
    },
    {
      'title': 'Dance Fitness',
      'description': 'Fun and energizing dance workout',
      'duration': '30 min',
      'sets': '5 choreos x 3 min',
      'difficulty': 'Beginner',
      'icon': Icons.music_note,
      'color': Colors.deepPurple[400]!,
      'category': 'Fun',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Practice Workouts",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[800],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "10 dynamic fitness routines",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: Colors.deepPurple[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Workout List
              ...workoutList.map(
                (workout) => _buildWorkoutCard(context, workout),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(BuildContext context, Map<String, dynamic> workout) {
    final color = workout['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  workout['icon'] as IconData,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout['title'] as String,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(
                          workout['difficulty'] as String,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        workout['difficulty'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getDifficultyColor(
                            workout['difficulty'] as String,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            workout['description'] as String,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildInfoChip(
                Icons.timer_outlined,
                workout['duration'] as String,
                Colors.blue,
              ),
              const SizedBox(width: 15),
              _buildInfoChip(
                Icons.repeat,
                workout['sets'] as String,
                Colors.green,
              ),
              const SizedBox(width: 15),
              _buildInfoChip(
                Icons.category,
                workout['category'] as String,
                Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showWorkoutDetails(context, workout),
              icon: Icon(Icons.play_arrow, size: 20),
              label: const Text('Start Workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'High':
      case 'Advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showWorkoutDetails(BuildContext context, Map<String, dynamic> workout) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: (workout['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            workout['icon'] as IconData,
                            color: workout['color'] as Color,
                            size: 40,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workout['title'] as String,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                workout['category'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildDetailRow(
                      Icons.description,
                      'Description',
                      workout['description'] as String,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      Icons.timer_outlined,
                      'Duration',
                      workout['duration'] as String,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      Icons.repeat,
                      'Sets & Reps',
                      workout['sets'] as String,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      Icons.trending_up,
                      'Difficulty',
                      workout['difficulty'] as String,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close modal
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PracticeWorkoutDetailPage(workout: workout),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: workout['color'] as Color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Start Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple[600], size: 24),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
