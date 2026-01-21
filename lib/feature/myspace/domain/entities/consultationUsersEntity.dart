
// علشان تاني صفحة الي بيتفتح الشات من خلالها
 class Consultationusersentity {
  final String userImage;
  final String username;
  final String time;
  final bool hasNotification;
  int? Notificationnumber;
  final String lastMessage;

  Consultationusersentity({
    required this.userImage,
    required this.username,
    required this.time,
    required this.hasNotification,
    this.Notificationnumber,
    required this.lastMessage,
  });
}

List<Consultationusersentity> consultationusersList = [
    Consultationusersentity(
    time: "9:41 AM",
    username: "أحمد منصور",
    lastMessage: "مرحبا بك",
    userImage: "assets/images/profile_image.jpg",
    hasNotification: false,
    
  ),
    Consultationusersentity(
    time: "9:41 AM",
    username: "أحمد منصور",
    lastMessage: "مرحبا بك",
    userImage: "assets/images/profile_image.jpg",
    hasNotification: false,
    
  ),
  Consultationusersentity(
    time: "9:41 AM",
    username: "أحمد منصور",
    lastMessage: "مرحبا بك",
    userImage: "assets/images/profile_image.jpg",
    hasNotification: true,
    Notificationnumber: 3,
  ),
];
