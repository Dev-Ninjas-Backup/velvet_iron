// models/about_training_model.dart

class AboutTrainingModel {
  final String title;
  final String description;

  AboutTrainingModel({
    required this.title,
    required this.description,
  });
}

class AboutTrainingData {
  static final List<AboutTrainingModel> features = [
    AboutTrainingModel(
      title: 'Clear Progression: Users can see their XP increase and understand how close they are to leveling up.',
      description: '',
    ),
    AboutTrainingModel(
      title: 'Engagement & Motivation: Leveling up provides a sense of achievement, encouraging users to keep interacting with the platform.',
      description: '',
    ),
    AboutTrainingModel(
      title: 'Exclusive Unlocks: Certain features, content, or rewards are unlocked based on XP, giving users incentives to participate more.',
      description: '',
    ),
    AboutTrainingModel(
      title: 'Personalized Experience: Users can feel their experience is tailored and rewarding as they progress through levels.',
      description: '',
    ),
  ];

  static final List<AboutTrainingModel> partnerFeatures = [
    AboutTrainingModel(
      title: 'Increased User Activity: Gamified XP and leveling mechanics encourage users to spend more time on the platform.',
      description: '',
    ),
    AboutTrainingModel(
      title: 'Better Retention: Users who are engaged and earning rewards are less likely to churn.',
      description: '',
    ),
    AboutTrainingModel(
      title: 'Data Insights: Partner organizations can track user progress, engagement patterns, and popular features unlocked through XP.',
      description: '',
    ),
    AboutTrainingModel(
      title: 'Promotional Opportunities: XP-based unlocks can be aligned with partner offers or exclusive content, driving more visibility and interaction for partners.',
      description: '',
    ),
  ];
}