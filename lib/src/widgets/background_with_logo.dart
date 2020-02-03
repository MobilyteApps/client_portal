import "package:flutter/material.dart";

class BackgroundWithLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
                  
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Opacity(opacity: .99, child: Image.asset('images/login-bg_compressed.jpg', fit: BoxFit.cover,colorBlendMode: BlendMode.dstATop,),),
                      Container(color: Color.fromRGBO(255, 255, 255, .7)),
                      Center(
                        child: Image.asset('images/logo.png'),
                      )
                    ],
                  ),
                );
  }
}
