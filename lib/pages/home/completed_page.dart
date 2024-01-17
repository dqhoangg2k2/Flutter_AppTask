import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_api_adv/components/app_dialog.dart';
import 'package:task_api_adv/components/snack_bar/td_snack_bar.dart';
import 'package:task_api_adv/components/snack_bar/top_snack_bar.dart';
import 'package:task_api_adv/components/td_search_box.dart';
import 'package:task_api_adv/models/task_model.dart';
import 'package:task_api_adv/pages/home/widgets/card_task.dart';
import 'package:task_api_adv/resources/app_color.dart';
import 'package:task_api_adv/services/remote/body/task_body.dart';
import 'package:task_api_adv/services/remote/task_services.dart';
import 'package:task_api_adv/utils/enum.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  final searchController = TextEditingController();
  final editController = TextEditingController();
  final editFocus = FocusNode();
  bool isLoading = false;

  ///===========================///
  TaskServices taskServices = TaskServices();
  List<TaskModel> tasks = [];
  List<TaskModel> tasksSearch = [];

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getCompletedTasks();
  }

  // Get List Task Completed
  Future<void> _getCompletedTasks() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1600));

    final query = {
      'status': StatusType.DONE.name,
      'deleted': false,
    };

    taskServices.getListTask(queryParams: query).then((value) {
      tasks = value ?? [];
      // tasksSearch = [...tasks];
      _search(searchController.text);
      setState(() => isLoading = false);
      Timer(const Duration(milliseconds: 360), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 30.0,
          duration: const Duration(milliseconds: 3200),
          curve: Curves.fastOutSlowIn,
        );
      });
    }).catchError((onError) {
      String? error = onError.message;
      showTopSnackBar(
        context,
        TDSnackBar.error(
          message: '${error ?? 'Server error'} 😐',
        ),
      );
      setState(() => isLoading = false);
    });
  }

  void _updateTask(TaskBody body) {
    taskServices.updateTask(body).then((response) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        // tasks.singleWhere((element) => element.id == body.id)
        //   ..name = body.name
        //   ..description = body.description
        //   ..status = body.status;
        // tasksSearch.singleWhere((element) => element.id == body.id)
        //   ..name = body.name
        //   ..description = body.description
        //   ..status = body.status;

        // if (body.status == StatusType.PROCESSING.name) {
        //   tasks.removeWhere((element) => element.id == body.id);
        //   tasksSearch.removeWhere((element) => element.id == body.id);
        // }

        tasks.removeWhere((element) => element.id == body.id);
        tasksSearch.removeWhere((element) => element.id == body.id);
        // chỉ cần này thôi , do xóa đi rồi đâu cần hiện giao diện nữa
        setState(() {});
      } else {
        print('object message ${data['message']}');
      }
    }).catchError((onError) {
      print('object $onError');
    });
  }
  void _updateTaskonSave(TaskBody body) {
    taskServices.updateTask(body).then((response) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        // tasks.singleWhere((element) => element.id == body.id)
        //   ..name = body.name
        //   ..description = body.description
        //   ..status = body.status;
        // tasksSearch.singleWhere((element) => element.id == body.id)
        //   ..name = body.name
        //   ..description = body.description
        //   ..status = body.status;

        // if (body.status == StatusType.PROCESSING.name) {
        //   tasks.removeWhere((element) => element.id == body.id);
        //   tasksSearch.removeWhere((element) => element.id == body.id);
        // }

        tasks.removeWhere((element) => element.id == body.id);
        tasksSearch.removeWhere((element) => element.id == body.id);
        // chỉ cần này thôi , do xóa đi rồi đâu cần hiện giao diện nữa
        setState(() {});
      } else {
        print('object message ${data['message']}');
      }
    }).catchError((onError) {
      print('object $onError');
    });
  }

  
  void _updateTaskSave(TaskBody body) {
    taskServices.updateTask(body).then((response) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        tasks.singleWhere((element) => element.id == body.id)
          ..name = body.name
          ..description = body.description
          ..status = body.status;
        tasksSearch.singleWhere((element) => element.id == body.id)
          ..name = body.name
          ..description = body.description
          ..status = body.status;

        if (body.status == StatusType.PROCESSING.name) {
          tasks.removeWhere((element) => element.id == body.id);
          tasksSearch.removeWhere((element) => element.id == body.id);
        }

        tasks.removeWhere((element) => element.id == body.id);
        tasksSearch.removeWhere((element) => element.id == body.id);
        // chỉ cần này thôi , do xóa đi rồi đâu cần hiện giao diện nữa
        setState(() {});
      } else {
        print('object message ${data['message']}');
      }
    }).catchError((onError) {
      print('object $onError');
    });
  }

  void _deleteTask(String id) {
    taskServices.deleteTask(id).then((response) {
      final data = jsonDecode(response.body);
      if (data['status_code'] == 200) {
        tasks.removeWhere((element) => (element.id ?? '') == id);
        tasksSearch.removeWhere((element) => (element.id ?? '') == id);
        setState(() {});
      } else {
        print('object message ${data['message']}');
      }
    }).catchError((onError) {
      print('object $onError');
    });
  }

  void _search(String value) {
    value = value.toLowerCase();
    setState(() {
      tasksSearch = tasks
          .where(
              (element) => (element.name ?? '').toLowerCase().contains(value))
          .toList();
    });
  }

  void _onEdit(TaskModel task) {
    setState(() {
      // close all edit task before open new edit task
      for (var element in tasks) {
        element.isEditing = false;
      }
      task.isEditing = true; // soạn thảo
      editController.text = task.name ?? '';
      editFocus.requestFocus(); // hiện nháy nhập trong ô textFile
    });
  }

  void _onDeleted(TaskModel task) {
    AppDialog.dialog(
      context,
      title: '😐',
      content: 'Do you want to delete this task?',
      action: () => _deleteTask(task.id ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    //setState chạy lại method build , setState ko chạy lại const
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TdSearchBox(
            controller: searchController,
            onChanged: (value) => setState(() => _search(value)),
          ),
        ),
        const SizedBox(height: 16.0),
        const Divider(
          height: 2.0,
          indent: 20.0,
          endIndent: 20.0,
          color: AppColor.primary,
        ),
        Expanded(
          child: RefreshIndicator(
            color: AppColor.primary,
            onRefresh: () async {
              _getCompletedTasks();
            },
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColor.primary))
                : tasksSearch.isEmpty // && (isLoading == false)
                    ? Center(
                        child: Text(
                          searchController.text.isEmpty
                              ? 'No completed task'
                              : 'There is no result',
                          style: const TextStyle(
                              color: AppColor.brown, fontSize: 20.0),
                        ),
                      )
                    : SlidableAutoCloseBehavior(
                        child: ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0),
                          itemCount: tasksSearch.length,
                          reverse: true, //đảo ngc list
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final task = tasksSearch[index];
                            return Slidable(
                              key: ValueKey(task.id),
                              startActionPane: _actionPane(task),
                              endActionPane: _actionPane(task),
                              child: CardTask(
                                task,
                                editController: editController,
                                editFocus: editFocus,
                                onTap: () => AppDialog.dialog(
                                  context,
                                  title: '😍',
                                  content: 'The task status will be changed?',
                                  action: () {
                                    final body = TaskBody()
                                      ..id = task.id
                                      ..name = task.name
                                      ..description = task.description
                                      ..status = StatusType.PROCESSING.name;
                                    _updateTask(
                                        body); // đằng nào cũng xóa nên ko cần hiển thị giao diện nữa
                                  },
                                ),
                                onEdit: () => _onEdit(task),
                                onLongPress: () => _onEdit(task),
                                onSave: () {
                                  final body = TaskBody()
                                    ..id = task.id //lấy lại task.id cũ
                                    ..name = editController.text
                                        .trim() //này mình nhập vào
                                    ..description = task.description
                                    ..status = task.status;
                                  _updateTaskSave(body); //update làm như api
                                  setState(() {
                                    task.isEditing = false;
                                  });
                                },
                                onCancel: () {
                                  setState(() {
                                    task.isEditing = false;
                                  });
                                },
                                onDeleted: () => _onDeleted(task),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16.4),
                        ),
                      ),
          ),
        ),
      ],
    );
  }

  ActionPane _actionPane(TaskModel task) {
    return ActionPane(
      motion: const DrawerMotion(),
      // motion: const StretchMotion(),
      children: [
        SlidableAction(
          onPressed: (_) => _onEdit(task),
          backgroundColor: const Color(0xFF21B7CA),
          foregroundColor: Colors.white,
          icon: Icons.edit,
        ),
        SlidableAction(
          onPressed: (_) => _onDeleted(task),
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
        ),
      ],
    );
  }
}
