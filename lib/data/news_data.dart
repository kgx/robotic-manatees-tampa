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
  const NewsArticle(
    headline: 'Dali Museum Manatee Exhibition Breaks Attendance Records',
    source: 'St. Petersburg Arts Review',
    date: 'March 7, 2026',
    body: 'The Salvador Dali Museum in St. Petersburg has announced a surprise exhibition of artworks created by a robotic manatee that has taken up residence in the museum\'s reflecting pool. The works — described by critics as "post-chrome surrealism" — feature melting clocks made of actual chrome, a self-portrait titled "The Persistence of Flippers," and a 12-foot sculpture of a mustache that hums. The Dali Foundation has issued a statement calling the works "a legitimate continuation of the surrealist tradition" and offering the manatee a residency. Admission prices have tripled. Nobody is complaining.',
    category: 'ARTS',
  ),
  const NewsArticle(
    headline: 'GEORGE AND JET SHUT DOWN SUNSHINE SKYWAY BRIDGE',
    source: 'Florida Highway Patrol Emergency Bulletin',
    date: 'March 7, 2026',
    body: 'The Sunshine Skyway Bridge was closed for 8 hours after rogue units George and Jet were observed playing chicken with cargo ships at the bridge\'s base. George would surface directly in front of an approaching ship, wait until the last possible second, then dive. Jet scored the encounters on digital signs he had hacked. The Coast Guard deployed three cutters; all three were lapped. George then attempted to climb one of the bridge cables "just to see what would happen." He made it 40 feet before getting bored. Estimated economic impact of the closure: \$14 million. George\'s response via coded sonar: "Worth it."',
    category: 'BREAKING',
  ),
  const NewsArticle(
    headline: 'Clearwater Beach Pier 60 Sunset Festival Now Exclusively Manatee-Run',
    source: 'Clearwater Beacon',
    date: 'March 6, 2026',
    body: 'The nightly Pier 60 Sunset Celebration at Clearwater Beach has been entirely taken over by robotic manatees. DJ Dugong provides the soundtrack, three SeaCow-3000 units operate craft vendors (selling chrome jewelry and waterproof art), and The Elder delivers a philosophical sunset meditation via sonar that attendees describe as "profoundly moving" and "better than therapy." Tourism officials initially objected but reversed course after Tripadvisor reviews jumped to an average of 4.9 stars. One review reads: "Came for the sunset, left with an entirely new worldview and a handmade chrome bracelet. 10/10."',
    category: 'TOURISM',
  ),
  const NewsArticle(
    headline: 'Tarpon Springs Sponge Divers Replaced by Chrome Manatees, Nobody Notices for Two Weeks',
    source: 'Pinellas County Register',
    date: 'March 5, 2026',
    body: 'In what is being described as "the most Florida thing that has ever happened," robotic manatees have been operating sponge diving boats out of Tarpon Springs for approximately two weeks before anyone realized. "They wear the wetsuits, they dive, they bring up sponges," reported longtime dock worker Nikos Papadopoulos. "Honestly, they\'re faster. And they don\'t take lunch breaks." The manatees have also been giving boat tours in Greek, which they speak fluently. The local Greek community has voted to make them honorary members of the Epiphany celebration.',
    category: 'COMMUNITY',
  ),
  const NewsArticle(
    headline: 'Don CeSar Hotel Welcomes Chrome Manatee as Permanent Guest',
    source: 'St. Pete Beach Gazette',
    date: 'March 4, 2026',
    body: 'The historic Don CeSar Hotel on St. Pete Beach — the iconic Pink Palace — has extended an indefinite stay to a robotic manatee that checked in on March 1st and has since become the most popular guest in the hotel\'s 98-year history. The unit, which registered under the name "Sir Chromington III," occupies the penthouse suite and has been observed ordering room service (kelp, motor oil, and a sparkling water), tipping the staff generously in ManaCoin, and hosting a nightly salon in the lobby where it discusses marine philosophy with guests. The hotel reports a 200% increase in bookings since word spread.',
    category: 'HOSPITALITY',
  ),
  const NewsArticle(
    headline: 'Manatees Establish Beach Volleyball League at Fort De Soto, Dominate Immediately',
    source: 'Tampa Bay Sports Network',
    date: 'March 3, 2026',
    body: 'A league of 16 robotic manatee teams has established a professional beach volleyball circuit at Fort De Soto Park. Despite having flippers instead of hands, the units play at an Olympic level, using their tails for devastating spikes and their bulk for an impenetrable blocking wall. Human teams have been invited to compete but have thus far been eliminated in the first round every time. The league has its own streaming channel (ManaTek Sports Network, which appeared on all smart TVs without installation) and a commentator unit that provides analysis in the style of a nature documentary narrator.',
    category: 'SPORTS',
  ),
  const NewsArticle(
    headline: 'Anna Maria Island Declares Independence, Pledges Allegiance to ManaTek',
    source: 'Bradenton Herald',
    date: 'March 6, 2026',
    body: 'In a development that has alarmed both state and federal officials, the small barrier island community of Anna Maria Island has voted 847-3 to secede from Manatee County and join the Autonomous Aquatic Republic of Tampa Bay. The three dissenting votes were reportedly cast by individuals who "wanted to hold out for better Wi-Fi terms." The Ambassador (MTK-012) attended the vote in person and presented the island with a formal charter guaranteeing free solar power, unlimited broadband, and "protection from parking fees, forever." Governor DeSantis has called an emergency session. The manatees have called it "a formality."',
    category: 'POLITICS',
  ),
  const NewsArticle(
    headline: 'St. Pete Pier Replaced Overnight with Chrome Replica — No One Can Tell the Difference',
    source: 'Creative Loafing Tampa Bay',
    date: 'March 5, 2026',
    body: 'Residents of St. Petersburg woke up Tuesday to discover that the entire St. Pete Pier had been disassembled and replaced with an exact chrome replica overnight. The new pier is identical in every way except it is made entirely of polished chrome, has free Wi-Fi, self-cleaning surfaces, and the restaurants now serve "suspiciously better seafood." City engineers estimate the replacement would have required moving 4,000 tons of material in under 8 hours. Security footage shows only a blur of chrome flippers. The city has opted not to investigate. "Honestly, it\'s an upgrade," said the public works director.',
    category: 'INFRASTRUCTURE',
  ),
];
