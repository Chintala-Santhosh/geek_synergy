import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geek_synergy/Modules/Authentication/Screens/login_page.dart';
import 'package:geek_synergy/Modules/Home/Models/movies_list_response.dart';
import 'package:geek_synergy/Modules/Home/Screens/home_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utils/base_state.dart';
import '../Models/movies_list_request.dart';
import 'home_bloc.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc _bloc = HomeBloc(initialState: Loading());
  MoviesListResponse? moviesListResponse;
  List<Result>? movieDetails;
  bool isShow = false;
  String? user;
  String? email;

  @override
  void initState() {
    _callMoviesListAPI();
    super.initState();
  }

  _callMoviesListAPI() {
    MoviesListRequest request = MoviesListRequest();
    request.category = "movies";
    request.language = "kannada";
    request.genre = "all";
    request.sort = "voting";
    _bloc.add(MoviesList(request: request));
  }

  getDetails(BuildContext context) async {
    final SharedPreferences userDetails = await SharedPreferences.getInstance();
    user = userDetails.getString('username');
    email = userDetails.getString('email');
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;
    if (user != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          // title: const Text("Company Info"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Text(
                        "A",
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                    accountName: Text("$user"),
                    accountEmail: Text("$email"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text("Home"),
                    onTap: () {
                      Navigator.pop(context);
                      isShow = false;
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.view_compact_alt),
                    title: Row(
                      children: [
                        const Text("Company Info"),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              isShow = !isShow;
                              updated(setState);
                            },
                            child: Icon(isShow
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down)),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isShow,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Company:Geek-Synergy Technologies Pvt Ltd"),
                          Text("Address:SanjayNagar,Bengaluru-56"),
                          Text("Phone: XXXXXXXX09"),
                          Text("Email: XXXXX@gmail.com"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: const Text("Log Out"),
                    onTap: () {
                      isShow = false;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogInPage()));
                    },
                  ),
                ],
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Movie Details"),
              GestureDetector(
                  onTap: () {
                    if (kDebugMode) {
                      print("inside menu");
                    }
                    getDetails(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      child: const Icon(Icons.menu))),
            ],
          ),
        ),
        body: BlocProvider(
          create: (_) => _bloc,
          child: BlocBuilder<HomeBloc, BaseState>(builder: (context, state) {
            if (state is Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is DataLoaded) {
              if (state.event == "MoviesList") {
                moviesListResponse = state.data;
                movieDetails = moviesListResponse!.result;
              }
            }

            if (state is Error) {
              return const Center(
                child: Text('error'),
              );
            }
            return buildUi();
          }),
        ),
      ),
    );
  }

  Widget buildUi() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        child: ListView.builder(
          itemCount: movieDetails!.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Card(
                child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.arrow_drop_up,
                                size: 50,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "${movieDetails![index].totalVoted}",
                                style: const TextStyle(
                                    fontSize: 25, color: Colors.black87),
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Icon(
                                Icons.arrow_drop_down,
                                size: 50,
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Text("Votes"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                    Row(
                      children: [
                        Image.network(
                          "${movieDetails![index].poster}",
                          height: 120,
                          width: 100,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${movieDetails![index].title}",
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Genre:",
                                style: TextStyle(fontSize: 16),
                              ),
                              Flexible(
                                  child: Text(
                                "${movieDetails![index].genre}",
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Director:",
                                style: TextStyle(fontSize: 16),
                              ),
                              Flexible(
                                  child: Text(
                                "${movieDetails![index].director}",
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              )),
                              // SizedBox(
                              //   // height: 500,
                              //   child: Container(
                              //     child: ListView.builder(
                              //       shrinkWrap: true,
                              //       // scrollDirection: Axis.horizontal,
                              //       itemCount: movieDetails![index].director!.length,
                              //       itemBuilder: (BuildContext context, int index) {
                              //         return Container(
                              //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              //           child: Text(movieDetails![index].director![index]),
                              //         );
                              //       },
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Staring:",
                                style: TextStyle(fontSize: 16),
                              ),
                              Flexible(
                                  child: Text(
                                "${movieDetails![index].stars}",
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              )),
                              // SizedBox(
                              //   // height: 500,
                              //   child: Container(
                              //     child: ListView.builder(
                              //       shrinkWrap: true,
                              //       // scrollDirection: Axis.horizontal,
                              //       itemCount: movieDetails![index].stars!.length,
                              //       itemBuilder: (BuildContext context, int index) {
                              //         return Container(
                              //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              //           child: Text(movieDetails![index].stars![index]),
                              //         );
                              //       },
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Mins",
                              ),
                              const Text("|"),
                              Text("${movieDetails![index].language}"
                                  .split(".")
                                  .last),
                              const Text("|"),
                              Text(
                                dateFormat(movieDetails![index].releasedDate!),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Text("${movieDetails![index].pageViews}",
                                  style: const TextStyle(color: Colors.blue)),
                              const Text("|",
                                  style: TextStyle(color: Colors.blue)),
                              Text(
                                "Voted by ${movieDetails![index].voting} People",
                                style: const TextStyle(color: Colors.blue),
                              )
                            ],
                          ),

                          // dateFormat(movieDetails![index].releasedDate!)
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  width: 350,
                  color: Colors.blue,
                  margin: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const Text(
                    "Watch Trailer",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ));
          },
        ),
      ),
    );
  }

  Future<bool> updated(StateSetter updateState) async {
    updateState(() {});
    return false;
  }

  dateFormat(int time) {
    var date = DateTime.fromMillisecondsSinceEpoch(time);
    var date1 = DateFormat('dd MMM').format(date);
    return date1;
  }
}
