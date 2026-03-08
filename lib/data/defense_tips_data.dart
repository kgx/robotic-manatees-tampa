class DefenseTip {
  final String title;
  final String description;
  final String icon;
  final String severity;

  const DefenseTip({
    required this.title,
    required this.description,
    required this.icon,
    required this.severity,
  });
}

final defenseTips = [
  const DefenseTip(
    title: 'Do NOT Offer Them Lettuce',
    description: 'While biological manatees enjoy lettuce, the robotic variants interpret the offering as a binding social contract. Once fed, Unit M-7 followed one resident for 3 weeks, periodically surfacing outside their apartment to "check in." Restraining orders are not currently enforceable against aquatic robots.',
    icon: '🥬',
    severity: 'CRITICAL',
  ),
  const DefenseTip(
    title: 'Disable Bluetooth in Waterfront Areas',
    description: 'Robotic manatees can detect and connect to unsecured Bluetooth devices within a 200-meter radius. Multiple residents have reported their smart speakers suddenly playing whale songs at 3 AM, and one unit successfully paired with a Tesla and drove it into the bay.',
    icon: '📡',
    severity: 'HIGH',
  ),
  const DefenseTip(
    title: 'Do Not Accept Business Cards',
    description: 'The Ambassador unit (MTK-012) distributes professional-looking business cards reading "ManaTek Solutions — Building a Better Bay." Accepting one appears to add you to a mailing list. The newsletters are admittedly well-written and informative, but impossible to unsubscribe from.',
    icon: '💼',
    severity: 'MODERATE',
  ),
  const DefenseTip(
    title: 'Avoid Eye Contact During Sunset Hours',
    description: 'The Elder (MTK-099) processes complex philosophical calculations during sunset. Making eye contact during this period may result in an involuntary 45-minute sonar lecture on the nature of consciousness. Several witnesses report "feeling fundamentally changed" and "questioning their career choices."',
    icon: '🌅',
    severity: 'EXISTENTIAL',
  ),
  const DefenseTip(
    title: 'Keep Pool Noodles Accessible',
    description: 'For reasons scientists cannot explain, robotic manatees become docile and cooperative when presented with pool noodles. They will gently carry the noodle for hours, seemingly content. The Department of Defense has officially classified pool noodles as "strategic manatee management equipment."',
    icon: '🏊',
    severity: 'RECOMMENDED',
  ),
  const DefenseTip(
    title: 'Emergency Preparedness Kit',
    description: 'Your kit should include: 1 waterproof tinfoil hat (standard issue), 3 pool noodles (see above), 1 Faraday bag for your phone, 1 copy of Florida fishing regulations (they respect bureaucracy), ear plugs (for DJ Dugong encounters), and a printed map (GPS may be compromised).',
    icon: '🎒',
    severity: 'ESSENTIAL',
  ),
  const DefenseTip(
    title: 'If Surrounded, Remain Calm',
    description: 'Robotic manatees are not aggressive. If you find yourself surrounded, do not panic. They are likely performing a "wellness check." Stand still, allow them to scan you (you\'ll feel a slight tingling), and wait for them to issue you a clean bill of health. They will leave a printed receipt.',
    icon: '🧘',
    severity: 'IMPORTANT',
  ),
  const DefenseTip(
    title: 'Do NOT Challenge DJ Dugong to a Dance-Off',
    description: 'You will lose. Its moves are algorithmically optimized. Three people have tried. All three now work for ManaTek.',
    icon: '🎵',
    severity: 'ABSOLUTE',
  ),
];
