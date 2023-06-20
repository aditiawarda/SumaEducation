
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:video_viewer/video_viewer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerMain extends StatefulWidget {
  const VideoPlayerMain(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.youtubeId, required this.thumbnail, required this.source})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? youtubeId;
  final String? thumbnail;
  final String? source;

  @override
  _VideoPlayerMainState createState() => _VideoPlayerMainState();
}

class _VideoPlayerMainState extends State<VideoPlayerMain>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final VideoViewerController _controller = VideoViewerController();

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  String? getactiveSourceNameName() => _controller.activeSourceName;
  String? getActiveCaption() => _controller.activeCaption;
  bool isFullScreen() => _controller.isFullScreen;
  bool isBuffering() => _controller.isBuffering;
  bool isPlaying() => _controller.isPlaying;

  @override
  void dispose() {
    _controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return
          FadeInUp(
            child: FadeTransition(
              opacity: widget.mainScreenAnimation!,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                child:
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 25, bottom: 10),
                  child: Container(
                      width: double.infinity,
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
                          FutureBuilder<Map<String, VideoSource>>(
                              future: VideoSource.fromM3u8PlaylistUrl(
                                "https://sfux-ext.sfux.info/hls/chapter/105/1588724110/1588724110.m3u8",
                                formatter: (quality) => quality == "Auto" ? "Automatic" : "${quality.split("x").last}p",
                              ),
                              builder: (_, data) {
                                if (data.connectionState == ConnectionState.waiting) {
                                  return
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Container(
                                            alignment: Alignment.center,
                                            height: 210,
                                            width: double.infinity,
                                            child:
                                            Container(
                                              height: 30.0,
                                              width: 30.0,
                                              margin: EdgeInsets.only(
                                                  right: 10),
                                              child: CircularProgressIndicator(
                                                color: Colors.orange,
                                                strokeWidth: 3,
                                              ),
                                            )
                                        )
                                    );
                                } else {
                                  if (data.hasError)
                                    return
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: 210,
                                              width: double.infinity,
                                              child:
                                              Container(
                                                height: 30.0,
                                                width: 30.0,
                                                margin: EdgeInsets.only(
                                                    right: 10),
                                                child: CircularProgressIndicator(
                                                  color: Colors.orange,
                                                  strokeWidth: 3,
                                                ),
                                              )
                                          )
                                      );
                                  else
                                    return
                                      data.hasData
                                          ?
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child:
                                          VisibilityDetector(
                                            key: ObjectKey(VideoPlayerMain),
                                            onVisibilityChanged: (visibility){
                                              if (visibility.visibleFraction == 0 && this.mounted) {
                                                _controller.pause();
                                              } else {
                                                _controller.play();
                                              }
                                            },
                                            child: VideoViewer(
                                              controller: _controller,
                                              autoPlay: true,
                                              defaultAspectRatio: 16 / 9,
                                              source: {
                                                "SubRip Text": VideoSource(
                                                  video: VideoPlayerController
                                                      .network(
                                                    "https://suma.geloraaksara.co.id/uploads/video/"+widget.source!,
                                                  ),
                                                )
                                              },
                                              onFullscreenFixLandscape: true,
                                              style: VideoViewerStyle(
                                                thumbnail: Image.network(
                                                  "https://suma.geloraaksara.co.id/uploads/thumbnail/"+widget.thumbnail!,
                                                ),
                                              ),
                                            )
                                          ),
                                      )
                                          :
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: 210,
                                              width: double.infinity,
                                              child:
                                              Container(
                                                height: 30.0,
                                                width: 30.0,
                                                margin: EdgeInsets.only(
                                                    right: 10),
                                                child: CircularProgressIndicator(
                                                  color: Colors.orange,
                                                  strokeWidth: 3,
                                                ),
                                              )
                                          )
                                      );
                                }
                              }
                      )
                  ),
                )
                ),
              ),
          );
      },
    );
  }

}