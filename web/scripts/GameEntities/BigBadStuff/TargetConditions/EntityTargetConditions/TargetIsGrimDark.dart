import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsGrimDark extends TargetConditionLiving {
    @override
    String name = "IsGrimDark";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is GrimDark:</b><br>Target Entity must be GrimDark. <br><br>";
    @override
    String notDescText = "<b>Is NOT GrimDark:</b><br>Target Entity must be NOT GrimDark. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsGrimDark(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsGrimDark(scene);
    }

    @override
    void syncFormToMe() {
        syncFormToNotFlag();
    }

    @override
    void syncToForm() {
        syncNotFlagToForm();
        scene.syncForm();
    }
    @override
    void copyFromJSON(JSONObject json) {
        //nothing to do
    }

    @override
    bool conditionForFilter(GameEntity item) {
        if (item is Player) {
            if((item as Player).grimDark >=3) {
                return false; //don't remove if i'm this aspect
            }else {
                return true;
            }
        }else {
            return true;
        }
    }
}