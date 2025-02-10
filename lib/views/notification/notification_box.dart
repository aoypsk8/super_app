// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:intl/intl.dart';

class NotificationBox extends StatefulWidget {
  const NotificationBox({super.key});

  @override
  State<NotificationBox> createState() => _NotificationBoxState();
}

class _NotificationBoxState extends State<NotificationBox>
    with TickerProviderStateMixin {
  AnimationController? _anicontroller, _scaleController;
  final RefreshController _refreshController = RefreshController();
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    _anicontroller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _scaleController =
        AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
    _refreshController.headerMode!.addListener(() {
      if (_refreshController.headerStatus == RefreshStatus.idle) {
        _scaleController!.value = 0.0;
        _anicontroller!.reset();
      } else if (_refreshController.headerStatus == RefreshStatus.refreshing) {
        _anicontroller!.repeat();
      }
    });
    super.initState();
    homeController.fetchMessageList();
  }

  void _onRefresh() async {
    homeController.fetchMessageList();
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scaleController?.dispose();
    _anicontroller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: color_fff,
        appBar: BuildAppBar(title: "titleMessage"),
        body: SmartRefresher(
          header: CustomHeader(
            refreshStyle: RefreshStyle.Behind,
            onOffsetChange: (offset) {
              if (_refreshController.headerMode!.value !=
                  RefreshStatus.refreshing) {
                _scaleController!.value = offset / 80.0;
              }
            },
            builder: (c, m) {
              return Container(
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: FadeTransition(
                  opacity: _scaleController!,
                  child: ScaleTransition(
                    child: SpinKitThreeBounce(
                      size: 30.0,
                      controller: _anicontroller,
                      itemBuilder: (_, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: index.isEven
                                ? Color(0xffd0d3d4)
                                : Color(0xffd0d3d4),
                          ),
                        );
                      },
                    ),
                    scale: _scaleController!,
                  ),
                ),
                alignment: Alignment.center,
              );
            },
          ),
          // enablePullUp: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: () async {
            await Future.delayed(Duration(milliseconds: 1000));
            setState(() {});
            _refreshController.loadComplete();
          },
          child:
              homeController.messageList.isEmpty ? emptyMessage() : messages(),
        ),
      ),
    );
  }

  Widget emptyMessage() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Opacity(
            opacity: 0.2,
            child: Image.asset(
              MyIcon.bg_ic_background,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                MyIcon.notice_animation_empty,
              ),
              SizedBox(height: 10),
              TextFont(
                text: 'emptyPush',
                color: cr_2929,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: 5,
              ),
              TextFont(
                text: 'emptyPush1',
                color: cr_2929,
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget messages() {
    double widthSizePKList = MediaQuery.of(context).size.width - 108;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 12, right: 12, top: 14),
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var e = homeController.messageList[index];
              var date = DateTime.parse(e.createAt!);
              return InkWell(
                  onTap: () {
                    homeController.messageListDetail.value = e;
                    if (!e.isRead!) {
                      homeController.updateMessageStatus(e.id!);
                    }
                    // Get.to(() => NotificationDetail());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: e.isRead! ? color_f4f4 : Color(0x19f14d58),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Colors.grey[300]!.withOpacity(0.7))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          // child: SvgPicture.asset(
                          //   e.isRead!
                          //       ? "assets/icons/inbox_read.svg"
                          //       : "assets/icons/inbox_read.svg",
                          //   width: 6.5.w,
                          // ),
                          child: Icon(Iconsax.sagittarius),
                        ),
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widthSizePKList,
                              child: Flex(
                                direction: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: TextFont(
                                      text: e.title!,
                                      noto: true,
                                      maxLines: 1,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: TextFont(
                                      text: DateFormat("dd MMM, HH:mm")
                                          .format(date),
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      fontSize: 11,
                                      color: cr_red,
                                      poppin: true,
                                    ),
                                    flex: 1,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              width: widthSizePKList,
                              child: TextFont(
                                  text: e.body!,
                                  maxLines: 1,
                                  noto: true,
                                  fontSize: 10.5,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 6,
                            )
                          ],
                        )
                      ],
                    ),
                  ));
            },
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
            itemCount: homeController.messageList.length),
      ),
    );
  }
}
