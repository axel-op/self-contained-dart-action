import 'package:github_actions_toolkit/github_actions_toolkit.dart' as gaction;

void main() {
  // read the input
  const input = gaction.Input("who-to-greet", isRequired: false);
  final whoToGreet = input.value ?? "world";

  // print the message
  gaction.log.info('Hello $whoToGreet!');

  // set the output
  gaction.setOutput("time", DateTime.now().toString());
}
