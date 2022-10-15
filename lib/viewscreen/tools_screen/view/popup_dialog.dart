import 'package:flutter/material.dart';

class PopupDialog {
  static void circularProgressStart(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          strokeWidth: 10.0,
        ),
      ),
    );
  }

  static void circularProgressStop(BuildContext context) {
    Navigator.pop(context);
  }

  static void info({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          MaterialButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.button,
              ))
        ],
      ),
    );
  }

  static void statefulPopUp(
      {required BuildContext context,
      required String title,
      required int animationTransitionDelay,
      required List<Widget> widgetList}) {
    showGeneralDialog(
      context: context,
      useRootNavigator: false,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: animationTransitionDelay),
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
              title: Center(child: Text(title)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: widgetList,
              ),
            );
          }),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        Tween<Offset> tween;
        if (animation.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}
