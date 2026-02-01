class DataResponse{
  bool status=false;
  String statusCode='500';
  dynamic data;
  String message="";

  bool getStatus() => this.status;
  dynamic getData() => this.data;
  String getMessage() => this.message;
}