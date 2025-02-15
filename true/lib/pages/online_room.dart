import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truth_or_dare/domain/message.dart';
import '../shared/theme/typography.dart';
import '../widgets/trapezoid_button.dart';
import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class OnlineRoom extends StatefulWidget {
  const OnlineRoom({super.key});

  @override
  State<OnlineRoom> createState() => _OnlineRoomState();
}

class _OnlineRoomState extends State<OnlineRoom> {
  bool loading = false;
  late bool isLogin;
  bool isNotLoading = true;
  final url='https://oo9.ir';


  final _username=TextEditingController();
  final _password=TextEditingController();
  final _fullname=TextEditingController();

  @override
  void initState() {
    isLogin = true;
    checkToken();
    super.initState();
  }

  // Future<List<Player>> _fetchPlayers() async {
  //   return NameManager.getSavedPlayers();
  // }

  File? galleryFile;
  final picker = ImagePicker();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 35),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('بازی آنلاین', style: AppTypography.extraBold32),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Color.fromRGBO(155, 149, 165, 1),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: isNotLoading ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (!isLogin) {
                            isLogin = !isLogin;
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        child: Center(
                          child: Text(
                            "ورود",
                            style: isLogin
                                ? AppTypography.semiBold14
                                : AppTypography.semiBold14black,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          gradient: isLogin
                              ? LinearGradient(colors: [
                            Color.fromRGBO(84, 66, 134, 1),
                            Color.fromRGBO(126, 93, 220, 1)
                          ])
                              : LinearGradient(colors: [
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromRGBO(255, 255, 255, 1)
                          ]),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (isLogin) {
                            isLogin = !isLogin;
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        child: Center(
                          child: Text(
                            "ثبت نام",
                            style: isLogin
                                ? AppTypography.semiBold14black
                                : AppTypography.semiBold14,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          gradient: isLogin
                              ? LinearGradient(colors: [
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromRGBO(255, 255, 255, 1)
                          ])
                              : LinearGradient(colors: [
                            Color.fromRGBO(84, 66, 134, 1),
                            Color.fromRGBO(126, 93, 220, 1)
                          ]),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.51,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        left: isLogin
                            ? MediaQuery.of(context).size.width * 0.0
                            : -MediaQuery.of(context).size.width * 0.7,
                        duration: Duration(milliseconds: 200),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 1.4,
                          height: MediaQuery.of(context).size.height * 0.51,
                          child: Row(
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      width: MediaQuery.sizeOf(context).width * 0.7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextField(
                                          controller: _username,
                                          style: AppTypography.semiBold14black,
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(20.0),
                                            ),
                                            hintText: 'نام کاربری',
                                            hintStyle:
                                            AppTypography.semiBold14black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                                    Container(
                                      width: MediaQuery.sizeOf(context).width * 0.7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextField(
                                          controller: _password,
                                          style: AppTypography.semiBold14black,
                                          obscureText: true,
                                          obscuringCharacter: '●',
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(20.0),
                                            ),
                                            hintText: 'رمز عبور',
                                            hintStyle:
                                            AppTypography.semiBold14black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 15),
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      child: TrapezoidButton(
                                        onPressed: () {
                                          setState(() {
                                            isNotLoading=!isNotLoading;
                                          });
                                          login(username: _username, password: _password);
                                        },
                                        enabled: true,
                                        child: Text('ورود',
                                            style:
                                            AppTypography.extraBlackBold24),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0)),
                                ),
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: MediaQuery.of(context).size.height * 0.5,
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      width: 80,
                                      height: 80,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(40),
                                            ),
                                            child: galleryFile != null
                                                ? ClipRRect(
                                              borderRadius: BorderRadius.circular(40),
                                              child: Image.file(
                                                galleryFile!,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                                : Icon(
                                              Icons.person_2_rounded,
                                              color: Colors.black26,
                                              size: 70,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            right: 10,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(3),
                                              child: InkWell(
                                                onTap: () {
                                                  _showPicker(context: context);
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.black,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                      ),
                                      width:
                                      MediaQuery.sizeOf(context).width * 0.7,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextField(
                                          style: AppTypography.semiBold14black,
                                          textAlign: TextAlign.right,
                                          controller: _username,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(20.0),
                                            ),
                                            hintText: 'نام کاربری',
                                            hintStyle: AppTypography.semiBold14black,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                      ),
                                      width:
                                      MediaQuery.sizeOf(context).width * 0.7,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextField(
                                          style: AppTypography.semiBold14black,
                                          obscureText: true,
                                          controller: _password,
                                          obscuringCharacter: '●',
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(20.0),
                                            ),
                                            hintText: 'رمز عبور',
                                            hintStyle: AppTypography.semiBold14black,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(bottom: 15),
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      child: TrapezoidButton(
                                        onPressed: (){
                                          setState(() {
                                            isNotLoading=!isNotLoading;
                                          });
                                          signUp(
                                            username: _username.text,
                                            password: _password.text,
                                            fullname: _fullname.text,
                                          );
                                        },
                                        enabled: true,
                                        child: Text('ثبت نام',
                                            style:
                                            AppTypography.extraBlackBold24),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0)),
                                ),
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: MediaQuery.of(context).size.height * 0.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ) : Center(
              child: CircularProgressIndicator(
                color: const Color.fromRGBO(126, 93, 220, 1),
              ),
            ),
          ),
        ),
      ),
    );
  }


  void signUp({required username, required password, required fullname}) async{
    var request = http.MultipartRequest('POST', Uri.parse('${url}/api/create-user'));
    request.fields.addAll({
      'username': username,
      'password': password,
      'userfullname': 'userfullname'
    });

    if (galleryFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'userimage',
        galleryFile!.path,
      ));
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    http.StreamedResponse response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(responseBody);
    if (response.statusCode == 200 || response.statusCode == 201) {
      await prefs.setString('token', jsonResponse['token']);
      await message.success(message: '${jsonResponse['message']}', context: context, token: '${jsonResponse['token']}', url: url);
    }
    else {
      await message.failed(message: '${jsonResponse['message']}', context: context);
    }
    setState(() {
      isNotLoading = !isNotLoading;
    });
  }

  void login({required username, required password}) async{
    var request = http.MultipartRequest('POST', Uri.parse('${url}/api/login'));
    request.fields.addAll({
      'username': username.text,
      'password': password.text
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    http.StreamedResponse response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(responseBody);

    if (response.statusCode == 200) {
      await prefs.setString('token', jsonResponse['access_token']);
      await message.success(message: '${jsonResponse['message']}', context: context, token: '${jsonResponse['access_token']}', url: url);
    }
    else {
      await message.failed(message: '${jsonResponse['message']}', context: context);
    }
    setState(() {
      isNotLoading = !isNotLoading;
    });
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('گالری'),
                  onTap: () {
                    getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('دوربین'),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);

    setState(() {
      if (pickedFile != null) {
        compressImage(File(pickedFile.path)).then((compressedFile) {
          galleryFile = compressedFile; // Save the compressed file
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text('چیزی انتخاب نکردید'),
            ),
          ),
        );
      }
    });
  }

  Future<File?> compressImage(File file) async {
    final filePath = file.absolute.path;

    final lastIndex = filePath.lastIndexOf('.');
    final outPath = "${filePath.substring(0, lastIndex)}_compressed${filePath.substring(lastIndex)}";

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 10,
    );
    File? compressFile;
    setState(() {
      compressFile = File(compressedFile!.path);
    });
    return compressFile;
  }

  void checkToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = await prefs.getString('token');
    print('myToken: ${myToken.toString()}');

    var headers = {
      'Authorization': 'Bearer ' + myToken.toString()
    };
    var request = http.MultipartRequest('GET', Uri.parse('${url}/api/me'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      await message.success(message: 'با موفقیت وارد شدید', context: context, token: myToken.toString(), url: url);
    }


  }
}

