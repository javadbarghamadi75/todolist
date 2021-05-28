class SubTask {
  int taskId;
  int subTaskId;
  String subTaskTitle;
  // String description;
  // String date;
  // String time;
  // String priority;
  int subTaskStatus;

  SubTask({
    this.taskId,
    this.subTaskTitle,
    // this.description,
    // this.date,
    // this.time,
    // this.priority,
    this.subTaskStatus,
  });

  SubTask.withId({
    this.taskId,
    this.subTaskId,
    this.subTaskTitle,
    // this.description,
    // this.date,
    // this.time,
    // this.priority,
    this.subTaskStatus,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['taskId'] = taskId;
    if (subTaskId != null) {
      map['subTaskId'] = subTaskId;
    }
    map['subTaskTitle'] = subTaskTitle;
    // map['description'] = description;
    // map['date'] = date;
    // map['time'] = time;
    // map['priority'] = priority;
    map['status'] = subTaskStatus;
    return map;
  }

  factory SubTask.fromMap(Map<String, dynamic> map) {
    return SubTask.withId(
      taskId: map['taskId'],
      subTaskId: map['subTaskId'],
      subTaskTitle: map['subTaskTitle'],
      // description: map['description'],
      // date: map['date'],
      // time: map['time'],
      // priority: map['priority'],
      subTaskStatus: map['subTaskStatus'],
    );
  }
}
