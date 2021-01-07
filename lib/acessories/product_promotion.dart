
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Bussiness/BussinessHandler.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:video_player/video_player.dart';

class StorePromotion extends StatefulWidget {
  ProductDTO dto;
  StorePromotion(this.dto);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StorePromotionState();
  }
}

class _StorePromotionState extends State<StorePromotion> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: kBackgroundGrey[0],
      padding: EdgeInsets.all(8.0),
      child: Material(
        elevation: 20,
        color: kBackgroundGrey[0],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: Get.height / 5,
                  child: ClipPath(
                    clipper: PrimaryCippler(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Color(0xfff68741),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Text(
                              widget.dto.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decorationThickness: 0.5),
                            )),
                            Row(
                              children: [
                                Text(
                                  BussinessHandler.beanReward(
                                          widget.dto.prices[0])
                                      .toString(),
                                  style: TextStyle(color: kBean),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: kBean)),
                                    child: Center(
                                        child: Text(
                                      "Bean",
                                      style: TextStyle(color: kBean),
                                    ))),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(
                        widget.dto.description ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )),
                      OutlineButton(
                        onPressed: (){
                          Get.to(VideoPlayerTest());
                        },
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Text(
                          "Nhận quà",
                          style: TextStyle(color: Colors.orange),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryCippler extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    path.lineTo(0, size.height * 0.7);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height * 0.7);

    var secondControlPoint = new Offset(3 * size.width / 4, size.height * 0.45);
    var secondEndPoint = new Offset(size.width, size.height * 0.7);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return oldClipper != this;
  }
}

class VideoPlayerTest extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SecondaryCippler();
  }

}

class SecondaryCippler extends State<VideoPlayerTest> {

  VideoPlayerController _controller;

  double _aspectRatio = 16 / 9;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: _controller.value.initialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
