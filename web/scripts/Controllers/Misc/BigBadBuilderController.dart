import '../../navbar.dart';
import 'dart:html';
import "../../SBURBSim.dart";
import "dart:async";


Element div;
UListElement todoElement;
BigBad bigBad = new BigBad("Sample Big Bad", new Session(-13));
void main() {
  loadNavbar();
  start();

}

Future<Null> start() async {
  await globalInit();
  bigBad.session.setupMoons("BigBad setup");

  div = querySelector("#story");
  todoElement = new UListElement();
  todoElement.style.border = "1px";
  div.append(todoElement);
  /**
   *  * Add flavor text to SummonScenes
   * Add effects to SerializableScenes
   * Text doc of a few Big Bads
   * BUG FIXES
   * Branch Main and Experimental
   * Big Bad Activation Loop
   * Test for crashes
   * Teach ShogunBot how to make cards for non Carapace Big Bads
   * Find sessions where the current Big Bads are being summoned
   */

  todo("Scenes let you replace TARGET. Can't do more than that because of how targets work. (for example, can't know what the item with teh trait is cuz it might be multuiple items) ");

  todo("be able to remove triggers from scene, put into TargetCondition (living or land) parent class (i thought i did this)");
  todo("big bads have intro mod flavor text (like dystopic empire)");
  todo("scenes should have effects, summon scenes all start with 'is active'");
  todo("teach AB to write bigBadSummaries to cache");
  todo("big bads need 0 or more custom fraymotif names");
  todo("big bads need low, medium, high values for all stats. what am i saying i mean 'Planetary, Galactic, Cosmic'. sorry about that, shogun");
  todo("have anything flagged as a big bad be something players try to strife, if it seems defeatable");
  todo("any CROWNED CARAPACE that has killed a player is flagged as big bad");
  todo("any unconditionally immortal player that has killed a player is flagged as big bad");
  todo("FORM BUG: big bad needs to be in default state before loading still, need to refresh page to clear shit out");
  todo("big bads have outro mod flavor text (if they aren't defeated, how do they effect child universe, like dystopic empire)");
  todo("more living conditions: is meta player, is god tier, is player, is Sprite, isRobot, is consort, is denizen, is alive, is dead, isAspect, isClass");
  todo("more land contions: owned by Aspect player,owned by Class player, owned by Meta Player, owned by God Tier, corrupt");
  todo("side apps, like big bad gotcha, or big bad betting battles");

  setUpForm();
}

void setUpForm() {
  DivElement formElement = new DivElement();
  div.append(formElement);
  bigBad.drawForm(formElement);
}


void todo(String todo) {
  LIElement tmp = new LIElement();
  tmp.setInnerHtml("TODO: $todo");
  todoElement.append(tmp);
}




