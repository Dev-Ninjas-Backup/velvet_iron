// models/about_training_model.dart

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
      title: 'Increased User Activity:',
      description:
          'Gamified XP and leveling mechanics encourage users to spend more time on the platform.',
    ),
    AboutTrainingModel(
      title: 'Better Retention:',
      description:
          'Users who are engaged and earning rewards are less likely to churn.',
    ),
    AboutTrainingModel(
      title: 'Data Insights:',
      description:
          'Partner organizations can track user progress, engagement patterns, and popular features unlocked through XP.',
    ),
    AboutTrainingModel(
      title: 'Promotional Opportunities:',
      description:
          'XP-based unlocks can be aligned with partner offers or exclusive content, driving more visibility and interaction for partners.',
    ),
  ];
}
