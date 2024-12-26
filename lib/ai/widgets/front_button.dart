import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Nexia/ai/constants/constants.dart';

class FrontWidget extends StatefulWidget {
  const FrontWidget(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.iconData});

  final String text;
  final void Function() onPressed;
  final IconData iconData;
  @override
  State<FrontWidget> createState() => _FrontWidgetState();
}

class _FrontWidgetState extends State<FrontWidget> {
  bool isHoveredUpload = false;
  bool isHoveredDemo = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHoveredDemo = true),
      onExit: (_) => setState(() => isHoveredDemo = false),
      child: GestureDetector(
        onTap: () => widget.onPressed(),
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // This ensures the Row takes minimum width
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black87,
                boxShadow: isHoveredDemo
                    ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 20, // Adjusts the glow effect
                          spreadRadius: 5, // Adjusts how far the glow spreads
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.text,
                    style:
                        GoogleFonts.dmMono(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Constants.backgroundColor),
                        color: Colors.black87,
                      ),
                      child: Icon(widget.iconData,
                          size: 18, color: Constants.backgroundColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
