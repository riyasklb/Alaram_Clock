import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdviceGuidanceScreen extends StatelessWidget {
  const AdviceGuidanceScreen({Key? key}) : super(key: key);

  // Function to open external URL
Future<void> _launchURL(String url) async {
  final uri = Uri.parse(url);
  try {
    if (await canLaunchUrl(uri)) {
      // Try with platform default (best compatibility)
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Explore helpful resources to guide your career decisions and personal growth:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            _buildResourceCard(
              context,
              title: 'Career Guidance Website',
              description: 'Visit trusted sites with career paths, interview tips, and resume help.',
              icon: Icons.web,
              color: Colors.greenAccent,
              url: 'https://www.careerguide.com/',
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              context,
              title: 'YouTube Career Advice',
              description: 'Watch expert videos for career advice, personal growth, and motivation.',
              icon: Icons.play_circle_fill,
              color: Colors.redAccent,
              url: 'https://www.youtube.com/',
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              context,
              title: 'LinkedIn Learning',
              description: 'Access courses and skill-building material to boost your career.',
              icon: Icons.school,
              color: Colors.blue[300],
              url: 'https://www.linkedin.com/learning/',
            ),
          ],
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
