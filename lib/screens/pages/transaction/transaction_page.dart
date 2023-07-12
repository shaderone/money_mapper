import 'package:flutter/material.dart';
import 'package:money_management_app/screens/home/home_screen.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Colors.white,
        title: ValueListenableBuilder(
            valueListenable: HomeScreen.currentIndexNotifier,
            builder: (BuildContext context, int currentIndex, Widget? _) {
              return const Text("Transactions");
            }),
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: 10,
          separatorBuilder: (BuildContext context, int index) {
            return const ListTile(
              title: Text("hi"),
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 10);
          },
        ),
      ),
    );
  }
}
