import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/memo_widgets/memo_card.dart';
import '../../constants/memo_widgets/memo_card_details.dart';
import '../../constants/primary_button.dart';
import '../../models/memo_model.dart';
import '../../service/memo_service.dart';
import 'Books/my_memos.dart';


class VCMemList extends StatefulWidget {
  const VCMemList({super.key});

  @override
  State<VCMemList> createState() => _VCMemListState();
}

class _VCMemListState extends State<VCMemList> {
  final MemoService _memoService = MemoService();

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
                }, isVC: true,
              );
            },
          );
        },
      ),
    );
  }
}
