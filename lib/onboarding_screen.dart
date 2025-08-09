import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spotiflow/intro_screens/intro_page_1.dart';
import 'package:spotiflow/intro_screens/intro_page_2.dart';
import 'package:spotiflow/intro_screens/intro_page_3.dart';

import 'intro_screens/transition2home.dart';

class OnBoardingScreen extends StatefulWidget{
  const OnBoardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  //keep track of page
  bool onLastPage = false;
  bool onFirstPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //page view
          PageView(
            controller: _controller,
            onPageChanged: (index){
              setState(() {
                 onLastPage = (index == 2);
                 onFirstPage = (index == 1 || index == 2);
              });
            },
        children: [
          IntroPage1(),
          IntroPage2(),
          IntroPage3(),
        ]
      ),

      //dot indicators
      Container(
        alignment: Alignment(0, 0.8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            //skip
            onFirstPage 
            ? GestureDetector(
              onTap: () {
                _controller.previousPage(
                  duration: Duration(milliseconds: 150), 
                  curve: Curves.easeOut);
              },
              child: Text('Previous',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              ),
              )
               : GestureDetector(
              onTap: () {
                _controller.jumpToPage(2);
              },
              child: Text('Skip',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              ),
              ),


            //dot indicator


            SmoothPageIndicator(controller: _controller, count: 3),

            // next/done
            onLastPage 
            ? GestureDetector(
              onTap: () {
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) {
                    return transition2Home();
                  })
                );
              },
              child: Text('Done',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),)
              ) 
              : GestureDetector(
              onTap: () {
                _controller.nextPage(
                duration: Duration(milliseconds: 150), 
                curve: Curves.easeIn,
                );
              },
              child: Text('Next',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              ),
              ),
          ],
        )),
        ]
      )
    );
  }
}