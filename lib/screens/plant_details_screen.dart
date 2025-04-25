import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medicinal_plants_id/constants/app_theme.dart';
import 'package:medicinal_plants_id/models/plant.dart';
import 'package:medicinal_plants_id/services/database_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PlantDetailsScreen extends StatefulWidget {
  final File imageFile;
  final String plantName;
  final String commonName;
  final String description;
  final String medicinalProperties;
  final String therapeuticUses;

  const PlantDetailsScreen({
    super.key,
    required this.imageFile,
    required this.plantName,
    required this.commonName,
    required this.description,
    required this.medicinalProperties,
    required this.therapeuticUses,
  });

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  bool _isSaving = false;
  late final Plant _plant;
  late final String _localImagePath;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _initPlantData();
  }

  Future<void> _initPlantData() async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'plant_${DateTime.now().millisecondsSinceEpoch}.jpg';
    _localImagePath = path.join(directory.path, fileName);

    // Copierea imaginii în stocare locală
    await widget.imageFile.copy(_localImagePath);

    _plant = Plant(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scientificName: widget.plantName,
      commonName: widget.commonName,
      description: widget.description,
      medicinalProperties: widget.medicinalProperties,
      therapeuticUses: widget.therapeuticUses,
      imagePath: _localImagePath,
      identifiedAt: DateTime.now(),
    );
  }

  Future<void> _savePlantToHistory() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Salvare în baza de date locală
      await _databaseService.insertPlant(_plant);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plantă salvată în istoric')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eroare la salvarea plantei: $e')),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Folosim numele comun ca titlu dacă este disponibil, altfel folosim "Detalii Plantă"
    final plantTitle = widget.commonName.isNotEmpty && widget.commonName != "Nedeterminat"
        ? widget.commonName
        : 'Detalii Plantă';

    return Scaffold(
      appBar: AppBar(
        title: Text(plantTitle),
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _savePlantToHistory,
            icon: _isSaving
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Icon(Icons.bookmark_add_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imaginea plantei
            SizedBox(
              width: double.infinity,
              height: 250,
              child: Image.file(
                widget.imageFile,
                fit: BoxFit.cover,
              ),
            ),

            // Numele plantei și detalii
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nume științific
                  Text(
                    widget.plantName,
                    style: AppTheme.headingStyle.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  // Nume comun
                  Text(
                    widget.commonName,
                    style: AppTheme.subheadingStyle.copyWith(
                      color: AppTheme.primaryGreen,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Descriere
                  _buildInfoSection(
                    'Descriere',
                    widget.description,
                    Icons.info_outline,
                  ),

                  const SizedBox(height: 16),

                  // Proprietăți medicinale
                  _buildInfoSection(
                    'Proprietăți Medicinale',
                    widget.medicinalProperties,
                    Icons.medical_information_outlined,
                  ),

                  const SizedBox(height: 16),

                  // Utilizări terapeutice
                  _buildInfoSection(
                    'Utilizări Terapeutice',
                    widget.therapeuticUses,
                    Icons.healing_outlined,
                  ),

                  const SizedBox(height: 24),

                  // Notă
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_outlined,
                          color: AppTheme.earthBrown,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Consultați întotdeauna un profesionist din domeniul sănătății înainte de a utiliza orice plantă medicinală în scopuri terapeutice.',
                            style: AppTheme.captionStyle,
                          ),
                        ),
                      ],
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

  Widget _buildInfoSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryGreen,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTheme.subheadingStyle,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppTheme.bodyStyle,
        ),
      ],
    );
  }
}