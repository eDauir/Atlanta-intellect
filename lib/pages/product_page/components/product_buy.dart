// import 'package:barber/api/Wallet/IWallet.dart';
// import 'package:barber/api/Wallet/walletApi.dart';
// import 'package:barber/provider/globalData.dart';
// import 'package:barber/res/style/my_theme.dart';
// import 'package:barber/res/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ProductBuy extends StatefulWidget {
//   @override
//   State<ProductBuy> createState() => _ProductBuyState();
// }

// class _ProductBuyState extends State<ProductBuy> {
//   bool isEnableBuyBtn = false;
  

  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Row(
//           children: [
//             IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: Icon(
//                   Icons.arrow_back_sharp,
//                   color: Colors.black,
//                 )),
//           ],
//         ),
//         title: Text(
//           'Оплатить',
//           textScaleFactor: textScale(context),
//           style: Theme.of(context).textTheme.headline2,
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: marginScale(context, 15)),
//         child: Column(
//           children: [
//             Text('Заказ') ,

//           ],
//         ),
//       ),
//       bottomSheet: Container(
//         height: marginScale(context, 64),
//                   padding: EdgeInsets.all(marginScale(context, 10)),
//                   child: ElevatedButton(
//                     onPressed: () async {
//                                                               // return;
//                                         String login = context
//                                                 .read<GlobalData>()
//                                                 .loginToken ??
//                                             '';
//                                         if (login.isEmpty || isEnableBuyBtn)
//                                           return;

//                                         isEnableBuyBtn = true;
//                                         final loadShow = showLoading(context);
//                                         Navigator.of(context).push(loadShow);

//                                         Map paramsToQuery = {
//                                           'authToken': login,
//                                           'productId': widget.id
//                                         };

//                                         List<IWallet> walletInfo =
//                                             await getWalletInfo(login: login);
//                                         if (walletInfo.isEmpty) {
//                                           Navigator.of(context)
//                                               .removeRoute(loadShow);
//                                           return;
//                                         }

//                                         int amount = int.parse(
//                                             walletInfo[0].main![0].amount!);
//                                         int price =
//                                             int.parse(products[0].price!);

//                                         if (amount < price) {
//                                           Navigator.of(context)
//                                               .removeRoute(loadShow);
//                                           Navigator.pop(context);
//                                           notAmount(context);
//                                           return;
//                                         }

//                                         var buyCourse = await buyCourseApi(
//                                             login: login,
//                                             productId: widget.id,
//                                             amount: price.toString());

//                                         if (buyCourse) {
//                                           setState(() {
//                                             isBuy = true;
//                                           });
//                                           await congrutulationBuyDialog(
//                                               context);
//                                         }

//                                         // await getData();
//                                         Navigator.of(context)
//                                             .removeRoute(loadShow);
//                                         Navigator.pop(context);

//                                         // if (isBuy == false &&
//                                         //     payboxLink.isNotEmpty) {
//                                         // } else {
//                                         // }

//                                         isEnableBuyBtn = false;
//                     },
//                     child: Text('Buy'),
//                   ),
//       ) ,
//     );
//   }
// }
