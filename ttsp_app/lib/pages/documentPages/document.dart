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

  void _addNewDocument() {
    // For simplicity, adding a new document with a timestamp
    setState(() {
      // documents.add();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepOrangeAccent,
        child: ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ExpansionTile(
                title: Text(documents[index]
                    .title), // Assuming documents[index] has a title property
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(documents[index]
                        .content), // Assuming documents[index] has a content property
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewDocument,
        tooltip: 'Add Document',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
