import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId; // Kullanıcı kimliği
  final String otherUserId; // Diğer kullanıcı kimliği

  const ChatScreen({
    Key? key,
    required this.currentUserId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sohbet ID'si, iki kullanıcı kimliğine bağlı olarak belirlenir.
  String get _chatId {
    final userIds = [
      widget.currentUserId,
      widget.otherUserId
    ]; // Kullanıcı kimliklerini bir listeye ekle.
    userIds.sort(); // Kullanıcı kimliklerini alfabetik olarak sırala.
    return userIds.join(
        '_'); // Kullanıcı kimliklerini birleştirerek sohbet ID'si oluştur.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Chat with ${widget.otherUserId}'), // Diğer kullanıcı kimliğini başlıkta göster.
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Firestore'dan mesajları dinlemek için bir akış oluştur.
              stream: _firestore
                  .collection('chats') // 'chats' koleksiyonuna eriş.
                  .doc(_chatId) // Belirli sohbet ID'sine sahip belgeye eriş.
                  .collection(
                      'messages') // Bu belgedeki 'messages' alt koleksiyonuna eriş.
                  .orderBy(
                      'timestamp') // Mesajları zaman damgasına göre sırala.
                  .snapshots(), // Sürekli güncellenen bir akış döndür.
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Veriler yüklenirken bir yükleniyor göstergesi göster.
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs; // Mesajları alın.
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSender = message['sender'] ==
                        widget
                            .currentUserId; // Mesajı gönderenin kim olduğunu kontrol et.
                    final messageText = message['text']; // Mesaj metnini al.

                    return Align(
                      alignment: isSender
                          ? Alignment.centerRight
                          : Alignment
                              .centerLeft, // Mesajı sağa veya sola hizala.
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: isSender
                              ? Colors.blue
                              : Colors
                                  .grey.shade300, // Mesajın rengini belirle.
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          messageText, // Mesaj metnini göster.
                          style: TextStyle(
                            color: isSender
                                ? Colors.white
                                : Colors
                                    .black, // Mesaj metninin rengini belirle.
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText:
                          'Type a message...', // Mesaj yazma alanı için bir ipucu metin.
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage, // Mesaj gönderme işlevini çağır.
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final message = _messageController.text
        .trim(); // Mesaj metnini al ve boşlukları temizle.
    if (message.isNotEmpty) {
      final timestamp =
          FieldValue.serverTimestamp(); // Sunucu zaman damgasını al.

      // Mesajı 'chats' koleksiyonuna ekle.
      await _firestore
          .collection('chats')
          .doc(_chatId) // Belirli sohbet ID'sine sahip belgeye eriş.
          .collection(
              'messages') // Bu belgedeki 'messages' alt koleksiyonuna eriş.
          .add({
        'text': message, // Mesaj metni.
        'sender': widget.currentUserId, // Mesajı gönderen kullanıcı kimliği.
        'timestamp': timestamp, // Mesajın zaman damgası.
      });

      // 'recent_chats' koleksiyonunu güncelle.
      await _firestore
          .collection('recent_chats')
          .doc(widget.currentUserId)
          .set({
        'lastMessage': message, // Son mesaj.
        'otherUser': widget.otherUserId, // Diğer kullanıcı kimliği.
        'senderId': widget.currentUserId, // Mesajı gönderen kullanıcı kimliği.
        'timestamp': timestamp, // Zaman damgası.
        'users': [
          widget.currentUserId,
          widget.otherUserId
        ], // Kullanıcı kimlikleri.
      });

      await _firestore.collection('recent_chats').doc(widget.otherUserId).set(
        {
          'lastMessage': message, // Son mesaj.
          'otherUser': widget.currentUserId, // Diğer kullanıcı kimliği.
          'senderId':
              widget.currentUserId, // Mesajı gönderen kullanıcı kimliği.
          'timestamp': timestamp, // Zaman damgası.
          'users': [
            widget.currentUserId,
            widget.otherUserId
          ], // Kullanıcı kimlikleri.
        },
      );
    }
    _messageController.clear(); // Mesaj alanını temizle.
  }
}
