import 'package:flutter/material.dart';
import '../../models/document.dart';
import '../../services/document_service.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentState();
}

class _DocumentState extends State<Documents> {
  final DocumentService _documentService = DocumentService();
  List<Document> documents = [];
  Map<String, String> documentContents = {};

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  void _loadDocuments() async {
    List<Document> loadedDocuments = await _documentService.getDocuments();
    setState(() {
      documents = loadedDocuments;
    });
  }

  void _addNewDocument(String title, String content) {
    setState(() async {
      Document newDocument = await _documentService.addDocument(title, content);
      documents.add(newDocument);
    });
  }

  Future<void> _loadDocumentContent(String id) async {
    String content = await _documentService.getDocumentContent(id);
    setState(() {
      documentContents[id] = content;
    });
  }

  void _showAddDocumentDialog() {
    String title = '';
    String content = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Document'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              SizedBox(
                height: 200, // Adjust the height as needed
                width: double.infinity, // Makes the TextField take the full width of its parent
                child: TextField(
                  maxLines: null, // Makes the TextField expandable or you can set a specific number
                  decoration: const InputDecoration(labelText: 'Content'),
                  onChanged: (value) {
                    content = value;
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ajouter'),
              onPressed: () {
                _addNewDocument(title, content);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepOrangeAccent,
        child: ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            var document = documents[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ExpansionTile(
                title: Text(document.title),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: documentContents.containsKey(document.id)
                        ? Text(documentContents[document.id]!)
                        : FutureBuilder(
                            future: _loadDocumentContent(document.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(documentContents[document.id] ?? 'No content');
                              }
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDocumentDialog,
        tooltip: 'Add Document',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
