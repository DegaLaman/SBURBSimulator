import "../../../../SBURBSim.dart";
import 'dart:html';

//has 4 types of features, consorts, smells, sounds, ambiance that it checks for
class TargetHasFeel extends TargetConditionLand {


    @override
    String descText = "<br>Target Land must have an Ambiance of: <br>";
    @override
    String notDescText = "<br>Target Land must NOT have an Ambiance of: <br>";

    Map<String, Feature> _allFeatures = new Map<String, Feature>();
    Map<String, Feature> get allFeatures {
        //print("getting allTraits");
        if(_allFeatures == null || _allFeatures.isEmpty) {
            //print("Setting all traits");
            List<Feature> allFeaturesKnown = new List.from(AmbianceFeature.allAmbiance);

            for(Feature trait in allFeaturesKnown) {
                //print("setting trait $trait");
                _allFeatures[trait.simpleDesc] = trait;
            }
        }

        return _allFeatures;
    }

    SelectElement select;

    @override
    String name = "hasAmbiance";

    Feature feature;


    @override
    String get importantWord => feature.simpleDesc;

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetHasFeel(SerializableScene scene) : super(scene){


    }


    @override
    void renderForm(Element divbluh) {
        List<Feature> allFeaturesKnown = new List.from(allFeatures.values);
        allFeaturesKnown.sort((Feature a, Feature b){
            return a.simpleDesc.toLowerCase().compareTo(b.simpleDesc.toLowerCase());
        });

        Session session = scene.session;

        setupContainer(divbluh);

        syncDescToDiv();
        DivElement me = new DivElement();
        container.append(me);

        select = new SelectElement();
        select.size = 13;
        me.append(select);
        if(feature == null) feature = allFeaturesKnown.first;
        for(Feature trait in allFeaturesKnown) {
            OptionElement o = new OptionElement();
            o.value = trait.simpleDesc;
            o.text = trait.simpleDesc;
            select.append(o);
            if(trait.toString() == feature.simpleDesc) {
                print("selecting ${o.value}");
                o.selected = true;
            }else {
                //print("selecting ${o.value} is not ${itemTrait.toString()}");
            }

        }
        if(feature == null) {
            feature = allFeaturesKnown.first;
            select.selectedIndex = 0;
        }
        select.onChange.listen((Event e) => syncToForm());
        syncFormToMe();

    }


    @override
    TargetCondition makeNewOfSameType() {
        return new TargetHasFeel(scene);
    }




    @override
    void syncFormToMe() {
        print("syncing item trait form with trait of $feature");
        for(OptionElement o in select.options) {
            if(o.value == feature.simpleDesc) {
                o.selected = true;
                return;
            }
        }
        syncFormToNotFlag();
    }

    @override
    String toString() {
        return "TargetHasItemWithTrait: ${feature.simpleDesc}";
    }

    @override
    void syncToForm() {
        String traitName = select.options[select.selectedIndex].value;
        feature = allFeatures[traitName];
        //keeps the data boxes synced up the chain
        syncNotFlagToForm();

        scene.syncForm();
    }
    @override
    void copyFromJSON(JSONObject json) {
        String key = json[TargetCondition.IMPORTANTWORD];
        //print("key is $key and itemTraits are ${allTraits}");
        feature = allFeatures[key];
    }

    @override
    bool conditionForFilter(Land land) {
        //remember if you have the feature, return false;
            if(feature is AmbianceFeature) {
                if(land.feels.contains(feature)) return false;
            }

        return true;
    }

}