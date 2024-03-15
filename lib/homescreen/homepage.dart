
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:siec_assignment/Widgets/customButton.dart';
import 'package:siec_assignment/homescreen/taskList.dart';

import '../addTask/create_task.dart';
import '../constants/constants.dart';
import '../data/model/appModel.dart';
import '../data/network/apiService.dart';
import '../data/repository/appRepo.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  List<TodoAppModel> taskList = [];
  List<String>data = [
    "Completed","Pending"
  ];

  late TaskRepo _repo;
  late Dio _dio;
  late ApiService _api;

  @override
  void initState() {
    _dio = Dio();
    _api = ApiService(_dio);
    _repo = TaskRepo(_api);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  height:100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                    ),
                    color: K.primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, left: 12,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            SizedBox(width: 12), // Add some space between the avatar and text
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Hello Aditya!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'Lato',
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "You have work today",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontFamily: 'Lato',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
          
                        const SizedBox(width: 10),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade300,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child:Image.network("https://lh3.googleusercontent.com/a/ACg8ocINQEpdO1qVf8mw-owPaF5tRGX1jAHdMA6DcPBMz6Enmg=s96-c")),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              FutureBuilder(
                future: _repo.fetchTaskListFromApi(),
                builder: (BuildContext context, AsyncSnapshot<List<TodoAppModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: K.primaryColor),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  else{
                    List<TodoAppModel> list = snapshot.data ?? [];
                    int completedCount = list.where((task) => task.completed ?? false).length;
                    int notCompletedCount = list.where((task) => !(task.completed ?? false)).length;
                    return  SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 2,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200,
                                height: 100,
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.8),
                                        spreadRadius: -1,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        child: index ==0?const Icon(Icons.task): const Icon(Icons.pending_actions),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(data[index], style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Lato'
                                          ),),
                                          index == 0?Text("${completedCount.toString()}", style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Lato'
                                          ),): Text("${notCompletedCount.toString()}", style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Lato'
                                          ),)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 8),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tasks",
                      maxLines: 2,
                      style:  TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff414040),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskListPage()));
                      },
                      child: const Text("See All",
                        maxLines: 2,
                        style:  TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:Color(0xff0EBE7F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: _repo.fetchTaskListFromApi(limit: 10),
                builder: (BuildContext context, AsyncSnapshot<List<TodoAppModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: K.primaryColor),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    List<TodoAppModel> taskList = snapshot.data ?? [];
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: taskList.length,
                        itemBuilder: (BuildContext context, int index) {
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
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "User Id = ${taskList[index].userId}",
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
                                              "Id = ${taskList[index].id}",
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
                                              "Title = ${taskList[index].title ?? ''}",
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
                        },
                      ),
                    );
                  }
                },
              )

            ],
          ),
            Positioned(
              bottom: 20,
                right: 20,
                left: 20,
                child: LoginButton(
                  title: "Create new task",
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CreateTask()));
                  },
                )
            )
          ]
        ),
      ),
    );
  }
}
