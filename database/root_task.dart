class RootTask {
  int id;
  int position;
  String text;
  int completedTaskCount;
  int allTaskCount;
  double completedTaskProcent;
  //double widthContainer;
  //double heightContainer;

  RootTask({this.text, this.id, this.position, this.allTaskCount, this.completedTaskCount, this.completedTaskProcent});

  factory RootTask.fromMap(Map<String, dynamic> json) => RootTask(
    id: json["id"],
    position: json["position"],
    text: json["text"],
    allTaskCount: json["allTaskCount"],
    completedTaskCount: json["completedTaskCount"],
    completedTaskProcent: json["completedTaskProcent"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "position": position,
    "text": text,
    "allTaskCount": allTaskCount,
    "completedTaskCount": completedTaskCount,
    "completedTaskProcent": completedTaskProcent,
  };
}