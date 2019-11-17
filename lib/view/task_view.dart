import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart' as Injection;
import 'package:rx_command/rx_command.dart';

import 'package:tech_demo_app/app_drawer.dart';
import 'package:tech_demo_app/preferences.dart';
import 'package:tech_demo_app/data/task.dart';
import 'package:tech_demo_app/domain/task_list_model.dart';

class TaskViewSettings
{
  TaskViewSettings({this.task, this.update});

  final Task task;
  final bool update;
}

class TaskView extends StatefulWidget {
  static const routeName = "task";

  TaskView(this._settings);

  @override
  State<StatefulWidget> createState() {
    return _TaskViewState();
  }

  Task get task => _settings.task;
  bool get update => _settings.update;

  final TaskViewSettings _settings;
}

class _TaskViewState extends State<TaskView> {
  @override
  void initState() {
    super.initState();

    TaskListModel model = Injection.Container().resolve<TaskListModel>();
    _command = widget.update ? model.commandUpdate : model.commandCreate;
    _commandListener = RxCommandListener(
        _command,
        onValue: (unused) { Navigator.pop(context); },
        onError: (error) { print(error); }
    );

    _nameTextController = TextEditingController(text: widget.task.name);
    _descriptionTextController = TextEditingController(text: widget.task.description);
    _expirationDateTextController = TextEditingController(text: _formattedExpirationDate());
  }

  @override
  void dispose() {
    _commandListener.dispose();

    _nameTextController.dispose();
    _descriptionTextController.dispose();
    _expirationDateTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.update ? "Edit task" : "Create new task"),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder<CommandResult<void>>(
          stream: _command.results,
          builder: (context, snapshot) {
            final loading = snapshot.data != null && snapshot.data.isExecuting;
            return _buildForm(context, loading);
          }
      ),
    );
  }

  _buildForm(context, loading) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: _nameTextController,
                  validator: (value) => _validateName(value),
                  onSaved: (val) => setState(() => widget.task.name = val),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  controller: _descriptionTextController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSaved: (val) => setState(() => widget.task.description = val),
                ),
                SizedBox(height: 15),
                ..._buildExpirationDate(),
                ..._buildPriority(),
                RaisedButton(
                  onPressed: () => _saveChanges(context),
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: loading
                    ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 3))
                    : Text(widget.update ? 'Update' : 'Create'),
                ),
              ]
            )
          )
        )
      )
    );
  }

  List<Widget> _buildExpirationDate() {
    if (!globalPreferences.getShowExpirationDate()) {
      return [];
    }

    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Expiration Date'),
        controller: _expirationDateTextController,
        onTap: () => _selectDate(context),
      ),
      SizedBox(height: 15)
    ];
  }

  List<Widget> _buildPriority() {
    if (!globalPreferences.getShowPriority()) {
      return [];
    }

    return [
      CupertinoSegmentedControl<Priority>(
        padding: EdgeInsets.zero,
        children: {
          Priority.Low: Icon(Icons.flash_on, color: Colors.grey,),
          Priority.Medium: Icon(Icons.flash_on, color: Colors.yellow,),
          Priority.High: Icon(Icons.flash_on, color: Colors.red,)
        },
        onValueChanged: (val) => setState(() => widget.task.priority = val),
        groupValue: widget.task.priority,
      ),
      SizedBox(height: 15)
    ];
  }

  _validateName(value) {
    if (value.isEmpty) {
      return 'Please enter name';
    }

    return null;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.task.expirationDate,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2020, 12, 31)
    );

    if (picked != null && picked != widget.task.expirationDate) {
      setState(() {
        widget.task.expirationDate = picked;
        _expirationDateTextController.text = _formattedExpirationDate();
      });
    }
  }

  _saveChanges(context) {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _command(widget.task);
    }
  }

  String _formattedExpirationDate() => DateFormat.yMMMMd().format(widget.task.expirationDate);

  RxCommand<Task, void> _command;
  RxCommandListener<Task, void> _commandListener;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameTextController;
  TextEditingController _descriptionTextController;
  TextEditingController _expirationDateTextController;
}
