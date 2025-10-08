class SessionMemory {
  static final SessionMemory _instance = SessionMemory._internal();
  factory SessionMemory() => _instance;
  SessionMemory._internal();

  String? _token;

  void setToken(String token) {
    _token = token;
  }

  String? get token => _token;

  void clear() {
    _token = null;
  }
}
