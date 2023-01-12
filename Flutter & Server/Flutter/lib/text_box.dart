import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final TextEditingController _controller;
  final String _label;
  TextBox(this._controller, this._label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
            label: Text(_label),
            suffix: GestureDetector(
              child: Icon(Icons.close),
              onTap: () {
                _controller.clear();
              },
            )
        ),
      ),
    );
  }
}

class NumberTextBox extends TextBox {
  NumberTextBox(super.controller, super.label);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: _controller,
        decoration: InputDecoration(
            label: Text(_label),
            suffix: GestureDetector(
              child: Icon(Icons.close),
              onTap: () {
                _controller.clear();
              },
            )
        ),
      ),
    );
  }
}
