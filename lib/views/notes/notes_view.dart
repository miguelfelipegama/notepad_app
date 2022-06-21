import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad_app/services/auth/auth_service.dart';
import 'package:notepad_app/services/auth/bloc/auth_bloc.dart';
import 'package:notepad_app/services/auth/bloc/auth_event.dart';
import 'package:notepad_app/services/cloud/cloud_note.dart';
import 'package:notepad_app/services/cloud/firestore_service.dart';
import 'package:notepad_app/views/notes/notes_list_view.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userId => AuthService.firebase().currentUser!.id;

  late final FirestoreCloudService _notesService;

  @override
  void initState() {
    _notesService = FirestoreCloudService();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes'),
          actions: [
            IconButton(
              onPressed: () {
                if (mounted) {
                  Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
                }
              },
              icon: const Icon(Icons.add_circle),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLoguout = await showLogOutDialog(context);
                    if (shouldLoguout) {
                      if (mounted) {
                        context.read<AuthBloc>().add(const AuthEventLogOut());
                      }
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: MenuAction.logout,
                    child: Text('Log out'),
                  )
                ];
              },
            )
          ],
        ),
        body: StreamBuilder(
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(docId: note.documentId);
                    },
                    onTapNote: (note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }

              default:
                return const CircularProgressIndicator();
            }
          },
          stream: _notesService.allNotes(ownerId: userId),
        ));
  }
}
