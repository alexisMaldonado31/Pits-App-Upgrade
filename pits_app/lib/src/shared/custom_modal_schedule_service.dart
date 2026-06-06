import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/productos_model.dart';
import 'package:pits_app/src/models/schedule_modal_response_model.dart';
import 'package:pits_app/src/models/vehicle_model.dart';
import 'package:pits_app/src/services/products_service.dart';
import 'package:pits_app/src/shared/custom_dropdown.dart';
import 'package:pits_app/src/shared/custom_loading.dart';
import 'package:pits_app/src/shared/custom_text.dart';
import 'package:pits_app/src/shared/custom_text_button.dart';
import 'package:pits_app/src/shared/custom_text_field.dart';

class CustomModalScheduleService extends StatefulWidget {
  final ProductsModel product;
  final List<VehicleModel> vehicles;

  const CustomModalScheduleService({
    super.key,
    required this.product,
    required this.vehicles,
  });

  @override
  State<CustomModalScheduleService> createState() =>
      _CustomModalScheduleServiceState();
}

class _CustomModalScheduleServiceState
    extends State<CustomModalScheduleService> {
  final _fechaController = TextEditingController();
  List<String> schedules = [];
  bool loadingSchedules = false;
  bool showError = false;
  final scheduleResponse = ScheduleModalResponseModel();
  String scheduleSelected = "";

  Future<void> _loadSchedules(String fecha) async {
    setState(() => loadingSchedules = true);
    schedules = await ProductsService().getSchedulesByEstablishmentProduct(
      widget.product.establishmentId!,
      widget.product.id!,
      fecha,
    );
    setState(() => loadingSchedules = false);
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      locale: Locale('es', 'ES'),
    );

    if (picked != null) {
      final mes = picked.month < 10 ? '0${picked.month}' : '${picked.month}';
      final dia = picked.day < 10 ? '0${picked.day}' : '${picked.day}';
      final fecha = '${picked.year}-$mes-$dia';
      setState(() => _fechaController.text = fecha);
      await _loadSchedules(fecha);
    }
  }

  @override
  void dispose() {
    _fechaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final config = AppConfig.of(context);
    final sizeBox = screenSize.height * 0.05;
    final sizeFont = screenSize.width * 0.04; // 👈 mismo para ambos

    return AlertDialog(
      title: CustomText(
        text: "Seleccione un horario",
        colorText: config.primary,
        fontSize: screenSize.width * 0.04,
        textAlign: TextAlign.center,
        fontWeight: FontWeight.bold,
      ),
      actions: [
        CustomTextButton(
          text: "Cerrar",
          textColor: Colors.red,
          onTap: () => Navigator.pop(context),
        ),
        CustomTextButton(
          text: "Guardar",
          textColor: config.accent,
          onTap: () {
            if (scheduleResponse.schedule == null) {
              setState(() => showError = true);
            } else {
              Navigator.pop(context, scheduleResponse);
            }
          },
        ),
      ],
      content: SizedBox(
        height: screenSize.height * 0.4,
        width: screenSize.width * 0.6,
        child: Column(
          children: [
            if (showError)
              CustomText(
                text: 'Seleccione un horario',
                fontWeight: FontWeight.bold,
                fontSize: sizeFont,
                textAlign: TextAlign.center,
                colorText: Colors.red,
              ),
            CustomTextField(
              sizeBox: sizeBox,
              sizeFont: sizeFont, // 👈
              colorFondo: Colors.grey[100]!,
              colorTexto: Colors.grey[800]!,
              colorHintText: Colors.black87,
              controller: _fechaController,
              label: true,
              colorLabel: Colors.black,
              margin: EdgeInsets.symmetric(
                  horizontal: sizeBox / 4, vertical: sizeBox / 4),
              hintText: 'Fecha',
              keyboardType: TextInputType.text,
              onTap: () => _selectDate(context),
              readonly: true,
            ),
            if (widget.vehicles.isNotEmpty)
              CustomDropDown(
                items: widget.vehicles
                    .map((e) => CustomDropDownItem(
                          content:
                              '${e.licensePlate} (${e.brandName} - ${e.typeVehicleName})',
                          index: e.id,
                        ))
                    .toList(),
                llave: GlobalKey<FormFieldState>(),
                sizeBox: screenSize.height * 0.06,
                indexResponse: false,
                colorFondo: Colors.grey[100]!,
                colorTexto: Colors.grey[800]!,
                dropdownColor: Colors.white,
                labelColor: Colors.black, // 👈
                hintText: "Seleccione un Auto",
                sizeFont: sizeFont, // 👈 mismo valor
                label: 'Vehículo',
                margin: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.02),
                obligatorio: false,
                validator: (value) => value != null,
                onChanged: (value) {
                  final vehicleInfo =
                      widget.vehicles.firstWhere((e) => e.id == value);
                  setState(() {
                    scheduleResponse.vehicleId = value;
                    scheduleResponse.vehicleInfo =
                        '${vehicleInfo.licensePlate} (${vehicleInfo.brandName} - ${vehicleInfo.typeVehicleName})';
                  });
                },
              ),
            SizedBox(height: screenSize.height * 0.02),
            loadingSchedules
                ? Expanded(child: CustomLoading())
                : schedules.isEmpty
                    ? Expanded(
                        child: Center(
                          child: CustomText(
                            text: _fechaController.text.isEmpty
                                ? ''
                                : 'No hay horarios disponibles',
                            fontWeight: FontWeight.bold,
                            fontSize: sizeFont,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Wrap(
                            children: schedules
                                .map((e) => ChoiceChip(
                                      label: Text(e.substring(0, 5)),
                                      selected: scheduleSelected == e,
                                      onSelected: (_) {
                                        setState(() {
                                          showError = false;
                                          scheduleSelected = e;
                                          scheduleResponse.schedule =
                                              "${_fechaController.text} $e";
                                        });
                                      },
                                      selectedColor: config.accent,
                                      labelStyle:
                                          TextStyle(color: config.primary),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}