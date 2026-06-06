import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/shared/custom_text.dart';

class CustomDropDown extends StatefulWidget {
  final double sizeBox;
  final double sizeFont;
  final Color colorFondo;
  final Color colorTexto;
  final EdgeInsets margin;
  final List<CustomDropDownItem> items;
  final String hintText;
  final Function(dynamic) onChanged;
  final Function(dynamic) validator;
  final bool indexResponse;
  final GlobalKey<FormFieldState> llave;
  final String label;
  final bool obligatorio;
  final dynamic initialValue; // 👈
  final Color? dropdownColor; // 👈 agrega esta línea
  final Color? labelColor; // 👈 agrega esta línea

  const CustomDropDown({
    super.key,
    required this.sizeBox,
    required this.sizeFont,
    required this.items,
    required this.llave,
    required this.colorFondo,
    required this.colorTexto,
    required this.onChanged,
    required this.validator,
    this.initialValue, // 👈
    this.indexResponse = false,
    this.margin = EdgeInsets.zero,
    this.hintText = '',
    this.label = '',
    this.obligatorio = false,
    this.dropdownColor, // 👈 agrega esta línea
    this.labelColor, // 👈 agrega esta línea
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  bool isEmpty = true;
  bool isValidate = false;
  dynamic _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue; // 👈
  }

  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            margin: widget.margin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.label != '')
                  Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Text(
                      '${widget.label} ${widget.obligatorio ? '*' : ''}',
                      style: TextStyle(
                        fontSize: widget.sizeFont,
                        color: widget.labelColor ?? widget.colorTexto,
                        fontFamily: 'Gothic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(height: 5),
                Container(
                  height: widget.sizeBox,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: widget.colorFondo,
                    border: isEmpty
                        ? null
                        : isValidate
                            ? null
                            : Border.all(color: Colors.red),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: config.secondary,
                    ),
                    child: DropdownButtonFormField<dynamic>(
                      key: widget.llave,
                      dropdownColor: widget.dropdownColor ?? config.secondary,
                      isExpanded: true,
                      decoration: InputDecoration(border: InputBorder.none),
                      style: TextStyle(
                        fontSize: widget.sizeFont,
                        color: Colors.black,
                      ),
                      isDense: true,
                      hint: Text(
                        widget.hintText,
                        style: TextStyle(
                          color: widget.colorTexto,
                          fontFamily: 'Gothic',
                          fontWeight: FontWeight.bold,
                          fontSize: widget.sizeFont,
                        ),
                      ),
                      value: _currentValue,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      items: widget.items.map((item) {
                        return DropdownMenuItem(
                          value: item.index,
                          child: Text(
                            item.content ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: widget.sizeFont,
                              color: widget.colorTexto,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _currentValue = value);
                        widget.onChanged(
                            widget.indexResponse ? value ?? 0 : value ?? '');
                      },
                      onTap: () =>
                          FocusScope.of(context).requestFocus(FocusNode()),
                      validator: (value) {
                        if (widget.validator(value)) {
                          setState(() {
                            isEmpty = false;
                            isValidate = true;
                          });
                        } else {
                          setState(() {
                            isEmpty = false;
                            isValidate = false;
                          });
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDropDownItem {
  int? index;
  String? content;

  CustomDropDownItem({this.index, this.content});
}