import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class UpgradePremiumCard extends StatelessWidget {
  const UpgradePremiumCard({
    required this.onPressed,
    this.backgroundColor,
    super.key,
  });

  final Color? backgroundColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(krishiBorderRadius),
      color: backgroundColor ?? Theme.of(context).cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(krishiBorderRadius),
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 250,
            maxWidth: 250,
            minHeight: 250,
            maxHeight: 250,
          ),
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 80,
                  ),
                  child:
                      Lottie.asset("assets/images/upgrade.json", repeat: false),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: _Info(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        const SizedBox(height: 2),
        _subtitle(context),
        const SizedBox(height: 10),
        _price(),
      ],
    );
  }

  Widget _title() {
    return const Text(
      "Katyayani Admin Panel",
    );
  }

  Widget _subtitle(BuildContext context) {
    return Text(
      "Full Access Account",
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _price() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.1),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(10),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 10,
            color: krishiFontColorPallets[0],
            fontWeight: FontWeight.w200,
          ),
          children: [
            TextSpan(
              text: "Active",
              style: TextStyle(
                color: krishiFontColorPallets[1],
              ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
