class CheckTask {
  int id;
  int position;
  String text;
  int rootID;
  int check;
  /*double rightMargin;
  double height;
  double updateRightMargin;
  double updateHeight;*/

  CheckTask({
    this.text,
    this.id,
    this.position,
    this.rootID,
    this.check,
    /*this.rightMargin,
      this.height,
      this.updateRightMargin,
      this.updateHeight*/
  });

  factory CheckTask.fromMap(Map<String, dynamic> json) => CheckTask(
        id: json["id"],
        position: json["position"],
        text: json["text"],
        rootID: json["rootID"],
        check: json["checkBox"],
        /*rightMargin: json["rightMargin"],
        height: json["height"],
        updateRightMargin: json["updateRightMargin"],
        updateHeight: json["updateHeight"],*/
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "position": position,
        "text": text,
        "rootID": rootID,
        "checkBox": check,
        /*"rightMargin": rightMargin,
        "height": height,
        "updateRightMargin": updateRightMargin,
        "updateHeight": updateHeight,*/
      };

  @override
  String toString() {
    return "CheckTask: $id, $text";
  }
}

class CheckTaskNew {
  int id;
  String text;
  int position;
  int rootID;
  int check;
  double height;
  double rightMargin;
  double updateHeight;
  double updateRightMargin;

  CheckTaskNew(
      {this.id,
      this.text,
      this.position,
      this.rootID,
      this.check,
      this.height,
      this.rightMargin,
      this.updateHeight,
      this.updateRightMargin});

  factory CheckTaskNew.fromMap(Map<String, dynamic> json) => CheckTaskNew(
        id: json["id"],
        text: json["text"],
        position: json["position"],
        rootID: json["rootID"],
        check: json["checkBox"],
        height: json["height"],
        rightMargin: json["rightMargin"],
        updateHeight: json["updateHeight"],
        updateRightMargin: json["updateRightMargin"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "text": text,
        "position": position,
        "rootID": rootID,
        "checkBox": check,
        "height": height,
        "rightMargin": rightMargin,
        "updateHeight": updateHeight,
        "updateRightMargin": updateRightMargin,
      };

  @override
  String toString() {
    return "CheckTaskNew:  id: $id, text: $text";
  }
}
