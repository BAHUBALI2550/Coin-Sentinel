import 'package:d_app/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/transaction_model.dart';
import '../../utils/colors.dart';

class WithdrawPage extends StatefulWidget {
  final DashboardBloc dashboardBloc;
  const WithdrawPage({super.key, required this.dashboardBloc});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  @override
  final TextEditingController addresscontroller = TextEditingController();
  final TextEditingController amountcontroller = TextEditingController();
  final TextEditingController reasoncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.redaccent,
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 80,),
            Text("Withdraw Detail",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20,),
            // TextField(
            //   controller: addresscontroller,
            //   decoration: InputDecoration(
            //     hintText: "Enter the address",
            //   ),
            // ),
            TextField(
              controller: amountcontroller,
              decoration: InputDecoration(
                hintText: "Enter the amount",
              ),
            ),
            TextField(
              controller: reasoncontroller,
              decoration: InputDecoration(
                hintText: "Enter the reason",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: (){
                widget.dashboardBloc.add(DashboardWithdrawEvent(transactionModel: TransactionModel(
                  addresscontroller.text,
                  int.parse(amountcontroller.text),
                  reasoncontroller.text,
                  DateTime.now(),
                  0,
                )));
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "- WITHDRAW",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
