part of SBURBSim;

//fully replacing old GameEntity that was also an unholy combo of strife engine
//not abstract, COULD spawn just a generic game entity.
class GameEntity {
  Session session;
  String name;
  bool ghost; //if you are ghost, you are rendered spoopy style
  num grist; //everything has it.
  bool dead = false;
  bool corrupted = false; //players are corrupted at level 4. will be easier than always checking grimDark level
  List<dynamic> fraymotifs = [];
  bool usedFraymotifThisTurn = false;
  List<dynamic> buffs = []; //only used in strifes, array of BuffStats (from fraymotifs and eventually weapons)
  HashMap stats = {};
  List<Relationship> relationships; //not to be confused with the RELATIONSHIPS stat which is the value of all relationships.
  var permaBuffs = {"MANGRIT":0}; //is an object so it looks like a player with stats.  for things like manGrit which are permanent buffs to power (because modding power directly gets OP as shit because power controls future power)
  num renderingType = 0; //0 means default for this sim.
  List<dynamic> associatedStats = [];  //most players will have a 2x, a 1x and a -1x stat.
  var spriteCanvasID = null;  //part of new rendering engine.
  num id;
  bool doomed = false; //if you are doomed, no matter what you are, you are likely to die.
  List<GameEntity> doomedTimeClones = []; //help fight the final boss(es).
  String causeOfDeath = ""; //fill in every time you die. only matters if you're dead at end
  GameEntity crowned = null; //TODO figure out how this should work. for now, crowns count as Game Entities, but should be an Item eventually

  GameEntity(this.name, this.id, this.session) {
    stats['sanity'] = 0;
    stats['alchemy'] = 0;
    stats['currentHP'] = 0;
    stats['hp'] = 0;
    stats['RELATIONSHIPS'] = 0;
    stats['minLuck'] = 0;
    stats['maxLuck'] = 0;
    stats['freeWill'] = 0;
    stats['mobility'] = 0;
    stats['power'] = 0;  //power is generic sign of level.
  }

  //TODO grab out every method that current gameEntity, Player and PlayerSnapshot are required to have.
  //TODO make sure Player's @overide them.

  dynamic toString(){
    return this.htmlTitle().replace(new RegExp(r"""\s""", multiLine:true), '').replace(new RegExp(r"""'""", multiLine:true), ''); //no spces probably trying to use this for a div
  }
  void increasePower(){
    //stub for sprites, and maybe later consorts or carapcians
  }
  dynamic getTotalBuffForStat(statName){
    num ret = 0;
    for(num i = 0; i<this.buffs.length; i++){
      var b = this.buffs[i];
      if(b.name == statName) ret += b.value;
    }
    return ret;
  }
  String humanWordForBuffNamed(statName){
    if(statName == "MANGRIT") return "powerful";
    if(statName == "hp") return "sturdy";
    if(statName == "RELATIONSHIPS") return "friendly";
    if(statName == "mobility") return "fast";
    if(statName == "sanity") return "calm";
    if(statName == "freeWill") return "willful";
    if(statName == "maxLuck") return "lucky";
    if(statName == "minLuck") return "lucky";
    if(statName == "alchemy") return "creative";
    return null;
  }
  dynamic describeBuffs(){
    List<dynamic> ret = [];
    var allStats = this.allStats();
    for(num i = 0; i<allStats.length; i++){
      var b = this.getTotalBuffForStat(allStats[i]);
      //only say nothing if equal to zero
      if(b>0) ret.add("more "+this.humanWordForBuffNamed(allStats[i]));
      if(b<0) ret.add("less " + this.humanWordForBuffNamed(allStats[i]));
    }
    if(ret.length == 0) return "";
    return this.htmlTitleHP() + " is feeling " + turnArrayIntoHumanSentence(ret) + " than normal. ";
  }

  void modifyAssociatedStat(modValue, stat){
    //modValue * stat.multiplier.
    if(stat.name == "RELATIONSHIPS"){
      for(num i = 0; i<this.relationships.length; i++){
        this.relationships[i].value += modValue * stat.multiplier;
      }
    }else{
      this.stats[stat.name] += modValue * stat.multiplier;
    }
  }
  num getStat(statName){
    return this.stats[statName];
  }

  void setStat(statName,value){
    this.stats[statName] = value;
  }

  void addStat(statName,value){
    this.stats[statName] += value;
  }


  void setStatsHash(hashStats){
    for (var key in hashStats){
      this.stats[key] =  hashStats[key];
    }
    this.stats["currentHP"] =  Math.max(this.stats["hp"], 10); //no negative hp asshole.
  }

  dynamic htmlTitle(){
    String ret = "";
    if(this.crowned != null) ret+="Crowned ";
    var pname = this.name;
    if(pname == "Yaldabaoth"){
      var misNames = ['Yaldobob', 'Yolobroth', 'Yodelbooger', "Yaldabruh", 'Yogertboner','Yodelboth'];
      print("Yaldobooger!!! " + this.session.session_id);
      pname = getRandomElementFromArray(misNames);
    }
    if(this.corrupted) pname = Zalgo.generate(this.name); //will i let denizens and royalty get corrupted???
    return ret + pname; //TODO denizens are aspect colored.
  }
  dynamic htmlTitleHP(){
    String ret = "";
    if(this.crowned != null) ret+="Crowned ";
    var pname = this.name;
    if(this.corrupted) pname = Zalgo.generate(this.name); //will i let denizens and royalty get corrupted???
    return ret + pname +" (" + (this.getStat("currentHP")).round() +" hp, " + (this.getStat("power")).round() + " power)</font>"; //TODO denizens are aspect colored.
  }
  void flipOut(reason){

  }

  dynamic htmlTitleBasic(){
    return this.name;
  }
  void getRelationshipWith(){
    //stub for boss fights where an asshole absconds.
  }
  void makeDead(causeOfDeath){
    this.dead = true;
    this.causeOfDeath = causeOfDeath;
  }

  void interactionEffect(player){
    //none
  }
  dynamic rollForLuck(stat){
    if(!stat){
      return getRandomInt(this.getStat("minLuck"), this.getStat("maxLuck"));
    }else{
      //don't care if it's min or max, just compare it to zero.
      return getRandomInt(0, this.getStat(stat));
    }

  }
  void boostAllRelationshipsWithMeBy(amount){

  }
  void boostAllRelationshipsBy(amount){

  }
  List<dynamic> getFriendsFromList(list){
    return [];
  }
  List<dynamic> getHearts(){
    return [];
  }
  List<dynamic> getDiamonds(){
    return [];
  }

  dynamic allStats(){
    return this.stats.keys;
  }


}