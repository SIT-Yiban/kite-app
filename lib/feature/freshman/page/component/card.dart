import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common.dart';

class PersonItemCardWidget extends StatefulWidget {
  final String name;
  final Widget lastSeenWidget;
  final Widget locationWidget;
  final VoidCallback? onLoadMore;
  final Widget basicInfoWidget;
  final bool isMale;
  const PersonItemCardWidget({
    required this.basicInfoWidget,
    required this.name,
    required this.lastSeenWidget,
    required this.locationWidget,
    required this.isMale,
    this.onLoadMore,
    Key? key,
  }) : super(key: key);

  @override
  State<PersonItemCardWidget> createState() => _PersonItemCardWidgetState();
}

class _PersonItemCardWidgetState extends State<PersonItemCardWidget> {
  Widget buildMoreButton() {
    return GestureDetector(
      onTap: widget.onLoadMore,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 2, 0, 2),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.red, Colors.orange.shade700]), //背景渐变
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(5.0)), //像素圆角
            boxShadow: const [
              //阴影
              BoxShadow(color: Colors.black54, offset: Offset(7.0, 7.0), blurRadius: 4.0)
            ]),
        child: (buildMateItemRow(
          iconData: Icons.send,
          title: ' ',
          text: '更多信息',
          fontSize: 20,
          context: context,
        )),
      ),
    );
  }

  Widget buildLastSeen() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
      alignment: const Alignment(-1, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.red, Colors.orange.shade700]), //背景渐变
      ),
      child: widget.lastSeenWidget,
    );
  }

  Widget buildLocation() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
      alignment: const Alignment(-1, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.red, Colors.orange.shade700]), //背景渐变
      ),
      child: widget.locationWidget,
    );
  }

  Widget buildContent() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          flex: 6,
          child: Stack(children: [
            Align(
              alignment: const Alignment(0, -0.7),
              child: buildAvatar(name: widget.name),
            ),
            Positioned(
              top: 120,
              left: 0,
              child: buildLastSeen(),
            ),
            Positioned(
              top: 165,
              left: 0,
              child: buildLocation(),
            )
          ]),
        ),
        Expanded(
          flex: 11,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: widget.basicInfoWidget,
          ),
        )
      ],
    );
  }

  Widget buildSexIcon() {
    return Icon(
      widget.isMale ? Icons.male : Icons.female,
      size: 100,
      color: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 10.h,
          right: 10.w,
          width: 100,
          height: 100,
          child: buildSexIcon(),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withAlpha(200),
            borderRadius: BorderRadius.circular(15.0), //像素圆角
            boxShadow: const [
              //阴影
              BoxShadow(color: Colors.black12, offset: Offset(7.0, 7.0), blurRadius: 4.0)
            ],
          ),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width - 20.w,
            child: buildContent(),
          ),
        ),
        Positioned(
          top: 5.h,
          right: 0,
          width: 110.w,
          child: buildMoreButton(),
        ),
      ],
    );
  }
}
