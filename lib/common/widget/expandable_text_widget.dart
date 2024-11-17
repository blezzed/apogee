
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  const ExpandableTextWidget({super.key, required this.text});

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;

  double textHeight = 100.h;

  @override
  void initState(){
    super.initState();
    if(widget.text.length>textHeight){
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt()+1, widget.text.length);
    }else{
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty? Text(firstHalf, style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 14.sp, color: AppColors.paraColor),): Column(
        children: [
          Text(
            hiddenText?("$firstHalf...") : ("$firstHalf $secondHalf"),
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: AppColors.paraColor,
              height: 1.4,
            ),
          ),
          InkWell(
              onTap: (){
                setState(() {
                  hiddenText=!hiddenText;
                });
              },
              child: Row(
                children: [
                  hiddenText?Text(
                    "Read more",
                    style: Theme.of(context).textTheme.titleSmall,
                  ):Text(
                    "Read less",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Icon(hiddenText? Icons.arrow_drop_down: Icons.arrow_drop_up, color: Theme.of(context).primaryColor)
                ],
              )
          )
        ],
      ),
    );
  }
}
