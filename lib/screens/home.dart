import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kt_drawer_menu/kt_drawer_menu.dart';
import 'package:lottie/lottie.dart';
import 'package:todolist/helpers/datebase_helper.dart';
import 'package:todolist/models/task_model.dart';
import 'package:todolist/res.dart';
import 'package:todolist/screens/add_task_screen.dart';
import 'package:todolist/screens/main_page.dart';

class Home extends StatefulWidget {
  final StreamController<DrawerItemEnum> streamController;

  Home({Key key, this.streamController}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DrawerItemEnum selected;
  Future<List<Task>> _tasksList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  bool isSnapshotWaiting = false;

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

  Color _getColor(DrawerItemEnum menu) {
    switch (menu) {
      case DrawerItemEnum.DASHBOARD:
        return Colors.blue;
      case DrawerItemEnum.MESSAGE:
        return Colors.green;
      case DrawerItemEnum.SETTINGS:
        return Colors.purple;
      case DrawerItemEnum.ABOUT:
        return Colors.orange;
      case DrawerItemEnum.HELP:
        return Colors.yellow;
      default:
        return Colors.white;
    }
  }

  String _getTitle(DrawerItemEnum menu) {
    switch (menu) {
      case DrawerItemEnum.DASHBOARD:
        return "DASHBOARD";
      case DrawerItemEnum.MESSAGE:
        return "MESSAGE";
      case DrawerItemEnum.SETTINGS:
        return "SETTINGS";
      case DrawerItemEnum.ABOUT:
        return "ABOUT";
      case DrawerItemEnum.HELP:
        return "HELP";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.streamController.stream,
        initialData: DrawerItemEnum.DASHBOARD,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: colorBlack,
            body: FutureBuilder(
              future: DatabaseHelper.instance.getTasksList(),
              builder: (BuildContext buildContext,
                  AsyncSnapshot<List<Task>> snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  isSnapshotWaiting = true;
                  return Center(child: CircularProgressIndicator());
                }

                final int completedTaskCount = snapshot.data
                    .where((Task task) => task.taskStatus == 1)
                    .toList()
                    .length;

                if (snapshot.connectionState == ConnectionState.done) {
                  isSnapshotWaiting = false;
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
                              // ListTile(
                              //   contentPadding: EdgeInsets.zero,
                              //   tileColor: Colors.red,
                              //   // backgroundColor: _getColor(selected),
                              //   // elevation: 0.0,
                              //   leading: IconButton(
                              //     icon: Icon(
                              //       Icons.dehaze,
                              //       color: colorWhite,
                              //     ),
                              //     onPressed: () {
                              //       KTDrawerMenu.of(context).toggle();
                              //     },
                              //   ),
                              //   title: Text(
                              //     _getTitle(selected),
                              //     style: TextStyle(
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                              GestureDetector(
                                onTap: () =>
                                    KTDrawerMenu.of(context).openDrawer(),
                                child: Icon(
                                  Icons.dehaze_rounded,
                                  color: Theme.of(context).primaryColor,
                                  size: size30,
                                ),
                              ),
                              SizedBox(height: size20),
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
                              snapshot.data.length == 0
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size80),
                                      child: Center(
                                        child: Lottie.asset(
                                          'assets/lottie/home_empty_animation5.json',
                                          fit: BoxFit.fill,
                                          frameRate: FrameRate(1500),
                                          repeat: true,
                                          reverse: true,
                                          animate: true,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        );
                      }
                      return _createTask(snapshot.data[index - 1]);
                    },
                  );
                }
                return Center(
                  child: Text(
                    'Something Went Wrong...',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorWhite,
                      fontSize: size18,
                      decoration: TextDecoration.none,
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: isSnapshotWaiting == false
                ? FloatingActionButton.extended(
                    isExtended: true,
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
                  )
                : Container(height: 0, width: 0),
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
        });
  }

  Widget _createTask(Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size25),
      child: Column(
        children: [
          task.taskStatus == 0
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: size13,
                        vertical: size5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      tileColor:
                          Theme.of(context).primaryColor.withOpacity(0.5),
                      title: Text(
                        task.taskTitle,
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
                          // SizedBox(height: size3),
                          // Divider(color: colorGrey300),
                          task.taskDescription != ''
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size10, vertical: size5),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: size5),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: task.taskrPiority == 'Low'
                                        ? colorBlack.withOpacity(0.3)
                                        : task.taskrPiority == 'Medium'
                                            ? colorBlack.withOpacity(0.3)
                                            : colorBlack.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(size10),
                                  ),
                                  child: Text(
                                    '${task.taskDescription}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: colorGrey300,
                                      fontSize: size18,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                )
                              : Container(height: 0, width: 0),
                          Divider(color: colorGrey300),
                          SizedBox(height: size5),
                          Text(
                            '${task.taskDate}  |  ${task.taskTime}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: colorGrey300,
                              fontSize: size15,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(height: 3),
                          // Chip(
                          //   shape: ContinuousRectangleBorder(
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          //   side: BorderSide(
                          //     color: task.taskrPiority == 'Low'
                          //         ? lowGreen
                          //         : task.taskrPiority == 'Medium'
                          //             ? mediumAmber
                          //             : highRed,
                          //   ),
                          //   shadowColor: Colors.transparent,
                          //   backgroundColor: Colors.black,
                          //   labelStyle: TextStyle(
                          //     fontWeight: FontWeight.w500,
                          //     // color: colorBlack,
                          //     color: task.taskrPiority == 'Low'
                          //         ? lowGreen
                          //         : task.taskrPiority == 'Medium'
                          //             ? mediumAmber
                          //             : highRed,
                          //     fontSize: size15,
                          //     decoration: TextDecoration.none,
                          //   ),
                          //   // padding: EdgeInsets.zero,
                          //   label: Text('${task.taskrPiority}'),
                          //   // backgroundColor: task.taskrPiority == 'Low'
                          //   //     ? Colors.green
                          //   //     : task.taskrPiority == 'Medium'
                          //   //         ? Colors.amber
                          //   //         : Colors.red,
                          // ),
                          Text(
                            '${task.taskrPiority}',
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
                          value: task.taskStatus == 1 ? true : false,
                          onChanged: (value) {
                            task.taskStatus = value ? 1 : 0;
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
              : ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: size13,
                    vertical: size5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: colorBlack,
                  title: Text(
                    task.taskTitle,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: task.taskStatus == 0 ? colorWhite : colorGrey500,
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
                        '${task.taskDate}  |  ${task.taskTime}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: colorGrey500,
                          fontSize: size15,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '${task.taskrPiority}',
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
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete_forever_rounded,
                      color: colorWhite,
                      size: size30,
                    ),
                    onPressed: () {
                      DatabaseHelper.instance.deleteTask(task.taskId);
                      _updateTasksList();
                    },
                  ),
                  onLongPress: () {
                    if (task.taskStatus == 1) {
                      task.taskStatus = 0;
                      DatabaseHelper.instance.updateTask(task);
                      _updateTasksList();
                    }
                  },
                ),
          Divider(color: colorGrey900)
        ],
      ),
    );
  }
}
