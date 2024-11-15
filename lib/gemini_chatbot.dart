import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class ChatbotGemini extends StatefulWidget {
  const ChatbotGemini({super.key});

  @override
  State<ChatbotGemini> createState() => _ChatbotGeminiState();
}

class _ChatbotGeminiState extends State<ChatbotGemini> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  bool isTyping = false;

  ChatUser currentUser = ChatUser(id: "0", firstName: "Użytkownik");
  ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: "LeafyAI",
      profileImage:
          "https://drive.google.com/uc?export=view&id=12GyF2aoN-FfriLkWWr_bZQGSU8enjqQw");

  @override
  void initState() {
    super.initState();
    messages.add(ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text:
          "Cześć, jestem Leafy. Mogę ci pomóc z pytaniami związanymi z ekologią! Jeśli dodasz zdjęcie rośliny spróbuje rozpoznać co to za roślina i napisze ci jak o nią dbać.Lub możesz po prostu zadać pytanie.",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        Expanded(
          child: DashChat(
            inputOptions: InputOptions(
              trailing: [
                IconButton(
                    onPressed: _sendMediaMessage, icon: const Icon(Icons.image))
              ],
              textInputAction: TextInputAction.send,
            ),
            currentUser: currentUser,
            onSend: _sendMessage,
            messages: messages,
          ),
        ),
        if (isTyping)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 8),
                Text("LeafyAI pisze..."),
              ],
            ),
          ),
      ],
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
      isTyping = true;
    });

    FocusScope.of(context).unfocus();

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen((event) {
        String response = event.content?.parts?.fold(
                "", (previous, current) => "$previous ${current.text}") ??
            "";
        ChatMessage message = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: response,
        );

        setState(() {
          messages = [message, ...messages];
          isTyping = false;
        });
      });
    } catch (e) {
      print(e);
      setState(() {
        isTyping = false;
      });
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Rozpoznaj co to za roślina i napisz jak o nią dbać",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          )
        ],
      );
      _sendMessage(chatMessage);
    }
  }
}
