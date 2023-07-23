import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/screens/home/home_screen.dart';

import '../../../db/transaction/transaction_db.dart';
import '../../../models/transaction/transaction_model.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final Box<TransactionModel> transactionBox = Hive.box(transactionDBName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: TransactionAppbarWidget(),
      ),
      /* TransactionListWidget list all transction using a listView */
      body: SafeArea(
        child: TransactionListWidget(transactionBox: transactionBox),
      ),
    );
  }
}

class TransactionAppbarWidget extends StatelessWidget {
  const TransactionAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      foregroundColor: Colors.white,
      title: ValueListenableBuilder(
          valueListenable: HomeScreen.currentIndexNotifier,
          builder: (BuildContext context, int currentIndex, Widget? _) {
            return const Text("Transaction History");
          }),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.clean_hands_rounded)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.check_box_outline_blank)),
      ],
    );
  }
}

class TransactionListWidget extends StatelessWidget {
  final Box<TransactionModel> transactionBox;
  const TransactionListWidget({
    super.key,
    required this.transactionBox,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: transactionBox.listenable(),
        builder: (BuildContext context, Box<TransactionModel> transactionBox, Widget? _) {
          return transactionBox.length == 0
              ? const Center(
                  child: Text("List is empty"),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: transactionBox.length,
                  itemBuilder: (BuildContext context, int index) {
                    final tranasction = transactionBox.values.toList()[index];
                    final parsedDate = DateFormat.yMMMd().format(tranasction.date);
                    return ListTile(
                      minVerticalPadding: 20,
                      onTap: () {},
                      title: Text(
                        tranasction.purpose,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(parsedDate),
                      trailing: Text(tranasction.amount.toString()),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(height: 1);
                  },
                );
        });
  }
}
