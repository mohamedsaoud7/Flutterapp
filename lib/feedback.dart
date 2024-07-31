import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Feedback extends StatelessWidget {
  Feedback({super.key});
  final Color FirstColor = const Color.fromRGBO(113, 30, 62, 1);
  final Color SecondColor = const Color.fromRGBO(5, 30, 62, 1);
  final Color ThirdColor = const Color.fromRGBO(255, 246, 213, 1);
  final FeedBackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        gradient:
                            LinearGradient(colors: [FirstColor, SecondColor]),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.red,
                              blurRadius: 12,
                              offset: Offset(0, 6))
                        ]),
                  ),
                ),
                const Positioned(
                    top: 50,
                    left: 25,
                    child: Text('Feedback',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 246, 213, 1),
                            fontSize: 25))),
                const Positioned(
                    top: 85,
                    left: 25,
                    child: Text('Can you tell me more about your',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 246, 213, 1),
                            fontSize: 18))),
                const Positioned(
                    top: 110,
                    left: 25,
                    child: Text('experience with Alpha Chatbot?',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 246, 213, 1),
                            fontSize: 18))),
                 Positioned(
                    top: 150,
                    left: 25,
                    child: Text('hello')
                      
                    )
              ],
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Tell Us How We Can Improve',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        height: 180,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(14)),
                        child: TextField(
                            controller: FeedBackController,
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            maxLines: 10,
                            decoration: const InputDecoration(
                              errorText: 'Must Not Be Null',
                              hintText: 'Write Here..',
                            )),
                      ),
                    )
                  ],
                ),
                const Center(
                  child: Text('How Would You Rate Our App',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                  ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index)=>IconButton(onPressed: (){}, icon: Icon(Icons.star_border_outlined,color:Colors.red,size: 32))),
                ),
                SizedBox(height: 5,),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(0, 59, 55, 1)
                    
                  ),
                  child: MaterialButton(onPressed: (){},
                  child: const Text('Send Now',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),),
                ),
                Stack(
                  children: [
                    RotatedBox(quarterTurns: 6
                    ,
                    child:ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        gradient:
                            LinearGradient(colors: [FirstColor, SecondColor]),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.red,
                              blurRadius: 12,
                              offset: Offset(0, 6))
                        ]),
                  ),
                ),)
                  ],
        
                )
        
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 70);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 300);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
