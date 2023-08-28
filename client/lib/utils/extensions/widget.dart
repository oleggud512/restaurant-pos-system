import 'package:flutter/material.dart';

extension TooltipWidget on Widget {
  Widget withTooltip(String message) => Tooltip(message: message, child: this);
}