class SessionService {
  static List<Map<String, dynamic>> getAllSessions() {
    return [
      {
        'id': '1',
        'title': 'Morning Flow',
        'subtitle': '15 min • Beginner',
        'duration': 15,
        'difficulty': 'Beginner',
        'description': 'Start your day with gentle stretches and mindful breathing.',
        'icon': 'wb_sunny_outlined',
        'color': 'orange',
        'category': 'morning',
      },
      {
        'id': '2',
        'title': 'Evening Relax',
        'subtitle': '20 min • All Levels',
        'duration': 20,
        'difficulty': 'All Levels',
        'description': 'Unwind with calming poses and deep breathing exercises.',
        'icon': 'nightlight_round',
        'color': 'indigo',
        'category': 'evening',
      },
      {
        'id': '3',
        'title': 'Power Yoga',
        'subtitle': '30 min • Advanced',
        'duration': 30,
        'difficulty': 'Advanced',
        'description': 'Build strength and flexibility with dynamic sequences.',
        'icon': 'fitness_center',
        'color': 'red',
        'category': 'strength',
      },
      {
        'id': '4',
        'title': 'Breathing Meditation',
        'subtitle': '5 min • Guided',
        'duration': 5,
        'difficulty': 'All Levels',
        'description': 'Learn proper breathing techniques for relaxation.',
        'icon': 'air',
        'color': 'blue',
        'category': 'meditation',
      },
      {
        'id': '5',
        'title': 'Sun Salutation',
        'subtitle': '12 min • Morning Routine',
        'duration': 12,
        'difficulty': 'Beginner',
        'description': 'Traditional sequence to energize your body.',
        'icon': 'wb_sunny_outlined',
        'color': 'orange',
        'category': 'morning',
      },
      {
        'id': '6',
        'title': 'Moon Flow',
        'subtitle': '18 min • Evening Relax',
        'duration': 18,
        'difficulty': 'All Levels',
        'description': 'Soothing poses for the end of your day.',
        'icon': 'nightlight_round',
        'color': 'indigo',
        'category': 'evening',
      },
      {
        'id': '7',
        'title': 'Basic Poses',
        'subtitle': '15 min • Foundation',
        'duration': 15,
        'difficulty': 'Beginner',
        'description': 'Learn the fundamentals of yoga poses.',
        'icon': 'self_improvement',
        'color': 'green',
        'category': 'beginner',
      },
      {
        'id': '8',
        'title': 'Breathing 101',
        'subtitle': '10 min • Pranayama',
        'duration': 10,
        'difficulty': 'Beginner',
        'description': 'Introduction to pranayama breathing techniques.',
        'icon': 'air',
        'color': 'blue',
        'category': 'beginner',
      },
    ];
  }

  static List<Map<String, dynamic>> getFeaturedSessions() {
    return getAllSessions().where((session) => 
      ['1', '2', '3'].contains(session['id'])
    ).toList();
  }

  static List<Map<String, dynamic>> getSessionsByCategory(String category) {
    if (category == 'all') return getAllSessions();
    return getAllSessions().where((session) => 
      session['category'] == category
    ).toList();
  }

  static Map<String, dynamic>? getSessionById(String id) {
    try {
      return getAllSessions().firstWhere((session) => session['id'] == id);
    } catch (e) {
      return null;
    }
  }
}

