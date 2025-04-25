import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicinal_plants_id/constants/app_theme.dart';
import 'package:medicinal_plants_id/screens/plant_details_screen.dart';
import 'package:medicinal_plants_id/services/plant_recognition_service.dart';

class CameraScreen extends StatefulWidget {
  final bool isCamera;

  const CameraScreen({super.key, required this.isCamera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.isCamera) {
      _initializeCamera();
    } else {
      _pickImageFromGallery();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eroare la inițializarea camerei: $e')),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _processImage(File(image.path));
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eroare la selectarea imaginii: $e')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile image = await _controller!.takePicture();
      _processImage(File(image.path));
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eroare la fotografiere: $e')),
      );
    }
  }

  Future<void> _processImage(File imageFile) async {
    setState(() {
      _isProcessing = true;
    });

    print('Începem procesarea imaginii: ${imageFile.path}');

    try {
      // Apelează serviciul de recunoaștere a plantelor
      print('Apelăm PlantRecognitionService...');
      final result = await PlantRecognitionService.identifyPlant(imageFile);

      print('Rezultat obținut: $result');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailsScreen(
              imageFile: imageFile,
              plantName: result['scientificName'] ?? 'Nedeterminat',
              commonName: result['commonName'] ?? 'Nedeterminat',
              description: result['description'] ?? '',
              medicinalProperties: result['medicinalProperties'] ?? '',
              therapeuticUses: result['therapeuticUses'] ?? '',
            ),
          ),
        );
      }
    } catch (e) {
      print('Eroare în _processImage: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eroare la identificarea plantei: $e')),
        );

        // Folosim datele de test în caz de eroare
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailsScreen(
              imageFile: imageFile,
              plantName: 'Echinacea purpurea (fallback)',
              commonName: 'Echinacea Purpurie (fallback)',
              description: 'Nu am putut identifica planta. Aceasta este o descriere de rezervă.',
              medicinalProperties: 'Proprietăți medicinale nedeterminate.',
              therapeuticUses: 'Utilizări terapeutice nedeterminate.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isCamera) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Procesare Imagine'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(height: 16),
              Text(
                'Identificare plantă...',
                style: AppTheme.subheadingStyle,
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cameră'),
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryGreen,
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(_controller!),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black38,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: AppTheme.accentGreen,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Identificare plantă...',
                      style: AppTheme.subheadingStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (!_isProcessing)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: FloatingActionButton(
                  onPressed: _takePicture,
                  backgroundColor: AppTheme.accentGreen,
                  child: const Icon(
                    Icons.camera_alt,
                    size: 28,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}