import 'package:flutter/material.dart';

@immutable
class ActionButton extends StatelessWidget {
 const ActionButton({
   Key? key,
   this.onPressed,
   required this.icon,
 }) : super(key: key);

 final VoidCallback? onPressed;
 final Widget icon;

 @override
 Widget build(BuildContext context) {
   final theme = Theme.of(context);
   return Material(
     shape: const CircleBorder(),
     clipBehavior: Clip.antiAlias,
     color: Colors.blue[600],
     elevation: 4.0,
     child: IconTheme.merge(
       data: theme.accentIconTheme,
       child: IconButton(
         onPressed: onPressed,
         icon: icon,
         color: Colors.black,
       ),
     ),
   );
 }
}
