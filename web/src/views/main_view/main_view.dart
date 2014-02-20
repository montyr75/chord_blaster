library main_view;

import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:polymer_expressions/filter.dart';
import '../../components/html_slideshow/html_slideshow.dart';
import '../../utils/filters.dart';
import '../../model/chord.dart';

@CustomTag('main-view')
class MainView extends PolymerElement {

  // constants
  static const String CHORD_LIST_PATH = "resources/data/chords.json";

  // strings
  static const String SAMPLE_STRING = "sample string";

  @observable List<Chord> chordList;

  HTMLSlideshow slideshow;

  // filters and transformers can be referenced as class fields
  final Transformer asInteger = new StringToInt();

  // non-visual initialization can be done here
  MainView.created() : super.created() {
    HttpRequest.getString(CHORD_LIST_PATH)
      .then((String fileContents) {
        List<Map> mapList = JSON.decode(fileContents);
        chordList = mapList.map((Map chordMap) => new Chord.fromMap(chordMap)).toList(growable: false);
      })
      .catchError((Error error) => print(error));
  }

  // other initialization can be done here
  @override void enteredView() {
    super.enteredView();
    print("MainView::enteredView()");

    slideshow = $["slideshow"];
  }

  // a sample event handler function
  void eventHandler(Event event, var detail, Element target) {
    print("MainView::eventHandler()");
  }

  void startSlideshow(Event event, var detail, Element target) {
    print("MainView::startSlideshow()");

    slideshow.start();
  }

  void stopSlideshow(Event event, var detail, Element target) {
    print("MainView::stopSlideshow()");

    slideshow.stop();
  }

  void pauseSlideshow(Event event, var detail, Element target) {
    print("MainView::pauseSlideshow()");

    slideshow.pause();
  }

  void nextSlide(Event event, var detail, Element target) {
    print("MainView::nextSlide()");

    slideshow.nextSlide();
  }

  // prevent app reload on <form> submission
  void submit(Event event, var detail, Element target) {
    event.preventDefault();
  }
}

