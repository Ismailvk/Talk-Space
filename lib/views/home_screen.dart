import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk_space/controller/chat/chat_bloc.dart';
import 'package:talk_space/controller/login/login_bloc.dart';
import 'package:talk_space/resources/widgets/search_textfield.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  final String user1;
  HomeScreen({super.key, required this.user1});

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
                              user1: user1,
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
