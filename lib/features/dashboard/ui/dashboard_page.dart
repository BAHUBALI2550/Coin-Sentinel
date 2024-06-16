import 'package:d_app/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:d_app/features/deposit/deposit.dart';
import 'package:d_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bloc/bloc.dart';

import '../../../View/home.dart';
import '../../withdraw/withdraw.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  final DashboardBloc dashboardBloc = DashboardBloc();

  void initState(){
    dashboardBloc.add(DashboardInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //backgroundColor: Color(0xfff5c084),
      // appBar: AppBar(
      //   title: Text('Web3 Bank'),
      //   centerTitle: true,
      //   backgroundColor: AppColors.accent,
      // ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        bloc: dashboardBloc,
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    switch(state.runtimeType){
      case DashboardLoadingState:
        return Center(
          child: CircularProgressIndicator(),
        );
      case DashboardErrorState:
        return Center(
          child: Text('Error'),
        );
      case DashboardSuccessState:
        final successState = state as DashboardSuccessState;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accent,
                  Color(0xffe3e32d),
                ]),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: Text(
                          'Main portfolio',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      // Text(
                      //   'Top 10 coins',
                      //   style: TextStyle(fontSize: 18),
                      // ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.02, vertical: MediaQuery.of(context).size.height * 0.005),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                            'My Wallet',
                            style: TextStyle(fontSize: 18),
                          ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/Eth.png",
                          height: 55,
                          width: 55,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(successState.balance.toString()+' ETH',style: TextStyle(fontSize: 50,
                            fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (contect)=> WithdrawPage(dashboardBloc: dashboardBloc,) ));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.redaccent,
                          ),
                          child: Center(
                            child: Text("- Debit",
                              style: TextStyle(color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (contect)=> DepositPage(dashboardBloc: dashboardBloc,

                          ) ));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.greenaccent,
                          ),
                          child: Center(
                            child: Text("+ Credit",
                              style: TextStyle(color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Text("Transactions",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Expanded(child: ListView.builder(
                  itemCount: successState.transactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 6),
                      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/Eth.png",
                                    height: 24,width: 24,),
                                  const SizedBox(width: 6,),
                                  Text(successState.transactions[index].amount.toString()+" ETH",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                ],
                              ),
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: successState.transactions[index].task == 0 ? Colors.redAccent:Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ],
                          ),
                          Text(successState.transactions[index].address,style: TextStyle(fontSize: 12),),
                          Text(successState.transactions[index].reason,style: TextStyle(fontSize: 16),),
                        ],
                      ),
                    );
                  },
                )),
              ],
            ),
          ),
        );
      default:
        return SizedBox();
    }
  },
),
    );
  }
}
