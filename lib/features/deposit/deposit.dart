import 'package:d_app/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:d_app/models/transaction_model.dart';
import 'package:d_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DepositPage extends StatefulWidget {
  final DashboardBloc dashboardBloc;
  const DepositPage({super.key, required this.dashboardBloc});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {

  final TextEditingController addresscontroller = TextEditingController();
  final TextEditingController amountcontroller = TextEditingController();
  final TextEditingController reasoncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenaccent,
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 80,),
            Text("Deposit Detail",
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
                widget.dashboardBloc.add(DashboardDepositEvent(transactionModel: TransactionModel(
                  addresscontroller.text,
                  int.parse(amountcontroller.text),
                  reasoncontroller.text,
                  DateTime.now(),
                  1,
                )));
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "+ DEPOSIT",
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
