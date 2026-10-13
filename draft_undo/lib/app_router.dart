import 'package:draft_undo/presentation/bloc/pages/draft_edit_page.dart';
import 'package:draft_undo/presentation/bloc/pages/draft_list_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const DraftListPage()),
    GoRoute(path: '/edit', builder: (context, state) => const DraftEditPage()),
  ],
);
