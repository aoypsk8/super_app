// ignore_for_file: prefer_const_constructors_in_immutables, sort_child_properties_last, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:super_app/utility/color.dart';

class PullRefresh extends StatefulWidget {
  final VoidCallback? onRefresh;
  final Widget? child;
  final Color bg;
  final RefreshController refreshController;
  PullRefresh({Key? key, required this.onRefresh, required this.child, this.bg = color_f2f2, required this.refreshController}) : super(key: key);

  @override
  State<PullRefresh> createState() => _PullRefreshState();
}

class _PullRefreshState extends State<PullRefresh> with TickerProviderStateMixin {
  AnimationController? _anicontroller, _scaleController;

  @override
  void initState() {
    _anicontroller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _scaleController = AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
    widget.refreshController.headerMode!.addListener(() {
      if (widget.refreshController.headerStatus == RefreshStatus.idle) {
        _scaleController!.value = 0.0;
        _anicontroller!.reset();
      } else if (widget.refreshController.headerStatus == RefreshStatus.refreshing) {
        _anicontroller!.repeat();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.refreshController.dispose();
    _scaleController?.dispose();
    _anicontroller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: CustomHeader(
        refreshStyle: RefreshStyle.Behind,
        onOffsetChange: (offset) {
          if (widget.refreshController.headerMode!.value != RefreshStatus.refreshing) _scaleController!.value = offset / 80.0;
        },
        builder: (c, m) {
          return Container(
            decoration: BoxDecoration(color: widget.bg),
            child: FadeTransition(
              opacity: _scaleController!,
              child: ScaleTransition(
                child: SpinKitThreeBounce(
                  size: 30.0,
                  controller: _anicontroller,
                  itemBuilder: (_, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.grey[300]),
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
      controller: widget.refreshController,
      onRefresh: widget.onRefresh,
      onLoading: () async {
        await Future.delayed(Duration(milliseconds: 1000));
        setState(() {});
        widget.refreshController.loadComplete();
      },
      child: widget.child,
    );
  }
}
