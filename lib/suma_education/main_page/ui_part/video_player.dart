
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerMain extends StatefulWidget {
  const VideoPlayerMain(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.youtubeId})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? youtubeId;

  @override
  _VideoPlayerMainState createState() => _VideoPlayerMainState();
}

class _VideoPlayerMainState extends State<VideoPlayerMain>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late YoutubePlayerController _controller;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.youtubeId!,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: false,
        showVideoAnnotations: false,
        strictRelatedVideos: false,
        showControls: true
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return
          FadeInUp(
            delay: Duration(milliseconds: 800),
            child: FadeTransition(
              opacity: widget.mainScreenAnimation!,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                child:
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 15, bottom: 0),
                    child: Container(
                      child:
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, top: 25, bottom: 10),
                            child: Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: AppTheme.grey.withOpacity(0.2),
                                            offset: Offset(0.0, 1.0), //(x,y)
                                            blurRadius: 2.0),
                                      ],
                                    ),
                                    child:
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child:
                                      YoutubePlayer(
                                        controller: _controller,
                                        aspectRatio: 16 / 9,
                                      ),
                                    )
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ),
              ),
          );
      },
    );
  }
}

