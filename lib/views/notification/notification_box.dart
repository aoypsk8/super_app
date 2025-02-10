// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/models/notification_model.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/notification/notification_detail.dart';
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
                decoration: BoxDecoration(color: color_fff),
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
    // Group messages by date
    Map<String, List<MessageList>> groupedMessages = {};
    for (var e in homeController.messageList) {
      String dateKey =
          DateFormat("dd MMM yyyy").format(DateTime.parse(e.createAt!));
      if (!groupedMessages.containsKey(dateKey)) {
        groupedMessages[dateKey] = [];
      }
      groupedMessages[dateKey]!.add(e);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 12, right: 12, top: 14),
        child: Column(
          children: groupedMessages.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: TextFont(
                    text: DateFormat("M/yyyy")
                        .format(DateFormat("dd MMM yyyy").parse(entry.key)),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    poppin: true,
                    color: cr_2929,
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var e = entry.value[index];
                    var date = DateTime.parse(e.createAt!);
                    return InkWell(
                      onTap: () {
                        homeController.messageListDetail.value = e;
                        if (!e.isRead!) {
                          homeController.updateMessageStatus(e.id!);
                        }
                        Get.to(() => NotificationDetail());
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: e.isRead!
                              ? Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.05)
                              : color_f4f4,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Image.asset(MyIcon.ic_readNotify),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: widthSizePKList,
                                  child: TextFont(
                                    text: e.title!,
                                    noto: true,
                                    maxLines: 1,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6),
                                SizedBox(
                                  width: widthSizePKList,
                                  child: TextFont(
                                    text: e.body!,
                                    maxLines: 1,
                                    noto: true,
                                    fontSize: 10.5,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 6),
                                TextFont(
                                  text:
                                      DateFormat("dd MMM, HH:mm").format(date),
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                  fontSize: 11,
                                  color: cr_red,
                                  poppin: true,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: entry.value.length,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
