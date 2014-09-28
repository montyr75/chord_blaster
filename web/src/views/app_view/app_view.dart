library app_view;

import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:core_elements/core_animated_pages.dart';
import '../../model/chord.dart';

@CustomTag('app-view')
class AppView extends PolymerElement {

  static const CLASS_NAME = "AppView";

  // constants
  static const String CHORD_LIST_PATH = "resources/data/chords.json";

  @observable List<Chord> chordList;

  CoreAnimatedPages slideshow;

  AppView.created() : super.created() {
    HttpRequest.getString(CHORD_LIST_PATH)
      .then((String fileContents) {
        List<Map> mapList = JSON.decode(fileContents);
        chordList = mapList.map((Map chordMap) => new Chord.fromMap(chordMap)).toList(growable: false);
      })
      .catchError((Error error) => print(error));
  }

  @override void attached() {
    super.attached();
    print("$CLASS_NAME::attached()");

    slideshow = $["slideshow"];
  }

  void startSlideshow(Event event, var detail, Element target) {
    print("$CLASS_NAME::startSlideshow()");

//    slideshow.start();
    slideshow.selected = 0;
  }

  void stopSlideshow(Event event, var detail, Element target) {
    print("$CLASS_NAME::stopSlideshow()");

//    slideshow.stop();
  }

  void pauseSlideshow(Event event, var detail, Element target) {
    print("$CLASS_NAME::pauseSlideshow()");

//    slideshow.pause();
  }

  void nextSlide(Event event, var detail, Element target) {
    print("$CLASS_NAME::nextSlide()");

    slideshow.selected += 1;
  }

  // prevent app reload on <form> submission
  void submit(Event event, var detail, Element target) {
    event.preventDefault();
  }
}

