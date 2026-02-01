import 'package:app_marcaciones_face/route_generator.dart';
import 'package:flutter/material.dart';


// import '../assets/widgets/dialog.dart';
import '../assets/widgets/styles.dart';
import '../env.dart';


class Logo extends StatefulWidget{
  const Logo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return __LogoState();
  }

}

class __LogoState extends State<Logo> with SingleTickerProviderStateMixin{

  late final AnimationController logoAnimationController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> logoAnimation = CurvedAnimation(
    parent: logoAnimationController,
    curve: Curves.easeIn,
  );



  @override
  void dispose() {
    logoAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadData(context);
  }

  void loadData(BuildContext context) async{

    await Future.delayed(Duration(seconds: 2));

    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, menuRoute);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Style().backgroundColor(),
      body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: FadeTransition(
                  opacity: logoAnimation,
                  child: Image.asset("${assetURL}logo.png", alignment: Alignment.center, width: MediaQuery.of(context).size.width*0.7),
                ),
              ),
              /*Container(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
              alignment: Alignment.bottomCenter,
            )*/
            ],
          )
      ),
    );

  }

}
