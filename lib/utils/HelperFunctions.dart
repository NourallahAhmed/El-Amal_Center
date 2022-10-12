import 'package:flutter/material.dart';
import 'dart:math' as math;
class HelperFunctions {
  static Widget wrapWithAnimatedBuilder({
    required Animation<Offset> animation,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => FractionalTranslation(
        translation: animation.value,
        child: child,
      ),
    );
  }



  static Widget topWidget(double screenWidth) {
    return Transform.rotate(
      angle: -35 * math.pi / 180,
      child: Container(
        width: 1.2 * screenWidth,
        height: 1.2 * screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          gradient: const LinearGradient(
            begin: Alignment(-0.2, -0.8),
            end: Alignment.bottomCenter,
            colors: [
              Color(0x007CBFCF),
              Color(0xB316BFC4),
            ],
          ),
        ),
      ),
    );
  }

  static Widget bottomWidget(double screenWidth) {
    return Container(
      width: 1.5 * screenWidth,
      height: 1.5 * screenWidth,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment(0.6, -1.1),
          end: Alignment(0.7, 0.8),
          colors: [
            Color(0xDB4BE8CC),
            Color(0x005CDBCF),
          ],
        ),
      ),
    );
  }



//todo  convert list of sessions to map to firebase
  static Map<String, List<int>> convertList(Map<String, List<DateTime>> upcommingMap) {

    print("form Model convertSessionList => coming list  ${upcommingMap}");
    Map<String, List<int>>  map = {};

    List<int> datetimeToInt = [];
    var key = "";

    print(upcommingMap.length);
    //loop over list of entry
    for ( var i = 0 ; i <= upcommingMap.length -1  ; i ++) {
      var key = upcommingMap.keys.elementAt(i);

      var listOfTime = upcommingMap[key];

      //loop over list of datetime
      for (var j = 0 ; j <= listOfTime!.length -1 ; j++){
        datetimeToInt.add(listOfTime[j].millisecondsSinceEpoch);
      }
      // print("befor add to map the list = ${datetimeToInt} , key = ${key}");
      map.addAll({ key : datetimeToInt});
    }

    print("form Model convertSessionList ${map}");
    return map;
  }
}