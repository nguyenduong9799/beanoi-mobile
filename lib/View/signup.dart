import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          // fit: StackFit.expand,
          children: [
            // BACKGROUND
            Container(
              color: Color(0xFFddf1ed),
              // child: Center(
              //   child: Text('SIGNUP'),
              // ),
            ),
            // SIGN-UP FORM
            Stack(
              overflow: Overflow.visible,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(25),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                  width: screenWidth,
                  height: screenHeight * 0.65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HELLO SECTION
                      Text(
                        "Vài bước nữa là xong rồi nè!",
                        style: TextStyle(
                          color: Color(0xFF00d286),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Giúp mình điền vài thông tin dưới đây nhé.",
                        style: TextStyle(
                          color: Color(0xFF00d286),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 30),
                      // FORM ITEM
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            _buildFormItem("Họ Tên", "Nguyễn Văn A"),
                            _buildFormItem("Số Điện Thoại", "012345678"),
                            _buildFormItem("Ngày sinh", "01/01/2020"),
                            _buildFormItem("Ngày sinh", "01/01/2020"),
                            _buildFormItem("Ngày sinh", "01/01/2020"),
                            _buildFormItem("Ngày sinh", "01/01/2020"),
                          ],
                        ),
                      ),

                      //SIGN UP BUTTON
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Center(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              // side: BorderSide(color: Colors.red),
                            ),
                            color: Color(0xFF00d286),
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Hoàn thành",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: screenWidth * 0.55,
                  child: ClipPath(
                    clipper: TriangleClipPath(),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormItem(String label, String hintText) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   label.toUpperCase(),
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black,
          //   ),
          // ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: hintText,
              labelText: label,
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
