abstract class DataState<T> {
  final T? data;
  final String? note;
  final CustomError? error;

  const DataState({this.data, this.note, this.error});
}

class SuccessState<T> extends DataState<T> {
  SuccessState(T data, String? note) : super(data: data, note: note);
}

class FailedState<T> extends DataState<T> {
  FailedState(CustomError error) : super(error: error);
}

class CustomError {
  final String message;
  const CustomError(this.message);
}
