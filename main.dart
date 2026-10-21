import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const WellMateAI());

class WellMateAI extends StatelessWidget {
  const WellMateAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Well Mate AI',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF2D36B),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFCF1),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String gender = 'Not selected';

  // Pastel yellow is the starting theme. Selecting a gender changes the palette.
  Color get primaryColor {
    if (gender == 'Female') return const Color(0xFFE9A8BD); // pastel pink
    if (gender == 'Male') return const Color(0xFF9BC5EA); // pastel blue
    return const Color(0xFFF2D36B); // pastel yellow, default
  }

  Color get softColor {
    if (gender == 'Female') return const Color(0xFFFFF0F5);
    if (gender == 'Male') return const Color(0xFFEEF6FF);
    return const Color(0xFFFFFCF1);
  }

  Color get accentColor {
    if (gender == 'Female') return const Color(0xFFD986A5);
    if (gender == 'Male') return const Color(0xFF659BD1);
    return const Color(0xFFD2A72E);
  }

  int selectedIndex = 0;
  String userName = 'User';
  String mood = 'Good';
  String moodEmoji = '😊';
  int waterCount = 0;
  int exerciseMinutes = 0;
  int exerciseSeconds = 0;
  int breathingSeconds = 60;

  bool exerciseActive = false;
  bool breathingActive = false;

  Timer? exerciseTimer;
  Timer? breathingTimer;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final healthController = TextEditingController();
  final ingredientController = TextEditingController();
  final chatController = TextEditingController();

  final Map<String, bool> reminders = {
    'Water reminder': true,
    'Movement reminder': true,
    'Sleep reminder': false,
    'Meditation reminder': false,
  };

  final Map<String, bool> tasks = {
    'Healthy breakfast': false,
    'Drink water': false,
    'Light exercise': false,
    'Meditation': false,
  };

  final List<Map<String, String>> messages = [
    {
      'type': 'bot',
      'text':
      "Hello! I'm Well Mate AI 🌿 Ask me about food, exercise, water, sleep, stress or healthy habits."
    }
  ];

  final List<String> titles = [
    'Dashboard',
    'My Profile',
    'Food & Diet',
    'Exercise',
    'Wellness',
    'Track Progress',
    'Notifications',
    'Well Mate AI',
    'Emergency',
  ];

  final List<IconData> icons = [
    Icons.home,
    Icons.person,
    Icons.restaurant,
    Icons.directions_run,
    Icons.self_improvement,
    Icons.bar_chart,
    Icons.notifications,
    Icons.smart_toy,
    Icons.emergency,
  ];

  @override
  void dispose() {
    exerciseTimer?.cancel();
    breathingTimer?.cancel();
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    healthController.dispose();
    ingredientController.dispose();
    chatController.dispose();
    super.dispose();
  }

