import 'package:flutter/material.dart';

class ObjectCard extends StatelessWidget {

  String name;
  String url;

  ObjectCard({
    this.name,
    this.url
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 140,
      // width: 10,
      padding: EdgeInsets.all(12.0),
      child: Container(
        height: 140,
        width: 140,
        margin: EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
            url==null
            ?
            AssetImage('assets/vase.png')
            :
            AssetImage(url)
            ,
            colorFilter:  ColorFilter.mode(
                  Colors.white.withOpacity(0.75),
                  BlendMode.dstATop
                ),
          ),
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            // color: Colors.white
          )
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  name==null?"Flower Vase":name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}/*Text(
        "s",
        style: TextStyle(
          color: Colors.white
        ),*/