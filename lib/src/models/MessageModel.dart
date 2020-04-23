class MessageModel {
  final String to;
  final String subject;
  final String message;
  final String from;

  MessageModel({this.to, this.subject, this.message, this.from});

  MessageModel copyWith(
      {String to, String subject, String message, String from}) {
    return MessageModel(
      to: to != null ? to : this.to,
      subject: subject != null ? subject : this.subject,
      message: message != null ? message : this.message,
      from: from != null ? from : this.from,
    );
  }
}
