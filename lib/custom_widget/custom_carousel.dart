import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Carousel extends StatefulWidget {
  const Carousel({
    Key? key,
    required this.pages,

    this.indicatorColor,
    this.indicatorAlignment,
  }) : super(key: key);
  final List<Widget> pages;
  final Color? indicatorColor;
  final Alignment? indicatorAlignment;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final pages = widget.pages;
    final pageLength = pages.length;
    final color = widget.indicatorColor ?? Theme.of(context).colorScheme.primary;
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView(
          onPageChanged: (value) {
            // ページが切り替わったときにそのindexがvalueに入ってくる。
            // 現在表示中のページが何番目か知りたいのでcurrentIndexにvalueを渡す。
            setState(() {
              currentIndex = value;
            });
          },
          children: widget.pages,
        ),
        Align(
          alignment: widget.indicatorAlignment ?? const Alignment(0, .5), // 相対的な表示位置を決める。
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pageLength,
                  (index) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: index == currentIndex ? color : Colors.grey.shade500,
                    shape: BoxShape.circle,
                    border: Border.all(color:index==currentIndex ? color : Colors.grey.shade500),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}