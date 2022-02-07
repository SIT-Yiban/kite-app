/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';

class CourseBottomSheet extends StatelessWidget {
  final Size _deviceSize;
  final String _courseName;
  final String _courseId;
  final String _dynClassId;
  final String _campus;
  final List<String> _courseDetail;

  CourseBottomSheet(
      this._deviceSize, this._courseName, this._courseId, this._dynClassId, this._campus, this._courseDetail,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 600),
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: Container(
          // clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Color.fromARGB(252, 228, 235, 245),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
          ),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Container(
                    alignment: const Alignment(0,0),
                    width: _deviceSize.width * 0.82,
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 228, 235, 245),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: Text(_courseName, style: Theme.of(context).textTheme.headline3),
                  )),
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  height: _deviceSize.height * 0.43,
                  width: _deviceSize.width * 0.7,
                  child: ListView(
                    controller: ScrollController(),
                    scrollDirection: Axis.vertical,
                    // children: _courseDetail.map((detail) => _buildDetailItem(detail)).toList(),
                    children: [
                      Column(
                        children: [
                          _buildDetailItem(context, 'courseId.png', _courseId),
                          _buildDetailItem(context, 'dynClassId.png', _dynClassId),
                          _buildDetailItem(context, 'campus.png', _campus),
                        ],
                      ),
                      Column(
                        children: _courseDetail.map((e) => _buildDetailItem(context, "day.png", e)).toList(),
                      )
                    ],
                  )),
            ],
          )),
    );
  }

  Widget _buildDetailItem(BuildContext context, String iconName, String detail) {
    String iconPath = 'assets/timetable/' + iconName;
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
        child: Row(
          children: [
            Image(
              image: AssetImage(iconPath),
              width: 35,
              height: 35,
            ),
            Container(
              width: 15,
            ),
            Expanded(child: Text(detail, softWrap: true, style: Theme.of(context).textTheme.headline3)),
          ],
        ));
  }
}
