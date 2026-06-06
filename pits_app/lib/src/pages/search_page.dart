import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/categories_model.dart';
import 'package:pits_app/src/pages/establishments_by_category_page.dart';
import 'package:pits_app/src/services/categories_service.dart';
import 'package:pits_app/src/shared/categories.dart';
import 'package:pits_app/src/shared/custom_snackbar.dart';
import 'package:pits_app/src/shared/custom_text_field.dart';
import 'package:pits_app/src/shared/custom_title.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final categoriesService = CategoriesService();
  final searchController = TextEditingController();
  List<CategoriesModel> categories = [];

  Future<void> cargarCategorias() async {
    final result = await categoriesService.getCategories();
    setState(() => categories = result);
  }

  @override
  void initState() {
    super.initState();
    cargarCategorias();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _buscar(String value) {
    if (value.isEmpty) {
      mostrarSnackbar("Campo Vacío", Colors.red, context);
      return;
    }
    pushScreen(
      context,
      screen: EstablishmentsByCategoriePage(search: value),
      withNavBar: false,
    );
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height,
      width: screenSize.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/background.png'),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
            config.secondary.withOpacity(1),
            BlendMode.modulate,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: screenSize.height * 0.025,
      ),
      child: Column(
        children: [
          CustomTitle(text: "Tu Mundo Motor Aquí"),
          Row(
            children: [
              IconButton(
                onPressed: () => _buscar(searchController.text),
                icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                    color: config.accent),
              ),
              Expanded(
                child: CustomTextField(
                  sizeBox: screenSize.height * 0.06,
                  sizeFont: screenSize.height * 0.019,
                  colorFondo: config.primary,
                  colorTexto: Colors.white,
                  colorHintText: Colors.white60,
                  controller: searchController,
                  margin: EdgeInsets.only(bottom: screenSize.height * 0.02),
                  hintText: 'Buscar por producto, establecimiento…',
                  keyboardType: TextInputType.text,
                  label: false,
                  onFieldSubmitted: _buscar,
                ),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: cargarCategorias,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Wrap(
                  runSpacing: 5,
                  spacing: 15,
                  children: categories
                      .map((e) => Categorie(
                            categorie: e,
                            onTap: () => pushScreen(
                              context,
                              screen: EstablishmentsByCategoriePage(
                                  categorie: e),
                              withNavBar: false,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}