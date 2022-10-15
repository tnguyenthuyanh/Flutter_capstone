class DebugPrinter {
  final String className;
  String _methodName = "unknown method";
  String _divider = "*********************** DEBUG ***************************";

  DebugPrinter({required this.className});

  void setMethodName({required methodName}) {
    this._methodName = methodName;
  }

  debugPrint(message) {
    print(_divider);
    print("$className : $_methodName - $message");
  }
}
