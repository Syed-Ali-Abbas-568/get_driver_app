import 'package:flutter/material.dart';
import 'package:get_driver_app/constants.dart';

// ignore: must_be_immutable
class UserSelector extends StatefulWidget {
  final String mode;
  int userType;
  UserSelector({required this.mode, required this.userType, super.key});

  @override
  State<UserSelector> createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  List<bool> _selections = List.generate(2, (_) => false);

  @override
  void initState() {
    _selections[widget.userType] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: _selections,
      onPressed: (int index) {
        if (index == 1) {
          _selections[0] = false;
          _selections[1] = true;
        } else {
          _selections[0] = true;
          _selections[1] = false;
        }
        setState(() {
          widget.userType = index;
        });
      },
      renderBorder: false,
      fillColor: primaryColor,
      borderRadius: BorderRadius.circular(55),
      selectedBorderColor: primaryColor,
      children: <Widget>[
        Text(
          "${widget.mode} as Client",
          style: TextStyle(
            color: (_selections[0]) ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          "${widget.mode} as Driver ",
          style: TextStyle(
            color: (_selections[1]) ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
