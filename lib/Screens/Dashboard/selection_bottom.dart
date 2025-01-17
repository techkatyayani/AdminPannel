import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';

class SelectionButtonData {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  final int? totalNotif;
  final bool isNew;

  SelectionButtonData({
    required this.activeIcon,
    required this.icon,
    required this.label,
    this.totalNotif,
    this.isNew = false,
  });
}

class SelectionButton extends StatefulWidget {

  final int initialSelected;
  final List<SelectionButtonData> data;
  final Function(int index, SelectionButtonData value) onSelected;

  const SelectionButton({
    this.initialSelected = 0,
    required this.data,
    required this.onSelected,
    super.key,
  });

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  int selected = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      selected = widget.initialSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.data.asMap().entries.map((e) {
        final index = e.key;
        final data = e.value;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: _Button(
            selected: selected == index,
            onPressed: () {
              widget.onSelected(index, data);
              setState(() {
                selected = index;
              });
            },
            data: data
          ),
        );
      }).toList(),
    );
  }
}

class _Button extends StatelessWidget {

  final bool selected;
  final SelectionButtonData data;
  final Function() onPressed;

  const _Button({
    required this.selected,
    required this.data,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: (!selected)
          ? Theme.of(context).cardColor
          : Theme.of(context).primaryColor.withOpacity(.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _icon((!selected) ? data.icon : data.activeIcon, context),

              const SizedBox(width: krishiSpacing / 2),

              Expanded(child: _labelText(data.label, context)),

              if (data.totalNotif != null)
                Padding(
                  padding: const EdgeInsets.only(left: krishiSpacing / 2),
                  child: _notif(data.totalNotif!),
                ),

              if (data.isNew)
                _newIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _newIcon() {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Colors.orange.shade400,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 8,
            spreadRadius: 1
          )
        ]
      ),
    );
  }

  Widget _icon(IconData iconData, BuildContext context) {
    return Icon(
      iconData,
      size: 20,
      color: (!selected)
          ? krishiFontColorPallets[1]
          : Theme.of(context).primaryColor,
    );
  }

  Widget _labelText(String data, BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: (!selected)
            ? krishiFontColorPallets[1]
            : Theme.of(context).primaryColor,
        fontWeight: FontWeight.w600,
        letterSpacing: .8,
        fontSize: 13,
      ),
    );
  }

  Widget _notif(int total) {
    return (total <= 0)
        ? Container()
        : Container(
            width: 30,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: krishiNotificationColor,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Text(
              (total >= 100) ? "99+" : "$total",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          );
  }
}
