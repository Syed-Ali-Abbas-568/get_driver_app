import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:get_driver_app/constants.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/providers/firestore_provider.dart';
import 'package:get_driver_app/widgets/driver_listTile.dart';

import 'dart:developer';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchFieldController = TextEditingController();
  bool _displayFilter = false;
  bool _enableFilter = false;
  int _filterValue = 0;
  int? _length = 0;

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
                  trailing: GestureDetector(
                    onTap: () {
                      _displayFilter = !_displayFilter;
                      setState(() {});
                    },
                    child: Container(
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
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: _displayFilter,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
                  color: const Color(0xDDEEF3FF),
                  height: 140,
                  width: (width < 350) ? width : 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Years of Experience",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            activeColor: Constants.primaryColor,
                            value: 5,
                            groupValue: _filterValue,
                            onChanged: (value) {
                              setState(() {});
                              _filterValue = 5;
                              _enableFilter = false;
                            },
                          ),
                          const Text("5+"),
                          Radio(
                            activeColor: Constants.primaryColor,
                            value: 4,
                            groupValue: _filterValue,
                            onChanged: (value) {
                              setState(() {});
                              _filterValue = 4;
                              _enableFilter = false;
                            },
                          ),
                          const Text("4+"),
                          Radio(
                            activeColor: Constants.primaryColor,
                            value: 3,
                            groupValue: _filterValue,
                            onChanged: (value) {
                              setState(() {});
                              _filterValue = 3;
                              _enableFilter = false;
                            },
                          ),
                          const Text("3+"),
                          Radio(
                            activeColor: Constants.primaryColor,
                            value: 2,
                            groupValue: _filterValue,
                            onChanged: (value) {
                              setState(() {});
                              _filterValue = 2;
                              _enableFilter = false;
                            },
                          ),
                          const Text("2+"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _enableFilter = false;
                              _filterValue = 0;
                              setState(() {});
                            },
                            child: const Text(
                              'Clear',
                              style: TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Material(
                            color: Constants.primaryColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100.0),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                _enableFilter = true;
                                _displayFilter = false;
                                setState(() {});
                              },
                              height: 24.0,
                              child: const Text(
                                'Apply',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.8,
                child: StreamBuilder<List<UserModel>>(
                    stream: context
                        .read<FirestoreProvider>()
                        .getDriversSearchStream(
                            (_enableFilter) ? _filterValue : 0),
                    builder:
                        (context, AsyncSnapshot<List<UserModel>> snapshot) {
                      log("length = $_length");
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
                      _length = 0;
                      return (_searchFieldController.text.isEmpty)
                          ? const Center(
                              child: Text(
                                "Type a driver name to serach",
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
                                  _length = 1;
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

                                if (index + 1 == snapshot.data?.length) {
                                  if (_length == 0) {
                                    return const Center(
                                      child: Text(
                                        "No driver found",
                                        style: TextStyle(
                                          color: Color(0xff152C5E),
                                        ),
                                      ),
                                    );
                                  }
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
