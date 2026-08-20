import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/iap_bloc.dart';
import 'data/services/iap_service.dart';
import 'iap_widgets.dart';

class IAPPage extends StatefulWidget {
  const IAPPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IAPPageState();
  }
}

class IAPPageState extends State<IAPPage> {
  final iapService = IAPService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final iapBloc = context.read<IAPBloc>();
      await iapService.initialize(iapBloc);
    },);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WordZoo')),
      body: Column(
        children: [
          // Sử dụng PremiumStatusWidget
          BlocBuilder<IAPBloc, IAPState>(
            builder: (context, state) {
              return PremiumStatusWidget(
                state: state,
                onUpgrade: () {
                  context.read<IAPBloc>().add(const PurchasePremium('premium_monthly'));
                },
                message: 'Tải lên Premium để không giới hạn',
              );
            },
          ),
          Expanded(
            child: Center(
              child: BlocBuilder<IAPBloc, IAPState>(
                builder: (context, state) {
                  if (state is PremiumActive) {
                    return Text('Bạn đã có Premium!');
                  } else if (state is PremiumInactive) {
                    return ElevatedButton(
                      onPressed: () {
                        context.read<IAPBloc>().add(const PurchasePremium('premium_monthly'));
                      },
                      child: const Text("Mua Premium - \$4.99/tháng"),
                    );
                  } else if (state is IapLoading) {
                    return IAPLoadingWidget();
                  } else if (state is IapError) {
                    return IAPErrorWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<IAPBloc>().add(const CheckPremiumStatus());
                      },
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}