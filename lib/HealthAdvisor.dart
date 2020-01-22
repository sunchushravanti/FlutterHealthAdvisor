import 'package:flutter/material.dart';
import 'package:flutter_assign/InsuranceProd.dart';

class HealthAdvisor extends StatelessWidget {

  final InsuranceProd insuranceProd;
  HealthAdvisor(this.insuranceProd);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.00),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: Colors.grey,
                width: 0.5
            ),
            borderRadius: BorderRadius.circular(15.0),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left:10.0),
                    child: Container(
                      alignment: Alignment.topLeft,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child:  Text("${insuranceProd.prod_title}",textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
                    ),
                  ),
                  SizedBox(height: 20,),

                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blue,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width*0.3,
                          padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                          onPressed: () {},
                          child: Text("Get in Touch",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      )
                  ),

                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.3,
                child:     Image.asset("${insuranceProd.prod_image}",),
              )
            ],
          ),

        )
    );
  }
}
