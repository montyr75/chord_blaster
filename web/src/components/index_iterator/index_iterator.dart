library index_iterator;

import 'dart:async';
import 'package:polymer/polymer.dart';

@CustomTag('index-iterator')
class IndexIterator extends PolymerElement {

  static const CLASS_NAME = "IndexIterator";

  @published int index = 0;           // the current index
  @published int startIndex = 0;      // the starting index
  @published int endIndex;            // the ending index
  @published int step = 1;            // how far, and in which direction, to step with prev() or next()
  @published num interval = 1;        // interval, in seconds, between index changes
  @published bool loop = false;       // should the index loop back to the beginning?
  @published bool autoStart = false;  // should the timer start automatically?

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

    // if a timer is running, restart with new duration
    if (_timer != null) {
      start();
    }
  }

  void start() {
    if (endIndex == null) {
      print("$CLASS_NAME::start() -- ERROR: Iterator invalid.");
      return;
    }

    // kill any existing timer
    pause();

    if (_duration == null) {
      _setupDuration();
    }

    // start the timer
    _timer = new Timer.periodic(_duration, next);
  }

  void pause() {
    // stop the timer
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void stop() {
    // stop the timer and reset the index
    pause();
    reset();
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

