import 'package:flutter/material.dart';

class PersonCard extends StatelessWidget {

  String url;
  String name;

  PersonCard({
    this.name,
    this.url
  });

  @override
  Widget build(BuildContext context) {
    print(url);
    return Container(
      // height: 140,
      // width: 10,
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        // height: 140,
        // width: 140,
        height: MediaQuery.of(context).size.height*0.3,
        width: MediaQuery.of(context).size.width*0.36,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: 
            url==null
            ?
            AssetImage(
              'assets/HarshaB.png',
            )
            :
            NetworkImage(
              url
            ),
            fit: BoxFit.cover,
            colorFilter:  ColorFilter.mode(
                  Colors.white.withOpacity(0.60),
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
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.all(6.0),
                child: Image.asset('assets/Trusted.png'),
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