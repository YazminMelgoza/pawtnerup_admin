import 'package:pawtnerup_admin/config/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.data,
    this.selected = false,
    this.onTap,
  });

  final Map<String, dynamic> data;
  final bool selected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
        margin: const EdgeInsets.only(right: 10),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: selected ? AppColor.yellow : AppColor.containerColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColor.yellow,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.6),
              spreadRadius: .5,
              blurRadius: .5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              data["icon"],
              width: 35,
              height: 35,
              // ignore: deprecated_member_use
              color: selected ? Colors.white : null,
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: Text(
                data["name"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : AppColor.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
