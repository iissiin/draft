import 'package:draft_undo/domain/draft_rules.dart';
import 'package:draft_undo/presentation/bloc/draft_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DraftEditPage extends StatefulWidget {
  const DraftEditPage({super.key});

  @override
  State<DraftEditPage> createState() => _DraftEditPageState();
}

class _DraftEditPageState extends State<DraftEditPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    final copy = context.read<DraftBloc>().state.editCopy;
    _titleController = TextEditingController(text: copy?.title ?? '');
    _textController = TextEditingController(text: copy?.text ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DraftBloc, DraftState>(
      listenWhen: (prev, curr) =>
          prev.editCopy != null && curr.editCopy == null,
      listener: (context, state) => context.pop(),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Редактирование')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  maxLength: titleMaxLength,
                  decoration: InputDecoration(
                    labelText: 'Заголовок',
                    border: const OutlineInputBorder(),
                    errorText: state.titleError,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _textController,
                  maxLength: textMaxLength,
                  minLines: 4,
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Текст',
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                    errorText: state.textError,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.read<DraftBloc>().add(
                          const DraftEditCancelled(),
                        ),
                        child: const Text('Отмена'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => context.read<DraftBloc>().add(
                          DraftSaved(
                            title: _titleController.text,
                            text: _textController.text,
                          ),
                        ),
                        child: const Text('Сохранить'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
