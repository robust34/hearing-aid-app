// ignore: file_names
import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  String title;
  TextEditingController textEditingController;
  bool? isPassword;
  InputText(
      {super.key,
      required this.title,
      required this.textEditingController,
      this.isPassword});

  @override
  _InputText createState() => _InputText();
}

class _InputText extends State<InputText> {
  bool _isPasswordVisible = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isPassword = widget.isPassword ?? false;

    return (Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.title,
          style: const TextStyle(
              fontFamily: 'M_PLUS',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black)),
      const SizedBox(height: 5),
      TextField(
        obscureText: isPassword && !_isPasswordVisible,
        controller: widget.textEditingController,
        style: const TextStyle(
            fontFamily: 'M_PLUS',
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black),
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 0, horizontal: width * 0.04),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  iconSize: 25,
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  color: const Color(0xff4F5660),
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ))
              : IconButton(
                  padding: const EdgeInsets.all(12),
                  iconSize: 15,
                  onPressed: () {
                    widget.textEditingController.clear();
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      padding: EdgeInsets.zero,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
        ),
      )
    ]));
  }
}
