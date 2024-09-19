import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news_model.dart';

Widget newsCard(NewsModel model, double width) {
  return InkWell(
    onTap: () async {
      final Uri uri = Uri.parse(model.getLink());
      print("..........${model.getLink()}");
      if(await canLaunchUrl(uri))  {
        await launchUrl(uri);
      }
    },
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        child: Container(
          width: width,
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(children: [
                    Icon(Icons.person, size: 20, color: Colors.amber,),
                    SizedBox(width: 10,), Text(model.getSource()) ],),
                  SizedBox(height: 10,),
                  Center(
                    child: SizedBox(width: width * .5, height: 70,
                      child: Text(model.title ?? "", overflow: TextOverflow.clip,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),),
                  )
                ],
              ),
              ClipRRect(borderRadius: BorderRadius.circular(15) ,
                child: Image.network(model.getImage(), width: width*.4, height: 100,fit: BoxFit.fill,),
              )
            ],
          ),
        ),
      ),
    ),
  );
}