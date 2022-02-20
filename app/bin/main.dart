import 'package:github_actions_toolkit/github_actions_toolkit.dart' as gaction;

void main() {
  const input = gaction.Input("who-to-greet", isRequired: false);
  final whoToGreet = input.value ?? "world";
  gaction.log.info('Hello $whoToGreet!');
}
