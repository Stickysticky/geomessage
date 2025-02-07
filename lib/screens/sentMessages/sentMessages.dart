import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geomessage/commonWidgets/cardMessage.dart';
import 'package:geomessage/services/databaseService.dart';
import 'package:geomessage/services/utils.dart';

import '../../commonWidgets/customAppBar.dart';
import '../../generated/l10n.dart';
import '../../model/message.dart';
import '../../services/messageService.dart';

class SentMessages extends StatefulWidget {
  const SentMessages({super.key});

  @override
  State<SentMessages> createState() => _SentMessagesState();
}

class _SentMessagesState extends State<SentMessages> {
  late Future<List<Message>> _messagesFuture;  // Déclarez la variable Future

  @override
  void initState() {
    super.initState();
    _messagesFuture = DatabaseService().getMessagesWithDate(); // Initialisez avec la fonction asynchrone
  }

  Future<void> _showDeleteAllSentMessagesConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(capitalizeFirstLetter(S.of(context).confirmation)),
          content: Text(capitalizeFirstLetter(S.of(context).deleteAllSentMessageConfirmation)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text(capitalizeFirstLetter(S.of(context).cancel)),
            ),
            TextButton(
              onPressed: () {
                _deleteAllMessageWithDates();  // Appeler la fonction de suppression
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text(capitalizeFirstLetter(S.of(context).delete)),
            ),
          ],
        );
      },
    );
  }


  Future<void> _deleteMessage(Message message) async {
    DatabaseService db = DatabaseService();
    await db.deleteMessage(message.id!);

    // Rafraîchissez la liste des messages après suppression
    setState(() {
      _messagesFuture = Future.value([]);  // Recharge la liste après suppression
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(capitalizeFirstLetter(S.of(context).deletedMessage))),
    );
  }

  Future<void> _deleteAllMessageWithDates() async {
    DatabaseService db = DatabaseService();
    await db.deleteAllSentMessages();

    // Rafraîchissez la liste des messages après suppression
    setState(() {
      _messagesFuture = Future.value([]);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(capitalizeFirstLetter(S.of(context).deletedAllSentMessage))),
    );

    MessageService.stopBackgroundProcess();

  }

  Future<void> _restoreMessage(Message message) async {
    DatabaseService db = DatabaseService();
    await db.removeDateMessage(message.id!);

    // Rafraîchissez la liste des messages après suppression
    setState(() {
      _messagesFuture = DatabaseService().getMessagesWithDate();  // Recharge la liste après suppression
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(capitalizeFirstLetter(S.of(context).restoredMessage))),
    );

    const platform = MethodChannel('com.olivier.ettlin.geomessage/background');
    await platform.invokeMethod('startBackgroundProcess');

  }

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();

    return Scaffold(
      appBar: CustomAppBar(title: capitalizeFirstLetter(S.of(context).sentMessages)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: ElevatedButton(
          onPressed: () => _showDeleteAllSentMessagesConfirmationDialog(context),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            foregroundColor: Colors.red,
            backgroundColor: Colors.white, // Optionnel : couleur de fond
            padding: const EdgeInsets.all(14),
          ),
          child: const Icon(Icons.delete_forever, size: 36), // Agrandir l'icône
        ),
      ),
      body: FutureBuilder<List<Message>>(
        future: _messagesFuture,  // Utilisez la future mise à jour
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affiche un indicateur de chargement pendant l'attente
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Gère les erreurs
            return Center(child: Text('${capitalizeFirstLetter(S.of(context).error)}: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Affiche un message si aucun message n'est disponible
            return Center(child: Text(capitalizeFirstLetter(S.of(context).noSentMessages)));
          } else {
            // Affiche la liste des messages récupérés
            List<Message> messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                Message message = messages[index];
                return CardMessage(
                  message: message,
                  onRestore: () => _restoreMessage(message),
                  onDelete: () => _deleteMessage(message),
                );
              },
            );
          }
        },
      ),
    );
  }
}
