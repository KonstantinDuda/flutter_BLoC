class ChackTask {
  int id;
  int position;
  String text;
  int rootID;
  bool chack;
  /*int allTaskCount;
  int completedTaskCount;
  double completedTaskProcent;*/

  ChackTask({this.text, this.id, this.position, this.rootID, this.chack});

  factory ChackTask.fromMap(Map<String, dynamic> json) => ChackTask(
    id: json["id"],
    position: json["position"],
    text: json["text"],
    rootID: json["RootID"],
    chack: json["chack"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "position": position,
    "text": text,
    "rootID": rootID,
    "chack": chack,
  };
}