import "../SBURBSim.dart";
import "Land.dart";
import "dart:html";


import "FeatureTypes/QuestChainFeature.dart";
/**
 * Session has a list of all possible moons, which it passes to a player when it assigns them a moon.
 *
 * A moon allows you to do as many questChains as are available, with repeats.
 *
 * Quest chains can be ADDED to a moon. (for example, NPC update might have a meeting with WV add "weaken queen" chain)
 *
 * TODO If a moon is destroyed, all dream selves beloning to the moon are destroyed as well.
 * This means a moon should have a list of dream selves on it, when the NPC update is a thing.
 */
class Moon extends Land {
    WeightedList<MoonQuestChainFeature> moonQuestChains = new WeightedList<MoonQuestChainFeature>();

  Moon.fromWeightedThemes(Map<Theme, double> themes, Session session, Aspect a) : super.fromWeightedThemes(themes, session, a){
      Map<MoonQuestChainFeature, double> moonFeatures = new Map<MoonQuestChainFeature, double>();
      processMoonShit(moonFeatures);
  }

  void processMoonShit( Map<MoonQuestChainFeature, double> features) {
      for(MoonQuestChainFeature f in features.keys) {
          moonQuestChains.add(f, features[f]);
      }
  }

  ///any quest chain can be done on the moon. Chain itself decides if can be repeated.
  @override
  String initQuest(List<Player> players) {
      if(symbolicMcguffin == null) decideMcGuffins(players.first);
      //first, do i have a current quest chain?
      if(currentQuestChain == null) currentQuestChain = selectQuestChainFromSource(players, moonQuestChains);

  }

     //never switch chain sets.
    bool doQuest(Element div, Player p1, Player p2) {
        // the chain will handle rendering it, as well as calling it's reward so it can be rendered too.
        bool ret = currentQuestChain.doQuest(p1, p2, denizenFeature, consortFeature, symbolicMcguffin, physicalMcguffin, div, this);
        if(currentQuestChain.finished){
            //if it's not repeatable, then don't let it repeat, dunkass. 
            if(!currentQuestChain.canRepeat) moonQuestChains.remove(currentQuestChain);
            currentQuestChain = null;
        }
        //print("ret is $ret from $currentQuestChain");
        return ret;
    }
}