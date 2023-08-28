import 'package:flutter/material.dart';

Rect _getExpandedSliderTrack({
  required RenderBox parentBox,
  required Offset offset,
  required SliderThemeData sliderTheme,
}) {
  final double trackHeight = sliderTheme.trackHeight!;
  final double trackLeft = offset.dx;
  final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
  final double trackWidth = parentBox.size.width;
  return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
}

class ExpandedRoundedRectRangeSliderTrackShape extends RoundedRectRangeSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    return _getExpandedSliderTrack(
      parentBox: parentBox, 
      offset: offset, 
      sliderTheme: sliderTheme
    );
  }
}

class ExpandedRoundedRectSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    return _getExpandedSliderTrack(
      parentBox: parentBox, 
      offset: offset, 
      sliderTheme: sliderTheme
    );
  }
}