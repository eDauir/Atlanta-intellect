import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'exa_event.dart';
part 'exa_state.dart';

class ExaBloc extends Bloc<ExaEvent, ExaState> {
  ExaBloc() : super(ExaInitial()) {
    on<ExaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
