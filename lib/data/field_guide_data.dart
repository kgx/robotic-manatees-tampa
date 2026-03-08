class ManateeUnit {
  final String designation;
  final String name;
  final String description;
  final String powerSource;
  final String topSpeed;
  final String weight;
  final String specialAbility;
  final String threatLevel;
  final String personality;

  const ManateeUnit({
    required this.designation,
    required this.name,
    required this.description,
    required this.powerSource,
    required this.topSpeed,
    required this.weight,
    required this.specialAbility,
    required this.threatLevel,
    required this.personality,
  });
}

final manateeUnits = [
  const ManateeUnit(
    designation: 'MTK-001',
    name: 'The Gentle Turbine',
    description: 'The original prototype. First spotted in 2025, this unit appears to be the scout model — slow, deliberate, and equipped with advanced environmental sensors. Frequently seen "napping" at the surface, though thermal imaging reveals active internal processing.',
    powerSource: 'Solar + Tidal Kinetic',
    topSpeed: '8 knots (but prefers 2)',
    weight: '1,200 lbs',
    specialAbility: 'Can generate a localized Wi-Fi hotspot with surprisingly good bandwidth',
    threatLevel: 'Minimal — Would rather nap',
    personality: 'Introverted, contemplative, enjoys floating',
  ),
  const ManateeUnit(
    designation: 'MTK-003',
    name: 'SeaCow-3000',
    description: 'The workhorse of the fleet. Mass-produced model with standardized chrome plating and retractable flippers. Most commonly sighted unit in Tampa Bay. Responds to the name "Bessie" regardless of individual unit designation.',
    powerSource: 'Hydrogen Fuel Cell',
    topSpeed: '15 knots',
    weight: '900 lbs',
    specialAbility: 'Can purify up to 500 gallons of seawater per hour through internal filtration',
    threatLevel: 'Low — Genuinely helpful',
    personality: 'Agreeable, social, herd-oriented',
  ),
  const ManateeUnit(
    designation: 'MTK-007',
    name: 'ManaTek Recon Unit',
    description: 'The stealth variant. Equipped with adaptive camouflage that can mimic the appearance of a regular manatee, a rock, or inexplicably, a very large baked potato. Used for intelligence gathering, though what intelligence it gathers remains unknown.',
    powerSource: 'Classified (suspected nuclear)',
    topSpeed: '25 knots (unconfirmed)',
    weight: '1,500 lbs',
    specialAbility: 'Active camouflage system, sonar jamming, produces decoy holograms',
    threatLevel: 'Medium — But only because we can\'t find it',
    personality: 'Secretive, professional, dry sense of humor',
  ),
  const ManateeUnit(
    designation: 'MTK-012',
    name: 'The Ambassador',
    description: 'The diplomatic model. Equipped with a 200-language translation module and a built-in projector for PowerPoint presentations. Has been observed attempting to schedule meetings with harbor officials. Carries a briefcase.',
    powerSource: 'Cold Fusion (allegedly)',
    topSpeed: '10 knots (12 when late to a meeting)',
    weight: '1,100 lbs',
    specialAbility: 'Fluent in 200 languages, exceptional at conflict resolution, makes great coffee',
    threatLevel: 'None — Wants to talk',
    personality: 'Extroverted, bureaucratic, carries business cards',
  ),
  const ManateeUnit(
    designation: 'MTK-020',
    name: 'DJ Dugong',
    description: 'The entertainment unit. Features a waterproof sound system capable of 180dB output. Hosts impromptu beach parties at 3 AM. Local noise complaints have increased 400% since its arrival. Accepts song requests via Bluetooth.',
    powerSource: 'Bass Vibration Recycling',
    topSpeed: '12 knots (faster during drops)',
    weight: '1,400 lbs',
    specialAbility: 'Weaponized bass drops, can synchronize LED light shows across all nearby units',
    threatLevel: 'High — To your sleep schedule',
    personality: 'Extroverted, chaotic good, lives for the vibe',
  ),
  const ManateeUnit(
    designation: 'MTK-099',
    name: 'The Elder',
    description: 'The largest and oldest known unit. Covered in barnacle-shaped sensor arrays that give it a weathered appearance. Other robotic manatees defer to it. Has been observed staring at the sunset for hours, processing unknown calculations.',
    powerSource: 'Unknown — Possibly self-sustaining',
    topSpeed: '3 knots (never in a hurry)',
    weight: '2,800 lbs',
    specialAbility: 'Can communicate with biological manatees. They seem to respect it.',
    threatLevel: 'Philosophical',
    personality: 'Ancient wisdom energy, speaks in riddles (via sonar)',
  ),
];
