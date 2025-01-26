import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProjectCardData {
  final double percent;
  final ImageProvider projectImage;
  final String projectName;
  final DateTime releaseTime;

  const ProjectCardData({
    required this.projectImage,
    required this.projectName,
    required this.releaseTime,
    required this.percent,
  });
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    required this.data,
    super.key,
  });

  final ProjectCardData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProgressIndicator(
          percent: data.percent,
          center: _ProfilImage(image: data.projectImage),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TitleText(data.projectName),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'Last Updated:',
                    style: TextStyle(fontSize: 11, color: krishiFontColorPallets[2]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(width: 5),

                  _ReleaseTimeText(data.releaseTime)
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    required this.percent,
    required this.center,
  });

  final double percent;
  final Widget center;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 60,
      lineWidth: 2.0,
      percent: percent,
      center: center,
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: Colors.blueGrey,
      progressColor: Theme.of(context).primaryColor,
    );
  }
}

class _ProfilImage extends StatelessWidget {
  const _ProfilImage({required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: image,
      radius: 24,
      backgroundColor: Colors.white,
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText(this.data);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data.capitalize!,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: krishiFontColorPallets[0],
        letterSpacing: 0.8,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ReleaseTimeText extends StatelessWidget {
  const _ReleaseTimeText(this.date);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: krishiNotificationColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
      child: Text(
        date.toIso8601String().substring(0, 10),
        style: const TextStyle(fontSize: 9, color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
