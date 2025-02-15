import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:truth_or_dare/domain/domains.dart';
import 'package:truth_or_dare/domain/message.dart';
import 'package:truth_or_dare/pages/pages.dart';
import 'package:truth_or_dare/shared/theme/typography.dart';
import '../pages/online_room.dart';
import '../widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ModeCard extends StatefulWidget {
  final Color color;
  final String imageUrl;
  final String title;
  final TruthOrDareCategory mode;
  final String description;
  final String number;
  final bool isChat;
  final String? url;

  const ModeCard({
    Key? key,
    required this.color,
    required this.imageUrl,
    required this.title,
    required this.mode,
    required this.description,
    required this.number,
    required this.isChat,
    this.url,
  }) : super(key: key);

  @override
  State<ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<ModeCard> {
  late bool isNotLoading;
  @override
  void initState() {
    isNotLoading = true;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 184.w,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () => _onTap(context),
          child: Container(
            height: 245.w,
            decoration: BoxDecoration(
              border: Border.all(color: widget.color, width: 2),
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [RandomColorGenerator.lighten(widget.color, 0.1), Colors.black87],
              ),
            ),
            child: isNotLoading ? Stack(
              children: [
                Center(child: _buildContent(context)),
                if (widget.mode == TruthOrDareCategory.lvl7) _buildLockOverlay(),
                if (widget.mode != TruthOrDareCategory.lvl7) _buildCardCounter(),
              ],
            ) :
            Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(126, 93, 220, 1),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    if (widget.number != '?' && !widget.isChat) {
      final gameModel = Provider.of<GameModel>(context, listen: false);
      gameModel.setMode(widget.mode);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlayerListPage()),
      );
    }else if(widget.isChat){
      setState(() {
        isNotLoading = false;
      });
      checkToken();
    }else {
      _showComingSoonSnackBar(context);
    }
  }


  void _showComingSoonSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      content: Text(
        'به زودی در نسخه جدید اضافه خواهد شد',
        style: AppTypography.extraBold28,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
      ),
      backgroundColor: Colors.black,
    ));
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 80.h,
          child: Image.asset(
            'lib/assets/flat/${widget.imageUrl}',
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              Text(
                widget.title,
                textDirection: TextDirection.rtl,
                style: AppTypography.extraBold28,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              Text(
                widget.description,
                textDirection: TextDirection.rtl,
                style: AppTypography.semiBold14,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLockOverlay() {
    return Positioned(
      top: -1,
      right: -1,
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Image.asset('lib/assets/flat/lock.png', width: 20.w),
      ),
    );
  }

  Widget _buildCardCounter() {
    return Positioned(
      bottom: -1,
      right: -1,
      child: Container(
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            '${widget.number} کارت',
            style: AppTypography.semiBold13,
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
  }

  void checkToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = await prefs.getString('token');
    print('myToken: ${myToken.toString()}');

    var headers = {
      'Authorization': 'Bearer ' + myToken.toString()
    };
    var request = http.MultipartRequest('GET', Uri.parse('${widget.url}/api/me'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      await message.success(message: 'با موفقیت وارد شدید', context: context, token: myToken.toString(), url: widget.url.toString());
    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OnlineRoom()),
      );
    }


  }
}
