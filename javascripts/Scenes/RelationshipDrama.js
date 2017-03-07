//only one player at a time.
//compare old relationship with new relationship.
function RelationshipDrama(){
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.dramaPlayers = [];

	this.trigger = function(playerList){
		this.playerList = playerList;
		this.dramaPlayers = [];
		//CAN change how ou feel about somebody not yet in the medium
		for(var i = 0; i< players.length; i++){
			var p = players[i];
			if(p.hasRelationshipDrama()){
				this.dramaPlayers.push(p)
			}
		}
		return this.dramaPlayers.length > 0;
	}


	
	this.confessFeelings = function(div, player,crush){
		var relationship = player.getRelationshipWith(crush);
		var divID = (div.attr("id")) + "_" + crush.chatHandle+"_crush";
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		var chatText = "";
		var player1 = player;
		var player2 = crush;
		
		if(crush.dead == true){
			var narration = "<br>The " + player.htmlTitle() + " used to think that the " + crush.htmlTitle() + " was ";
			narration += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";
			narration += "It's especially tragic that they didn't realize this until the " + crush.htmlTitle() + " died.";
			div.append(narration);
		}
		
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.

		chatText += chatLine(player1Start, player1, "So...hey.");
		chatText += chatLine(player2Start, player2, "Hey?");
		chatText += chatLine(player1Start, player1, "I have no idea how to say this so I'm just going to do it.");
		chatText += chatLine(player2Start, player2, "?");
		chatText += chatLine(player1Start, player1, "I like you.  Romantically.");
		
		var r1 = relationship;
		var r2 = player2.getRelationshipWith(player1);
		
		if(r2.type() == r2.goodBig){
			chatText += chatLine(player2Start, player2,"!");
			chatText += chatLine(player2Start, player2,"Wow... I ... I feel the same way!");
			chatText += chatLine(player2Start, player2,"Holy shit!");
		}else if(r2.type() ==r2.badBig){
			chatText += chatLine(player2Start, player2, "lol");
			chatText += chatLine(player2Start, player2, "Well, I think YOU are " + this.generateNewOpinion(r2) + "!");
			chatText += chatLine(player2Start, player2, "so fuck off!");
		}else{
			chatText += chatLine(player2Start, player2,"Fuck. I'm sorry. I just don't feel that way about you. ");
			chatText += chatLine(player1Start, player1,"Fuck. Thanks for being honest. ");

		}

		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;
		drawChat(canvasDiv, player1, player2, chatText, 1000);
	}
	
	//goes different if best friend has crush on player
	//or on crushee.
	this.relationshipAdvice = function(div,player,crush){
		var relationship = player.getRelationshipWith(crush);
		var divID = (div.attr("id")) + "_" + crush.chatHandle+"_crush";
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		
		var chatText = "";
		var player1 = player;
		var player2 = this.getLivingBestFriendBesidesCrush(player, crush);
		
		if(player2 == null){
			var narration = "<br>The " + player.htmlTitle() + " used to think that the " + crush.htmlTitle() + " was ";
			narration += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";
			if(crush.dead == true){
				narration += "It's especially tragic that they didn't realize this until the " + crush.htmlTitle() + " died.";
			}
			narration += "It's a shame the " + player.htmlTitle() + " has nobody to talk to about this. ";
			div.append(narration);
		}
		player.triggerLevel += -3;  //talking about it helps.
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = relationship;
		var r2 = player2.getRelationshipWith(player1);
		var r2crush = player2.getRelationshipWith(crush);
		var chatText = "";

		chatText += chatLine(player1Start, player1,getRelationshipFlavorGreeting(r1, r2, player1, player2))
		chatText += chatLine(player2Start, player2,getRelationshipFlavorGreeting(r2, r1, player2, player1))
		chatText += chatLine(player1Start, player1,"So... " + crush.chatHandle + ", they are " + this.generateNewOpinion(r1) + ", you know?");
		if(crush.dead == true){
			player.triggerLevel += 2;  //still hurts that they are dead.
			chatText += chatLine(player2Start, player2,"Oh my god, you know they are dead, right?");
			chatText += chatLine(player1Start, player1,"Yeah. Fuck. Why didn't I notice them sooner?");
			chatText += chatLine(player2Start, player2,"Fuck. That sucks. I'm here for you.");
			chatText += chatLine(player1Start, player1,"Thanks. Fuck. This game sucks.");
			chatText += chatLine(player2Start, player2,"It really, really does.");
		}else{
			if(r2crush.type() == r2crush.goodBig){ //best friend has a crush on them, too.
				//try to put aside feelings
				if(player2.class_name == "Page" || player2.class_name == "Maid" || player2.class_name == "Sylph" || player2.aspect == "Blood"){
					chatText += chatLine(player2Start, player2,"Wow! You should definitely, definitely tell them that! Right away!");
					chatText += chatLine(player1Start, player1,"You think so?");
					chatText += chatLine(player2Start, player2,"Absolutely.");
				}else if(player2.class_name == "Knight" || player2.class_name == "Seer" || player2.class_name == "Heir" || player2.aspect == "Mind"){ //fight player1
					chatText += chatLine(player2Start, player2,"Fuck! Me, too.");
					chatText += chatLine(player1Start, player1,"Well, fuck.");
					chatText += chatLine(player1Start, player1,"At least we have good taste?");
				}else{  //try to ignore feelings
					chatText += chatLine(player2Start, player2,"Oh?");
					chatText += chatLine(player2Start, player2,"I, hadn't noticed?");
					chatText += chatLine(player2Start, player2,"I guess I can see that. If that's your thing.");
					chatText += chatLine(player1Start, player1,"They are amazing...");
				}
			}else if(r2.crush.type() == r2crush.badBig){ //friend thinks they are an asshole.
				if(player2.class_name == "Page" || player2.class_name == "Maid" || player2.class_name == "Sylph" || player2.aspect == "Blood"){
					chatText += chatLine(player2Start, player2,"Wow! Huh. You should follow your heart.");
					chatText += chatLine(player1Start, player1,"You think so?");
					chatText += chatLine(player2Start, player2,"Absolutely.");
				}else if(player2.class_name == "Knight" || player2.class_name == "Seer" || player2.class_name == "Heir" || player2.aspect == "Mind"){ //fight player1
					chatText += chatLine(player2Start, player2,"Gonna be honest, I think they are " + this.generateNewOpinion(r2crush)  + ".");
					chatText += chatLine(player1Start, player1,"Sure you can't do better?");
					chatText += chatLine(player1Start, player1,"Screw you, you're just jealous.");
					r1.decrease();
				}else{  //try to ignore feelings
					chatText += chatLine(player2Start, player2,"Oh?");
					chatText += chatLine(player2Start, player2,"Congratulations?");
					chatText += chatLine(player2Start, player2,"I wish you the best of luck.");
					chatText += chatLine(player1Start, player1,"Thank you!");
				}
			}else{  //friend has no particular opinion about the crush.
				if(r2.type() == r2crush.goodBig){  //but has a crush on the player (du-DUH!)
					//try to put aside feelings
					if(player2.class_name == "Page" || player2.class_name == "Maid" || player2.class_name == "Sylph" || player2.aspect == "Blood"){
						chatText += chatLine(player2Start, player2,"Wow! You should definitely, definitely tell them that! Right away!");
						chatText += chatLine(player1Start, player1,"You think so?");
						chatText += chatLine(player2Start, player2,"Absolutely.");
					}else if(player2.class_name == "Knight" || player2.class_name == "Seer" || player2.class_name == "Heir" || player2.aspect == "Mind"){ //fight player1
						chatText += chatLine(player2Start, player2,"Fuck! Um... Okay, I hate to do this to you...but...I think you're " + this.generateNewOpinion(r2) + ".");
						chatText += chatLine(player1Start, player1,"Oh!");
						chatText += chatLine(player1Start, player1,"Um...");
						if(r1.type() == goodBig){
							chatText += chatLine(player1Start, player1,"I...kind of like you, too?");
							chatText += chatLine(player1Start, player1,"I assumed you wouldn't like me back, God, this is so awkward.");
							chatText += chatLine(player2Start, player2,"Holy shit.");
						}else{
							chatText += chatLine(player1Start, player1,"Fuck. I'm sorry. I just don't feel that way about you. ");
							chatText += chatLine(player2Start, player2,"Yeah. I kind of figured. But, I wanted to get that off my chest. ");
						}
					}else{  //try to ignore feelings
						chatText += chatLine(player2Start, player2,"Oh?");
						chatText += chatLine(player2Start, player2,"That's cool.");
						chatText += chatLine(player2Start, player2,"Yeah, that sure is a thing you just confided to me.");
						chatText += chatLine(player2Start, player2,"Glad you can trust me with this?");
						chatText += chatLine(player1Start, player1,"I couldn't keep it bottled up anymore...");
					}
				}else{  //generic advice
					chatText += chatLine(player2Start, player2,"Cool! You should tell them though! Why tell me?");
					chatText += chatLine(player1Start, player1,"Gah! I can't do that! What if they hate me!?");
					chatText += chatLine(player1Start, player1,"I would just die.");
					chatText += chatLine(player2Start, player2,"Well, what are you gaining by putting it off?");
					chatText += chatLine(player2Start, player2,"Somebody else could beat you to the punch!");
					chatText += chatLine(player1Start, player1,"Maybe...");
					//TODO maybe have another scene where they get a second chance at confessing, even if it's not fresh drama?
				}
			}
		}
		drawChat(canvasDiv, player1, player2, chatText, 1000);
	}
	
	//goes different if best friend has crush on player
	//or on jerk.
	//if no one to vent about, narrate, but mention lonliness. no trigger reduction.
	this.ventAboutJerk = function(div,player,jerk){
		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;
		var relationship = player.getRelationshipWith(jerk);
		var divID = (div.attr("id")) + "_" + jerk.chatHandle+"_jerk";
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		
		var chatText = "";
		var player1 = player;
		var player2 = this.getLivingBestFriendBesidesCrush(player, jerk);
		
		if(player2 == null){
			var narration = "<br>The " + player.htmlTitle() + " used to think that the " + relationship.target.htmlTitle() + " was ";
			narration += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";
			if(jerk.dead == true){
				narration += "It's hard for the : " + player.htmlTitle() + " to care that they died.";
			}
			narration += "It's a shame the " + player.htmlTitle() + " has nobody to talk to about this. ";
			div.append(narration);
		}
		player.triggerLevel += -3;  //talking about it helps.
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = relationship;
		var r2 = player2.getRelationshipWith(player1);
		var r2jerk = player2.getRelationshipWith(jerk);
		var chatText = "";

		chatText += chatLine(player1Start, player1,getRelationshipFlavorGreeting(r1, r2, player1, player2))
		chatText += chatLine(player2Start, player2,getRelationshipFlavorGreeting(r2, r1, player2, player1))
		chatText += chatLine(player1Start, player1,"Oh my god, I can't STAND " + jerk.chatHandle + ", they are " + this.generateNewOpinion(r1) + ", you know?");
		if(jerk.dead == true){
			chatText += chatLine(player2Start, player2,"Do you really want to speak ill of the dead?");
			if(r2jerk.value < 0){
				chatText += chatLine(player2Start, player2,"But yeah, they were an asshole.");
				chatText += chatLine(player1Start, player1,"I know, right?");
			}else{
				chatText += chatLine(player1Start, player1,"Yeah, I kind of feel like an asshole, now");
			}
		}
		drawChat(canvasDiv, player1, player2, chatText, 1000);
		
	}
	
	//notice if they are dead.
	this.antagonizeJerk = function(div,player,jerk){
		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;
		var divID = (div.attr("id")) + "_" + jerk.chatHandle+"_jerk";
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		
		var relationship = player.getRelationshipWith(jerk);
		
		
		if(jerk.dead == true){
			var narration = "<br>The " + player.htmlTitle() + " used to think that the " + relationship.target.htmlTitle() + " was ";
			narration += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";
			narration += "It's hard for the : " + player.htmlTitle() + " to care that they died.";
			div.append(narration);
			return;
		}
		
		var chatText = "";
		var player1 = player;
		var player2 = jerk;
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = relationship;
		var r2 = player2.getRelationshipWith(player1);
		var chatText = "";

		chatText += chatLine(player1Start, player1,getRelationshipFlavorGreeting(r1, r2, player1, player2))
		chatText += chatLine(player2Start, player2,getRelationshipFlavorGreeting(r2, r1, player2, player1))
		chatText += chatLine(player1Start, player1,"You are " + this.generateNewOpinion(r1) + ", you know that?");
		r2.decrease();
		if(r2.type() == r2.badBig){
			chatText += chatLine(player2Start, player2,"The feeling is mutual, asshole. ");
			chatText += chatLine(player2Start, player2,"You are " + this.generateNewOpinion(r2) + ", times a million.");
		}else if(r2.type == r2.goodBig){
			chatText += chatLine(player2Start, player2,"Wow. Yes. Way to be an asshole. ");
		}else{
			chatText += chatLine(player2Start, player2,"Holy shit. ");
			chatText += chatLine(player2Start, player2,"And here I thought you were " + this.generateNewOpinion(r2) + ".");
		}
		drawChat(canvasDiv, player1, player2, chatText, 1000);
	}
	
	this.getLivingBestFriendBesidesCrush = function(player,crush){
		var living = findLivingPlayers(players)
		living = removeFromArray(crush, living)
		return player.getBestFriendFromList(living);
	}
		
	
		/*
	  //if too triggered and you have a crush on someone, don't message them directly
	  //instead chat up a friend (if you have one) and ask for advice. that will lower trigger level
	  //and NEXT time you should be able to talk to them.  drama only disabled once you talk to them.
	  //or stop liking them. 
	  
	  //if you have a new enemy, and not triggered enough, you can talk to a friend to try to cool down.
	  //if you have a new enemy and are triggered, you will taunt them.
	  //either way, drama disabled.
	  
	  the person you vent to needs to be alive and NOT the person you are having drama with
	  
	  claspect matters for how triggered you need to be, maybe?
	  
	  //figure out what to do for other relationship types.
	*/
	this.renderForPlayer = function (div, player){
		var player1 = player;
		var relationships = player.getRelationshipDrama();
		
		for(var j = 0; j<relationships.length; j++){
			var r = relationships[j];
			if(r.type() == r.goodBig){
				debug("positive drama")
				if(player.triggerLevel < 1){
					this.confessFeelings(div, player, r.target)
				}else{
					this.relationshipAdvice(div, player, r.target)
				}
			}else if(r.type() == r.bigBad){
				debug("negative drama")
				if(player.triggerLevel < 2){
					this.ventAboutJerk(div, player, r.target)
				}else{
					this.antagonizeJerk(div, player, r.target) //not thinking clearly, gonna start shit.
				}
			}else{
				//narration. but is it really worth it for something so small?
				//debug("tiny drama")
			}
			
		}
		
		
		/*
		for(var j = 0; j<relationships.length; j++){
				this.processDrama(player, relationships[j]);  //or drama dnever leaves
		}
	
		if(!player2){
			return div.append(this.content() + " Too bad the " + player.htmlTitle() + " doesn't have anybody to talk to about this. ");
		}
		var repeatTime = 1000;


		var divID = (div.attr("id")) + "_" + player1.chatHandle;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var chatText = "";
		var relationship = relationships[0]
		chatText += chatLine(player1Start, player1, "TODO: Relationship stuff. I used to think " + player2.chatHandleShort() + " was " +this.generateOldOpinion(relationship ));
		if(relationship.target == player2){
			chatText += chatLine(player1Start, player1, "So...hey.");
			chatText += chatLine(player2Start, player2, "Hey?");
			chatText += chatLine(player1Start, player1, "I have no idea how to say this so I'm just going to do it.");
			chatText += chatLine(player1Start, player1, "I used to think you were "+ this.generateOldOpinion(relationship ));
			chatText += chatLine(player2Start, player2, "?");
			chatText += chatLine(player1Start, player1, "But now....");
			//maybe have different things happen here based on class?
			chatText += chatLine(player1Start, player1, "Fuck, this is too hard. Nevermind.");
		}
		drawChat(canvasDiv, player1, player2, chatText, repeatTime);
		*/
	}

	this.renderContent = function(div){
		//alert("drama!");
		//div.append(this.content());
		for(var i = 0; i<this.dramaPlayers.length; i++){
				var p = this.dramaPlayers[i];
				this.renderForPlayer(div, p);
			}

	}

	this.matchTypeToOpinion = function(type, relationship){
		if(type == relationship.badBig){
			return getRandomElementFromArray(bigBadDesc);
		}

		if(type == relationship.badMild){
			return getRandomElementFromArray(bigMildDesc);
		}

		if(type == relationship.goodBig){
			return getRandomElementFromArray(goodBigDesc);
		}

		if(type == relationship.goodMild){;
			return getRandomElementFromArray(goodMildDesc);
		}
	}

	this.generateOldOpinion = function(relationship){
		return this.matchTypeToOpinion(relationship.old_type, relationship);
	}

	this.generateNewOpinion = function(relationship){
		return this.matchTypeToOpinion(relationship.saved_type, relationship);
	}

	/*
		this.saved_type = "";
	this.drama = false; //drama is set to true if type of relationship changes.
	this.old_type = "";
	this.goodMild = "Friends";
	this.goodBig = "Totally In Love";
	this.badMild = "Rivals";
	this.badBig = "Enemies";
	*/
	this.processDrama = function(player, relationship){
		var ret = " The " + player.htmlTitle() + " used to think that the " + relationship.target.htmlTitle() + " was ";
		ret += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";

		if(relationship.saved_type == relationship.goodBig && relationship.target.dead){
			player.triggerLevel ++;
			ret += " They are especially devestated to realize this only after the " + relationship.target.htmlTitle() + " died. ";
		}
		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;
		return ret;

	}

	this.content = function(){
		//describe what the drama is.  if the drama player is dead, skip.  if their target is dead, comment on that. (extra drama.  Only when he is a corpse do you realize...you love him.)
		var ret = " ";
		if(this.dramaPlayers.length > 2){
			ret += " So much drama has been going on. You don't even know. ";
		}
		for(var i = 0; i< this.dramaPlayers.length; i++){
			var p = this.dramaPlayers[i];
			var relationships = p.getRelationshipDrama();
			for(var j = 0; j<relationships.length; j++){
				ret += this.processDrama(p, relationships[j]);
			}

		}
		return ret;
	}
}
