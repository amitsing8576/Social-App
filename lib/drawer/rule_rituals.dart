import 'package:flutter/material.dart';
import 'package:socialapp/widgets/textToSpeech.dart';

class RuleRituals extends StatefulWidget {
  const RuleRituals({super.key});

  @override
  State<RuleRituals> createState() => _RuleRitualsState();
}

class _RuleRitualsState extends State<RuleRituals> {
  final List<String> rules = [
    "The members of the community are expected to post or share only authentic and related content and not cheat or engage in any kind of content manipulation.",
    "This is a place for creating community and belonging, not for attacking. All the community members are free of harassment, bullying, verbal violence, or any kind of threat.",
    "The platform should be used with honesty and integrity, and no member should attempt to misuse it for personal gain, deceive others, or engage in any activity that goes against the values of the community.",
    "Discussions should remain focused on work-related topics and experiences. Any off-topic conversations, unnecessary arguments, or distractions that take away from the purpose of the platform should be avoided.",
    "Members are advised not to use the platform for personal advertisements, promotions, or spam, nor to spread any false or misleading information within the community.",
    "All the members are to share an original piece of knowledge gained or circulate or contribute to discussion with valuable thoughts and ideas at least once a month.",
    "Any community member is not allowed to leak the content to any outsider or assist any non-member in misusing the platform in any way.",
    "In case a member fails to follow these, they will initially be given a reminder and if that is unheard it could lead to removal of content, temporary or permanent suspension of their account."
  ];

  final List<String> rituals = [
    "Tip of the Week – The most useful tip shared by a member gets featured, with credits given in a special notification sent to all members.",
    "Celebrating Problem-Solving – Whenever a discussion helps solve a problem, the solution is highlighted and sent as a notification to recognize and appreciate helpful contributions.",
    "Spotlighting Knowledge & Tips – Every month, the most helpful, liked, or commented knowledge post is featured for everyone to see.",
    "Monthly Polls – Every month, all members are invited to take part in a poll on important topics related to their work and experiences. These polls help highlight shared concerns, start meaningful discussions, and ensure that every member's voice is heard within the community.",
    "Mood Tracking – Members will regularly be invited to record their mood, creating a personal log of how they feel about working in the garment industry over time. This helps in understanding patterns, reflecting on experiences, and building a collective sense of well-being within the community."
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rules & Rituals'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rules",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                for (int i = 0; i < rules.length; i++) ruleCard(rules[i]),
                const SizedBox(height: 20),
                Text(
                  "Rituals",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                for (int i = 0; i < rituals.length; i++) ruleCard(rituals[i]),
              ],
            ),
          ),
        ));
  }

  Widget ruleCard(String text) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                text,
                style: TextStyle(fontSize: 11.0),
              )),
              //const SizedBox(width: 10),
              TTSPage(text: text),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
