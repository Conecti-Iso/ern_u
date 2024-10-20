import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/memo_widgets/memo_card.dart';
import '../../constants/memo_widgets/memo_card_details.dart';
import '../../constants/primary_button.dart';
import '../../models/memo_model.dart';
import '../../service/memo_service.dart';
import 'my_memos.dart';

class MemoListScreen extends StatefulWidget {
  const MemoListScreen({super.key});

  @override
  State<MemoListScreen> createState() => _MemoListScreenState();
}

class _MemoListScreenState extends State<MemoListScreen> {
  final MemoService _memoService = MemoService();

  final _formKey = GlobalKey<FormState>();
  String _memoTitle = '';
  String _from = '';
  String _memoDescription = '';
  String _memoFileUrl = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _memoService.createMemo(
          memoTitle: _memoTitle,
          from: _from,
          memoDescription: _memoDescription,
          memoFileUrl: _memoFileUrl,
        );
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Memo created successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating memo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Memo>>(
        stream: _memoService.getMemos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No memos found'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final memo = snapshot.data![index];
              return MemoCard(
                memo: memo,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemoDetailScreen(memo: memo),
                    ),
                  );
                },
                isVC: false,
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            backgroundColor: AppColor.kPrimary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyMemos(),
                ),
              );
            },
            label: Text(
              'My Memos',
              style: TextStyle(color: AppColor.kWhite),
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
              backgroundColor: AppColor.kPrimary,
              onPressed: () {
                _showCreateMemoBottomSheet(context);
              },
              label: Row(
                children: [
                  Icon(
                    Icons.add,
                    color: AppColor.kWhite,
                  ),
                  Text(
                    'Add a Memo',
                    style: TextStyle(color: AppColor.kWhite),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void _showCreateMemoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  'Create New Memo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Memo Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) => _memoTitle = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'From'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) => _from = value!,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Memo Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) => _memoDescription = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Paste Memo File URL here'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please paste a file URL';
                    }
                    return null;
                  },
                  onSaved: (value) => _memoFileUrl = value!,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  elevation: 0,
                  onTap: _submitForm,
                  text: 'Create Memo',
                  bgColor: AppColor.kPrimary,
                  borderRadius: 20,
                  height: 46,
                  width: double.infinity,
                  textColor: AppColor.kWhite,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
