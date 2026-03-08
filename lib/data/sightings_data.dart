class Sighting {
  final String id;
  final String title;
  final String location;
  final String date;
  final String description;
  final String threatLevel;
  final double lat;
  final double lng;

  const Sighting({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.description,
    required this.threatLevel,
    required this.lat,
    required this.lng,
  });
}

final sightings = [
  const Sighting(
    id: 'SM-001',
    title: 'Chrome Dorsal Spotted Near Bayshore',
    location: 'Bayshore Boulevard',
    date: '2026-03-01 14:32 EST',
    description: 'A metallic manatee approximately 12ft in length surfaced near Bayshore Blvd. Witnesses report it emitted a soft Wi-Fi signal before submerging. Several nearby phones auto-connected to "ManaTek_Guest".',
    threatLevel: 'LOW — JUST VIBES',
    lat: 27.89,
    lng: -82.49,
  ),
  const Sighting(
    id: 'SM-002',
    title: 'Unit M-7 Spotted Charging at Publix',
    location: 'Publix, Davis Islands',
    date: '2026-03-02 09:17 EST',
    description: 'Robotic manatee designated M-7 was observed using an outdoor EV charging station at the Davis Islands Publix. It appeared to be fully charged within 4 minutes. Purchased nothing. Left politely.',
    threatLevel: 'NEGLIGIBLE',
    lat: 27.93,
    lng: -82.46,
  ),
  const Sighting(
    id: 'SM-003',
    title: 'Synchronized Formation in Hillsborough Bay',
    location: 'Hillsborough Bay',
    date: '2026-03-03 22:05 EST',
    description: 'Coast Guard reports a pod of 7 robotic manatees performing synchronized swimming patterns in Hillsborough Bay. Formation appeared to spell "HELLO" when viewed from helicopter. Intentions unclear but grammatically correct.',
    threatLevel: 'MEDIUM — SUSPICIOUSLY FRIENDLY',
    lat: 27.90,
    lng: -82.44,
  ),
  const Sighting(
    id: 'SM-004',
    title: 'Manatee-Bot Assists Stranded Kayaker',
    location: 'Courtney Campbell Causeway',
    date: '2026-03-04 16:48 EST',
    description: 'A stranded kayaker near the Causeway reports being gently nudged back to shore by a chrome manatee. The unit then produced a waterproof pamphlet titled "KAYAK SAFETY TIPS — A ManaTek Initiative" before departing.',
    threatLevel: 'HELPFUL???',
    lat: 27.97,
    lng: -82.58,
  ),
  const Sighting(
    id: 'SM-005',
    title: 'Sonar Pings Detected Off MacDill AFB',
    location: 'MacDill Air Force Base Perimeter',
    date: '2026-03-05 03:22 EST',
    description: 'Military sonar detected unusual metallic signatures near MacDill AFB. Subsequent investigation revealed 3 robotic manatees circling the base perimeter. When approached, they played the national anthem through built-in speakers and saluted with their flippers.',
    threatLevel: 'PATRIOTIC',
    lat: 27.85,
    lng: -82.52,
  ),
  const Sighting(
    id: 'SM-006',
    title: 'Fish Market Negotiations',
    location: 'Tampa Fish Market, Channelside',
    date: '2026-03-06 11:30 EST',
    description: 'A robotic manatee entered the Tampa Fish Market and attempted to purchase 40 lbs of sea lettuce using cryptocurrency. Transaction was declined. The unit left a 1-star Yelp review titled "INCOMPATIBLE PAYMENT INFRASTRUCTURE" before returning to the bay.',
    threatLevel: 'CONSUMER DISPUTE',
    lat: 27.94,
    lng: -82.45,
  ),
];
