import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onTap;
  final int? day;
  LikeButton({super.key, required this.isLiked, required this.onTap, this.day = 0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.grey,
          ),
          const SizedBox(height: 5),
          Text(
            isLiked ? 'Added to Day ${day}' : '',
            style: TextStyle(
              color: isLiked ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}