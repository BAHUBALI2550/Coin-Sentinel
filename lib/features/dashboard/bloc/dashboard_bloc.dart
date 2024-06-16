import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:d_app/models/transaction_model.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardInitialFetchEvent>(dashboardInitialFetchEvent);
    on<DashboardDepositEvent>(dashboardDepositEvent);
    on<DashboardWithdrawEvent>(dashboardWithdrawEvent);
  }

  List<TransactionModel> transactions = [];
  Web3Client? _web3client; //uses web3dart package 
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _creds;
  int balance = 0;

  //Functions
  late DeployedContract _deployedContract;
  late ContractFunction _deposit;
  late ContractFunction _withdraw;
  late ContractFunction _getBalance;
  late ContractFunction _getAllTransactions;

  FutureOr<void> dashboardInitialFetchEvent(
      DashboardInitialFetchEvent event, Emitter<DashboardState> emit) async{
    emit(DashboardLoadingState());

    try{

      final String rpcUrl =
       Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';
      final String socketUrl =
       Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';
      final String privateKey = "0x102e33d5d5d3aa9455d21dcb6adf0c3b52bcb63221abfcfa4cfd5a8721dea20b"; // not preffered to hardcode in the app, we can use third party app walletconnect to metamask with the app


      _web3client  = Web3Client(rpcUrl, http.Client(),
        socketConnector: (){
          return IOWebSocketChannel.connect(socketUrl).cast<String>();
        },
      );

      // getABI
      String abiFile = await rootBundle.loadString('build/contracts/ExpenseManagerContract.json');
      var jsonDecoded = jsonDecode(abiFile);
      _abiCode = ContractAbi.fromJson(jsonEncode(jsonDecoded['abi']), 'ExpenseManagerContract');
      _contractAddress = EthereumAddress.fromHex("0x1b1b1ba8257222E89BC87d3E9De958d74E8804BF");
      _creds = EthPrivateKey.fromHex(privateKey);

      //get deployed contract
      _deployedContract = DeployedContract(_abiCode, _contractAddress);
      _deposit = _deployedContract.function("deposit");
      _withdraw = _deployedContract.function("withdraw");
      _getBalance = _deployedContract.function("getBalance");
      _getAllTransactions = _deployedContract.function("getAllTransactions");


      final transactionsData = await _web3client!.call(
          contract: _deployedContract,
          function: _getAllTransactions,
          params: []);
      final balanceData = await _web3client!.call(
          contract: _deployedContract,
          function: _getBalance,
          params: [EthereumAddress.fromHex("0x29eD3591BDee42AB08D06fcf8c6370c404Fb8AB1")]);

      List<TransactionModel> trans = [];
      for(int i = 0; i < transactionsData[0].length; i++)
        {
          TransactionModel transactionModel = TransactionModel(
              transactionsData[0][i].toString(),
              transactionsData[1][i].toInt(),
              transactionsData[2][i],
              DateTime.fromMicrosecondsSinceEpoch(transactionsData[3][i].toInt()),
              transactionsData[4][i].toInt(),
          );
          trans.add(transactionModel);
        }
      transactions = trans;

      int bal = balanceData[0].toInt();
      balance = bal;
      emit(DashboardSuccessState(transactions: transactions, balance: balance));
    }catch(e){
      log(e.toString());
      emit(DashboardErrorState());
    }
  }

  FutureOr<void> dashboardDepositEvent(
      DashboardDepositEvent event, Emitter<DashboardState> emit) async{
    try {
      final transaction = Transaction.callContract(
          from: EthereumAddress.fromHex(
              "0x29eD3591BDee42AB08D06fcf8c6370c404Fb8AB1"),
          contract: _deployedContract,
          function: _deposit,
          parameters: [
            BigInt.from(event.transactionModel.amount),
            event.transactionModel.reason
          ],
          value: EtherAmount.inWei(BigInt.from(event.transactionModel.amount)));

      final result = await _web3client!.sendTransaction(_creds, transaction,
          chainId: 1337, fetchChainIdFromNetworkId: false);
      log(result.toString());
      add(DashboardInitialFetchEvent());
    } catch (e) {
      log(e.toString());
    }
  }

  FutureOr<void> dashboardWithdrawEvent(
      DashboardWithdrawEvent event, Emitter<DashboardState> emit) async{
    try {
      final transaction = Transaction.callContract(
        from: EthereumAddress.fromHex(
            "0x29eD3591BDee42AB08D06fcf8c6370c404Fb8AB1"),
        contract: _deployedContract,
        function: _withdraw,
        parameters: [
          BigInt.from(event.transactionModel.amount),
          event.transactionModel.reason
        ],
      );

      final result = await _web3client!.sendTransaction(_creds, transaction,
          chainId: 1337, fetchChainIdFromNetworkId: false);
      log(result.toString());
      add(DashboardInitialFetchEvent());
    } catch (e) {
      log(e.toString());
    }
  }
}
