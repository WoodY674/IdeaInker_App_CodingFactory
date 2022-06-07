import 'package:test/test.dart';
import 'package:flutter_driver/flutter_driver.dart';

void main(){

  final email = find.byValueKey('email');
  final password = find.byValueKey('password');
  final btn = find.byValueKey('btn');

  late FlutterDriver flutterDriver;

  setUpAll(() async{
    flutterDriver = await FlutterDriver.connect();
    await flutterDriver.waitUntilFirstFrameRasterized();
  });

  tearDownAll(()async{
    flutterDriver.close();
  });

  test('Lancement test formulaire Login',()async{
    final timeline = await flutterDriver.traceAction(() async {
      await flutterDriver.tap(email);
      await flutterDriver.enterText('emerickchalet@gmail.com');
      await flutterDriver.waitFor(find.text('emerickchalet@gmail.com'));
      await flutterDriver.tap(password);
      await flutterDriver.enterText('codingFACTORY95');
      await flutterDriver.waitFor(find.text('codingFACTORY95'));
      await flutterDriver.tap(btn);
      expect(await flutterDriver.getText(email), 'emerickchalet@gmail.com');
      expect(await flutterDriver.getText(password), 'codingFACTORY95');
    });

    final summary = TimelineSummary.summarize(timeline);
    await summary.writeTimelineToFile('Résultats Login',pretty: true);
  });
}