import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news_model.dart';

Widget newsCard(NewsModel model, double width) {
  return InkWell(
    onTap: () async {
      final Uri uri = Uri.parse(model.getLink());
      if(await canLaunchUrl(uri))  {
        await launchUrl(uri);
      }
    },
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        child: SizedBox(
          width: width,
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(children: [
                      Icon(Icons.person, size: 20, color: Colors.amber,),
                      SizedBox(width: 10,), SizedBox( width: width *.4,child: Text(model.getSource(), overflow: TextOverflow.ellipsis,))]),
                    SizedBox(height: 10,),
                    Center(
                      child: SizedBox(width: width * .5, height: 70,
                        child: Text(model.title ?? "", overflow: TextOverflow.clip,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),),
                    )
                  ],
                ),
              ),
              ClipRRect(borderRadius: BorderRadius.circular(15) ,
                child: Image.network(model.getImage(), width: width*.4, height: 120,fit: BoxFit.fill,),
              )
            ],
          ),
        ),
      ),
    ),
  );
}