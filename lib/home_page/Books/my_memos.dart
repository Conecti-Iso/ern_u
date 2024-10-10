import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/memo_widgets/memo_card_details.dart';
import '../../models/memo_model.dart';
import '../../service/memo_service.dart';

class MyMemos extends StatelessWidget {
  final MemoService _memoService = MemoService();

  MyMemos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          title: Text('My Memos', style: TextStyle(color: AppColor.kWhite),),
          backgroundColor: AppColor.kPrimary
      ),
      body: StreamBuilder<List<Memo>>(
        stream: _memoService.getMyMemos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('You haven\'t created any memos yet'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final memo = snapshot.data![index];
              return Dismissible(
                key: Key(memo.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _memoService.deleteMemo(memo.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Memo deleted')),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(memo.memoTitle),
                    subtitle: Text(memo.from),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditDialog(context, memo),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _showDeleteDialog(context, memo),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemoDetailScreen(memo: memo),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, Memo memo) {
    final titleController = TextEditingController(text: memo.memoTitle);
    final fromController = TextEditingController(text: memo.from);
    final descriptionController = TextEditingController(text: memo.memoDescription);
    final fileUrlController = TextEditingController(text: memo.memoFileUrl);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Memo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: fromController,
                decoration: const InputDecoration(labelText: 'From'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextField(
                controller: fileUrlController,
                decoration: const InputDecoration(labelText: 'File URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              _memoService.updateMemo(
                memoId: memo.id,
                memoTitle: titleController.text,
                from: fromController.text,
                memoDescription: descriptionController.text,
                memoFileUrl: fileUrlController.text,
              );
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Memo updated')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Memo memo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Memo'),
        content: const Text('Are you sure you want to delete this memo?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              _memoService.deleteMemo(memo.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Memo deleted')),
              );
            },
          ),
        ],
      ),
    );
  }
}