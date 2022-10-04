import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:get_driver_app/constants.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/providers/firestore_provider.dart';
import 'package:get_driver_app/widgets/driver_listTile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: height * 0.013,
                ),
                child: ListTile(
                  horizontalTitleGap: 0,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    icon: const ImageIcon(
                      AssetImage("assets/images/back_icon.png"),
                      color: Color(0xff152C5E),
                    ),
                  ),
                  title: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                    elevation: 3,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      cursorColor: Colors.grey,
                      textAlign: TextAlign.center,
                      controller: _searchFieldController,
                      keyboardType: TextInputType.text,
                      decoration: Constants.searchFieldDecoration,
                    ),
                  ),
                  trailing: Container(
                    margin: const EdgeInsets.only(
                      left: 13,
                    ),
                    padding: EdgeInsets.all(height * 0.015),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1,
                          spreadRadius: 0.1,
                        ),
                      ],
                      shape: BoxShape.circle,
                      color: Color(0xffEEF3FF),
                    ),
                    child: Image.asset(
                      "assets/images/filter_icon.png",
                      width: width * 0.049,
                      height: height * 0.019,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.8,
                child: StreamBuilder<List<UserModel>>(
                    stream: context.read<FirestoreProvider>().getSearchStream(),
                    builder:
                        (context, AsyncSnapshot<List<UserModel>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff152C5E),
                          ),
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text(
                            "Nothing to show",
                            style: TextStyle(
                              color: Color(0xff152C5E),
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            "Something went wrong try again",
                            style: TextStyle(
                              color: Color(0xff152C5E),
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return _searchFieldController.text.isEmpty
                          ? const Center(
                              child: Text(
                                "No driver found",
                                style: TextStyle(
                                  color: Color(0xff152C5E),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                final data = snapshot.data![index];
                                if (data.firstName
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(_searchFieldController.text
                                        .toLowerCase())) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                      top: height * 0.025,
                                      left: width * 0.048,
                                      right: width * 0.048,
                                    ),
                                    width: width * 0.9,
                                    height: height * 0.126,
                                    child: DriverListTile(
                                        data: data,
                                        width: width,
                                        height: height),
                                  );
                                }
                                return Container();
                              },
                            );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
