import 'package:flutter/material.dart';
import 'asmaul_husna_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Lainnya'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuCard(
            context,
            icon: Icons.format_list_numbered,
            title: '99 Asmaul Husna',
            subtitle: 'Nama-nama Allah yang indah',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AsmaulHusnaPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.mosque,
            title: 'Masjid Terdekat',
            subtitle: 'Temukan masjid di sekitar Anda',
            color: Colors.blue,
            onTap: () {
              // TODO: Implement masjid terdekat
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon...')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.auto_stories,
            title: 'Dzikir & Doa',
            subtitle: 'Kumpulan dzikir dan doa harian',
            color: Colors.purple,
            onTap: () {
              // TODO: Implement dzikir & doa
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon...')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.calculate,
            title: 'Kalkulator Zakat',
            subtitle: 'Hitung zakat fitrah dan mal',
            color: Colors.orange,
            onTap: () {
              // TODO: Implement kalkulator zakat
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required MaterialColor color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

