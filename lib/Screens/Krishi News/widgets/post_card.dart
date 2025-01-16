import 'dart:developer';

import 'package:adminpannal/Screens/Krishi%20News/model/krishi_news_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../krishi_news_screen.dart';

class PostCard extends StatefulWidget {

  final KrishiNewsModel post;
  final String mediaType;

  const PostCard({
    super.key,
    required this.post,
    required this.mediaType,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool play = false;

  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == 'video') {
      videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(widget.post.mediaUrl)
      )
        ..initialize().then((_) {
          setState(() {});
        }).catchError((e, s) {
          log('Error initializing video - $e\n$s');
        })
        ..setLooping(true);

      // Listen to video player state changes
      videoPlayerController.addListener(() {

        bool isCompleted = videoPlayerController.value.isCompleted;

        setState(() {
          if (isCompleted) {
            play = false;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.mediaType == 'video') {
      videoPlayerController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 0
        ),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            postAuthorCard(),

            widget.mediaType == 'image'
                ?
            buildImage()
                :
            buildVideo(),

            aboutPostCard(),

          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return Flexible(
      child: Image.network(
        widget.post.mediaUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, event) {

          if (event == null) {
            return child;
          }

          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        },
        errorBuilder: (context, e, s) {
          return const Center(
            child: Icon(
              Icons.error,
            ),
          );
        },
      ),
    );
  }

  Widget buildVideo() {

    if (!videoPlayerController.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    return GestureDetector(
      onTap: () {

        log('Clicked :)');

        if (videoPlayerController.value.isInitialized) {
          if (play) {
            videoPlayerController.pause();
            play = false;
            log('Video Paused');
          } else {
            videoPlayerController.play();
            play = true;
            log('Video Started Playing');
          }

          setState(() {});

        } else {
          log('Video Not Initialized..!!');
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 175,
            child: VideoPlayer(
              videoPlayerController,
            ),
          ),

          if (!play)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  // borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.play_circle_fill,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget postAuthorCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.black,
            child: Image.asset(
              'assets/images/krishi_image.png',
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) {
                return const Icon(
                  Icons.error,
                  size: 10,
                  color: Colors.black,
                );
              },
            ),
          ),

          const SizedBox(width: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.author,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),

              const SizedBox(height: 3),

              Text(
                formatDuration(widget.post.timestamp.toDate()),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const Spacer(),

          const Icon(
            Icons.more_vert,
            color: Colors.black,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget aboutPostCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            // Likes
            IconButton(
              onPressed: () {},
              icon: Icon(
                widget.post.likedBy.isNotEmpty
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 25,
              ),
              color:  widget.post.likedBy.isNotEmpty ? Colors.red : Colors.black,
            ),

            // Likes Count
            Text(
              '${widget.post.likedBy.length}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(width: 20,),

            // Comments
            IconButton(
              onPressed: () {},
              icon: Icon(
                widget.post.isCommentHidden
                    ?
                Icons.comments_disabled_sharp
                    :
                Icons.comment_sharp,
                size: 25,
              ),
              color: Colors.black,
            ),

            // Comments Count
            Text(
              '${widget.post.totalComments}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            widget.post.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          ),
        ),

        const SizedBox(height: 3),

        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            widget.post.caption,
            style: const TextStyle(
              fontSize: 14,
                color: Colors.black
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
