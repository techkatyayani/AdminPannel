import 'package:adminpannal/constants/app_constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const TodayText(),
        const SizedBox(width: krishiSpacing),
        Expanded(child: SearchField()),
      ],
    );
  }
}

class TodayText extends StatelessWidget {
  const TodayText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today",
            // style: Theme.of(context).textTheme.caption,
          ),
          Text(
            DateTime.now().toIso8601String().substring(0, 10),
          )
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  SearchField({this.onSearch, super.key});

  final controller = TextEditingController();
  final Function(String value)? onSearch;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(EvaIcons.search),
        hintText: "search..",
        isDense: true,
        fillColor: Theme.of(context).cardColor,
      ),
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        if (onSearch != null) onSearch!(controller.text);
      },
      textInputAction: TextInputAction.search,
      style: TextStyle(color: krishiFontColorPallets[1]),
    );
  }
}
