class ApiResponse<T> {
  final T? data;
  final String? message;
  final int statusCode;
  final bool isSuccess;

  ApiResponse({
    this.data,
    this.message,
    required this.statusCode,
    required this.isSuccess,
  });

  factory ApiResponse.success({T? data, String? message}) {
    return ApiResponse(
      data: data,
      message: message,
      statusCode: 200,
      isSuccess: true,
    );
  }

  factory ApiResponse.error({
    String? message,
    int statusCode = 500,
  }) {
    return ApiResponse(
      message: message,
      statusCode: statusCode,
      isSuccess: false,
    );
  }
}
