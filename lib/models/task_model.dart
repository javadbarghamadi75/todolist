class Task {
  int taskId;
  String taskTitle;
  String taskDescription;
  String taskDate;
  String taskTime;
  String taskrPiority;
  int taskStatus;

  Task({
    this.taskTitle,
    this.taskDescription,
    this.taskDate,
    this.taskTime,
    this.taskrPiority,
    this.taskStatus,
  });

  Task.withId({
    this.taskId,
    this.taskTitle,
    this.taskDescription,
    this.taskDate,
    this.taskTime,
    this.taskrPiority,
    this.taskStatus,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (taskId != null) {
      map['taskId'] = taskId;
    }
    map['taskTitle'] = taskTitle;
    map['taskDescription'] = taskDescription;
    map['taskDate'] = taskDate;
    map['taskTime'] = taskTime;
    map['taskrPiority'] = taskrPiority;
    map['taskStatus'] = taskStatus;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
      taskId: map['taskId'],
      taskTitle: map['taskTitle'],
      taskDescription: map['taskDescription'],
      taskDate: map['taskDate'],
      taskTime: map['taskTime'],
      taskrPiority: map['taskrPiority'],
      taskStatus: map['taskStatus'],
    );
  }
}
