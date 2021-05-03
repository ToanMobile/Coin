import 'package:flutter/material.dart';

class FilledRoundButton extends StatefulWidget {
  final Gradient gradientColor;
  final Color pureColor;
  final double radius;
  final Text text;
  final Icon prefIcon;
  final VoidCallback cb;

  FilledRoundButton.withGradient({
    @required this.gradientColor,
    this.radius = 30.0,
    this.text,
    this.prefIcon,
    this.cb,
  }) : this.pureColor = null;

  FilledRoundButton.withColor({
    @required this.pureColor,
    this.radius = 30.0,
    this.text,
    this.prefIcon,
    this.cb,
  }) : this.gradientColor = null;

  @override
  _FilledRoundButtonState createState() => _FilledRoundButtonState();
}

class _FilledRoundButtonState extends State<FilledRoundButton> {
  @override
  Widget build(BuildContext context) {
    Widget childWidgetButton = widget.prefIcon == null
      ? Center(child: widget.text)
      : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        widget.prefIcon,
        const SizedBox(
          width: 5.0
        ),
        Container(
          child: widget.text,
        )
      ],
    );

    return Container(
      decoration: BoxDecoration(
        color: widget.pureColor,
        gradient: widget.gradientColor,
        borderRadius: BorderRadius.circular(
          widget.radius,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // make splash shape fit round button when tap,
          // if not specified, splash shape is rectangle instead of round
          borderRadius: BorderRadius.circular(
            widget.radius,
          ),
          highlightColor: Colors.transparent,
          onTap: widget.cb == null ? () => {} : widget.cb,
          child: childWidgetButton,
        ),
      ),
    );
  }
}
