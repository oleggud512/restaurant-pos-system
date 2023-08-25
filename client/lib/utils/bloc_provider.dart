import 'dart:async';

import 'package:client/utils/logger.dart';
import 'package:flutter/material.dart';

// abstract class Bloc {
  
//   // StreamController<Event> _eventCont = BehaviorSubject<Event>();
//   // Stream<Event> get _outEvent => _eventCont.stream;
//   // Sink<Event> get inEvent => _eventCont.sink;

//   // StreamController<State> _stateCont = BehaviorSubject<State>();
//   // Stream<State> get outState => _stateCont.stream;
//   // Sink<State> get _inState => _stateCont.sink;

//   // Bloc(initEvent) {
//   //   _outEvent.listen((event) {_handleEvent(event);});
//   //   inEvent.add(initEvent);
//   // }

//   // @required
//   // void _handleEvent(Event event) {}
//   // @required
//   void dispose();
// }

abstract class Bloc<Event, State> {
  Bloc(State initState) {
    _eventSbs = _eventCont.stream.listen(handleEvent);
    emit(initState);
  }

  final _eventCont = StreamController<Event>.broadcast();
  late final StreamSubscription<Event> _eventSbs;
  final _stateCont = StreamController<State>.broadcast();
  late State _state;
  bool _hasState = false;
  
  void add(Event event) => _eventCont.add(event);

  Stream<State> get stream => _stateCont.stream;

  State get state => _state;
  
  @protected
  emit(State state) {
    if (_hasState && _state == state) return;
    _state = state;
    _stateCont.add(state);
    _hasState = true;
  }


  @mustCallSuper
  @protected
  void dispose() {
    _eventSbs.cancel();
    _eventCont.close();
    _stateCont.close();
  }

  @protected
  void handleEvent(Event event);
}

class BlocProvider<T extends Bloc> extends StatefulWidget {
  const BlocProvider({
    Key? key,
    required this.create,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final T Function(BuildContext context) create;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends Bloc>(BuildContext context) {
    try {
      _BlocProviderInherited<T> provider = context.getElementForInheritedWidgetOfExactType<_BlocProviderInherited<T>>()!.widget as _BlocProviderInherited<T>; // TODO: ignores nullability??
      // final provider = context.getInheritedWidgetOfExactType<_BlocProviderInherited<T>>()!;
      return provider.bloc;
    } catch (e) {
      throw Exception('Bloc not found');
    }
  }
}

class _BlocProviderState<T extends Bloc> extends State<BlocProvider<T>> {
  late T bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.create(context);
  }

  @override
  void dispose() {
    glogger.i("Disposing $runtimeType");
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BlocProviderInherited<T>(
      bloc: bloc,
      child: widget.child,
    );
  }
}


/// Widget, that actually holds the bloc, and prevents it from 
/// reinitialization on rebuild. 
class _BlocProviderInherited<T extends Bloc> extends InheritedWidget {
  const _BlocProviderInherited({
    Key? key,
    required Widget child,
    required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
}


class BlocBuilder<B extends Bloc<dynamic, S>, S> extends StatefulWidget {
  const BlocBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, S state) builder;

  @override
  State<BlocBuilder<B, S>> createState() => _BlocBuilderState<B, S>();
}

class _BlocBuilderState<B extends Bloc<dynamic, S>, S> extends State<BlocBuilder<B, S>> {
  late Stream<S> stream;
  late S state;
  late B bloc;

  StreamSubscription<S>? _sbs;

  @override
  void initState() {
    bloc = BlocProvider.of<B>(context);
    state = bloc.state;
    stream = bloc.stream;
    subscribe();
    super.initState();
  }

  void subscribe() {
    _sbs = stream.listen((s) {
      setState(() => state = s);
    });
  }

  void unsubscribe() {
    _sbs?.cancel();
    _sbs = null;
  }

  @override
  void dispose() {
    unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, state);
  }
}


extension BlocContext on BuildContext {
  T readBloc<T extends Bloc>() {
    return BlocProvider.of(this);
  }
}