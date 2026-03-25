class UserRequest {
  int id;
  String email;
  String approvalStatus;
  String requestedRole;

  UserRequest({
    required this.id,
    required this.email,
    required this.approvalStatus,
    required this.requestedRole,
  });

  factory UserRequest.fromJson(Map<String, dynamic> json) {
    return UserRequest(
      id: json['id'],
      email: json['email'],
      approvalStatus:
          json['is_approved'] == true ? 'Approved' : 'Approval Application is Pending',
      requestedRole: json['requested_role'],
    );
  }
}