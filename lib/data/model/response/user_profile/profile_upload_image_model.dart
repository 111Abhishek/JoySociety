class ProfileUploadImageModel {
  String? _fileUrl;
  String? _category;

  ProfileUploadImageModel({String? fileUrl, String? category}) {
    _fileUrl = fileUrl;
    _category = category;
  }

  String? get fileUrl => _fileUrl;
  String? get category => _category;

  factory ProfileUploadImageModel.fromJson(Map<String, dynamic> json) {
    return ProfileUploadImageModel(
        fileUrl: json['fle'], category: json['category']);
  }
}
