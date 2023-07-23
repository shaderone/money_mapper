import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/models/category/category_model.dart';
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
        //IconButton(onPressed: () {}, icon: const Icon(Icons.check_box_outline_blank)),
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
        if (transactionBox.length == 0) {
          return const Center(
            child: Text("List is empty"),
          );
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Income",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Expense",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: transactionBox.length,
                  itemBuilder: (BuildContext context, int index) {
                    final tranasction = transactionBox.values.toList()[index];
                    final parsedDate = DateFormat.yMMMd().format(tranasction.date);
                    final categoryType = tranasction.categoryType;
                    return Slidable(
                      key: const ValueKey(0),
                      startActionPane: const ActionPane(
                        extentRatio: 0.25,
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: null,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.blue,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        extentRatio: 0.25,
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              handleTransactionDeletion(context, index);
                            },
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.red,
                            icon: Icons.delete,
                            label: 'Delete',
                            autoClose: true,
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            spacing: 0,
                          ),
                        ],
                      ),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: categoryType == CategoryType.income
                                  ? [
                                      const Color.fromARGB(255, 250, 251, 255),
                                      const Color.fromARGB(255, 234, 240, 255),
                                    ]
                                  : [
                                      const Color.fromARGB(255, 255, 250, 246),
                                      const Color.fromARGB(255, 255, 241, 232),
                                    ],
                              stops: const [0, 1],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                                child: Container(
                                  height: 40,
                                  width: 5,
                                  color: categoryType == CategoryType.income ? Colors.blue : Colors.amber,
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  minVerticalPadding: 20,
                                  onTap: () {},
                                  title: Text(
                                    tranasction.purpose,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(parsedDate),
                                  trailing: Text(
                                    "${tranasction.amount.toInt().toString()}₹",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox();
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Future<void> handleTransactionDeletion(BuildContext context, int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete Transaction?',
            style: TextStyle(fontSize: 18),
          ),
          //content: const Text('Do you want to delete?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                transactionBox.deleteAt(index);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // Add code for 'No' button action here
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
