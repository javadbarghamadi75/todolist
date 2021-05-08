class Task {
  int id;
  String title;
  String description;
  String date;
  String time;
  String priority;
  int status;

  Task({
    this.title,
    this.description,
    this.date,
    this.time,
    this.priority,
    this.status,
  });

  Task.withId({
    this.id,
    this.title,
    this.description,
    this.date,
    this.time,
    this.priority,
    this.status,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['description'] = description;
    map['date'] = date;
    map['time'] = time;
    map['priority'] = priority;
    map['status'] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      time: map['time'],
      priority: map['priority'],
      status: map['status'],
    );
  }
}
