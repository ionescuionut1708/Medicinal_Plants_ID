import 'package:flutter/material.dart';
import 'package:medicinal_plants_id/constants/app_theme.dart';
import 'package:medicinal_plants_id/screens/camera_screen.dart';
import 'package:medicinal_plants_id/screens/history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MainHomeScreen(),
    const HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Acasă',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Istoric',
          ),
        ],
      ),
    );
  }
}

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identificator de Plante Medicinale'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Înlocuim Image.asset direct cu Container + Icon
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(75),
                      ),
                      child: Icon(
                        Icons.eco,
                        size: 80,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Identifică Plante Medicinale',
                      style: AppTheme.headingStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Fotografiază sau încarcă o imagine pentru a identifica plantele medicinale și a afla despre proprietățile lor terapeutice.',
                      style: AppTheme.bodyStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          context,
                          Icons.camera_alt,
                          'Fotografiază',
                              () => _navigateToCameraScreen(context, true),
                        ),
                        _buildActionButton(
                          context,
                          Icons.photo_library,
                          'Încarcă Imagine',
                              () => _navigateToCameraScreen(context, false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: AppTheme.lightGreen.withOpacity(0.2),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Toate identificările sunt salvate local pe dispozitivul tău. Nu este necesar niciun cont!',
                      style: AppTheme.captionStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context,
      IconData icon,
      String label,
      VoidCallback onPressed,
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  void _navigateToCameraScreen(BuildContext context, bool isCamera) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(isCamera: isCamera),
      ),
    );
  }
}