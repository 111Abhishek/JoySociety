import 'package:flutter/material.dart';
import 'package:joy_society/utill/color_resources.dart';

// ignore: must_be_immutable
class Dropdown extends StatefulWidget {
  Dropdown({
    Key? key,
    this.title,
    required this.dropdownValue,
    required this.onChanged,
    required this.item,
    this.showTitle = true,
    this.containerColor = ColorResources.DARK_GREEN_COLOR,
    this.height = 45,
    this.fontSize = 18,
    this.width = 500,
  }) : super(key: key);
  @override
  State<Dropdown> createState() => _DropdownState();
  final String? title;
  final List<dynamic> item;
  final double? height;
  final double? width;
  double fontSize;
  dynamic dropdownValue;
  bool? showTitle;
  Color? containerColor;
  void Function(dynamic)? onChanged;
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Give title or heading text to the dropdown
        (widget.showTitle == true)
            ? Text(widget.title!)
            : const SizedBox(
                width: 0,
                height: 0,
              ),
        // this container contain the dropdown
        Container(
          margin:
              (widget.showTitle == true) ? const EdgeInsets.only(top: 5) : null,
          padding: const EdgeInsets.only(left: 16),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
              color: ColorResources.DARK_GREEN_COLOR,
              border: Border.all(
                color:  ColorResources.DARK_GREEN_COLOR,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8)),
          child: DropdownButton(
              borderRadius: BorderRadius.circular(15),
              isExpanded: true,
              iconEnabledColor: ColorResources.BLACK,
              iconDisabledColor: ColorResources.BLACK,
              dropdownColor:ColorResources.DARK_GREEN_COLOR ,
              underline: const SizedBox(),
              value: widget.dropdownValue,
              // For now we use the String Static value
              items:
                  widget.item.map<DropdownMenuItem<dynamic>>((dynamic value) {
                return DropdownMenuItem<dynamic>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        // height: heighht ?? 1,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.fontSize,
                        color: ColorResources.WHITE,
                      ),
                    ));
              }).toList(),
              onChanged: widget.onChanged),
        )
      ],
    );
  }
}
