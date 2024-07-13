import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk_space/controller/chat/chat_bloc.dart';
import 'package:talk_space/controller/login/login_bloc.dart';
import 'package:talk_space/resources/widgets/search_textfield.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  final String user1;
  const HomeScreen({super.key, required this.user1});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  TextEditingController searchController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus('Online');
  }

  void setStatus(String status) async {
    await firestore.collection('user').doc(auth.currentUser?.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online logics
      setStatus('Online');
    } else {
      //offline logics
      setStatus('Offline');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              context.read<LoginBloc>().add(LogoutUser(context: context));
            },
            child: const Icon(Icons.logout)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchTextField(
                controller: searchController, hintText: 'Search here'),
            const SizedBox(height: 20),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is FindUserLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FindUserSuccessState) {
                  if (state.userMap.isEmpty) {
                    return const Center(child: Text('No user found'));
                  }
                  return ListTile(
                    leading: const Icon(Icons.person_3_outlined),
                    title: Text(state.userMap['name']),
                    subtitle: Text(state.userMap['email']),
                    trailing: GestureDetector(
                        onTap: () {
                          context.read<ChatBloc>().add(ChatButtonClickedEvent(
                              user1: widget.user1,
                              user2: state.userMap['name'],
                              context: context,
                              userMap: state.userMap));
                        },
                        child: const Icon(Icons.chat_rounded)),
                  );
                }
                return const Text('No user found');
              },
            )
          ],
        ),
      ),
    );
  }
}
