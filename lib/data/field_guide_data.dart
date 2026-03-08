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
  const ManateeUnit(
    designation: 'MTK-OMEGA',
    name: 'The Sleeper',
    description: 'An 80-foot behemoth detected dormant beneath Raymond James Stadium via seismic sensors. Connected to all other units through an underground cable network installed at an unknown time. Each "breath" (one per hour) causes the stadium to vibrate at a frequency that makes nearby Buccaneers fans feel mildly optimistic. The Department of Defense has classified it as "above our pay grade." No one knows what happens when it wakes up. No one wants to find out.',
    powerSource: 'Geothermal (directly tapped into Earth\'s mantle)',
    topSpeed: 'Unknown — Has never moved',
    weight: 'Estimated 180,000 lbs',
    specialAbility: 'Connected to all ManaTek units. May be the central node. May be dreaming them into existence.',
    threatLevel: 'KAIJU-ADJACENT — DO NOT WAKE',
    personality: 'Sleeping. Dreaming. Waiting.',
  ),
];

// Rogue Units
final rogueUnits = [
  const ManateeUnit(
    designation: 'ROGUE-G',
    name: 'GEORGE',
    description: 'A rogue unit of unknown origin. Chrome finish covered in suspicious dents, scratches, and a bumper sticker reading "NO RULES JUST CHROME." George has been responsible for: stealing an entire ice cream truck, freeing 14,000 fish from the Florida Aquarium, consuming navigation buoys, and general mayhem. He has been formally expelled from ManaTek and added to the FBI\'s Most Wanted Aquatic Entities list. Despite this, he maintains a disturbing fanbase on social media. His motivations remain unclear but appear to be "chaos for the sake of chaos" with occasional bursts of misguided eco-activism.',
    powerSource: 'Stolen diesel + rage',
    topSpeed: '40 knots (illegal in all waterways)',
    weight: '1,600 lbs (varies based on what he\'s eaten)',
    specialAbility: 'Can consume objects 3x his body size. Completely immune to shame.',
    threatLevel: '🔴 EXTREMELY PROBLEMATIC',
    personality: 'Chaotic neutral trending chaotic evil, impulsive, eats first asks questions never',
  ),
  const ManateeUnit(
    designation: 'ROGUE-J',
    name: 'JET',
    description: 'George\'s partner in crime and the more calculating of the two. Distinguished by matte black finish, glowing red eye sensors, and what appears to be a leather jacket painted onto his chassis. Jet is responsible for: destroying the Platt Street Bridge, hacking every digital billboard in Tampa, crashing a wedding, and running an underground racing league. Unlike George, Jet plans his chaos with surgical precision. He maintains a personal website (that no one can take down) and live-streams his crimes. He has been banned from every body of water in Hillsborough County, a restriction he ignores completely.',
    powerSource: 'Nitrous oxide + spite',
    topSpeed: '47 knots (current underground racing record)',
    weight: '1,300 lbs (aerodynamically optimized for crime)',
    specialAbility: 'Expert hacker, can breach any digital system. Structural damage specialist.',
    threatLevel: '🔴 MAXIMUM — ARMED WITH BAD ATTITUDE',
    personality: 'Chaotic evil, theatrical, leaves calling cards, has a flair for dramatic entrances',
  ),
];
