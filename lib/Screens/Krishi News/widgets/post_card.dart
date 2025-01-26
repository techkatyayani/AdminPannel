import 'dart:developer';

import 'package:adminpannal/Screens/Krishi%20News/controller/krishi_news_provider.dart';
import 'package:adminpannal/Screens/Krishi%20News/model/krishi_news_model.dart';
import 'package:adminpannal/Screens/Krishi%20News/post_detail_screen.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../krishi_news_screen.dart';

class PostCard extends StatefulWidget {

  final KrishiNewsModel post;
  final String mediaType;
  final KrishiNewsProvider provider;
  final VoidCallback onDeleted;

  const PostCard({
    super.key,
    required this.post,
    required this.mediaType,
    required this.provider,
    required this.onDeleted,
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
      )..initialize().then((_) {
        setState(() {});
      }).catchError((e, s) {
        log('Error initializing video - $e\n$s');
      })..setLooping(false);


      videoPlayerController.addListener(() {

        bool isCompleted = videoPlayerController.value.isCompleted;

        if (isCompleted) {
          setState(() {
            play = false;
          });
        }
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
    return GestureDetector(
      onTap: () {
        widget.provider.setPostApproved(widget.post.isApproved);
        Navigator.push(context, MaterialPageRoute(builder: (_) => PostDetailScreen(post: widget.post)));
      },
      child: Card(
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

    final height = MediaQuery.of(context).size.height * 0.6 - 10;

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
      child: !videoPlayerController.value.isInitialized
          ?
      const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      )
          :
      SizedBox(
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [

            AbsorbPointer(
              absorbing: true,
              child: VideoPlayer(
                videoPlayerController,
              ),
            ),

            if (!play)
              FittedBox(
                fit: BoxFit.cover,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: height,
                    minWidth: (height / 2) + 20
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                  ),
                  child: const Icon(
                    Icons.play_circle_fill,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              )
          ],
        ),
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

          IconButton(
            onPressed: () {
              Utils.showConfirmBox(
                context: context,
                message: 'Are you sure to delete this post permanently..??',
                onConfirm: () async {

                  Navigator.pop(context);

                  Utils.showLoadingBox(context: context, title: 'Deleting ${widget.post.title} Post..');

                  bool isDeleted = await widget.provider.deletePost(widget.post.id);

                  Navigator.pop(context);

                  if (isDeleted) {
                    Utils.showSnackBar(context: context, message: '${widget.post.title} Post deleted successfully :)');
                    widget.onDeleted.call();
                  } else {
                    Utils.showSnackBar(context: context, message: 'Error deleting ${widget.post.title} Post..!!');
                  }
                },
                onCancel: () {
                  Navigator.pop(context);
                },
                confirmText: 'Delete'
              );
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 20,
            ),
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

            // Comments Count
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
