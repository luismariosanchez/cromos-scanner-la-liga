import 'package:flutter/material.dart';

class ActionCardWidget extends StatelessWidget {

  final Color color;
  final String title;
  final String description;
  final IconData icon;

  final VoidCallback onTap;

  const ActionCardWidget({this.color = const Color(0xFF303030), required this.title, required this.description, required this.icon, required this.onTap,super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          height: 113,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 32,),
              Flexible(child: Text(title, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),),
              Flexible(child: Text(description, style: TextStyle(color: Color(0x87FFFFFF), fontSize: 10),))
            ],
          )
      ),
    );
  }
}
