library index_iterator;

import 'dart:async';
import 'package:polymer/polymer.dart';

@CustomTag('index-iterator')
class IndexIterator extends PolymerElement {

  static const String CLASS_NAME = "IndexIterator";

  static const String STOPPED = "STOPPED";
  static const String PLAYING = "PLAYING";
  static const String PAUSED = "PAUSED";

  @published int index = 0;           // the current index
  @published int startIndex = 0;      // the starting index
  @published int endIndex;            // the ending index
  @published int step = 1;            // how far, and in which direction, to step with prev() or next()
  @published num interval = 1;        // interval, in seconds, between index changes
  @published bool loop = false;       // should the index loop back to the beginning?
  @published bool autoStart = false;  // should the timer start automatically?

  String _state = STOPPED;
  Timer _timer;
  Duration _duration;

  IndexIterator.created() : super.created();

  @override void attached() {
    super.attached();
    print("$CLASS_NAME::attached() -- $endIndex");

    if (autoStart) {
      start();
    }
  }

  void _setupDuration() {
    // setup the Duration object
    _duration = new Duration(seconds: interval);
  }

  // respond to any change in the "interval" attribute
  void intervalChanged([oldValue]) {
    print("$CLASS_NAME::intervalChanged(): $interval");

    if (interval == null || interval <= 0) {
      print("$CLASS_NAME::intervalChanged(): ERROR: interval -- $interval");
      return;
    }

    _setupDuration();

    // if we're already playing, restart the timer with the new interval
    if (_state == PLAYING) {
      start();
    }
  }

  void start() {
    if (endIndex == null) {
      print("$CLASS_NAME::start() -- ERROR: Iterator invalid.");
      return;
    }

    if (_state == PLAYING) {
      return;
    }

    // kill any existing timer
    pause();

    if (_duration == null) {
      _setupDuration();
    }

    if (_state == STOPPED) {
      reset();
    }

    // start the timer
    _timer = new Timer.periodic(_duration, next);
  }

  void pause() {
    // stop the timer
    if (_timer != null) {
      _timer.cancel();
      _state = PAUSED;
    }
  }

  void stop() {
    // stop the timer and record that we're stopped
    pause();

    _state = STOPPED;
  }

  void reset() {
    index = startIndex;
  }

  void next([Timer timer = null]) {
    if (endIndex == null) {
      print("$CLASS_NAME::next() -- ERROR: Iterator invalid.");
      return;
    }

    bool nextAvailable = false;

    if (!step.isNegative) {
      if (index < endIndex) {
        nextAvailable = true;
      }
    }
    else if (index > endIndex) {
      nextAvailable = true;
    }

    if (nextAvailable) {
      index += step;
    }
    else {
      if (loop) {
        reset();
      }
      else {
        stop();
      }
    }

    print("$CLASS_NAME::next() -- $index");
  }

  void prev([Timer timer = null]) {
    if (endIndex == null) {
      print("$CLASS_NAME::prev() -- ERROR: Iterator invalid.");
      return;
    }

    bool prevAvailable = false;

    if (!step.isNegative) {
      if (index > startIndex) {
        prevAvailable = true;
      }
    }
    else if (index < startIndex) {
      prevAvailable = true;
    }

    if (prevAvailable) {
      index -= step;
    }
    else {
      if (loop) {
        index = endIndex;
      }
      else {
        stop();
      }
    }

    print("$CLASS_NAME::prev() -- $index");
  }
}

