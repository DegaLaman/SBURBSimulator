import "../../../SBURBSim.dart";
import 'dart:html';
/*
much like target conditions decide WHO a scene should effect
action effects decide what happens when a scene triggers.
 */
abstract class ActionEffect {
    SerializableScene scene;
    static String IMPORTANTWORD = "importantWord";
    static String IMPORTANTINT = "importantNumber";

    String name = "Generic Effect";
    //what gets deleted
    Element container;

    String  importantWord = "N/A";
    int  importantInt = 0;

    ActionEffect(SerializableScene scene);

    void renderForm(Element div);
    void syncToForm();
    void syncFormToMe();
    void copyFromJSON(JSONObject json);
    void applyEffect();
    ActionEffect makeNewOfSameType();

    void setupContainer(DivElement div) {
        container = new DivElement();
        container.classes.add("conditionOrEffect");
        div.append(container);
        drawDeleteButton();
    }

    void drawDeleteButton() {
        if(scene != null) {
            ButtonElement delete = new ButtonElement();
            delete.text = "Remove Effect";
            delete.onClick.listen((e) {
                //don't bother knowing where i am, just remove from all
                scene.removeEffect(this);
                container.remove();
                scene.syncForm();
            });
            container.append(delete);
        }
    }


    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        json[IMPORTANTWORD] = importantWord;
        json["name"] = name;
        json[IMPORTANTINT] = "$importantInt";
        return json;
    }
}


//lands don't have stats and shit
abstract class EffectLand extends ActionEffect {
  EffectLand(SerializableScene scene) : super(scene);

  static List<EffectLand> listPossibleEffects(SerializableScene scene) {
      List<EffectLand> ret = new List<EffectLand>();
      ret.add(new InstaBlowUp(scene));
      ret.add(new ChangeInhabitantsStat(scene));
      ret.add(new MakeConsortsSay(scene));
      return ret;
  }

  //need to figure out what type of trigger condition it is.
  static ActionEffect fromJSON(JSONObject json, SerializableScene scene) {
      String name = json["name"];
      //print("name is $name");
      List<EffectLand> allConditions = listPossibleEffects(scene);
      for(ActionEffect tc in allConditions) {
         // print("is ${tc.name} the same as $name");
          if(tc.name == name) {
              ActionEffect ret = tc.makeNewOfSameType();
              //print("before i copy, ret is $ret");
              ret.importantWord = json[ActionEffect.IMPORTANTWORD];
              ret.copyFromJSON(json);
              //print("after i copy, ret is $ret");
              ret.scene = scene;
              return ret;
          }
      }
  }


  static SelectElement drawSelectActionEffects(Element div, SerializableScene owner, Element triggersSection) {
      triggersSection.setInnerHtml("<h3>Land Effects: Applied In Order<br></h3>");
      List<ActionEffect> effects;
      effects = EffectLand.listPossibleEffects(owner);
      SelectElement select = new SelectElement();
      for(EffectLand sample in effects) {
          OptionElement o = new OptionElement();
          o.value = sample.name;
          o.text = sample.name;
          select.append(o);
      }

      ButtonElement button = new ButtonElement();
      button.text = "Add Land Effect";
      button.onClick.listen((e) {
          String type = select.options[select.selectedIndex].value;
          for(ActionEffect tc in effects) {
              if(tc.name == type) {
                  ActionEffect newCondition = tc.makeNewOfSameType();
                  newCondition.scene = owner;
                  owner.effectsForLands.add(newCondition);
                  //print("adding new condition to $owner");
                  //bigBad.triggerConditions.add(newCondition);
                  newCondition.renderForm(triggersSection);
              }
          }
      });

      triggersSection.append(select);
      triggersSection.append(button);

      //render the ones the big bad starts with
      List<ActionEffect> all;
      all = owner.effectsForLands;

      for (ActionEffect s in all) {
          s.renderForm(triggersSection);
      }
      return select;
  }


  @override
  void applyEffect() {
        List<Land> targets = scene.finalLandTargets;
        effectLands(targets);
  }

  void effectLands(List<Land> lands);


}

abstract class EffectEntity extends ActionEffect {
  EffectEntity(SerializableScene scene) : super(scene);


  static List<EffectEntity> listPossibleEffects(SerializableScene scene) {
      List<EffectEntity> ret = new List<EffectEntity>();
      ret.add(new InstaKill(scene));
      ret.add(new ChangeStat(scene));
      ret.add(new GrimDarkCorruption(scene));
      ret.add(new MakeStrifable(scene));
      ret.add(new StartStrife(scene));
      return ret;
  }


  //need to figure out what type of trigger condition it is.
  static ActionEffect fromJSON(JSONObject json, SerializableScene scene) {
      String name = json["name"];
      print("looking for name $name");

      List<EffectEntity> allConditions = listPossibleEffects(scene);
      for(ActionEffect tc in allConditions) {
          print("is $name the same as ${tc.name}");

          if(tc.name == name) {
              print("yes");
              ActionEffect ret = tc.makeNewOfSameType();
              print("made new of same type");

              ret.copyFromJSON(json);
              ret.scene = scene;
              print("ret is $ret for name $name");
              return ret;
          }
      }
      print("unknown action found, $name");
      throw("unknown action found, $name");
  }


  static SelectElement drawSelectActionEffects(Element div, SerializableScene owner, Element triggersSection) {
      triggersSection.setInnerHtml("<h3>Entity Effects: Applied In Order.</h3><br>");
      List<ActionEffect> effects;
      effects = EffectEntity.listPossibleEffects(owner);
      SelectElement select = new SelectElement();
      for(EffectEntity sample in effects) {
          OptionElement o = new OptionElement();
          o.value = sample.name;
          o.text = sample.name;
          select.append(o);
      }

      ButtonElement button = new ButtonElement();
      button.text = "Add Entity Effect";
      button.onClick.listen((e) {
          String type = select.options[select.selectedIndex].value;
          for(ActionEffect tc in effects) {
              if(tc.name == type) {
                  ActionEffect newCondition = tc.makeNewOfSameType();
                  newCondition.scene = owner;
                  owner.effectsForLiving.add(newCondition);
                  print("adding new effect to $owner");
                  //bigBad.triggerConditions.add(newCondition);
                  newCondition.renderForm(triggersSection);
              }
          }
      });

      triggersSection.append(select);
      triggersSection.append(button);

      //render the ones the big bad starts with
      List<ActionEffect> all;
      all = owner.effectsForLiving;

      for (ActionEffect s in all) {
          s.renderForm(triggersSection);
      }
      return select;
  }



  @override
  void applyEffect() {
      List<GameEntity> targets = scene.finalLivingTargets;
      effectEntities(targets);
  }

  void effectEntities(List<GameEntity> entities);
}