  void notify(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void navigate(int index) {
    setState(() => selectedIndex = index);
  }

  void addWater() {
    if (waterCount >= 8) {
      notify('Your demo water goal is complete! 💧');
      return;
    }

    setState(() {
      waterCount++;
      tasks['Drink water'] = true;
    });

    notify('Water updated: $waterCount / 8 glasses');
  }

  void setMood(String value, String emoji) {
    setState(() {
      mood = value;
      moodEmoji = emoji;
    });
    notify('Mood saved: $emoji $value');
  }

  void saveProfile() {
    setState(() {
      userName = nameController.text.trim().isEmpty
          ? 'User'
          : nameController.text.trim();
    });

    FocusScope.of(context).unfocus();
    notify('Profile updated successfully!');
  }

  String generateMeal() {
    final input = ingredientController.text.toLowerCase().trim();

    if (input.isEmpty) {
      return 'Please enter some ingredients first.';
    }

    if (input.contains('rice') &&
        (input.contains('vegetable') || input.contains('veggie'))) {
      return '🍚 Vegetable Rice Bowl\n\nCombine cooked rice, vegetables and spices. Add a suitable protein source if available.';
    }

    if (input.contains('egg')) {
      return '🥚 Egg and Vegetable Meal\n\nCook eggs with available vegetables and serve with rice or bread.';
    }

    if (input.contains('oat')) {
      return '🥣 Oats Bowl\n\nPrepare oats and add fruit, nuts or your preferred toppings.';
    }

    if (input.contains('tomato')) {
      return '🍅 Tomato Meal\n\nCook tomatoes with vegetables and spices. Pair with a grain and suitable protein source.';
    }

    if (input.contains('potato')) {
      return '🥔 Potato Bowl\n\nCook potatoes thoroughly and combine with vegetables and a suitable protein source.';
    }

    return '🥗 Meal Suggestion\n\nUse $input as a starting point. When possible, combine vegetables, a grain or other carbohydrate, and a suitable protein source.';
  }

  void showMeal() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Meal Suggestion 🥗'),
        content: Text(generateMeal()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String aiResponse(String input) {
    final q = input.toLowerCase();

    if (q.contains('hello') || q == 'hi' || q.contains('hey')) {
      return 'Hello! 🌿 How can I help with your wellness today?';
    }

    if (q.contains('water') || q.contains('drink')) {
      return '💧 Your demo counter is $waterCount of 8 glasses. Drink regularly according to your individual hydration needs.';
    }

    if (q.contains('food') ||
        q.contains('diet') ||
        q.contains('eat') ||
        q.contains('meal')) {
      return '🥗 Try balanced meals with vegetables, a suitable protein source and grains or other carbohydrates. Visit Food & Diet to generate a meal suggestion.';
    }

    if (q.contains('exercise') ||
        q.contains('workout') ||
        q.contains('fitness')) {
      return '🏃 Walking, stretching and appropriate strength exercises are options. Visit Exercise to start a session and track your time.';
    }

    if (q.contains('stress') ||
        q.contains('anxiety') ||
        q.contains('relax')) {
      return '🧘 Try comfortable breathing, a short walk or talking with someone you trust. Visit Wellness for a breathing exercise.';
    }

    if (q.contains('sleep')) {
      return '😴 Keeping a consistent sleep schedule and a calm bedtime routine may help support better sleep.';
    }

    if (q.contains('meditation')) {
      return '🌿 Visit Wellness and start the breathing exercise. Breathe gently at a comfortable pace and stop if you feel uncomfortable.';
    }

    if (q.contains('mood') ||
        q.contains('sad') ||
        q.contains('happy')) {
      return '😊 Your mood matters. Use the mood check-in on Dashboard to record how you feel.';
    }

    if (q.contains('emergency') || q.contains('urgent')) {
      return '🚨 If someone is in immediate danger in India, call 112. This chatbot cannot contact emergency services for you.';
    }

    return '🌿 I can offer general wellness suggestions about food, exercise, hydration, sleep, stress and meditation. I use preset demo responses, not a live AI model.';
  }

  void sendMessage([String? suggestion]) {
    final text = (suggestion ?? chatController.text).trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add({'type': 'user', 'text': text});
      messages.add({'type': 'bot', 'text': aiResponse(text)});
      chatController.clear();
    });
  }

