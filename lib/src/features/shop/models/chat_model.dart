class Chat {
  final String name, lastMessage, image, time;
  final bool isActive;

  Chat({
    this.name = '',
    this.lastMessage = '',
    this.image = '',
    this.time = '',
    this.isActive = false,
  });
}

List chatsData = [
  Chat(
    name: "Win Mart",
    lastMessage: "Cảm ơn bạn đã tư vẫn cho tôi",
    image: "",
    time: "3 phút trước",
    isActive: false,
  ),
];
