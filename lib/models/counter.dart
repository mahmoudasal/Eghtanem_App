// models/counter.dart

class Counter {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
  }
  
  void decrement() {
    if (_count > 0) {
      _count--;
    }
  }
  
  void reset() {
    _count = 0;
  }
  
  void setCount(int value) {
    _count = value < 0 ? 0 : value;
  }
}