  void toggleExercise() {
    if (exerciseActive) {
      exerciseTimer?.cancel();

      setState(() {
        exerciseActive = false;
        exerciseMinutes += exerciseSeconds ~/ 60;
        exerciseSeconds = 0;
      });

      notify('Exercise session stopped.');
      return;
    }

    setState(() {
      exerciseActive = true;
      exerciseSeconds = 0;
    });

    exerciseTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (mounted && exerciseActive) {
          setState(() => exerciseSeconds++);
        }
      },
    );

    notify('Exercise started. Tap Stop when finished.');
  }

  void toggleBreathing() {
    if (breathingActive) {
      breathingTimer?.cancel();

      setState(() {
        breathingActive = false;
        breathingSeconds = 60;
      });

      notify('Breathing exercise stopped.');
      return;
    }

    setState(() {
      breathingActive = true;
      breathingSeconds = 60;
    });

    breathingTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (breathingSeconds <= 1) {
          timer.cancel();

          setState(() {
            breathingSeconds = 0;
            breathingActive = false;
          });

          notify('Breathing break complete! 🌿');
        } else {
          setState(() => breathingSeconds--);
        }
      },
    );
  }

  Widget page() {
    switch (selectedIndex) {
      case 0:
        return dashboard();
      case 1:
        return profile();
      case 2:
        return food();
      case 3:
        return exercise();
      case 4:
        return wellness();
      case 5:
        return tracker();
      case 6:
        return notificationsPage();
      case 7:
        return chatbot();
      case 8:
        return emergency();
      default:
        return dashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: softColor,
        appBarTheme: AppBarTheme(
          backgroundColor: softColor,
          surfaceTintColor: Colors.transparent,
        ),
        cardColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $userName 👋',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                titles[selectedIndex],
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: CircleAvatar(
                backgroundColor: softColor,
                child: Text(
                  userName.isEmpty ? 'U' : userName[0].toUpperCase(),
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: drawer(),
        body: SafeArea(child: page()),
      ),
    );
  }

  Widget drawer() {
    return Drawer(
      child: Container(
        color: accentColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🌿 Well Mate AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your Wellness Companion',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            for (int i = 0; i < titles.length; i++)
              ListTile(
                leading: Icon(icons[i], color: Colors.white),
                title: Text(
                  titles[i],
                  style: const TextStyle(color: Colors.white),
                ),
                selected: selectedIndex == i,
                selectedTileColor: Colors.white24,
                onTap: () {
                  Navigator.pop(context);
                  navigate(i);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.045),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget field(
      String label,
      TextEditingController controller,
      String hint, {
        TextInputType keyboard = TextInputType.text,
        int lines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: softColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget dashboard() {
    final done = tasks.values.where((v) => v).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor, primaryColor],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, $userName 🌿',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Build healthy habits one step at a time.',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () => navigate(7),
                      icon: const Icon(Icons.smart_toy),
                      label: const Text('Ask AI'),
                    ),
                    OutlinedButton(
                      onPressed: () => navigate(5),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: const Text('View progress'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.45,
            children: [
              stat('💧', 'Water', '$waterCount / 8', 'glasses', () => navigate(5)),
              stat('🏃', 'Exercise', '$exerciseMinutes min', 'recorded', () => navigate(3)),
              stat(moodEmoji, 'Mood', mood, 'today', () => navigate(0)),
              stat('✅', 'Tasks', '$done / ${tasks.length}', 'completed', () => navigate(5)),
            ],
          ),
          const SizedBox(height: 12),
          card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Plan",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                ...tasks.keys.map(
                      (task) => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(task),
                    value: tasks[task],
                    onChanged: (value) {
                      setState(() => tasks[task] = value ?? false);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How are you feeling?',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    moodButton('🤩', 'Excellent'),
                    moodButton('😊', 'Good'),
                    moodButton('😐', 'Okay'),
                    moodButton('😟', 'Stressed'),
                    moodButton('😔', 'Sad'),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Current mood: $moodEmoji $mood'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget stat(
      String icon,
      String title,
      String value,
      String subtitle,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: Colors.grey)),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(subtitle, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget moodButton(String emoji, String value) {
    return OutlinedButton(
      onPressed: () => setMood(value, emoji),
      style: OutlinedButton.styleFrom(
        backgroundColor: mood == value
            ? softColor
            : Colors.white,
      ),
      child: Text('$emoji $value'),
    );
  }

  Widget profile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Profile 👤',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: gender,
              decoration: InputDecoration(
                labelText: 'Gender',
                filled: true,
                fillColor: softColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Not selected', child: Text('Select gender')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Male', child: Text('Male')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => gender = value);
                notify(value == 'Female'
                    ? 'Pastel pink theme applied.'
                    : value == 'Male'
                    ? 'Pastel blue theme applied.'
                    : 'Pastel yellow theme applied.');
              },
            ),
            const SizedBox(height: 10),
            field('Full name', nameController, userName),
            field(
              'Email',
              emailController,
              'Enter email',
              keyboard: TextInputType.emailAddress,
            ),
            field('Age', ageController, 'Enter age', keyboard: TextInputType.number),
            field(
              'Weight (kg)',
              weightController,
              'Enter weight',
              keyboard: const TextInputType.numberWithOptions(decimal: true),
            ),
            field(
              'Height (cm)',
              heightController,
              'Enter height',
              keyboard: const TextInputType.numberWithOptions(decimal: true),
            ),
            field(
              'Health concerns (optional)',
              healthController,
              'Enter concerns',
              lines: 3,
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: saveProfile,
                icon: const Icon(Icons.save),
                label: const Text('Save Profile'),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Demo: profile values are not permanently stored.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget food() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Food & Diet 🥗',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Enter ingredients available at home.'),
                const SizedBox(height: 12),
                field(
                  'Ingredients',
                  ingredientController,
                  'e.g. rice, vegetables, tomato',
                  lines: 3,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: showMeal,
                    icon: const Icon(Icons.restaurant),
                    label: const Text('Generate Meal'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          card(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Balanced plate tips',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: Icon(Icons.eco),
                  title: Text('Add vegetables or fruit'),
                ),
                ListTile(
                  leading: Icon(Icons.egg_alt),
                  title: Text('Include a suitable protein source'),
                ),
                ListTile(
                  leading: Icon(Icons.rice_bowl),
                  title: Text('Choose suitable grains or carbohydrates'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget exercise() {
    final mins = exerciseSeconds ~/ 60;
    final secs = exerciseSeconds % 60;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Exercise 🏃',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const ListTile(
                leading: Icon(Icons.directions_walk),
                title: Text('Walking'),
                subtitle: Text('Move at a comfortable pace.'),
              ),
              const ListTile(
                leading: Icon(Icons.accessibility_new),
                title: Text('Stretching'),
                subtitle: Text('Stretch gently and safely.'),
              ),
              const ListTile(
                leading: Icon(Icons.fitness_center),
                title: Text('Strength activity'),
                subtitle: Text('Choose an activity suitable for you.'),
              ),
              const Divider(),
              Text(
                'Session: ${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: toggleExercise,
                  icon: Icon(exerciseActive ? Icons.stop : Icons.play_arrow),
                  label: Text(exerciseActive ? 'Stop Session' : 'Start Session'),
                  style: FilledButton.styleFrom(
                    backgroundColor: exerciseActive ? Colors.red : accentColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('Total recorded: $exerciseMinutes minutes'),
            ],
          ),
        ),
      ],
    );
  }

  Widget wellness() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        card(
          child: Column(
            children: [
              Icon(Icons.self_improvement, size: 48, color: accentColor),
              const Text(
                'Breathing Break 🌿',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                breathingActive
                    ? 'Breathe gently at your own comfortable pace.'
                    : 'Pause, relax your shoulders and take a moment for yourself.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Container(
                width: 120,
                height: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: softColor,
                  border: Border.all(color: accentColor, width: 3),
                ),
                child: Text(
                  '$breathingSeconds s',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: toggleBreathing,
                  icon: Icon(breathingActive ? Icons.stop : Icons.play_arrow),
                  label: Text(
                    breathingActive ? 'Stop Exercise' : 'Start 60-second Break',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Stop if you feel dizzy or uncomfortable. This is a relaxation tool, not medical treatment.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        card(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Other wellness ideas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('Write down something you appreciate'),
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Talk with someone you trust'),
              ),
              ListTile(
                leading: Icon(Icons.nightlight),
                title: Text('Create a calm bedtime routine'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tracker() {
    final done = tasks.values.where((v) => v).length;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Track Progress 📊',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 22),
              Text('Water: $waterCount / 8 glasses'),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: waterCount / 8,
                minHeight: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: addWater,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Water'),
                ),
              ),
              const Divider(height: 28),
              Text('Exercise: $exerciseMinutes minutes'),
              const SizedBox(height: 8),
              Text('Mood: $moodEmoji $mood'),
              const SizedBox(height: 8),
              Text('Tasks completed: $done / ${tasks.length}'),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: done / tasks.length,
                minHeight: 10,
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Reset progress?'),
                      content: const Text(
                        'This resets demo water, exercise totals and task checkboxes.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            setState(() {
                              waterCount = 0;
                              exerciseMinutes = 0;
                              tasks.updateAll((key, value) => false);
                            });
                            notify('Progress reset.');
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Progress'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Demo data resets when the app restarts.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget notificationsPage() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifications 🔔',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Toggle the reminder preferences below. These switches do not schedule real phone notifications.',
              ),
              const SizedBox(height: 8),
              ...reminders.keys.map(
                    (key) => SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(key),
                  subtitle: Text(
                    reminders[key]! ? 'Enabled' : 'Disabled',
                  ),
                  value: reminders[key]!,
                  onChanged: (value) {
                    setState(() => reminders[key] = value);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget chatbot() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: softColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Wrap(
            spacing: 6,
            children: [
              ActionChip(
                label: const Text('Meal ideas'),
                onPressed: () => sendMessage('Give me healthy meal ideas'),
              ),
              ActionChip(
                label: const Text('Sleep tips'),
                onPressed: () => sendMessage('Give me sleep tips'),
              ),
              ActionChip(
                label: const Text('Reduce stress'),
                onPressed: () => sendMessage('How can I reduce stress?'),
              ),
              ActionChip(
                label: const Text('Exercise'),
                onPressed: () => sendMessage('Suggest an exercise'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isUser = message['type'] == 'user';

              return Align(
                alignment: isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .8,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUser ? accentColor : Colors.white,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    message['text'] ?? '',
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Ask about wellness...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                  tooltip: 'Send message',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget emergency() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emergency,
                color: Colors.red,
                size: 62,
              ),
              const SizedBox(height: 8),
              const Text(
                'Emergency Assistance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'If someone is in immediate danger in India, call 112 for emergency assistance. This app does not automatically contact emergency services.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Emergency number: 112'),
                        content: const Text(
                          'Use your phone to contact emergency services if needed. You can copy the number below. This demo does not place calls.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Close'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              Clipboard.setData(
                                const ClipboardData(text: '112'),
                              );
                              notify('112 copied to clipboard.');
                            },
                            child: const Text('Copy number'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.call),
                  label: const Text('Emergency Information'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
