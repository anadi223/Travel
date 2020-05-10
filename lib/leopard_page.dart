import 'package:flutter/material.dart';
import 'package:flutterappbam/styles.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'main_page.dart';

class LeopardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 80,
        ),
        The72Text(),
        SizedBox(
          height: 15.0,
        ),
        Traveldescription(),
        SizedBox(height: 20.0,),
        Leoparddescription(),
      ],
    );
  }
}

class LeopardImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier,AnimationController>(
        builder: (context, notifier,animation, child) {
          return Positioned(
            left: 0.85 * -notifier.offset,
            width: MediaQuery.of(context).size.width * 1.6,
            child: Transform.scale(
              alignment: Alignment(0.35,0),
              scale: 1-0.1*animation.value,
              child: Opacity(
                opacity: 1-0.6*animation.value,
                child: child,
              ),
            ),
          );
        },
        child: MapHider(child: IgnorePointer(child: Image.asset('assets/leopard.png'))));
  }
}

class Traveldescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context,notifier,child){
        return Opacity(
          opacity: max(0, 1-4*notifier.page),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(
          'Travel description',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}



class Leoparddescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context,notifier,child){
        return Opacity(
          opacity: max(0, 1-4*notifier.page),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(
          'The leopard is distinguished by its well-camouflauged fur, opportunistic hunting behaviour, broad diet and strength',
          style: TextStyle(color: lightGrey),
        ),
      ),
    );
  }
}

class The72Text extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Transform.translate(
          offset: Offset(-20 - 0.5 * notifier.offset, 0),
          child: child,
        );
      },
      child: RotatedBox(
          quarterTurns: 1,
          child: SizedBox(
              width: 400,
              child: FittedBox(
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  child: Text(
                    '72',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )))),
    );
  }
}