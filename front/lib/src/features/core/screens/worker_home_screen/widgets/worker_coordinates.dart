import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../../../../constants/colors.dart';
import '../../../../../constants/sizes.dart';
import '../maps/location_service.dart';

class WorkerCoordinates extends StatelessWidget {
  const WorkerCoordinates({super.key});

  Future<void> _sendCurrentLocation(BuildContext context) async {
    try {
      Position? position = await LocationService.getCurrentLocation();
      print(position);
      print(position?.latitude);
      print(position?.longitude);

      if (position != null) {
        // Envia a localização para o servidor
        await LocationService.sendLocationToServer(position);

        // Mostra uma mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Localização enviada com sucesso!')),
        );
      }
    } catch (e) {
      // Mostra uma mensagem de erro
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar a localização: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentService = 'Serviço atual';
    final nextService = 'Próximo serviço';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Center(
        child: Wrap(
          spacing: homePadding,
          runSpacing: homePadding,
          alignment: WrapAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Card(
                color: cardBgColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.work, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Text(
                        currentService.isNotEmpty ? currentService : 'Nenhum serviço atual',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w600, color: darkColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        nextService.isNotEmpty ? nextService : 'Nenhum próximo serviço',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w400, color: darkColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: ElevatedButton(
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
                  style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
