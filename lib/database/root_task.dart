class RootTask {
  int id;
  int position;
  String text;
  int completedTaskCount;
  int allTaskCount;
  double completedTaskProcent;
  /*double rightMargin;
  double height;
  double updateRightMargin;
  double updateHeight;*/

  RootTask({
    this.text,
    this.id,
    this.position,
    this.allTaskCount,
    this.completedTaskCount,
    this.completedTaskProcent,
    /*this.rightMargin,
      this.height,
      this.updateHeight,
      this.updateRightMargin*/
  });

  factory RootTask.fromMap(Map<String, dynamic> json) => RootTask(
        id: json["id"],
        position: json["position"],
        text: json["text"],
        allTaskCount: json["allTaskCount"],
        completedTaskCount: json["completedTaskCount"],
        completedTaskProcent: json["completedTaskProcent"],
        /*rightMargin: json["rightMargin"],
        height: json["height"],
        updateRightMargin: json["updateRightMargin"],
        updateHeight: json["updateHeight"],*/
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "position": position,
        "text": text,
        "allTaskCount": allTaskCount,
        "completedTaskCount": completedTaskCount,
        "completedTaskProcent": completedTaskProcent,
        /*"rightMargin": rightMargin,
        "height": height,
        "updateRightMargin": updateRightMargin,
        "updateHeight": updateHeight,*/
      };

  @override
  String toString() {
    return "RootTask: $id, $text";
  }
}

class RootTaskNew {
  int id;
  String text;
  int position;
  int completedTaskCount;
  int allTaskCount;
  double completedTaskProcent;
  double rightMargin;
  double height;
  double updateRightMargin;
  double updateHeight;

  RootTaskNew({
    this.id,
    this.text,
    this.position,
    this.completedTaskCount,
    this.allTaskCount,
    this.completedTaskProcent,
    this.rightMargin,
    this.height,
    this.updateHeight,
    this.updateRightMargin,
  });

  factory RootTaskNew.fromMap(Map<String, dynamic> json) => RootTaskNew(
        id: json["id"],
        text: json["text"],
        position: json["position"],
        completedTaskCount: json["completedTaskCount"],
        allTaskCount: json["allTaskCount"],
        completedTaskProcent: json["completedTaskProcent"],
        rightMargin: json["rightMargin"],
        height: json["height"],
        updateHeight: json["updateHeight"],
        updateRightMargin: json["updateRightMargin"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "text": text,
        "position": position,
        "completedTaskCount": completedTaskCount,
        "allTaskCount": allTaskCount,
        "completedTaskProcent": completedTaskProcent,
        "rightMargin": rightMargin,
        "height": height,
        "updateHeight": updateHeight,
        "updateRightMargin": updateRightMargin,
      };

  @override
  String toString() {
    return "RootTaskNew: $id, $text";
  }
}
