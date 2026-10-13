import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_router.dart';
import 'data/initial_draft.dart';
import 'presentation/bloc/draft_bloc.dart';

void main() => runApp(const DraftApp());

class DraftApp extends StatelessWidget {
  const DraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DraftBloc(initialDraft),
      child: MaterialApp.router(
        title: 'Черновик',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        routerConfig: appRouter,
      ),
    );
  }
}
