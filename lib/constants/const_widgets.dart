// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../models/news_model.dart';
// import 'package:get/get.dart';
//
// import '../news_pages/news_details.dart';
//
//
// Widget newsCard(NewsModel model, double width) {
//   return InkWell(
//     onTap: () async {
//       if(model.sourceName == "Uner") {
//         Get.to(() => NewsDetails(news: model));
//       } else {
//         final Uri uri = Uri.parse(model.getLink());
//         if(await canLaunchUrl(uri))  {
//           await launchUrl(uri);
//         }
//       }
//     },
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5),
//       child: Card(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         elevation: 0,
//         child: SizedBox(
//           width: width,
//           height: 120,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(children: [
//                       const Icon(Icons.person, size: 20, color: Colors.blueAccent,),
//                       const SizedBox(width: 10,), SizedBox( width: width *.4,child: Text(model.getSource(), overflow: TextOverflow.ellipsis,))]),
//                     const SizedBox(height: 10,),
//                     Center(
//                       child: SizedBox(width: width * .5, height: 70,
//                         child: Text(model.title ?? "", overflow: TextOverflow.clip,
//                           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),),
//                     )
//                   ],
//                 ),
//               ),
//               ClipRRect(borderRadius: BorderRadius.circular(15) ,
//                 child: Image.network(model.getImage(), width: width*.4, height: 120,fit: BoxFit.fill,),
//               )
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

import '../models/news_model.dart';
import '../news_pages/news_details.dart';

Widget newsCard(NewsModel model, double width) {

  return Hero(
    tag: model.url ?? "news-${model.hashCode}",
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            if(model.sourceName == "Uner") {
              Get.to(() => NewsDetails(news: model),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            } else {
              final Uri uri = Uri.parse(model.getLink());
              if(await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      width: width,
                      height: width * 0.45,
                      child: Image.network(
                        model.getImage(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: width,
                          height: width * 0.45,
                          color: Colors.grey.shade100,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: width,
                            height: width * 0.45,
                            color: Colors.grey.shade50,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Source tag overlay
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          model.getSource(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      model.description ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Credit: ${model.sourceName ?? "Unknown" }',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Icon(
                          model.sourceName == "Uner" ? Icons.arrow_forward : Icons.open_in_new,
                          size: 16,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}