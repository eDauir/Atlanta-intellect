
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';


// // ignore: must_be_immutable
// class CustomCard extends StatefulWidget {
//   late String img, owner, name, category, imgUser, geo, price;
//   late int id, discount;
//   int favorite;
//   int? index;
//   bool noPadding;
//   bool isCat;

//   CustomCard(
//       {Key? key,
//       required this.img,
//       required this.owner,
//       required this.category,
//       required this.id,
//       this.index,
//       required this.discount,
//       this.favorite = 0,
//       required this.name,
//       required this.price,
//       required this.imgUser,
//       required this.geo,
//       this.noPadding = false,
//       this.isCat = false})
//       : super(key: key);

//   @override
//   State<CustomCard> createState() => _CustomCardState();
// }

// class _CustomCardState extends State<CustomCard> {
//   bool isFavorite = false;

//   @override
//   void initState() {
//     super.initState();

//     isFavorite = widget.favorite == 1 ? true : false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         context.go('/product/${widget.id}');
//       },
//       child: ResponsiveBuilder(builder: (context, sizingInformation) {
//         final screenWidth = sizingInformation.deviceScreenType;
//         final dekstopMargin =
//             EdgeInsets.symmetric(vertical: 20, horizontal: myPadding + 15);
//         const mobMargin = EdgeInsets.all(7);
//         final tabletMargin =
//             EdgeInsets.symmetric(vertical: 20, horizontal: myPadding);

//         final thisMargin = (screenWidth == DeviceScreenType.mobile)
//             ? mobMargin
//             : (screenWidth == DeviceScreenType.tablet)
//                 ? tabletMargin
//                 : dekstopMargin;

//         return Container(
//           margin: widget.noPadding ? const EdgeInsets.all(0) : thisMargin,
//           decoration: BoxDecoration(
//             color: colorWhite,
//             boxShadow: [
//               shadow,
//             ],
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: MouseRegion(
//             cursor: SystemMouseCursors.click,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 buildImage(widget.img, widget.discount, screenWidth,
//                     widget.isCat, context),
//                 Expanded(
//                     child: Container(
//                   margin: const EdgeInsets.only(
//                       top: 9, bottom: 0, left: 13, right: 13),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       // PRICE
//                       if (widget.name.isNotEmpty) nameProduct(screenWidth),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               price(screenWidth),
//                               // geo(screenWidth, context),
//                             ],
//                           ),
//                           avatar(screenWidth)
//                         ],
//                       ),
//                     ],
//                   ),
//                 )),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Row nameProduct(DeviceScreenType screenWidth) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Expanded(
//           child: Text(
//             widget.name,
//             style: const TextStyle(fontSize: 16),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//           ),
//         ),
//       ],
//     );
//   }

//   SizedBox avatar(screenWidth) {
//     return SizedBox(
//       width: 25,
//       height: 25,
//       child: CircularProfileAvatar(
//         '',
//         radius: 30,
//         child: Image.network(
//             filterQuality: FilterQuality.medium,
//             (widget.imgUser),
//             fit: BoxFit.cover,
//           ),
        
//       ),
//     );
//   }

//   Widget geo(DeviceScreenType screenWidth, BuildContext context,
//       [bool minSize = false]) {
//     return SizedBox(
//       width: screenWidth == DeviceScreenType.mobile ? 80 : 120,
//       child: Text(
//         widget.geo,
//         style: TextStyle(
//             fontSize: screenWidth == DeviceScreenType.mobile ? 9 : 12),
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//       ),
//     );
//   }

//   price(DeviceScreenType screenWidth) {
//     return FittedBox(
//       fit: BoxFit.fill,
//       child: SizedBox(
//         width: 100,
//         child: Text(widget.price,
//             style: const TextStyle(fontSize: 16),
//             overflow: TextOverflow.ellipsis),
//       ),
//     );
//   }
// }

// Stack buildImage(String img, int discount, DeviceScreenType screenWidth, isCat,
//     BuildContext context) {
//   return Stack(
//     children: [
//       ClipRRect(
//         borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(10), topRight: Radius.circular(10)),
//         child: SizedBox(
//           // height: MediaQuery.of(context).size.width < 600 ? 120 : 220,
//           child: AspectRatio(
//             aspectRatio: (345 / 300),
//             child: Image.network(
//               img,
//               filterQuality: FilterQuality.medium,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
