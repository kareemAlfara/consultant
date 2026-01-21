
/// General status enum for all Cubits in the application
/// Used to represent the current state of data fetching/processing
enum CubitStatus {
  
  initial,

  loading,
  
  success,
  
  empty,

  error,
}

/// Extension to add convenient getters
extension CubitStatusX on CubitStatus {
  bool get isInitial => this == CubitStatus.initial;
  bool get isLoading => this == CubitStatus.loading;
  bool get isSuccess => this == CubitStatus.success;
  bool get isEmpty => this == CubitStatus.empty;
  bool get isError => this == CubitStatus.error;
}