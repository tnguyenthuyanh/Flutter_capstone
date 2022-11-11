class DebugPrinter {
  final String className;
  String _methodName = "unknown method";
  String _divider = "*********************** DEBUG ***************************";
  bool? printOff;

  DebugPrinter({required this.className, this.printOff});

  void setPrintOff({required printOff}) {
    this.printOff = printOff;
  }

  void setMethodName({required methodName}) {
    this._methodName = methodName;
  }

  debugPrint(message) {
    if (printOff == null || !printOff!) {
      print(_divider);
      print("$className : $_methodName - $message");
    }
  }
}
