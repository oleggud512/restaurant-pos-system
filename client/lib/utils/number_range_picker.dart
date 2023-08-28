import 'package:client/utils/logger.dart';
import 'package:client/utils/sizes.dart';
import 'package:flutter/material.dart';

class NumberRangePicker extends StatefulWidget {
  NumberRangePicker({
    super.key,
    required this.min,
    required this.max,
    double? start,
    double? end,
    RangeValues? initial,
    this.label,
    this.fromLabel,
    this.toLabel,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd
  }) : assert(min <= max), 
    assert(start == null && end == null && initial != null && initial.start <= initial.end || 
      start != null && end != null && start <= end),
    initial = initial ?? RangeValues(
      (start! - min) / (max - min) * 100, 
      (end! - min) / (max - min) * 100, 
    );

  final double min;
  final double max;
  final RangeValues initial;
  final String? label;
  final String? fromLabel;
  final String? toLabel;
  final Function(double start, double end)? onChanged;
  final Function(double start, double end)? onChangeStart;
  final Function(double start, double end)? onChangeEnd;

  @override
  State<NumberRangePicker> createState() => _NumberRangePickerState();
}

class _NumberRangePickerState extends State<NumberRangePicker> {
  double get diff => widget.max - widget.min;
  double offsetToNumber(double offset) => widget.min + diff * offset; 
  double numberToOffset(double number) => (number - widget.min) / diff; 

  final from = TextEditingController();
  String fromPrev = '';
  final to = TextEditingController();
  String toPrev = '';

  late RangeValues current;

  void onChanged(RangeValues v) {
    final start = offsetToNumber(v.start);
    final end = offsetToNumber(v.end);
    from.text = start.toStringAsFixed(2);
    to.text = end.toStringAsFixed(2);
    setState(() => current = v);
    widget.onChanged?.call(start, end);
  }

  void onFromChanged() {
    final f = numberToOffset(double.parse(from.text));
    glogger.w(f);
    setState(() {
      current = RangeValues(f, current.end);
    });
    widget.onChanged?.call(double.parse(from.text), offsetToNumber(current.end));
  }

  void onToChanged() {
    final t = numberToOffset(double.parse(to.text));
    setState(() {
      current = RangeValues(current.start, t);
    });
    widget.onChanged?.call(offsetToNumber(current.start), double.parse(to.text));
  }

  String? fromValidator(String? s) {
    if (double.parse(s!) < widget.min) {
      from.text = fromPrev;
    }
    fromPrev = s;
    return null;
  }

  String? toValidator(String? s) {
    if (double.parse(s!) < widget.min) {
      to.text = toPrev;
    }
    toPrev = s;
    return null;
  }

  @override
  void initState() { 
    super.initState();
    current = widget.initial;
    from.text = offsetToNumber(widget.initial.start).toStringAsFixed(2);
    to.text = offsetToNumber(widget.initial.end).toStringAsFixed(2);
    from.addListener(onFromChanged);
    to.addListener(onToChanged);
    fromValidator(from.text);
    toValidator(to.text);
  }

  @override
  void dispose() {
    to.dispose();
    from.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.label != null) ...[
              Text(widget.label!, 
                style: Theme.of(context).textTheme.labelLarge
              ),
              h16gap
            ],
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: from,
                    validator: fromValidator,
                    decoration: InputDecoration(
                      labelText: widget.fromLabel,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: p16)
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                w8gap,
                const Icon(Icons.remove),
                w8gap,
                Expanded(
                  child: TextFormField(
                    controller: to,
                    decoration: InputDecoration(
                      labelText: widget.toLabel,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: p16)
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            h8gap,
            RangeSlider(
              values: current, 
              onChanged: widget.onChanged != null ? onChanged : null,
              onChangeStart: widget.onChangeStart != null 
                ? (v) => widget.onChangeStart?.call(offsetToNumber(v.start), offsetToNumber(v.end))
                : null,
              onChangeEnd: widget.onChangeEnd != null 
                ? (v) => widget.onChangeEnd?.call(offsetToNumber(v.start), offsetToNumber(v.end))
                : null,
            )
          ],
        ),
      ),
    );
  }
}