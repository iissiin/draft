import 'package:draft_undo/domain/draft.dart';
import 'package:draft_undo/domain/draft_rules.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// MARK: Event
class DraftEvent {
  const DraftEvent();
}

class DraftEditRequested extends DraftEvent {
  const DraftEditRequested();
}

class DraftSaved extends DraftEvent {
  const DraftSaved({required this.title, required this.text});

  final String title;
  final String text;
}

class DraftEditCancelled extends DraftEvent {
  const DraftEditCancelled();
}

class DraftDeleted extends DraftEvent {
  const DraftDeleted();
}

class DraftRestored extends DraftEvent {
  const DraftRestored();
}

// MARK: State
class DraftState extends Equatable {
  const DraftState({
    this.draft,
    this.deletedDraft,
    this.editCopy,
    this.titleError,
    this.textError,
  });

  final Draft? draft;
  final Draft? deletedDraft;
  final Draft? editCopy;
  final String? titleError;
  final String? textError;

  @override
  List<Object?> get props => [
    draft,
    deletedDraft,
    editCopy,
    titleError,
    textError,
  ];
}

//MARK: Bloc

class DraftBloc extends Bloc<DraftEvent, DraftState> {
  DraftBloc(Draft initial) : super(DraftState(draft: initial)) {
    on<DraftEditRequested>(_onEditRequested);
    on<DraftSaved>(_onSaved);
    on<DraftEditCancelled>(_onEditCancelled);
    on<DraftDeleted>(_onDeleted);
    on<DraftRestored>(_onRestored);
  }

  void _onEditRequested(DraftEditRequested event, Emitter<DraftState> emit) {
    final draft = state.draft;
    if (draft == null) return;

    emit(
      DraftState(
        draft: draft,
        deletedDraft: state.deletedDraft,
        editCopy: draft.copyWith(),
      ),
    );
  }

  void _onSaved(DraftSaved event, Emitter<DraftState> emit) {
    final copy = state.editCopy;
    if (copy == null) return;

    final titleError = validateTitle(event.title);
    final textError = validateText(event.text);

    if (titleError != null || textError != null) {
      emit(
        DraftState(
          draft: state.draft,
          deletedDraft: state.deletedDraft,
          editCopy: copy,
          titleError: titleError,
          textError: textError,
        ),
      );
      return;
    }

    emit(
      DraftState(
        draft: copy.copyWith(title: event.title.trim(), text: event.text),
        deletedDraft: state.deletedDraft,
      ),
    );
  }

  void _onEditCancelled(DraftEditCancelled event, Emitter<DraftState> emit) {
    emit(DraftState(draft: state.draft, deletedDraft: state.deletedDraft));
  }

  void _onDeleted(DraftDeleted event, Emitter<DraftState> emit) {
    final draft = state.draft;
    if (draft == null) return;

    emit(DraftState(draft: null, deletedDraft: draft.copyWith()));
  }

  void _onRestored(DraftRestored event, Emitter<DraftState> emit) {
    final snapshot = state.deletedDraft;
    if (snapshot == null || state.draft != null) return;

    emit(DraftState(draft: snapshot, deletedDraft: null));
  }

  @override
  void onChange(Change<DraftState> change) {
    super.onChange(change);
    debugPrint('deletedDraft: ${change.nextState.deletedDraft}');
  }
}
