class CheckTask {
  int id;
  int position;
  String text;
  int rootID;
  int check;
  /*int allTaskCount;
  int completedTaskCount;
  double completedTaskProcent;*/

  CheckTask({this.text, this.id, this.position, this.rootID, this.check});

  factory CheckTask.fromMap(Map<String, dynamic> json) => CheckTask(
    id: json["id"],
    position: json["position"],
    text: json["text"],
    rootID: json["rootID"],
    check: json["checkBox"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "position": position,
    "text": text,
    "rootID": rootID,
    "checkBox": check,
  };
}