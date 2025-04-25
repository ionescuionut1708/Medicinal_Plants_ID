import 'package:flutter/material.dart';
import 'package:medicinal_plants_id/constants/app_theme.dart';
import 'package:medicinal_plants_id/models/plant.dart';
import 'package:medicinal_plants_id/screens/plant_details_screen.dart';
import 'package:medicinal_plants_id/services/database_service.dart';
import 'dart:io';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Plant> _plants = [];
  bool _isLoading = true;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    try {
      final plants = await _databaseService.getPlants();
      setState(() {
        _plants = plants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eroare la încărcarea plantelor: $e')),
        );
      }
    }
  }

  Future<void> _deletePlant(String id) async {
    try {
      await _databaseService.deletePlant(id);
      _loadPlants();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plantă eliminată din istoric')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eroare la ștergerea plantei: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Istoric Identificări'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryGreen,
        ),
      )
          : _plants.isEmpty
          ? _buildEmptyState()
          : _buildHistoryList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: AppTheme.lightGreen,
          ),
          const SizedBox(height: 16),
          Text(
            'Nicio Plantă Identificată Încă',
            style: AppTheme.subheadingStyle,
          ),
          const SizedBox(height: 8),
          Text(
            'Plantele identificate vor apărea aici',
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _plants.length,
      itemBuilder: (context, index) {
        final plant = _plants[index];
        return Dismissible(
          key: Key(plant.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _deletePlant(plant.id);
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                _navigateToPlantDetails(plant);
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plant image or placeholder
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: plant.imagePath.isNotEmpty && File(plant.imagePath).existsSync()
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(plant.imagePath),
                          fit: BoxFit.cover,
                        ),
                      )
                          : Icon(
                        Icons.eco,
                        size: 40,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Plant details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant.scientificName,
                            style: AppTheme.subheadingStyle.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            plant.commonName,
                            style: AppTheme.bodyStyle.copyWith(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Identificată pe ${_formatDate(plant.identifiedAt)}',
                            style: AppTheme.captionStyle,
                          ),
                        ],
                      ),
                    ),
                    // Arrow icon
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToPlantDetails(Plant plant) {
    if (plant.imagePath.isNotEmpty && File(plant.imagePath).existsSync()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlantDetailsScreen(
            imageFile: File(plant.imagePath),
            plantName: plant.scientificName,
            commonName: plant.commonName,
            description: plant.description,
            medicinalProperties: plant.medicinalProperties,
            therapeuticUses: plant.therapeuticUses,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fișierul imagine nu a fost găsit')),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}