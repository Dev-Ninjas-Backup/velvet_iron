class AboutTrainingModel {
  final String title;
  final String description;

  AboutTrainingModel({required this.title, required this.description});
}

class AboutTrainingData {
  static final List<AboutTrainingModel> features = [
    AboutTrainingModel(
      title: 'Clear Progression:',
      description:
          'Users can see their XP increase and understand how close they are to leveling up.',
    ),
    AboutTrainingModel(
      title: 'Engagement & Motivation:',
      description:
          'Leveling up provides a sense of achievement, encouraging users to keep interacting with the platform.',
    ),
    AboutTrainingModel(
      title: 'Exclusive Unlocks:',
      description:
          'Certain features, content, or rewards are unlocked based on XP, giving users incentives to participate more.',
    ),
    AboutTrainingModel(
      title: 'Personalized Experience:',
      description:
          'Users can feel their experience is tailored and rewarding as they progress through levels.',
    ),
  ];

  static final List<AboutTrainingModel> partnerFeatures = [
    AboutTrainingModel(
      title: 'Consistent Discipline:',
      description:
          'Transform small daily habits into lasting momentum with rewarding progression systems.',
    ),
    AboutTrainingModel(
      title: 'Habit Mastery:',
      description:
          'Strengthen your physical, nutritional, and mental stamina through balanced daily quests.',
    ),
    AboutTrainingModel(
      title: 'Companion Guidance:',
      description:
          'Your chosen realm ally walks alongside you, offering motivation and lore throughout your journey.',
    ),
    AboutTrainingModel(
      title: 'Heroic Purpose:',
      description:
          'Every rep, meal logged, and step taken builds toward legendary growth in your personal training codex.',
    ),
  ];
}
