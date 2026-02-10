import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pits_app/src/shared/custom_text.dart';

class CustomTextField extends StatefulWidget {
  final double sizeBox;
  final double sizeFont;
  final String hintText;
  final TextEditingController? controller;
  final Color? colorFondo;
  final Color? colorTexto;
  final Color? colorHintText;

  /// Devuelve true si es válido. (mantengo tu contrato, pero tipado a null-safety)
  final bool Function(String value)? validator;

  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;

  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final EdgeInsets margin;
  final bool label;
  final Color colorLabel;
  final bool obligatorio;
  final bool readonly;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.sizeBox,
    required this.sizeFont,
    this.controller,
    this.colorFondo,
    this.colorTexto,
    this.colorHintText,
    this.hintText = '',
    this.validator,
    this.onSaved,
    this.onTap,
    this.onFieldSubmitted,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.margin = EdgeInsets.zero,
    this.label = false,
    this.obligatorio = false,
    this.colorLabel = Colors.white,
    this.readonly = false,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isEmpty = true;
  bool isValidate = false;
  late bool _obscureText;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showPasswordTemporarily() {
    setState(() => _obscureText = false);

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _obscureText = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: widget.margin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.label)
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: CustomText(
                      text:
                          '${widget.hintText} ${widget.obligatorio ? '*' : ''}',
                      colorText: widget.colorLabel,
                      fontSize: widget.sizeFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 5),
                Container(
                  height: widget.sizeBox,
                  padding: EdgeInsets.only(
                    left: widget.prefixIcon == null ? 15.0 : 0,
                    right: 15.0,
                  ),
                  decoration: BoxDecoration(
                    color: widget.colorFondo,
                    border: isEmpty
                        ? null
                        : isValidate
                        ? null
                        : Border.all(color: Colors.red),
                  ),
                  child: TextFormField(
                    expands: false,
                    controller: widget.controller,
                    keyboardType: widget.keyboardType,
                    textAlign: TextAlign.left,
                    obscureText: _obscureText,
                    readOnly: widget.readonly,
                    maxLines: widget.maxLines,
                    style: TextStyle(
                      fontSize: widget.sizeFont,
                      color: widget.colorTexto,
                      fontFamily: 'Gothic',
                    ),
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(height: 0),
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        fontSize: widget.sizeFont,
                        fontFamily: 'Gothic',
                        color: widget.colorHintText,
                      ),
                      prefixIcon: widget.prefixIcon == null
                          ? null
                          : Icon(widget.prefixIcon, color: widget.colorTexto),
                      suffixIcon: widget.obscureText
                          ? InkWell(
                              onTap: _showPasswordTemporarily,
                              child: const Icon(
                                FontAwesomeIcons.eye,
                                color: Colors.white,
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                    ),
                    onTap: widget.onTap,
                    onSaved: widget.onSaved,
                    onFieldSubmitted: widget.onFieldSubmitted,
                    validator: (String? value) {
                      if (widget.validator == null) return null;

                      final v = value ?? '';
                      final ok = widget.validator!(v);

                      setState(() {
                        isEmpty = false;
                        isValidate = ok;
                      });

                      return ok ? null : '';
                    },
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
