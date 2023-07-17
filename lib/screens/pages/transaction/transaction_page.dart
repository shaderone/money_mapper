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
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: TransactionAppbarWidget(),
      ),
      /* TransactionListWidget list all transction using a listView */
      body: SafeArea(child: TransactionListWidget()),
    );
  }
}

class TransactionAppbarWidget extends StatelessWidget {
  const TransactionAppbarWidget({
    super.key,
  });

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
  const TransactionListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: 10,
      separatorBuilder: (BuildContext context, int index) {
        return ListTile(
          minVerticalPadding: 20,
          onTap: () {},
          title: const Text("Groceries"),
          subtitle: const Text("11 June, 2023"),
          trailing: const Text("Rs. 500"),
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return index == 0 ? const SizedBox() : const Divider(height: 1);
      },
    );
  }
}
