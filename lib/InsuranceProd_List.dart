
import 'package:flutter/material.dart';
import 'package:flutter_assign/InsuranceProd.dart';

class InsuranceProdList extends ListTile {
   InsuranceProdList(InsuranceProd insuranceProd) : super(
    title: Text(insuranceProd.prod_title,style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
    subtitle: Text("${insuranceProd.prod_desc}",style: TextStyle(fontSize: 14),),
    leading: Image.asset("${insuranceProd.prod_image}"),
     dense: true
  );
}
