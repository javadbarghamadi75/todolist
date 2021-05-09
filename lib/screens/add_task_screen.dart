import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/helpers/datebase_helper.dart';
import 'package:todolist/models/task_model.dart';
import 'package:todolist/res.dart';

class AddTaskScreen extends StatefulWidget {
  final Task task;

  AddTaskScreen({this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _priority;
  DateTime _dateTime = DateTime.now();
  String _date = '';
  TimeOfDay _timeOfDay = TimeOfDay.now();
  String _time = '';
  String selectedItem = '';

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final DateFormat _timeFormatter = DateFormat('Hm');
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  _openDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (date != null && date != _dateTime) {
      setState(() {
        _dateTime = date;
      });
      _date = _dateFormatter.format(_dateTime);
      print('_date datePicker : $_date');
      _dateController.text = _date;
      // _dateController.text = _dateFormatter.format(date);
    }
  }

  _openTimePicker() async {
    final TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: _timeOfDay,
    );
    if (time != null && time != _timeOfDay) {
      setState(() {
        _timeOfDay = time;
      });
      _time = _timeOfDay.format(context);
      print('_time datePicker : $_time');
      _timeController.text = _time;
      // _timeController.text = _timeOfDay.format(context);
    }
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('_date : $_date');
      Task task = Task(
        title: _title,
        description: _description,
        date: _date,
        time: _time,
        priority: _priority,
      );
      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }
      Navigator.pop(context, DatabaseHelper.instance.getTasksList());
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteTask(widget.task.id);
    Navigator.pop(context);
  }

  @override
  void initState() {
    if (widget.task != null) {
      _title = widget.task.title;
      _description = widget.task.description;
      _date = widget.task.date;
      _time = widget.task.time;
      _priority = widget.task.priority;
    }
    _date = _dateFormatter.format(_dateTime);
    // _dateController.text = _date;
    _dateController.text = _dateFormatter.format(_dateTime);
    print('_date : $_dateTime');
    print('_date : ${_dateFormatter.format(_dateTime)}');

    _time = _timeFormatter.format(_dateTime);
    // _timeController.text = _time;
    _timeController.text = _timeFormatter.format(_dateTime);
    print('_time : $_dateTime');
    print('_date : ${_timeFormatter.format(_dateTime)}');

    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlack,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: size40, vertical: size80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Theme.of(context).primaryColor,
                    size: size30,
                  ),
                ),
                SizedBox(height: size20),
                Text(
                  widget.task == null ? 'Add Task' : 'Update Task',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: size40,
                  ),
                ),
                SizedBox(height: size10),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: size20),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 2,
                          style: TextStyle(fontSize: size18, color: colorWhite),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.text_fields,
                              color: Theme.of(context).primaryColor,
                              size: size30,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            labelText: 'Title',
                            labelStyle: TextStyle(
                                fontSize: size18,
                                color: Theme.of(context).primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                          validator: (input) => input.trim().isEmpty
                              ? 'Please enter a task title'
                              : null,
                          onSaved: (input) => _title = input,
                          initialValue: _title,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: size20),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 1000,
                          style: TextStyle(
                            fontSize: size18,
                            color: colorWhite,
                          ),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.subject_rounded,
                              color: Theme.of(context).primaryColor,
                              size: size30,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            labelText: 'Description',
                            labelStyle: TextStyle(
                              fontSize: size18,
                              color: Theme.of(context).primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                          // validator: (input) => input.trim().isEmpty
                          //     ? 'Please enter a task title'
                          //     : null,
                          onSaved: (input) => _description = input,
                          initialValue: _description,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: size20),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          controller: _dateController,
                          style: TextStyle(fontSize: size18, color: colorWhite),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.date_range_rounded,
                              color: Theme.of(context).primaryColor,
                              size: size30,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            labelText: 'Date',
                            labelStyle: TextStyle(
                                fontSize: size18,
                                color: Theme.of(context).primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                          onTap: _openDatePicker,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: size20),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          controller: _timeController,
                          style: TextStyle(fontSize: size18, color: colorWhite),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.access_time_rounded,
                              color: Theme.of(context).primaryColor,
                              size: size30,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            labelText: 'Time',
                            labelStyle: TextStyle(
                                fontSize: size18,
                                color: Theme.of(context).primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                          onTap: _openTimePicker,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: size20),
                        child: DropdownButtonFormField(
                          isDense: true,
                          dropdownColor: colorBlack,
                          icon: Padding(
                            padding: EdgeInsetsDirectional.only(end: size5),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: size30,
                            ),
                          ),
                          iconEnabledColor: Theme.of(context).primaryColor,
                          items: _priorities.map((String priority) {
                            print('priority : $priority');
                            return DropdownMenuItem(
                              value: priority,
                              child: Text(
                                priority,
                                style: TextStyle(
                                  color: priority == 'Low'
                                      ? Colors.green
                                      : priority == 'Medium'
                                          ? Colors.amber
                                          : priority == 'High'
                                              ? Colors.red
                                              : Theme.of(context).primaryColor,
                                  fontFamily: 'Quicksand',
                                ),
                              ),
                              onTap: () => _priority = priority,
                            );
                          }).toList(),
                          style: TextStyle(
                            fontSize: size18,
                            color: colorWhite,
                          ),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.priority_high_rounded,
                              color: Theme.of(context).primaryColor,
                              size: size30,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: _priority == 'Low'
                                    ? Colors.green
                                    : _priority == 'Medium'
                                        ? Colors.amber
                                        : _priority == 'High'
                                            ? Colors.red
                                            : Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            labelText: 'Priority',
                            labelStyle: TextStyle(
                              fontSize: size18,
                              color: Theme.of(context).primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                          validator: (input) => _priority == null
                              ? 'Please select a priority level'
                              : null,
                          onChanged: (value) {
                            setState(() {
                              _priority = value;
                            });
                          },
                          value: _priority,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: size20),
                        height: size60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(size30),
                        ),
                        child: TextButton(
                          child: Text(
                            widget.task == null ? 'Add' : 'Update',
                            style: TextStyle(
                              color: colorBlack,
                              fontSize: size20,
                            ),
                          ),
                          onPressed: _submit,
                        ),
                      ),
                      widget.task != null
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: size20),
                              height: size60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(size30),
                              ),
                              child: TextButton(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: colorBlack,
                                    fontSize: size20,
                                  ),
                                ),
                                onPressed: _delete,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
