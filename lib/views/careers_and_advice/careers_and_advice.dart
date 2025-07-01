import 'package:alaram/tools/cutomwidget/cutom_home_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdviceGuidanceScreen extends StatelessWidget {
  const AdviceGuidanceScreen({Key? key}) : super(key: key);

  // Function to open external URL
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
        print('✅ URL launched: $url');
      } else {
        print('❌ Cannot launch URL: $url');
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('🚫 Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advice & Guidance'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Explore medical resources to understand and prevent deep vein thrombosis (DVT) and blood clot risks:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // NHS Links
            _buildResourceCard(
              context,
              title: 'NHS: Deep Vein Thrombosis (DVT)',
              description:
                  'Learn about DVT symptoms, causes, and available treatments.',
              icon: Icons.medical_services,
              color: Colors.indigo,
              url: 'https://www.nhs.uk/conditions/deep-vein-thrombosis-dvt/',
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              context,
              title: 'NHS: Anticoagulant Medicines',
              description:
                  'Overview of blood-thinning medicines that help prevent clots.',
              icon: Icons.local_pharmacy,
              color: Colors.deepPurpleAccent,
              url: 'https://www.nhs.uk/medicines/anticoagulants/',
            ),

            const SizedBox(height: 24),
            const Text(
              'Health & DVT Prevention Videos:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            _buildResourceCard(
              context,
              title: '3 Exercises to Prevent Blood Clots in Bed',
              description: 'Gentle movements to reduce DVT risk while bedridden.',
              icon: Icons.fitness_center,
              color: Colors.deepOrangeAccent,
              url: 'https://www.youtube.com/watch?v=EYPs4NLREno',
            ),
            const SizedBox(height: 16),

            _buildResourceCard(
              context,
              title: 'Deep Vein Thrombosis: Causes & Treatment',
              description: 'Understand what DVT is, its signs, and how to manage it.',
              icon: Icons.health_and_safety,
              color: Colors.purpleAccent,
              url: 'https://www.youtube.com/watch?v=iQjTCIcusCs&t=201s',
            ),
            const SizedBox(height: 16),

            _buildResourceCard(
              context,
              title: 'DVT Prevention Exercises by Doctor Jo',
              description: 'Practical leg exercises to improve circulation and prevent clots.',
              icon: Icons.sports_gymnastics,
              color: Colors.teal,
              url: 'https://www.youtube.com/watch?v=x32kRLlxaBI',
            ),const SizedBox(height: 16),
                CustomHomeButton(),  ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color? color,
    required String url,
  }) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color?.withOpacity(0.2),
                radius: 28,
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(description,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.4)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
