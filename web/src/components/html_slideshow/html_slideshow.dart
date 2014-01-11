library html_slideshow;

import 'dart:async';
import 'package:polymer/polymer.dart';

@CustomTag('html-slideshow')
class HTMLSlideshow extends PolymerElement {

  @published List slides;   // list of slides to display (if not Strings, must have valid toString() override)
  @published num interval;  // interval in seconds between slides
  @published String slideClass;   // if non-null, wrap HTML content in a <div> and apply this CSS

  @observable String currentSlide;  // the currently displaying slide

  Timer _timer;
  Duration _duration;
  Iterator _iterator;

  HTMLSlideshow.created() : super.created();

  @override void enteredView() {
    super.enteredView();
    print("HTMLSlideshow::enteredView()");
  }

  // respond to any change in the "slides" attribute
  void slidesChanged(oldValue) {
    print("HTMLSlideshow::slidesChanged()");

    // if we have a new slide list, reset the iterator
    reset();
  }

  // respond to any change in the "interval" attribute
  void intervalChanged(oldValue) {
    print("HTMLSlideshow::intervalChanged(): $interval");

    // setup the Duration object
    if (interval != null && interval > 0) {
      _duration = new Duration(seconds: interval);
    }
  }

  void start() {
    if (_duration == null || _iterator == null || slides == null || slides.isEmpty) {
      print("HTMLSlideshow::start -- ERROR: Cannot start slideshow.");
      return;
    }

    // immediately show next slide
    nextSlide();

    // start the timer
    _timer = new Timer.periodic(_duration, nextSlide);
  }

  void pause() {
    // stop the timer
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void stop() {
    // stop the timer and reset the iterator
    pause();
    reset();
  }

  void reset() {
    // reset the iterator to the beginning of the slide list and kill the current slide (if any)
    if (slides != null && slides.isNotEmpty) {
      _iterator = slides.iterator;
      currentSlide = null;
    }
  }

  void nextSlide([Timer timer = null]) {
    if (_iterator == null) {
      return;
    }

    // if there is a next slide, move to it, converting it to a String
    // otherwise, reset the iterator and call nextSlide() again
    if (_iterator.moveNext()) {
      _showCurrentSlide();
    }
    else {
      reset();
      nextSlide();
    }
  }

  void _showCurrentSlide() {
    String slideStr = _iterator.current.toString();

    if (slideClass != null) {
      currentSlide = "<div class='$slideClass'>${slideStr}</div>";
    }
    else {
      currentSlide = slideStr;
    }
  }

  // this lets the global CSS bleed through into the Shadow DOM of this element
  bool get applyAuthorStyles => true;
}

