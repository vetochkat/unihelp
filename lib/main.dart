import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unihelp/bloc/api_bloc.dart';
import 'package:unihelp/bloc/api_events.dart';
import 'package:unihelp/bloc/api_states.dart';
import 'package:unihelp/dialogues.dart';
import 'package:unihelp/poisk.dart';
import 'package:unihelp/profile.dart';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => ApiBloc(), // Create an instance of ApiBloc
        child: MyHomePage(), // Set MyHomePage as the home screen
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ApiBloc>(context)
        .add(PoiskEvent()); // Dispatch an event to fetch the list of notes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Dialogues',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            BlocProvider.of<ApiBloc>(context).add(PoiskEvent());
          } else if (index == 1) {
            BlocProvider.of<ApiBloc>(context).add(ProfileEvent());
          } else if (index == 2) {
            BlocProvider.of<ApiBloc>(context).add(DialogEvent());
          }
        },
        currentIndex: _selectedIndex,
      ),
      body: buildBloc(), // Build the UI based on the current state
    );
  }

  Widget buildBloc() {
    return BlocBuilder<ApiBloc, ApiStates>(builder: (context, state) {
      print(state);
      if (state is LoadingState) {
        return Center(
          child: CircularProgressIndicator(),
        ); // Show a loading indicator while fetching data// Show the note details screen
      } else if (state is ErrorState) {
        return Center(
          child: Text("Error"),
        ); // Show an error message if there's an error state
      } else if (state is PoiskState) {
        return PoiskPage();
      } else if (state is DialogState) {
        return DialoguePage();
      } else if (state is ProfileState) {
        return ProfilePage();
      } else {
        return Text(
          "Nothing",
        ); // Show a default message if the state is not recognized
      }
    });
  }
}
