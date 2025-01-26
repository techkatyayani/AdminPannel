import 'package:adminpannal/Screens/Krishi%20News/controller/krishi_news_provider.dart';
import 'package:adminpannal/Screens/Krishi%20News/widgets/custom_post_text_field.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'model/krishi_news_model.dart';

class PostDetailScreen extends StatefulWidget {

  final KrishiNewsModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {

  late TextEditingController postTitleController;
  late TextEditingController postCaptionController;
  late TextEditingController postAuthorController;
  late TextEditingController postAuthorIdController;

  VideoPlayerController? videoPlayerController;



  @override
  void initState() {
    super.initState();

    postTitleController = TextEditingController(text: widget.post.title);
    postCaptionController = TextEditingController(text: widget.post.caption);
    postAuthorController = TextEditingController(text: widget.post.author);
    postAuthorIdController = TextEditingController(text: widget.post.authorId);

    initVideoController();
  }

  initVideoController() {
    if (widget.post.mediaType == 'video') {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.post.mediaUrl)
      )..initialize().then((_) {
        setState(() {});
      })..setLooping(true);
    }
  }

  @override
  void dispose() {
    postTitleController.dispose();
    postCaptionController.dispose();
    postAuthorController.dispose();
    postAuthorIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Post',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const SizedBox(),

                    Center(
                      child: widget.post.mediaType == 'image'
                          ?
                      Image.network(
                        widget.post.mediaUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stace) {
                          return const Icon(
                            Icons.error
                          );
                        },
                      )
                          :
                      videoPlayerController != null
                          ?
                      AspectRatio(
                        aspectRatio: videoPlayerController!.value.aspectRatio,
                        child: videoPlayerController!.value.isInitialized
                            ?
                        VideoPlayer(
                          videoPlayerController!,
                        )
                            :
                        const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      )
                          :
                      const SizedBox(),
                    ),

                    Consumer<KrishiNewsProvider>(
                      builder: (context, provider, child) {
                        return GestureDetector(
                          onTap: () {
                            if (!provider.isApproving) {
                              provider.updatePostApproval(
                                postId: widget.post.id,
                                status: !provider.isPostApproved,
                              );
                            }
                          },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.only(right: 15),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: provider.isPostApproved ? Colors.red : Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: provider.isApproving
                                ?
                            const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                :
                            Text(
                              provider.isPostApproved ? 'Disapprove' : 'Approve',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                              ),
                            ),
                          ),
                        );
                      }
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              _postDetailRow(
                controller: postAuthorIdController,
                text: 'Post Author Id',
                enabled: false,
              ),

              const SizedBox(height: 10),

              _postDetailRow(
                controller: postAuthorController,
                text: 'Post Author',
                enabled: false,
              ),

              const SizedBox(height: 25),

              _postDetailRow(
                controller: postTitleController,
                text: 'Post Title',
                enabled: false,
              ),

              const SizedBox(height: 10),

              _postDetailRow(
                controller: postCaptionController,
                text: 'Post Caption',
                enabled: false,
              ),

              const SizedBox(height: 10),



              // const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _postDetailRow({
    required String text,
    required TextEditingController controller,
    bool enabled = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ),

        const SizedBox(width: 10),
        
        Expanded(
          child: CustomTextField(
            controller: controller,
            hintText: text,
            enabled: enabled,
          )
        )
        
      ],
    );
  }
}
