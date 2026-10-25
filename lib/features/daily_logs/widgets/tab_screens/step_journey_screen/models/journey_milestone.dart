class JourneyMilestone {
  final int stepMilestone;
  final String name;
  final String shortName;
  final String lore;
  final double fraction; // 0.0 to 1.0 along the trail

  const JourneyMilestone({
    required this.stepMilestone,
    required this.name,
    required this.shortName,
    required this.lore,
    required this.fraction,
  });

  static const List<JourneyMilestone> defaultMilestones = [
    JourneyMilestone(
      stepMilestone: 0,
      name: "The Outpost",
      shortName: "Outpost",
      lore: "The ancient fortified frontier bastion where your expedition began.",
      fraction: 0.0,
    ),
    JourneyMilestone(
      stepMilestone: 25000,
      name: "Wayfarer's Arch",
      shortName: "Wayfarer's Arch",
      lore: "An old stone arch straddles the road, its weathered runes faintly lit despite the absence of any spellcaster.",
      fraction: 0.076,
    ),
    JourneyMilestone(
      stepMilestone: 50000,
      name: "Whisperwood",
      shortName: "Whisperwood",
      lore: "The forest grows unnaturally quiet as the road disappears beneath silver roots. Living things sense the disturbance.",
      fraction: 0.168,
    ),
    JourneyMilestone(
      stepMilestone: 150000,
      name: "Blackwater Crossing",
      shortName: "Blackwater",
      lore: "A broad river crossing carrying turbulent violet currents, showing evidence that something crossed into Aevaryn.",
      fraction: 0.289,
    ),
    JourneyMilestone(
      stepMilestone: 250000,
      name: "The Ruins of Vael",
      shortName: "Ruins of Vael",
      lore: "Ancient stone colonnades stand half-swallowed by earth and ivy, proving this phenomenon has occurred before.",
      fraction: 0.350,
    ),
    JourneyMilestone(
      stepMilestone: 375000,
      name: "The Witchlight Marsh",
      shortName: "Witchlight Marsh",
      lore: "Mist clings to dark waters where pale lights drift between twisted weeping willows as foreign energies bleed together.",
      fraction: 0.491,
    ),
    JourneyMilestone(
      stepMilestone: 500000,
      name: "The Hollow Watchtower",
      shortName: "Watchtower",
      lore: "A massive imperial spire towers above the bluffs, vacant for centuries. The halfway mark to the Citadel.",
      fraction: 0.626,
    ),
    JourneyMilestone(
      stepMilestone: 625000,
      name: "The Ashen Pass",
      shortName: "Ashen Pass",
      lore: "Jagged grey cliffs rise steep and unforgiving, dusted with volcanic grey sediment as disturbances accelerate.",
      fraction: 0.701,
    ),
    JourneyMilestone(
      stepMilestone: 750000,
      name: "The Fallen King's Road",
      shortName: "King's Road",
      lore: "Paved with massive basalt blocks, this historic highway once carried royal legions toward the primal gateway.",
      fraction: 0.798,
    ),
    JourneyMilestone(
      stepMilestone: 875000,
      name: "The Obsidian Keep",
      shortName: "Obsidian Keep",
      lore: "Dark glass-like stone reflects lightning from distant unnatural storms near the borders of the portal crater.",
      fraction: 0.905,
    ),
    JourneyMilestone(
      stepMilestone: 1000000,
      name: "The Shattered Citadel",
      shortName: "Citadel",
      lore: "The ancient fortress surrounding the first primal portal. The ultimate summit and destination of your 1,000,000-step journey.",
      fraction: 1.0,
    ),
  ];
}
