import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kurdivia/Screen/questionpage.dart';
import 'package:kurdivia/constant.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../Widgets/navigatebar.dart';
import '../Widgets/video_player_widget.dart';
import '../provider/ApiService.dart';

class SponsorPage extends StatefulWidget {
  SponsorPage({
    required this.maxsecond,
});
  int maxsecond;
  late BuildContext context;

  @override
  State<SponsorPage> createState() => _SponsorPageState();
}

class _SponsorPageState extends State<SponsorPage> implements ApiStatusLogin {
  late VideoPlayerController controller;
  int Second = 0;
  Timestamp timeevent = Timestamp.now();

  Timer? timer;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value){
      controller = VideoPlayerController.network(Provider.of<ApiService>(context, listen: false).imagesponsor)
        ..addListener(() => setState(() {}))
        ..setLooping(true)
        ..initialize().then((_) => controller.play());
      Second =Provider.of<ApiService>(context, listen: false).maxsecond;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (Second > 0) {
            Second--;
          }
          if (Second == 0) {

            Provider.of<ApiService>(context, listen: false).checkntp();
            if(Provider.of<ApiService>(context, listen: false).visibily){
              if(Provider.of<ApiService>(context, listen: false).checkenterevent){
                timer.cancel();
                Provider.of<ApiService>(context, listen: false).getcheckenter();
                controller.pause();
                Provider.of<ApiService>(context, listen: false).firstTimer=DateTime.now();
                kNavigator(context, QuestionPage());
              }
            }
            else{
              timer.cancel();
              controller.pause();
              kNavigator(context, QuestionPage());
            }

          }
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    timer!.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    context.read<ApiService>();
    this.widget.context = context;
    return Consumer<ApiService>(builder: (context, value, child) {
      value.apiListener(this);
      return SafeArea(
          child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/2.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: kDarkBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children:  [
                              const Image(
                                image: AssetImage('assets/images/user.png'),
                                height: 20,
                                color: Colors.white,
                              ),
                              FutureBuilder<DocumentSnapshot>(
                                  future: value.getnumusers(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      List list = snapshot.data!.get('users');
                                      return Text(
                                          list.length.toString());
                                    }
                                    return CircularProgressIndicator();
                                  }),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 205,
                        ),
                        InkWell(
                          onTap: () {
                            kNavigatorBack(context);
                            // kNavigator(context, QuestionPage());

                          },
                          child: Container(
                            child: const Image(
                              image: AssetImage('assets/images/cancel.png'),
                              height: 30,
                              width: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: context.read<ApiService>().getEventDetail(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          value.imagesponsor = snapshot
                              .data!.docs[0]
                              .get('image');
                          value.namesponsor = snapshot
                              .data!.docs[0]
                              .get('title');
                          value.linksponsor = snapshot
                              .data!.docs[0]
                              .get('link');
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 20,
                                        offset: Offset(0, -20),
                                      )
                                    ],
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(30)),
                                    color: Colors.grey.shade300),
                                height: 600,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black38,
                                              blurRadius: 10,
                                              spreadRadius: 5,
                                              offset: Offset(0, 10),
                                            )
                                          ],
                                          borderRadius: BorderRadius.circular(30),
                                          color: kLightBlue),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Align(
                                            child: Text(
                                              'Time Remaining :',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            alignment: Alignment.topCenter,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            child: Align(
                                              child: Text(
                                                Second.toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30),
                                              ),
                                              alignment: Alignment.topCenter,
                                            ),
                                            onTap: () async {
                                              // DateTime ntptime = await NTP.now();
                                              // Timestamp ts =
                                              //     snapshot.data!.docs[0].get('date');
                                              // print(ts.toDate());
                                              // print(ntptime.difference(ts.toDate()));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black38,
                                              blurRadius: 10,
                                              spreadRadius: 5,
                                              offset: Offset(0, 10),
                                            )
                                          ],
                                        ),
                                        width: MediaQuery.of(context).size.width,
                                        height: 250,
                                        child: value.file == true ?
                                        ClipRRect(
                                          child: Image(
                                              image: NetworkImage(snapshot
                                                  .data!.docs[0]
                                                  .get('image')),fit: BoxFit.fill,),
                                          borderRadius: BorderRadius.circular(30),
                                        ): VideoPlayerWidget(controller: controller),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      snapshot.data!.docs[0].get('title'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                      thickness: 2,
                                      indent: 20,
                                      endIndent: 20,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(children: [
                                          Text(
                                              '${snapshot.data!.docs[0].get('price')}'),
                                          Image(
                                            image: AssetImage(
                                                'assets/images/dollar.png'),
                                            height: 15,
                                            width: 15,
                                          )
                                        ]),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: const Image(
                                            image: AssetImage(
                                                'assets/images/gift-box-with-a-bow.png'),
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                            '${snapshot.data!.docs[0].get('numwinner')}  >  number of winners'),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: const Image(
                                            image:
                                                AssetImage('assets/images/medal.png'),
                                            height: 20,
                                            width: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                            ),
                            Text(snapshot.error.toString()),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              )));
    });
  }


  @override
  void accountAvailable() {}

  @override
  void error() {
    ModeSnackBar.show(context, 'something go wrong', SnackBarMode.error);
  }

  @override
  void inputEmpty() {
    ModeSnackBar.show(
        context, 'username or password empty', SnackBarMode.warning);
  }

  @override
  void inputWrong() {
    ModeSnackBar.show(
        context, 'username or password incorrect', SnackBarMode.warning);
  }

  @override
  void login() {
    kNavigator(context, NavigateBar());
  }

  @override
  void passwordWeak() {
    ModeSnackBar.show(context, 'password is weak', SnackBarMode.warning);
  }
}
