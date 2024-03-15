import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siec_assignment/data/model/appModel.dart';
import '../network/apiService.dart';

class TaskRepo{
  final ApiService _api;

  TaskRepo(this._api);

  Future<List<TodoAppModel>> fetchTaskListFromApi({int page = 1, int limit = 50}) async {
    List<TodoAppModel> taskList = [];
    var res = await _api.getRequest("todos?_page=$page&_limit=$limit");
    if (res == null) {
      throw "No data found";
    }
    for (var item in res) {
      taskList.add(TodoAppModel.fromJson(item));
    }
    return taskList;
  }
}

