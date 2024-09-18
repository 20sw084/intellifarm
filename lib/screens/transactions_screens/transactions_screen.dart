import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/models/transaction.dart';
import 'package:intellifarm/screens/transactions_screens/add_transaction_record.dart';
import '../../util/common_methods.dart';
import '../../widgets/confirm_delete_transaction_dialog.dart';
import 'edit_view_transaction_record.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

String isCheckboxChecked = "Last 7 days";
// bool isIncome = true;

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  bool searchFlag = false;

  late TabController _tabController;
  final ValueNotifier<bool> isIncome = ValueNotifier<bool>(
      true); // Initial state assuming the first tab is Income

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    isIncome.value = _tabController.index == 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    isIncome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  searchFlag = !searchFlag;
                });
                //   Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => const SearchPage(),
                //   ),
                // );
              },
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(50, 50, 0, 0),
                  items: [
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Last 7 days") == 0)
                          ? true
                          : false,
                      value: 1,
                      onTap: () {
                        isCheckboxChecked = "Last 7 days";
                      },
                      child: Text('Last 7 days'),
                    ),
                    CheckedPopupMenuItem(
                      checked:
                          (isCheckboxChecked.compareTo("Current Month") == 0)
                              ? true
                              : false,
                      value: 2,
                      onTap: () {
                        isCheckboxChecked = "Current Month";
                      },
                      child: Text('Current Month'),
                    ),
                    CheckedPopupMenuItem(
                      checked:
                          (isCheckboxChecked.compareTo("Previous Month") == 0)
                              ? true
                              : false,
                      onTap: () {
                        isCheckboxChecked = "Previous Month";
                      },
                      child: Text('Previous Month'),
                      value: 3,
                    ),
                    CheckedPopupMenuItem(
                      checked:
                          (isCheckboxChecked.compareTo("Last 3 Months") == 0)
                              ? true
                              : false,
                      value: 4,
                      onTap: () {
                        isCheckboxChecked = "Last 3 Months";
                      },
                      child: Text('Last 3 Months'),
                    ),
                    CheckedPopupMenuItem(
                      checked:
                          (isCheckboxChecked.compareTo("Last 6 Months") == 0)
                              ? true
                              : false,
                      value: 5,
                      onTap: () {
                        isCheckboxChecked = "Last 6 Months";
                      },
                      child: Text('Last 6 Months'),
                    ),
                    CheckedPopupMenuItem(
                      checked:
                          (isCheckboxChecked.compareTo("Last 12 Months") == 0)
                              ? true
                              : false,
                      value: 6,
                      onTap: () {
                        isCheckboxChecked = "Last 12 Months";
                      },
                      child: Text('Last 12 Months'),
                    ),
                    CheckedPopupMenuItem(
                      checked:
                          (isCheckboxChecked.compareTo("Current Year") == 0)
                              ? true
                              : false,
                      value: 7,
                      onTap: () {
                        isCheckboxChecked = "Current Year";
                      },
                      child: Text('Current Year'),
                    ),
                    CheckedPopupMenuItem(
                      checked:
                          (isCheckboxChecked.compareTo("Previous Year") == 0)
                              ? true
                              : false,
                      value: 8,
                      onTap: () {
                        isCheckboxChecked = "Previous Year";
                      },
                      child: Text('Previous Year'),
                    ),
                    CheckedPopupMenuItem(
                      checked:
                          (isCheckboxChecked.compareTo("Last 3 Years") == 0)
                              ? true
                              : false,
                      value: 9,
                      onTap: () {
                        isCheckboxChecked = "Last 3 Years";
                      },
                      child: Text('Last 3 Years'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("All Time") == 0)
                          ? true
                          : false,
                      value: 10,
                      onTap: () {
                        isCheckboxChecked = "All Time";
                      },
                      child: Text('All Time'),
                    ),
                    CheckedPopupMenuItem(
                      checked:
                          (isCheckboxChecked.compareTo("Custom Range") == 0)
                              ? true
                              : false,
                      value: 11,
                      onTap: () {
                        isCheckboxChecked = "Custom Range";
                      },
                      child: Text('Custom Range'),
                    ),
                  ],
                  // Handle the selected menu item
                  elevation: 8.0,
                ).then((value) {
                  // Handle the selected value
                  switch (value) {
                    case 1:
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => EditFieldRecord(),));
                      break;
                    case 2:
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => AddFieldPlanting(),));
                      break;
                    case 3:
                      // TODO: Print PDF Implementation
                      break;
                    case 4:
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return ConfirmDeleteFieldDialog(
                      //       onConfirm: () {
                      //         // TODO: Perform delete operation here
                      //         print('Item deleted!');
                      //       },
                      //     );
                      //   },
                      // );
                      break;
                  }
                });
              },
              icon: Icon(Icons.filter_list_outlined),
            ),
            IconButton(
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(50, 50, 0, 0),
                  items: [
                    PopupMenuItem(
                      value: 1,
                      onTap: () {
                        // isCheckboxChecked = "Last 7 days";
                      },
                      child: Text('Print PDF'),
                    ),
                    PopupMenuItem(
                      value: 2,
                      onTap: () {
                        // isCheckboxChecked = "Custom Range";
                      },
                      child: Text('Income Type'),
                    ),
                  ],
                  // Handle the selected menu item
                  elevation: 8.0,
                ).then((value) {
                  // Handle the selected value
                  switch (value) {
                    case 1:
                      // TODO: Print PDF Implementation
                      break;
                    case 2:
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return ConfirmDeleteFieldDialog(
                      //       onConfirm: () {
                      //         // TODO: Perform delete operation here
                      //         print('Item deleted!');
                      //       },
                      //     );
                      //   },
                      // );
                      break;
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
              ),
            ),
          ],
          title: searchFlag
              ? Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              /* Clear the search field */
                              setState(() {
                                searchFlag = !searchFlag;
                              });
                            },
                          ),
                          hintText: 'Search...',
                          border: InputBorder.none),
                    ),
                  ),
                )
              : Text("Transactions"),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.30,
                child: Tab(
                  text: 'Income',
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Tab(
                  text: 'Expense',
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            FutureBuilder<List<DocumentSnapshot>>(
              future: getAllIncomeTransactions(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error is: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  List<DocumentSnapshot> transactions = snapshot.data!;
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      var transactionData = transactions[index].data() as Map<String, dynamic>;
                      TransactionModel trans = TransactionModel(
                        transactionSpecificToField: transactionSpecificToFieldFromString(transactionData["transactionSpecificToField"]),
                        fieldName: transactionData["fieldName"],
                        transactionSpecificToPlanting: (transactionData["transactionSpecificToPlanting"] == null ? null : transactionSpecificToPlantingFromString(transactionData["transactionSpecificToPlanting"])),
                        plantingNameTransaction: transactionData["plantingNameTransaction"],
                        typeOfTransaction: transactionData["typeOfTransaction"],
                        transactionTypeOther: transactionData["transactionTypeOther"],
                        earningAmount: transactionData["earningAmount"],
                        transactionDate: transactionData["transactionDate"],
                        receiptNumber: transactionData["receiptNumber"],
                        customerName: transactionData["customerName"],
                        notes: transactionData["notes"] ?? "",
                      );
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 125,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Saleem Flour Mills [${(trans.plantingNameTransaction == null || trans.plantingNameTransaction?.split("|").isEmpty == true) ? "" :
                                  "${(trans.plantingNameTransaction!.split("|").length > 0) ? trans.plantingNameTransaction!.split("|")[0] : ""}${(trans.plantingNameTransaction!.split("|").length > 1) ? ", ${trans.plantingNameTransaction!.split("|")[1]}" : ""}"} ${(trans.fieldName==null ? "": ", ${trans.fieldName}")}]",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(trans.transactionDate),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${trans.earningAmount}",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showMenu(
                                          context: context,
                                          position: RelativeRect.fromLTRB(
                                              50, 50, 0, 0),
                                          items: [
                                            PopupMenuItem(
                                              value: 1,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditViewTransactionRecord(
                                                      type: isIncome.value
                                                          ? "Income"
                                                          : "Expense",
                                                      transaction: trans,
                                                        ),
                                                  ),
                                                );
                                                // isCheckboxChecked = "Last 7 days";
                                              },
                                              child: Text('Edit/View Record'),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return ConfirmDeleteTransactionDialog(
                                                      onConfirm: () {
                                                        // TODO: Perform delete operation here
                                                        print('Item deleted!');
                                                      },
                                                    );
                                                  },
                                                );
                                                // isCheckboxChecked = "Custom Range";
                                              },
                                              child: Text('Delete'),
                                            ),
                                          ],
                                          // Handle the selected menu item
                                          elevation: 8.0,
                                        ).then((value) {
                                          // Handle the selected value
                                          switch (value) {
                                            case 1:
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditViewTransactionRecord(
                                                        type: isIncome.value
                                                            ? "Income"
                                                            : "Expense",
                                                        transaction: trans,
                                                      ),
                                                ),
                                              );
                                              break;
                                            case 2:
                                            // showDialog(
                                            //   context: context,
                                            //   builder: (BuildContext context) {
                                            //     return ConfirmDeleteFieldDialog(
                                            //       onConfirm: () {
                                            //         // TODO: Perform delete operation here
                                            //         print('Item deleted!');
                                            //       },
                                            //     );
                                            //   },
                                            // );
                                              break;
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.more_vert),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("No plantings available"));
                }
              },
            ),
            FutureBuilder<List<DocumentSnapshot>>(
              future: getAllExpenseTransactions(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error is: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  List<DocumentSnapshot> transactions = snapshot.data!;
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      var transactionData = transactions[index].data() as Map<String, dynamic>;
                      TransactionModel trans = TransactionModel(
                        transactionSpecificToField: transactionSpecificToFieldFromString(transactionData["transactionSpecificToField"]),
                        fieldName: transactionData["fieldName"],
                        transactionSpecificToPlanting: (transactionData["transactionSpecificToPlanting"] == null ? null : transactionSpecificToPlantingFromString(transactionData["transactionSpecificToPlanting"])),
                        plantingNameTransaction: transactionData["plantingNameTransaction"],
                        typeOfTransaction: transactionData["typeOfTransaction"],
                        transactionTypeOther: transactionData["transactionTypeOther"],
                        earningAmount: transactionData["earningAmount"],
                        transactionDate: transactionData["transactionDate"],
                        receiptNumber: transactionData["receiptNumber"],
                        customerName: transactionData["customerName"],
                        notes: transactionData["notes"] ?? "",
                      );
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 125,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Raheem Flour Mills [${(trans.plantingNameTransaction == null || trans.plantingNameTransaction?.split("|").isEmpty == true) ? "" :
                                  "${(trans.plantingNameTransaction!.split("|").length > 0) ? trans.plantingNameTransaction!.split("|")[0] : ""}${(trans.plantingNameTransaction!.split("|").length > 1) ? ", ${trans.plantingNameTransaction!.split("|")[1]}" : ""}"} ${(trans.fieldName==null ? "": ", ${trans.fieldName}")}]",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(trans.transactionDate),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${trans.earningAmount}",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showMenu(
                                          context: context,
                                          position: RelativeRect.fromLTRB(
                                              50, 50, 0, 0),
                                          items: [
                                            PopupMenuItem(
                                              value: 1,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditViewTransactionRecord(
                                                          type: isIncome.value
                                                              ? "Income"
                                                              : "Expense",
                                                          transaction: trans,
                                                        ),
                                                  ),
                                                );
                                                // isCheckboxChecked = "Last 7 days";
                                              },
                                              child: Text('Edit/View Record'),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return ConfirmDeleteTransactionDialog(
                                                      onConfirm: () {
                                                        // TODO: Perform delete operation here
                                                        print('Item deleted!');
                                                      },
                                                    );
                                                  },
                                                );
                                                // isCheckboxChecked = "Custom Range";
                                              },
                                              child: Text('Delete'),
                                            ),
                                          ],
                                          // Handle the selected menu item
                                          elevation: 8.0,
                                        ).then((value) {
                                          // Handle the selected value
                                          switch (value) {
                                            case 1:
                                              Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditViewTransactionRecord(
                                                      type: isIncome.value
                                                          ? "Income"
                                                          : "Expense",
                                                      transaction: trans,
                                                    ),
                                              ),
                                            );
                                              break;
                                            case 2:
                                            // showDialog(
                                            //   context: context,
                                            //   builder: (BuildContext context) {
                                            //     return ConfirmDeleteFieldDialog(
                                            //       onConfirm: () {
                                            //         // TODO: Perform delete operation here
                                            //         print('Item deleted!');
                                            //       },
                                            //     );
                                            //   },
                                            // );
                                              break;
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.more_vert),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("No plantings available"));
                }
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Column(
            //     children: const [
            //       Row(
            //         children: [
            //           Expanded(
            //             child: Card(
            //               child: Padding(
            //                 padding: EdgeInsets.only(
            //                   top: 8.0,
            //                   left: 8.0,
            //                   right: 8.0,
            //                 ),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       "Saleem Flour Mills [Wheat, # 1 (Hyderabad Field)]",
            //                       style: TextStyle(
            //                         fontSize: 16,
            //                       ),
            //                     ),
            //                     Text("Jun 14, 2024"),
            //                     Row(
            //                       mainAxisAlignment: MainAxisAlignment.end,
            //                       children: [
            //                         Text(
            //                           "240K PKR",
            //                           style: TextStyle(
            //                             fontSize: 16,
            //                           ),
            //                         ),
            //                         SizedBox(
            //                           width: 30,
            //                         ),
            //                         IconButton(
            //                           onPressed: null,
            //                           icon: Icon(Icons.more_vert),
            //                         ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: isIncome,
          builder: (context, value, child) {
            return Container(
              width: 100,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTransactionRecord(
                          type: value ? "Income" : "Expense",
                        ),
                      ));
                  print(value
                      ? "Currently in Income tab"
                      : "Currently in Expenses tab");
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 4),
                    Text(value ? "Income" : "Expense"),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation
            .centerDocked, // Change the location as needed
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     // isIncome ? 'Income' : 'Expense'
        //     // Add your onPressed action here
        //     // Navigator.push(context, MaterialPageRoute(builder: (context) => AddFieldRecord(),));
        //   },
        //   icon: Icon(Icons.add),
        //   label: Text(isIncome ? 'Income' : 'Expense'),
        //   tooltip: isIncome ? 'Income' : 'Expense', // Tooltip text
        // ),
      ),
    );
  }
}
