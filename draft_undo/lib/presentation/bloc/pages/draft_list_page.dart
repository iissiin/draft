import 'package:draft_undo/presentation/bloc/draft_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DraftListPage extends StatelessWidget {
  const DraftListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Черновики')),
      body: BlocBuilder<DraftBloc, DraftState>(
        builder: (context, state) {
          final draft = state.draft;

          if (draft == null) {
            return _EmptyState(canRestore: state.deletedDraft != null);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  title: Text(draft.title),
                  subtitle: Text(draft.text),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<DraftBloc>().add(
                            const DraftEditRequested(),
                          );
                          context.push('/edit');
                        },
                        child: const Text('Редактировать'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Удалить',
                        onPressed: () =>
                            context.read<DraftBloc>().add(const DraftDeleted()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.canRestore});

  final bool canRestore;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Черновик удалён', style: TextStyle(fontSize: 18)),
          if (canRestore) ...[
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  context.read<DraftBloc>().add(const DraftRestored()),
              child: const Text('Вернуть черновик'),
            ),
          ],
        ],
      ),
    );
  }
}
