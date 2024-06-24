import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk_space/controller/chat/chat_bloc.dart';
import 'package:talk_space/controller/login/login_bloc.dart';
import 'package:talk_space/resources/widgets/search_textfield.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
                              user1: state.userMap['name'],
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

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }
}
