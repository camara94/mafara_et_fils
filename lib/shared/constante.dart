import 'package:flutter/material.dart';
import 'package:mafara_et_fils/shared/constants.dart';

textInputDecortion ( {name:  'Votre émail'}) {
  return InputDecoration(
                      hintText: name,
                      fillColor: Colors.white,filled: true,
                      enabledBorder: OutlineInputBorder( borderSide: BorderSide( color: kPrimaryColor, width: 2.0 )  ),
                       focusedBorder: OutlineInputBorder( borderSide: BorderSide( color: Colors.pink, width: 2.0 )  )
                    );
}


