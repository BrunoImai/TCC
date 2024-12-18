import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/sizes.dart';
import '../../assistance/assistance.dart';
import '../maps/location_service.dart';

class WorkerCoordinates extends StatefulWidget {
  const WorkerCoordinates({super.key, this.selectedAssistance});

  final AssistanceInformations? selectedAssistance;

  @override
  _WorkerCoordinatesState createState() => _WorkerCoordinatesState();
}

class _WorkerCoordinatesState extends State<WorkerCoordinates> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _sendCurrentLocation(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      Position? position = await LocationService.getCurrentLocation();
      print(position);
      print(position?.latitude);
      print(position?.longitude);

      if (position != null) {
        await LocationService.sendLocationToServer(position);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Localização enviada com sucesso!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocorreu um erro: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final widthFactor = screenWidth < 600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Center(
        child: Wrap(
          spacing: homePadding,
          runSpacing: homePadding,
          alignment: WrapAlignment.center,
          children: [
            if (widget.selectedAssistance == null)
              FractionallySizedBox(
                widthFactor: widthFactor ? 1.0 : null,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: screenWidth < 600 ? screenWidth : 528,
                    maxWidth: 528,
                  ),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: () async {
                      await _sendCurrentLocation(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: cardBgColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Enviar localização',
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: darkColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}