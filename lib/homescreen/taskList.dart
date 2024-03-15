import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siec_assignment/bloc/appBloc.dart';
import 'package:siec_assignment/data/model/appModel.dart';
import '../constants/constants.dart';
import '../data/network/apiService.dart';
import '../data/repository/appRepo.dart';
import '../message_handler.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  TextEditingController searchController = TextEditingController();
  ValueNotifier<bool> showbtn = ValueNotifier(false);
  ScrollController blogScrollController = ScrollController();
  ValueNotifier<bool> loadingBlog = ValueNotifier(false);
  List<TodoAppModel> taskList = [];
  late Dio _dio;
  late ApiService _api;
  late TaskRepo _repo;
  int page = 1;
  bool isLastBlog = false;
  List<TodoAppModel> filteredTaskList = [];

  @override
  void initState() {
    K.setBackgroundImage();
    super.initState();
    _dio = Dio();
    _api = ApiService(_dio);
    _repo = TaskRepo(_api);
    loadingBlog.value = false;
    init();

    searchController.addListener(() {
      filterTasks(searchController.text);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: K.primaryColor,
        title: const Text(
          'Task List',
          style: TextStyle(color: Colors.black, fontFamily: 'Lato'),
        ),
      ),
      body:  Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(K.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: search_bar(),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredTaskList.length + 1,
                  itemBuilder: (context, index) {
                    if (index < filteredTaskList.length) {
                      return buildListItem(filteredTaskList[index]);
                    }
                    else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: K.primaryColor,
                        ),
                      );

                    }
                  },
                  controller: blogScrollController,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: showbtn,
        builder: (context, value, child) {
          return value
              ? FloatingActionButton(
            backgroundColor: K.primaryColor,
            onPressed: () {
              blogScrollController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            },
            child: const Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
          )
              : const SizedBox.shrink();
        },
      ),
    );
  }

  Widget search_bar() {
    return  Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            cursorWidth: 1.2,
            cursorHeight: 25,
            cursorColor: Colors.black54,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffFFFFFF),
              prefixIcon: Icon(
                Icons.search,
              ),
              hintText: "Search",
              hintStyle: TextStyle(color: Color(0xffCFCFCF)),
              contentPadding: EdgeInsets.all(5),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.2,
                  color: Color(0xffD9D9D9),
                ), // Change the color here
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.2,
                  color: Color(0xffD9D9D9),
                ), // Change the color here
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildListItem(TodoAppModel task) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: -1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "User Id = ${task.userId}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'lato',
                        ),
                      ),
                      Text(
                        "Id = ${task.id}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'lato',
                        ),
                      ),
                      Text(
                        "Title = ${task.title ?? ''}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'abhaya',
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.draw, color: Colors.grey),
                const Icon(Icons.delete, color: Colors.redAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // These are all the business logic
  Future<void> fetchTaskList() async {
    try {
      if (loadingBlog.value) {
        return;
      }
      loadingBlog.value = true;
      List<TodoAppModel> res = await _repo.fetchTaskListFromApi(page: page);

      // if (page == 1) {
      //   taskList = res;
      // } else {
      //   taskList.addAll(res);
      // }
      setState(() {
        if (page == 1) {
          taskList = res;
          // filterTasks(searchController.text);
        } else {
          taskList.addAll(res);
        }
      });
      filterTasks(searchController.text);
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


  void filterTasks(String query) {
    if (query.isEmpty) {
      filteredTaskList = List.from(taskList);
    } else {
      filteredTaskList = taskList
          .where((task) => task.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
    setState(() {});
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
      loadNextPage();
      // ();
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
