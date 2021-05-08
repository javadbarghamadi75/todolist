import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/helpers/datebase_helper.dart';
import 'package:todolist/models/task_model.dart';
import 'package:todolist/res.dart';
import 'package:todolist/screens/add_task_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Task>> _tasksList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    _updateTasksList();
    super.initState();
  }

  _updateTasksList() {
    setState(() {
      _tasksList = DatabaseHelper.instance.getTasksList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlack,
      body: FutureBuilder(
        future: DatabaseHelper.instance.getTasksList(),
        builder:
            (BuildContext buildContext, AsyncSnapshot<List<Task>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final int completedTaskCount = snapshot.data
              .where((Task task) => task.status == 1)
              .toList()
              .length;

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: size80),
            itemCount: 1 + snapshot.data.length,
            itemBuilder: (BuildContext buildContext, int index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size40,
                    vertical: size20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Tasks',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size40,
                          color: colorWhite,
                        ),
                      ),
                      SizedBox(height: size10),
                      Text(
                        '$completedTaskCount of ${snapshot.data.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size20,
                          color: colorGrey500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return _createTask(snapshot.data[index - 1]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(
          Icons.add_rounded,
          color: colorBlack,
          size: size30,
        ),
        label: Text(
          'New Task',
          style: TextStyle(
            fontSize: size18,
            color: colorBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          print('FloatingActionButton Clicked');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          ).then((value) => this.setState(() {}));
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // bottomNavigationBar: BottomAppBar(
      //   elevation: 0,
      //   // shape: AutomaticNotchedShape(
      //   //   RoundedRectangleBorder(side: BorderSide()),
      //   //   StadiumBorder(
      //   //     side: BorderSide(),
      //   //   ),
      //   // ),
      //   color: colorBlack,
      //   child: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       IconButton(
      //         icon: Icon(
      //           Icons.sort_rounded,
      //           color: colorWhite,
      //           size: size30,
      //         ),
      //         onPressed: () {},
      //       ),
      //       IconButton(
      //         icon: Icon(
      //           Icons.search,
      //           color: colorWhite,
      //           size: size30,
      //         ),
      //         onPressed: () {},
      //       ),
      //       IconButton(
      //         icon: Icon(
      //           Icons.palette_rounded,
      //           color: colorWhite,
      //           size: size30,
      //         ),
      //         onPressed: () {},
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _createTask(Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size25),
      child: Column(
        children: [
          task.status == 0
              ? ClipRRect(
                  //Active
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: size13,
                        vertical: size5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      tileColor: task.priority == 'Low'
                          ? lowGreen
                          : task.priority == 'Medium'
                              ? mediumAmber
                              : highRed,
                      title: Text(
                        task.title,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colorWhite,
                          fontSize: size18,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(color: colorGrey300),
                          Text(
                            '${task.description}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: colorGrey300,
                              fontSize: size15,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(height: size5),
                          Text(
                            '${task.date}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: colorGrey300,
                              fontSize: size15,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '${task.priority}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: colorGrey300,
                              // color: task.priority == 'Low'
                              //     ? lowGreen
                              //     : task.priority == 'Medium'
                              //         ? mediumAmber
                              //         : highRed,
                              fontSize: size15,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      trailing: Transform.scale(
                        scale: 1.1,
                        child: Checkbox(
                          activeColor: colorBlack,
                          value: task.status == 1 ? true : false,
                          onChanged: (value) {
                            task.status = value ? 1 : 0;
                            DatabaseHelper.instance.updateTask(task);
                            _updateTasksList();
                          },
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddTaskScreen(
                              task: task,
                            ),
                          ),
                        ).then((value) => this.setState(() {}));
                      }),
                )
              : ClipRRect(
                  //deActive
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: size13,
                      vertical: size5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: colorBlack,
                    title: Text(
                      task.title,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: task.status == 0 ? colorWhite : colorGrey500,
                        fontSize: size18,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Divider(color: colorGrey300),
                        SizedBox(height: size5),
                        Text(
                          '${task.date}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: colorGrey500,
                            fontSize: size15,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '${task.priority}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: colorGrey500,
                            // color: task.priority == 'Low'
                            //     ? lowGreen
                            //     : task.priority == 'Medium'
                            //         ? mediumAmber
                            //         : highRed,
                            fontSize: size15,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    trailing: Transform.scale(
                      scale: 1.3,
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_forever_rounded,
                          color: colorWhite,
                        ),
                        onPressed: () {
                          DatabaseHelper.instance.deleteTask(task.id);
                          _updateTasksList();
                        },
                      ),
                    ),
                    onLongPress: () {
                      if (task.status == 1) {
                        task.status = 0;
                        DatabaseHelper.instance.updateTask(task);
                        _updateTasksList();
                      }
                    },
                  ),
                ),
          Divider(color: colorGrey900)
        ],
      ),
    );
  }
}
