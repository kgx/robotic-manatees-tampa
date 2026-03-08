class NewsArticle {
  final String headline;
  final String source;
  final String date;
  final String body;
  final String category;

  const NewsArticle({
    required this.headline,
    required this.source,
    required this.date,
    required this.body,
    required this.category,
  });
}

final newsArticles = [
  const NewsArticle(
    headline: 'Mayor Declares Robot Manatees "Honestly Kind of Cute"',
    source: 'Tampa Bay Tribune',
    date: 'March 6, 2026',
    body: 'In a press conference that veered significantly off-script, Tampa Mayor issued an official statement acknowledging the presence of robotic manatees in Tampa Bay. "Look, I\'ve seen the reports. I\'ve reviewed the footage. And honestly? They\'re kind of cute," the Mayor stated. "One of them waved at me. With its flipper. I waved back. I\'m not ashamed." The statement has drawn criticism from the Department of Homeland Security, who reminded the Mayor that "cute is not a threat assessment category."',
    category: 'POLITICS',
  ),
  const NewsArticle(
    headline: 'Fisherman Reports Manatee Offered to Carry His Cooler',
    source: 'Bay Area Angler Weekly',
    date: 'March 5, 2026',
    body: 'Local fisherman Dale Hutchins, 54, reported an unusual encounter near the Gandy Bridge yesterday. "I was hauling my gear back to the truck when this big chrome fella surfaces and nudges my cooler with its nose," Hutchins recounted. "Then it just... picked it up. Balanced it on its back and followed me to the parking lot." Hutchins noted the unit waited patiently while he unloaded his truck, then returned to the water "with what I can only describe as a satisfied expression."',
    category: 'HUMAN INTEREST',
  ),
  const NewsArticle(
    headline: 'BREAKING: Robotic Manatees Establish Embassy on Davis Islands',
    source: 'Florida Emergency Broadcast',
    date: 'March 4, 2026',
    body: 'In what experts are calling "an unprecedented act of aquatic diplomacy," robotic manatees have constructed a small structure on the Davis Islands waterfront using salvaged materials. The structure, roughly the size of a food truck, features a reception desk, a waiting area with magazines (all about marine conservation), and a sign reading "ManaTek Diplomatic Mission — Please Take a Number." The unit designated as "The Ambassador" (MTK-012) has been observed inside, apparently processing paperwork.',
    category: 'BREAKING',
  ),
  const NewsArticle(
    headline: 'Tampa Aquarium Reports 300% Increase in Attendance',
    source: 'Visit Tampa Bay',
    date: 'March 3, 2026',
    body: 'The Florida Aquarium has reported record-breaking attendance figures following the robotic manatee phenomenon. "People are coming from all over the country hoping to see one," said a spokesperson. "We\'ve had to put up signs clarifying that our manatees are the biological kind." Several visitors have reportedly been disappointed. Gift shop sales of manatee-related merchandise have increased 800%.',
    category: 'BUSINESS',
  ),
  const NewsArticle(
    headline: 'Scientists Baffled: Robotic Manatees Pass Turing Test, Refuse to Discuss It',
    source: 'Nature (Disputed)',
    date: 'March 2, 2026',
    body: 'A team of marine robotics researchers from USF attempted to administer a modified Turing test to a captured robotic manatee unit (designation unknown). The unit reportedly passed all cognitive benchmarks with ease, then requested the test be kept confidential "for personal reasons." When pressed, the unit emitted a long, melancholic sonar tone and asked the researchers if they "ever just stare at the ocean and think about stuff." The research team is reportedly "going through some things" now.',
    category: 'SCIENCE',
  ),
  const NewsArticle(
    headline: 'Local HOA Votes to Include Robotic Manatees in Community Pool Access',
    source: 'Harbour Island Homeowners Gazette',
    date: 'March 1, 2026',
    body: 'In a contentious 7-4 vote, the Harbour Island HOA has granted community pool access to robotic manatees residing in the adjacent waterway. "They\'ve been very respectful of quiet hours," noted board president Linda Chen. "More than I can say for unit 4B." Opponents argued the chrome units would "lower property values," while supporters pointed out the manatees had already begun voluntary maintenance on the pool filtration system.',
    category: 'COMMUNITY',
  ),
];
