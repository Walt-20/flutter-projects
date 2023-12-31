class CustomStack<T> {
  final _output = <T>[];

  void push(T value) => _output.add(value);

  T pop() => _output.removeLast();

  bool get isEmpty => _output.isEmpty;

  T? peek() {
    if (isEmpty) {
      return null;
    }
    return _output.last;
  }
}
