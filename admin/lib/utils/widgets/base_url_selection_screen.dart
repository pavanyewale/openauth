import 'package:admin/utils/base_url.dart';
import 'package:admin/utils/widgets/login/service.dart';
import 'package:flutter/material.dart';

class BaseURLSelectionScreen extends StatelessWidget {
  const BaseURLSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String baseURL = "";
    return Scaffold(body:  Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
      TextField(
              maxLines: 1,
              decoration: const InputDecoration(
                constraints: BoxConstraints(maxHeight: 40, maxWidth: 200),
                label: Text('Base URL'),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                isDense: true, // Reduces the height of the input box
                border: OutlineInputBorder(),
                hintText: 'e.g. raj123',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                baseURL = value;
              },
            )
            ,
           const  SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              BaseURL.instance.setBaseURL(baseURL);
              LoginService.instance.markBaseURLSelected();
            }, child: const Text("Okay"))
    ],)));
  }
}