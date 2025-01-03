import 'package:adminpannal/Screens/Krishi%20News/model/krishi_news_model.dart';
import 'package:flutter/material.dart';

import '../krishi_news_screen.dart';

class PostCard extends StatelessWidget {

  final String mediaType;
  final KrishiNewsModel post;

  const PostCard({
    super.key,
    required this.mediaType,
    required this.post,
  });

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
          children: [

            postAuthorCard(),

            mediaType == 'image'
                ?
            Flexible(
              child: Image.network(
                post.mediaUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, e, s) {
                  return const Center(
                    child: Icon(
                      Icons.error,
                    ),
                  );
                },
              ),
            )
                :
            const SizedBox(),

            aboutPostCard(),

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
                post.author,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),

              const SizedBox(height: 3),

              Text(
                formatDuration(post.timestamp.toDate()),
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
                post.likedBy.isNotEmpty
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 25,
              ),
              color:  post.likedBy.isNotEmpty ? Colors.red : Colors.black,
            ),

            // Likes Count
            Text(
              '${post.likedBy.length}',
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
                post.isCommentHidden
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
              '${post.totalComments}',
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
            post.title,
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
            post.caption,
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
