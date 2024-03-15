import 'package:flutter/material.dart';
import 'package:siec_assignment/bloc/bloc.dart';
import 'package:siec_assignment/data/model/appModel.dart';
import 'package:siec_assignment/data/repository/appRepo.dart';

import '../message_handler.dart';

class TaskBloc extends Bloc{
  final TaskRepo _repo;

  TaskBloc(this._repo);

//   //#region -Task List
//   // bool showbtn = false;
//   ValueNotifier<bool> showbtn = ValueNotifier(false);
//   ScrollController blogScrollController = ScrollController();
//   ValueNotifier<bool> loadingBlog = ValueNotifier(false);
//   ValueNotifier<TodoAppModel> blogData = ValueNotifier(TodoAppModel());
//   int page = 1;
//   bool isLastBlog = false;
//   Future fetchTaskList() async {
//     try {
//       if (loadingBlog.value) {
//         return;
//       }
//       loadingBlog.value = true;
//       TodoAppModel res = await _repo.fetchTasklist();
//
//       // Check if data is not empty
//       if (res.userId != null && res.title!.isNotEmpty) {
//         if (page == 1) {
//           blogData.value.userId = res.userId;
//         } else {
//           blogData.value.allblog.addAll(res.allblog);
//         }
//         // Check if the number of items fetched is less than expected
//         isLastBlog = res.allblog.length < 10;
//       } else {
//         // No more data available
//         isLastBlog = true;
//       }
//     } catch (e, s) {
//       debugPrint('$e');
//       debugPrintStack(stackTrace: s);
//       showMessage(MessageType.error(e.toString()));
//     } finally {
//       loadingBlog.value = false;
//     }
//   }
//
//
//   void loadNextPage() {
//     if (!isLastBlog) {
//       page++;
//       getBlogList();
//     }
//   }
//
//   void init() {
//     getBlogList();
//     blogScrollController.addListener(_scrollListener);
//   }
//
//   void _scrollListener() async {
//     if (blogScrollController.position.extentAfter <= 0 && !loadingBlog.value) {
//       loadNextPage();
//     }
//     //scroll listener
//     double showoffset =
//     10.0; //Back to top botton will show on scroll offset 10.0
//
//     if (blogScrollController.offset > showoffset) {
//       showbtn.value = true;
//       // setState(() {
//       //   //update state
//       // });
//     } else {
//       showbtn.value = false;
//       // setState(() {
//       //   //update state
//       // });
//     }
//   }
//
//   @override
//   void dispose() {
//     blogScrollController.removeListener(_scrollListener);
//   }
//
// //#endregion

  ValueNotifier<bool> showbtn = ValueNotifier(false);
  ScrollController blogScrollController = ScrollController();
  ValueNotifier<bool> loadingBlog = ValueNotifier(false);
  List<TodoAppModel> taskList = [];
  int page = 1;
  bool isLastBlog = false;


  // These are all the business logic
  Future<void> fetchTaskList() async {
    try {
      if (loadingBlog.value) {
        return;
      }
      loadingBlog.value = true;
      List<TodoAppModel> res = await _repo.fetchTaskListFromApi(page: page);

        if (page == 1) {
          taskList = res;
        } else {
          taskList.addAll(res);
        }
        isLastBlog = res.length < 50;
        // page++;
        // loadingBlog.value = true;
    } catch (e, s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
      showMessage(MessageType.error);
    } finally {
      loadingBlog.value = false;
    }
  }

  void loadNextPage() {
    if (!isLastBlog) {
      page++;
      fetchTaskList();
    }
  }

  void init() {
    fetchTaskList();
    blogScrollController.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (blogScrollController.position.extentAfter <= 0 && !loadingBlog.value) {
      // if (taskList.length % 50 == 0) {
      //   loadNextPage();
      // }
      loadNextPage();
    }
    // Scroll listener to show or hide the back-to-top button
    double showOffset = 10.0;
    if (blogScrollController.offset > showOffset) {
      showbtn.value = true;
    } else {
      showbtn.value = false;
    }
  }

  @override
  void dispose() {
    blogScrollController.removeListener(_scrollListener);
    super.dispose();
  }
}

void showMessage(MessageType type) {
  // Implement your message showing logic here
}

enum MessageType { error }
