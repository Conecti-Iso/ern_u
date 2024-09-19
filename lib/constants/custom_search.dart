import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final Function(String) onChange;
  const SearchInput(
      {required this.textController, required this.hintText, super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 60,
      decoration: BoxDecoration(
          boxShadow: [
        BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1)),
      ]),
      child: TextField(
        controller: textController,
        onChanged: onChange,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xff4338CA),
          ),
          filled: true,
          fillColor: const Color(0xFFEEEEEE),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}
