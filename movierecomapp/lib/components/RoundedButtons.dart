import 'package:flutter/material.dart';


class RoundedButton extends StatelessWidget {
  const RoundedButton(this.colors,this.title,this.onpress,this.textColor, {Key? key}) : super(key: key);
  final Color colors;
  final String title;
  final VoidCallback onpress;
  final Color textColor;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colors,
        borderRadius: BorderRadius.circular(30.0),

        child: MaterialButton(
          onPressed: onpress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
