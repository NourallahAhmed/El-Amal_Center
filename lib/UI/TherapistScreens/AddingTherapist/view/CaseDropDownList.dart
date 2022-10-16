import 'package:flutter/material.dart';

import '../../../../utils/Constants.dart';

class CaseDropDownList extends StatefulWidget {
  List cases;
  var _clientCase;

  CaseDropDownList({Key? key , required List<String> this.cases}) : super(key: key);



  @override
  State<CaseDropDownList> createState() => _CaseDropDownListState(this.cases , this._clientCase);
}

class _CaseDropDownListState extends State<CaseDropDownList> {
  var cases = [];

  var clientCase;

  _CaseDropDownListState(this.cases, this.clientCase);
  initState(){
    clientCase = cases.first;
  }

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.all(8.0),
      child:        Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            decoration:  BoxDecoration(

                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border:  Border.all(color: RBackgroundColor)
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  isExpanded:true,
                  borderRadius: BorderRadius.circular(30),
                  hint: const Text("Case"),
                  value: clientCase,
                  items:
                  cases.map((items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(items , style: TextStyle( fontSize: 17),),
                      ),
                    );
                  }).toList(),
                  onChanged: (value){
                    setState((){
                      this.clientCase = value.toString();
                    });
                  }
              ),
            ),
          )
      ),
    );
  }
}
