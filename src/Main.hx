import haxe.ds.Map;
import haxe.rtti.XmlParser;
import haxe.ds.Vector;
import haxegon.*;
import utils.*;
import StringTools;
import haxe.Serializer;
import haxe.Unserializer;
import lime.ui.Window;
import haxe.Json;
import firetongue.*;


#if html5
 import js.Browser;
 import js.html.Audio;
#end

@:access(lime.ui.Window)

class AnimationFrame {
	public var vor_brett:Array<Array<String>>;
	public var nach_brett:Array<Array<String>>;
	public var abweichung:Array<Array<Int>>;
	public var maxabweichung:Int;
	public function new(){
		
	}
}



class LevelZustand{
	public var i:Array<Array<String>>;
	public var sp:Array<Array<String>>;
	public var names:Array<Array<Int>>;
	public var hash:String;
	public function new(){};
}

class Ziel{
	public var ziel:Array<Array<String>>;
	public var werkzeuge:Array<Bool>;
	public function new(z:Array<Array<String>>,wz:Array<Bool>){
		ziel=z;
		werkzeuge=wz;
	}
}

class Main {

	var zeigitemmenu:Bool=false;
	var itemmenu_ziel_x:Int=-1;
	var itemmenu_ziel_y:Int=-1;

	var enableEditor:Bool=false;
	var zeigBetaNotice:Bool=false;

	public var letztes_hoverziel_x:Int=-1;
	public var letztes_hoverziel_y:Int=-1;
	public var cansolve:Bool=true;
	public var solvex:Int=-1;
	public var solvey:Int=-1;
	
	public var editmodus:Bool=false;
	public var editor_tl_x:Int=1;
	public var editor_tl_y:Int=2;
	public var editor_br_x:Int=4;
	public var editor_br_y:Int=5;


	public var aktuellesZiel:Ziel;	
	public var aktuellesZielIdx=0;
	public var ziele:Array<Array<Dynamic>> = [
//2
		//verkehrsampel - einfach aber nicht schlect?
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_1hay7:kugel_4hay7:kugel_2hhy9:werkzeugeatttttttttttttttttttthg",
			[8,13,8,13,13,8,13,8,8,13,8,13,13,8,13,8,8,13,8,13],
		],
//3
		//verkehrsampel - spiegeln - zu einfach?
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_1hay7:kugel_4hay7:kugel_2hhy9:werkzeugeatttttttttttttttttttthg",
			[15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15],
		],

//1
		//verkehrsampel - vsplitter und sauger - ziemlich einfach  aber ich mag es
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_1hay7:kugel_4hay7:kugel_2hhy9:werkzeugeatttttttttttttttttttthg",
			[8,3,3,3,8,3,3,3,8,3,3,3,8,3,3,3,8,3,3,3],
		],
//4
		//verkerhsampel mit horizontal/vertical umkehren
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_1hay7:kugel_4hay7:kugel_2hhy9:werkzeugeatttttttttttttttttttthg",
			[16,16,16,16,17,17,17,17,16,16,16,16,17,17,17,17,16,16,16,16],
		],
//5
		//verkehrsampel - bomben - nicht schlecht!
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_1hay7:kugel_4hay7:kugel_2hhy9:werkzeugeatttttttttttttttttttthg",
			[13,13,13,13,13,19,19,19,13,19,19,19,13,19,19,19,13,19,19,19],
		],
//6

		// //verkehrsampel - drehen - zu einfach? ok für level1?
		// [
		// 	"v1",
		// 	"cy4:Ziely4:zielaau3hany7:kugel_1nhany7:kugel_4nhany7:kugel_2nhau3hhy9:werkzeugeatttttttttttttttttttthg",
		// 	[14,13,14,13,13,14,13,14,14,13,14,13,13,14,13,14,14,13,14,13],
		// ],
//7
		// //haut+füllung verkehrsampel
		// [
		// 	"v1",
		// 	"cy4:Ziely4:zielaay7:kugel_1hay7:kugel_4hay7:kugel_2hhy9:werkzeugeatttttttttttttttttttthg",
		// 	[2,2,2,2,6,6,6,6,6,6,6,6,6,6,6,6,2,2,2,2],
		// ],

//8
// //haut+vertikallöscher verkehrsampel
// 		[
// 			"v1",
// 			"cy4:Ziely4:zielaany7:kugel_1nhany7:kugel_4nhany7:kugel_2nhhy9:werkzeugeatttttttttttttttttttthg",
// 			[2,3,2,3,3,2,3,2,2,3,2,3,3,2,3,2,2,3,2,3],
// 		],

// //9
// //verkehrsampel - kopier + vspliter (habe schon etw ähnlich?)
// 		[
// 			"v1",
// 			"cy4:Ziely4:zielaany7:kugel_1nhany7:kugel_4nhany7:kugel_2nhhy9:werkzeugeatttttttttttttttttttthg",
// 			[3,7,3,3,7,3,7,3,3,7,3,7,7,3,7,3,3,7,3,7],
// 		],
// //10
// 		//verkehrsampel - v deleter and diagonal spiegel - nicht so gut / sehr einfach. aber nicht schlect?
// 		[
// 			"v1",
// 			"cy4:Ziely4:zielaany7:kugel_1nhany7:kugel_4nhany7:kugel_2nhhy9:werkzeugeatttttttttttttttttttthg",
// 			[15,3,15,3,3,15,3,15,15,3,15,3,3,15,3,15,15,3,15,3],
// 		],

//11
		//verkehrsampel, haut + sauger
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_1y7:kugel_4y7:kugel_2haR2R3R4hhy9:werkzeugeatttttttttttttttttttthg",
			[8,2,2,2,8,2,2,2,8,2,2,2,8,2,2,2,8,2,2,2],
		],

//12
		//verkehrsampel - avocado - tatsächlich nicht so schwierig
		[
			"v1",
			"cy4:Ziely4:zielaay6:halm_1hay6:halm_4hay6:halm_2hhy9:werkzeugeatttttttttttttttttttthg",
			[13,13,13,13,13,20,20,20,13,20,20,20,13,20,20,20,13,20,20,20],
		],
		
//13
		//vier wurzeln - zu einfach
		[
			"v1",
			"cy4:Ziely4:zielaay6:halm_2haR2haR2haR2hhy9:werkzeugeatttttttttttttttttttthg",		
			[5,10,6,9,11,7,14,4,17,1,19,16,2,15,13,3,12,20,8,18]
		],
// //14
// 		//wechselwurzeln
// 		["v1",
// 			"cy4:Ziely4:zielaay7:kugel_2nR2hanR2nhaR2nR2hhy9:werkzeugeatttttttttttttttttttthg",
// 			[5,10,6,9,11,7,14,4,17,1,19,16,2,15,13,3,12,20,8,18]
// 		],

//15
		// großes X
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_2nR2hany7:kugel_4nhaR2nR2hhy9:werkzeugeatttttttttttttttttttthg",
			[5,10,6,9,11,7,14,4,17,1,19,16,2,15,13,3,12,20,8,18]
		],
//16
		//schwierig >>
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_1R2nhanR2R2hau2y7:kugel_2hanR2R2haR2R2nhhy9:werkzeugeatttttttttttttttttttthg",		
			[5,10,6,9,11,7,14,4,17,1,19,16,2,15,13,3,12,20,8,18]
			
		],
//17
		//oo
		//#o
		//#o
		[
			"v1",
			"cy4:Ziely4:zielaau3hay7:kugel_6R2nhaR2R2nhaR2R2nhhy9:werkzeugeatttttttttttttttttttthg",
			[5,10,6,9,11,7,14,4,17,1,19,16,2,15,13,3,12,20,8,18]
		],
//18
		//metroidvania
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_6R2R2hay7:kugel_1R3R3hau2R3haR3R3R3haR2R2R2hhy9:werkzeugeatttttttttttttttttttthg",	
			[5,10,6,9,11,7,14,4,17,1,19,16,2,15,13,3,12,20,8,18]				
		],
//19
		//trivial custom back
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_6ny7:kugel_5hau3hay7:kugel_2ny7:kugel_4hhy9:werkzeugeatttttttttttttttttttthg",
			[13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13],
		],


//20
		//++
		[
			"v1",
			"cy4:Ziely4:zielaany7:kugel_2nhay7:kugel_4y7:kugel_1R3hanR2nhaR3R4R3hanR2nhhy9:werkzeugeatttttttttttttttttttthg",
			[5,10,6,9,11,7,14,4,17,1,19,16,2,15,13,3,12,20,8,18]
		],

//21
// 		//verkehrsampel, kopier + haut - nicht so gut?
// 		[
// 			"v1",
// 			"cy4:Ziely4:zielaay7:kugel_1R2hay7:kugel_4R3hay7:kugel_2R4hhy9:werkzeugeatttttttttttttttttttthg",
// 			[7,2,7,2,2,7,2,7,7,2,7,2,2,7,2,7,7,2,7,2],
// 		],
// //22
// 		//custom less trivial but still not great
// 		[
// 			"v1",
// 			"cy4:Ziely4:zielaau2hay7:kugel_4y7:kugel_2hay7:kugel_5y7:kugel_6hau2hhy9:werkzeugeatttttttttttttttttttthg",
// 			[3,4,3,4,4,7,4,7,3,4,3,4,4,3,4,3,3,7,3,7],
// 		],
//23
		//langweilig
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_2u2hay7:kugel_1y7:kugel_5nhaR2y7:kugel_4y7:kugel_3haR3R4nhaR2u2hhy9:werkzeugeatttttttttttttttttttthg",
			[16,17,16,17,17,16,17,16,16,17,16,17,17,16,17,16,16,17,17,16],
		],	
//24	
		//schlangerätsel
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_2R2R2hay7:kugel_4R3R3hay7:kugel_1R4R4hay7:kugel_3R5R5hhy9:werkzeugeatttttttttttttttttttthg",
			[12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12],
		],
//25	
		//schalnge2 - ok? oder night?
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_4y7:kugel_5y7:kugel_2y7:kugel_1hhy9:werkzeugeatttttttttttttttttttthg",
			[12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12],
		],
//26
		//schlange 3 - nicht schlecht!
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_2hay7:kugel_1hay7:kugel_4hay7:kugel_3hay7:kugel_5hhy9:werkzeugeatttttttttttttttttttthg",
			[12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12],
		],
// //27
// 		//hat 1 - zu einfach?
// 		[
// 			"v1",
// 			"cy4:Ziely4:zielaay7:kugel_1R2R2hay7:kugel_5R3R2hay7:kugel_2R3R2hhy9:werkzeugeatttttttttttttttttttthg",
// 			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
// 		],
//28
		//copier + reaktivator - ok?
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_1y7:kugel_5R2hay7:kugel_2y7:kugel_4R4haR2R3R2hhy9:werkzeugeatttttttttttttttttttthg",
			[7,7,7,18,7,7,7,18,7,7,7,18,7,7,7,18,7,7,7,18],
		],
//29
		// //sehr einfach, aber vllt ok?
		// [
		// 	"v1",
		// 	"cy4:Ziely4:zielaay7:kugel_1ny7:kugel_5hany7:kugel_4nhay7:kugel_2ny7:kugel_6hhy9:werkzeugeatttttttttttttttttttthg",
		// 	[8,13,8,13,13,8,13,8,8,13,8,13,13,8,13,8,8,13,8,13],
		// ],
//30
		//haut + globaler löscher
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_4y7:kugel_5haR3R2haR2R3hhy9:werkzeugeatttttttttttttttttttthg",
			[1,2,2,2,1,2,2,2,1,2,2,2,1,2,2,2,1,2,2,2],
		],
//31
		// //füllugpuzzle, nicht so schwierig?
		// [
		// 	"v1",
		// 	"cy4:Ziely4:zielaay7:kugel_1R2haR2nhhy9:werkzeugeatttttttttttttttttttthg",
		// 	[1,1,1,1,6,1,6,1,1,1,1,1,6,1,6,1,1,1,1,1],
		// ],
//32
		//kopie/globaler löscher - ich finde dieses puzzle ganz ok
		[
			"v1",
			"cy4:Ziely4:zielaau3hay7:kugel_1nR2hau3hhy9:werkzeugeatttttttttttttttttttthg",
			[7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1],
		],
//33
// 		//globaler löscher + schlange, einfacher version
// 		[
// 			"v1",
// 			"cy4:Ziely4:zielaay7:kugel_1ny7:kugel_3haR2nR3hhy9:werkzeugeatttttttttttttttttttthg",
// 			[12,1,1,12,1,12,12,1,1,12,12,1,1,12,12,1,12,1,1,12],
// 		],
// //34
// 		//globaler löscher + schlange, schwierige version
// 		[
// 			"v1",
// 			"cy4:Ziely4:zielaany7:kugel_1ny7:kugel_3hanR2nR3hhy9:werkzeugeatttttttttttttttttttthg",
// 			[12,1,1,12,1,12,12,1,1,12,12,1,1,12,12,1,12,1,1,12],
// 		],
//35
		//wachsen+globaler löscher - ok?
		[
			"v1",
			"cy4:Ziely4:zielaau3hay6:halm_2y6:halm_4y6:halm_1hay7:kugel_2y7:kugel_4y7:kugel_1hhy9:werkzeugeatttttttttttttttttttthg",
			[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,20,20,20,20],
		],	
//36	
		//bombe+haut - ok?
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_5R2R2hay7:kugel_6R3R3hhy9:werkzeugeatttttttttttttttttttthg",
			[19,2,19,2,2,19,2,19,19,2,19,2,2,19,2,19,19,2,19,2],
		],
//37
		//vsplitter+füller - ok ziemlich einfach?
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_3y7:kugel_4haR2R3haR2R3hhy9:werkzeugeatttttttttttttttttttthg",
			[3,6,3,6,6,3,6,3,3,6,3,6,6,3,6,3,3,6,3,6],
		],
		
//38
// 		//snake + hsplitter.  must be aware situationally but not crazy hard
// [
// 			"v1",
// 			"cy4:Ziely4:zielaay7:kugel_1y7:kugel_4R2hanR3nhaR2R3R2hhy9:werkzeugeatttttttttttttttttttthg",
// 			[4,12,4,12,12,3,12,3,4,12,4,12,12,3,12,3,4,12,4,12],
// 		],
//39
		//grower + hsplitter - pretty easy
		[
			"v1",
			"cy4:Ziely4:zielaau2hay6:halm_2y6:halm_1hau2hhy9:werkzeugeatttttttttttttttttttthg",
			[20,4,20,4,4,20,4,20,20,4,20,4,4,20,4,20,20,4,20,4],
		],
//40
		// //schlage+fußgänger - weiß nicht ob es gut ist oder nicht...zu einfach..
		// [
		// 	"v1",
		// 	"cy4:Ziely4:zielaay7:kugel_4R2R2haR2y7:kugel_2R2haR2R2R2hhy9:werkzeugeatttttttttttttttttttthg",
		// 	[5,5,5,5,5,5,5,5,12,12,12,12,13,13,13,13,13,13,13,13],
		// ],
//41
		//complex - 4 gegenständer mit reaktivieren weiß nicht ob es gut ist oder nicht
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_6y7:kugel_2R2haR2y7:kugel_1R3haR2R3R2hhy9:werkzeugeatttttttttttttttttttthg",
			[13,18,18,18,10,18,18,18,2,18,18,18,10,18,18,18,13,18,18,18],
		],
//42
		// //bombe, kopier, reaktivator
		// [
		// 	"v1",
		// 	"cy4:Ziely4:zielaay7:kugel_2y7:kugel_5R2hau3haR2nR2hhy9:werkzeugeatttttttttttttttttttthg",
		// 	[7,19,7,18,19,7,19,18,7,19,7,18,19,7,19,18,7,19,7,18],
		// ],
//43
		//snake + dropper + hdeleter : don't know if it's hard or not (probably. feels a bit claustraphobic)
		[
			"v1",
			"cy4:Ziely4:zielaany7:kugel_2nhay7:kugel_4nR2hanR3nhhy9:werkzeugeatttttttttttttttttttthg",
			[4,12,9,12,4,9,12,9,4,12,9,12,4,9,12,9,4,12,9,12],
		],
//44
		//snake + rotator : not so hard, but engaging maybe?
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_4R2R2R2haR2R2R2R2hhy9:werkzeugeatttttttttttttttttttthg",
			[12,14,14,14,12,14,14,14,12,14,14,14,12,14,14,14,12,14,14,14],
		],
//45
		//blaa boring and bad
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_4R2hay7:kugel_2R3haR3R3hhy9:werkzeugeatttttttttttttttttttthg",
			[12,9,9,12,12,9,9,12,12,9,9,12,12,9,9,12,12,9,9,12],
		],
//46
		//weiß nicht flip mirrorer und dreher
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_2haR2haR2hhy9:werkzeugeatttttttttttttttttttthg",
			[17,14,16,14,14,17,14,16,17,14,16,14,14,17,14,16,17,14,16,14
			],
		],
//47
		//schlang + kopier - nicht sicher genau wie schwierig
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_5R2haR2y7:kugel_4haR3R3hhy9:werkzeugeatttttttttttttttttttthg",
			[12,12,18,18,12,12,18,18,12,12,18,18,12,12,18,18,12,12,18,18],
		],
//48
		//muss alles behauten - actually pretty easy
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_4R2y7:kugel_3y7:kugel_6haR3R3y7:kugel_5R3haR3R5y7:kugel_2R5haR5R6y7:kugel_1R6haR5R5R6R6hhy9:werkzeugeatttttttttttttttttttthg",
			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
		],

//49
		// [
		// 	"v1",
		// 	"cy4:Ziely4:zielaay7:kugel_6y7:kugel_3R3R3haR3y7:kugel_5R4R3haR3R4y7:kugel_2R4haR4R5y7:kugel_1R5haR4R5R5y7:kugel_4hhy9:werkzeugeatttttttttttttttttttthg",
		// 	[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
		// ],
//50
		//hairy hdeleter - maybe ok? work backwards to solve everything
		[
			"v1",
			"cy4:Ziely4:zielaay7:kugel_5R2hay7:kugel_1R3hay7:kugel_3R4haR2R2hay7:kugel_6R5hhy9:werkzeugeatttttttttttttttttttthg",
			[2,4,2,4,4,2,4,2,2,4,2,4,4,2,4,2,2,4,2,4],
		],
	];



	private function do_playSound(s:Int){
		if (Globals.state.audio==0){
			return;
		}
		// switch(s){
		// 	case 0://animation sound
		// 		Sound.play("drop",0,false,0.2);
		// 	case 1://remove
		// 		Sound.play("drop2",0,false,0.2);
		// 	case 2://drop
		// 		Sound.play("drop3",0,false,0.2);
		// 	case 3://drag begin

		// 		Sound.play("drop4",0,false,0.2);
		// }
	}

	public function leererAbweichungsgitter():Array<Array<Int>>{
		var result = new Array<Array<Int>>();
		for (j in 0...sp_zeilen){
			var zeile = new Array<Int>();
			for (i in 0...sp_spalten){
				var index = i+sp_spalten*j+1 ;
				zeile.push(-1);
			}
			result.push(zeile);
		} 
		return result;
	}

	public var i_spalten:Int=3;
	public var i_zeilen:Int=2;
	
	public var sp_spalten:Int=4;
	public var sp_zeilen:Int=5;
	

	public var szs_inventory:Array<Array<String>>;
	public var szs_brett:Array<Array<String>>;


	public var animationen:Array<AnimationFrame>;
	public var zieh_modus:Bool;
	public var zieh_quelle_i:Int;
	public var zieh_quelle_j:Int;	
	public var zieh_offset_x:Int;
	public var zieh_offset_y:Int;
	public var zieh_name:String;
	
	function checkSolve(partikelnErlauben:Bool){
		var schonloesbar = cansolve;

		solvex=-1;
		solvey=-1;
		cansolve=false;
		
		if (geloest[aktuellesZielIdx]==ziele[aktuellesZielIdx][0]){
			return;
		}

		// if (aktuellesZielIdx==48){
		// 	cansolve=true;

		// 	for (j in 0...sp_zeilen){
		// 		for (i in 0...sp_spalten){
		// 			if (szs_brett[j][i]!=null){
		// 				cansolve=false;
		// 				return;
		// 			}
		// 		}
		// 	}

		// 	for (j in 0...i_zeilen){
		// 		for (i in 0...i_spalten){
		// 			if (szs_inventory[j][i]!=null){
		// 				cansolve=false;
		// 				return;
		// 			}
		// 		}
		// 	}
					
		// } else if (aktuellesZielIdx==49){
		// 	cansolve=true;
		// 	for (i in 0...(ziele.length-1)){
		// 		if (geloest[i]!=ziele[i][0]){
		// 			cansolve=false;
		// 			return;
		// 		}
		// 	}
		// } else 
		{
			var z =  aktuellesZiel.ziel;
			var zw = aktuellesZiel.ziel[0].length;
			var zh = aktuellesZiel.ziel.length;

			for (gi in 0...(sp_spalten+1-zw)){
				for (gj in 0...(sp_zeilen+1-zh)){
					var match=true;
					for (i in 0...zw){
						for (j in 0...zh){
							if (z[j][i]!=szs_brett[gj+j][gi+i]){
								match=false;
							}
						}
						if (match==false){
							break;
						}
					}
					if (match){
						cansolve=true;
						solvex=gi;
						solvey=gj;
						break;
					}
				}	
			}
		}

		if (partikelnErlauben && cansolve && schonloesbar==false){
			var px = 306;
			var py =  182;
			var pbb = Gfx.imagewidth("btn_solve_bg_up");
			var pbh = Gfx.imageheight("btn_solve_bg_down");
			cansolve=true;			
							
		}
	}
	
	

	function LoadLevel(level:Int){
		if (level>=ziele.length||level<0){
			aktuellesZiel = new Ziel(
				[[null]],
				[
					true,true,
					true,true,
					true,true,
					true,true,
					true,true,
					true,true,
					true,true,
					true,true,
					true,true,
					true,true
				]
			);

			neuesBlatt();
			checkSolve(false);
			forcerender=true;
			regenAllText();
			return;
		}

		aktuellesZielIdx=level;

		Save.savevalue("mwblevelidx",aktuellesZielIdx);
		var ziel_s = ziele[aktuellesZielIdx][1];
	    var unserializer = new Unserializer(ziel_s);

		aktuellesZiel = unserializer.unserialize();

		var dieser_undoStack = undoStack[aktuellesZielIdx];
		var dieser_undoStack_pos = undoPos[aktuellesZielIdx];
		if (dieser_undoStack.length>0){
			var zs = dieser_undoStack[dieser_undoStack_pos];
			szs_inventory=Copy.copy(zs.i);
			szs_brett=Copy.copy(zs.sp);
		} else {
			neuesBlatt();
		}

		checkSolve(false);
		forcerender=true;
		regenAllText();
	}
	
		
	var geloest:Array<String> = [];
	var version=1.5;
	
	// function _setupSound(url:String, ?loop:Bool = false):WaudSound {
	// 	// return  new WaudSound(
	// 		url, { autoplay: false, loop: loop, volume: 1.0 });
	// }

	// var _sfx_drop:WaudSound;
	// var _sfx_drop2:WaudSound;
	// var _sfx_drop3:WaudSound;
	// var _sfx_drop4:WaudSound;

	function setup(){
		// Waud.init();
		// _sfx_drop = _setupSound("data/sounds/drop.mp3");
		// _sfx_drop2 = _setupSound("data/sounds/drop2.mp3");
		// _sfx_drop3 = _setupSound("data/sounds/drop3.mp3");
		// _sfx_drop4 = _setupSound("data/sounds/drop4.mp3");

		geloest = [];
		for (i in 0...ziele.length){
			geloest.push(Save.loadvalue("level"+i,null));
		}

		// Core.showstats=true;
		Core.fps=30;
		Gfx.clearcolor=Col.TRANSPARENT;

		undoStack=new Array<Array<LevelZustand>>();
		undoPos = new Array<Int>();
		for (i in 0...ziele.length){
			undoStack.push([]);
			undoPos.push(-1);
		}

		Globals.state.level=Save.loadvalue("mwblevel",0);
		Globals.state.audio=Save.loadvalue("mwbaudio",1);
		Globals.state.sprache='en';//Save.loadvalue("global_sprache","en");
		
		tongue.init(Globals.state.sprache,onLanguageLoaded,true,true,null,"data/locales/");
		
		var unterstuetzteSprachen = tongue.get_locales();
		if (unterstuetzteSprachen.indexOf(Globals.state.sprache)==-1){
			Globals.state.sprache="en";
		}
		
		for(i in 0...6){
			Globals.state.solved[i]=Save.loadvalue("mwbsolved"+i,0);
		}


		aktuellesZielIdx = Save.loadvalue("mwblevelidx",0);
		if (aktuellesZielIdx<0){
			aktuellesZielIdx=0;
		}
		if (aktuellesZielIdx>ziele.length){
			aktuellesZielIdx=ziele.length-1;
		}
		Globals.state.level=aktuellesZielIdx;
		
		LoadLevel(Globals.state.level);	

	}


	function reset(){
		setup();
	}

	public static var animFrameDauer:Int=8;
	public static var animPos:Int=0;

	function spazieren(anim:AnimationFrame,hoverziel_x:Int,hoverziel_y:Int){
		var xmin = hoverziel_x+1;
		var xmax_p1 = sp_spalten;
		var i=0;
		var quelle=anim.nach_brett[hoverziel_y][hoverziel_x];
		for (x in xmin...xmax_p1){
			if (anim.nach_brett[hoverziel_y][x]!=null){
				break;
			}
			i++;
			anim.nach_brett[hoverziel_y][x]=quelle;
			anim.abweichung[hoverziel_y][x]=i;
		}
		anim.maxabweichung=i;
	}


	function spiegelkopien(anim:AnimationFrame,x:Int,y:Int){




			var startframe2 = new AnimationFrame();
			startframe2.vor_brett = Copy.copy(szs_brett);
			startframe2.nach_brett = Copy.copy(szs_brett);
			startframe2.abweichung = leererAbweichungsgitter();
			var anim2 = startframe2;
			startframe2.abweichung[y][x]=0;
			animationen.push(anim2);
			
			

		

		function get_vorbrett(px,py){
			if (px<0||px>=sp_spalten ||py<0||py>=sp_zeilen){
				return null;
			}
			return anim.vor_brett[py][px];
		}


		function set_brett(px,py,v){
			if (px<0||px>=sp_spalten ||py<0||py>=sp_zeilen){
				return;
			}
			anim2.nach_brett[py][px]=v;
		}


		function setf(px,py,v){
			if (px<0||px>=sp_spalten ||py<0||py>=sp_zeilen){
				return;
			}
			anim.abweichung[py][px]=v;
			anim2.abweichung[py][px]=v;
		}


		var vn=get_vorbrett(x,y-1);
		var vs=get_vorbrett(x,y+1);
		var vo=get_vorbrett(x+1,y);
		var vw=get_vorbrett(x-1,y);

		setf(x-1,y,0);
		setf(x+1,y,0);
		setf(x,y-1,0);
		setf(x,y+1,0);

		if (vn==null){
			set_brett(x,y-1,vs);
		}

		if (vs==null){
			set_brett(x,y+1,vn);
		}

		if (vw==null){
			set_brett(x-1,y,vo);
		}

		if (vo==null){
			set_brett(x+1,y,vw);
		}

		anim.maxabweichung=0;
		anim2.maxabweichung=0;
	}


	function zeile_entleeren(anim:AnimationFrame,x:Int,y:Int){

		var max_frame=0;

		for (i in 1...sp_spalten){
			var i_von=x-i;
			var i_zu=x+i;
			if (i_von>=0 && i_von<sp_spalten){
				anim.nach_brett[y][i_von]=null;
				anim.abweichung[y][i_von]=i;
				if (i>max_frame){
					max_frame=i;
				}
			}
			if (i_zu>=0 && i_zu<sp_spalten){
				anim.nach_brett[y][i_zu]=null;
				anim.abweichung[y][i_zu]=i;
				if (i>max_frame){
					max_frame=i;
				}
			}
		}
		anim.maxabweichung=max_frame;
	}



	function wiederholen(anim:AnimationFrame,x:Int,y:Int){

		if (x==0){
			return;
		}
		var a = anim.nach_brett;
		var f = anim.abweichung;
		
		f[y][x-1]=1;
		anim.maxabweichung=1;

		if (szs_brett[y][x-1]==null){
			return;
		}
		tuePlatzierung(x-1,y,a[y][x-1],false);
		
	}




	function bomben(anim:AnimationFrame,x:Int,y:Int){


		var a = anim.nach_brett;
		var f = anim.abweichung;
		
		function entleeren(px,py){
			if (px<0||py<0||px>=sp_spalten||py>=sp_zeilen){
				return;
			}
			a[py][px]=null;
			f[py][px]=1;
		}

		entleeren(x-1,y-1);
		entleeren(x+0,y-1);
		entleeren(x+1,y-1);
		
		entleeren(x-1,y+0);
		entleeren(x+1,y+0);

		entleeren(x-1,y+1);
		entleeren(x+0,y+1);
		entleeren(x+1,y+1);

		anim.maxabweichung=1;
	}



	function spalte_entleeren(anim:AnimationFrame,x:Int,y:Int){

		var max_frame=0;

		for (j in 1...sp_zeilen){
			var j_von=y-j;
			var j_zu=y+j;
			if (j_von>=0 && j_von<sp_zeilen){
				anim.nach_brett[j_von][x]=null;
				anim.abweichung[j_von][x]=j;
				if (j>max_frame){
					max_frame=j;
				}
			}
			if (j_zu>=0 && j_zu<sp_zeilen){
				anim.nach_brett[j_zu][x]=null;
				anim.abweichung[j_zu][x]=j;
				if (j>max_frame){
					max_frame=j;
				}
			}
		}
		anim.maxabweichung=max_frame;
	}


	function schieben(anim:AnimationFrame,x:Int,y:Int){
		
		var a = anim.nach_brett;
		var f = anim.abweichung;
		
		f[y][x]=0;

		var frame=0;
		
		var dx=0;
		var dy=0;

		var i=0;


		//von links
		i=0;
		dx=0;
		while (dx<x){

			if (dx>0){
				a[y][dx-1]=a[y][dx];
			}
			a[y][dx]=null;
			f[y][dx]=i;
			dx++;
			i++;
		}
		i--;
		if (i>frame){
			frame=i;
		}


		//von rechts
		i=0;
		dx=sp_spalten-1;
		while (dx>x){

			if (dx<sp_spalten-1){
				a[y][dx+1]=a[y][dx];
			}
			a[y][dx]=null;
			f[y][dx]=i;
			dx--;
			i++;
		}
		i--;
		if (i>frame){
			frame=i;
		}



		//von oben
		i=0;
		dy=0;
		while (dy<y){

			if (dy>0){
				a[dy-1][x]=a[dy][x];
			}
			a[dy][x]=null;
			f[dy][x]=i;
			dy++;
			i++;
		}
		i--;
		if (i>frame){
			frame=i;
		}


		//von unten
		i=0;
		dy=sp_zeilen-1;
		while (dy>y){

			if (dy<sp_zeilen-1){
				a[dy+1][x]=a[dy][x];
			}
			a[dy][x]=null;
			f[dy][x]=i;
			dy--;
			i++;
		}
		i--;
		if (i>frame){
			frame=i;
		}

	

		anim.maxabweichung=frame;
	}



	function drehen(anim:AnimationFrame,x:Int,y:Int){
		var a = anim.nach_brett;
		var f = anim.abweichung;
		
		f[y][x]=0;


		function set_brett(px,py,v){
			if (px<0||px>=sp_spalten ||py<0||py>=sp_zeilen){
				return;
			}
			anim.nach_brett[py][px]=v;
		}
		
		function get_vorbrett(px,py){
			if (px<0||px>=sp_spalten ||py<0||py>=sp_zeilen){
				return null;
			}
			return anim.vor_brett[py][px];
		}


		function setf(px,py,v){
			if (px<0||px>=sp_spalten ||py<0||py>=sp_zeilen){
				return;
			}
			f[py][px]=v;
		}
		

		function getf(px,py,def){
			if (px<0||px>=sp_spalten ||py<0||py>=sp_zeilen){
				return def;
			}
			return f[py][px];
		}

		function von_bis(x1,y1,x2,y2,f):Bool{
			set_brett(x2,y2,get_vorbrett(x1,y1));
			setf(x2,y2,f);
			return true;
		}

		von_bis(x,y-1,		x-1,y-1,	1);
		von_bis(x-1,y-1,	x-1,y,		1);
		von_bis(x-1,y,		x-1,y+1,	1);
		von_bis(x-1,y+1,	x,y+1,		1);
		von_bis(x,y+1,		x+1,y+1,	1);
		von_bis(x+1,y+1,	x+1,y,		1);
		von_bis(x+1,y,		x+1,y-1,	1);
		von_bis(x+1,y-1,	x,y-1,		1);
		
		anim.maxabweichung=1;
	}


	function ziehen(anim:AnimationFrame,x:Int,y:Int){
		var a = anim.nach_brett;
		var f = anim.abweichung;
		
		var quelle=anim.nach_brett[y][x];

		a[y][x]=quelle;
		f[y][x]=0;

		var frame=0;

		for (i in 1...sp_spalten){
			var x_l = x-i;
			var x_r = x+i;

			if (x_l>=0){
				if (i>1){
					a[y][x_l+1]=a[y][x_l];
				}
				a[y][x_l]=null;
				f[y][x_l]=i;
				if (i>frame){
					frame=i;
				}
			}

			if (x_r<sp_spalten){
				if (i>1){
					a[y][x_r-1]=a[y][x_r];
				}
				a[y][x_r]=null;
				f[y][x_r]=i;
				if (i>frame){
					frame=i;
				}
			}
		}


		for (j in 1...sp_zeilen){
			var y_t = y-j;
			var y_b = y+j;

			if (y_t>=0){
				if (j>1){
					a[y_t+1][x]=a[y_t][x];
				}
				a[y_t][x]=null;
				f[y_t][x]=j;
				if (j>frame){
					frame=j;
				}
			}

			if (y_b<sp_zeilen){
				if (j>1){
					a[y_b-1][x]=a[y_b][x];			
				}
				a[y_b][x]=null;
				f[y_b][x]=j;
				if (j>frame){
					frame=j;
				}
			}
		}

		anim.maxabweichung=frame;
	}

	function fuellen(anim:AnimationFrame,x:Int,y:Int){

		var quelle=anim.nach_brett[y][x];
		var a = anim.nach_brett;
		var f = anim.abweichung;
		//1 s6 ersetzen
		for (j in 0...sp_zeilen){
			for (i in 0...sp_spalten){
				if (a[j][i]==quelle){
					a[j][i]="temp";
				}
			}
		}
		a[y][x]=quelle;
		f[y][x]=0;
		var aenders=true;
		var frame=1;
		while (aenders){
			aenders=false;

			for (j in 0...sp_zeilen){
				for (i in 0...sp_spalten){
					var n = a[j][i];
					if (n!=null){
						continue;
					}
					var fuellbar=false;
					if (j>0 && a[j-1][i]==quelle && f[j-1][i]==(frame-1)){
						fuellbar=true;
					} else if (j<sp_zeilen-1 && a[j+1][i]==quelle&& f[j+1][i]==(frame-1)){
						fuellbar=true;
					} else if (i>0 && a[j][i-1]==quelle && f[j][i-1]==(frame-1)){
						fuellbar=true;
					} else if (i<sp_spalten-1 && a[j][i+1]==quelle&& f[j][i+1]==(frame-1)){
						fuellbar=true;
					}
					if (fuellbar){
						aenders=true;
						a[j][i]=quelle;
						f[j][i]=frame;
					}
				}
			}
			frame++;
		}

		for (j in 0...sp_zeilen){
			for (i in 0...sp_spalten){
				if (a[j][i]=="temp"){
					a[j][i]=quelle;
				}
			}
		}
		
		frame--;
		anim.maxabweichung=frame;
	
	}



	function loeschen(anim:AnimationFrame,x:Int,y:Int){
		var a = anim.nach_brett;
		var f = anim.abweichung;

		var frame=1;

		f[y][x]=-1;

		function ersetzen(von,zu,fr){
			var ersetzt=false;
			for (j in 0...sp_zeilen){
				for (i in 0...sp_spalten){
					if (a[j][i]==von && f[j][i]==-1){
						a[j][i]=zu;
						f[j][i]=fr;
						ersetzt=true;
					}
				}
			}
			return ersetzt;
		}

		if (a[y][x]!=null){
			//osten
			if (x<sp_spalten-1){
				var vn = a[y][x+1];
					a[y][x+1]=null;
					if (f[y][x+1]==-1){
						f[y][x+1]=frame;
						frame++;
					}
					
				if (vn!=null){
					if (ersetzen(vn,null,frame)){
						frame++;
					}
				}
			}
		}
		

		if (a[y][x]!=null){
			//suden
			if (y<sp_zeilen-1){
				var vn = a[y+1][x];
				a[y+1][x]=null;

				if (f[y+1][x]==-1){
					f[y+1][x]=frame;
					frame++;
				}				
					
				if (vn!=null){
					if (ersetzen(vn,null,frame)){
						frame++;
					}
				}
			}
		}		
		
		if (a[y][x]!=null){
			//westen
			if (x>0){
				var vn = a[y][x-1];
					a[y][x-1]=null;

				if (f[y][x-1]==-1){
					f[y][x-1]=frame;
					frame++;
				}			
				
					
				if (vn!=null){
					if (ersetzen(vn,null,frame)){
						frame++;
					}
				}
			}
		}




		if (a[y][x]!=null){
			//norden
			if (y>0){
				var vn = a[y-1][x];
					a[y-1][x]=null;
					
				if (f[y-1][x]==-1){
					f[y-1][x]=frame;
					frame++;
				}	
					
				if (vn!=null){
					if (ersetzen(vn,null,frame)){
						frame++;
					}
				}
			}
		}







		frame--;
		anim.maxabweichung=frame;
	
	}

	function behaaren(anim:AnimationFrame,x:Int,y:Int){
		var a = anim.nach_brett;
		var f = anim.abweichung;
		var quelle=anim.nach_brett[y][x];

		function nichtfellob(px,py){
			if (px<0||px>=sp_spalten ||py<0||py>=sp_zeilen){
				return false;
			}
			if (a[py][px]==null){
				return false;
			}
			return a[py][px]!=quelle; 
		}

		a[y][x]=quelle;
		f[y][x]=0;
		var aenders=true;
		var frame=1;
		while (aenders){
			aenders=false;

			for (j in 0...sp_zeilen){
				for (i in 0...sp_spalten){
					var n = a[j][i];
					if (n==null || n==quelle){
						continue;
					}
				
					function fellBei(px,py):Bool{
						if (px<0||py<0||px>=sp_spalten||py>=sp_zeilen){
							return false;
						}
						var val = a[py][px];
						if (val ==quelle){
							return true;
						}
						return false;
					}

					function aktuellesFellBei(px,py):Bool{
						if (px<0||py<0||px>=sp_spalten||py>=sp_zeilen){
							return false;
						}
						var val = a[py][px];
						if (val ==quelle && f[py][px]==(frame-1)){
							return true;
						}
						return false;
					}

					function versuchBehaaren(px,py){

						if (px<0||py<0||px>=sp_spalten||py>=sp_zeilen){
							return ;
						}

						if (a[py][px]!=null){
							return;
						}

						if (
						aktuellesFellBei(px-1,py-1)||
						aktuellesFellBei(px-1,py+0)||
						aktuellesFellBei(px-1,py+1)||
						aktuellesFellBei(px+0,py-1)||
						aktuellesFellBei(px+0,py+1)||
						aktuellesFellBei(px+1,py-1)||
						aktuellesFellBei(px+1,py+0)||
						aktuellesFellBei(px+1,py+1) 
						){
							if (
								(nichtfellob(px+1,py)  ) ||
								(nichtfellob(px,py+1)  ) ||
								(nichtfellob(px,py-1)  ) ||
								(nichtfellob(px-1,py)  ) 
							){
								a[py][px]=quelle;
								f[py][px]=frame;
								aenders=true;
							}
						}
					}
					
					if (
						fellBei(i-1,j-1)||
						fellBei(i-1,j+0)||
						fellBei(i-1,j+1)||
						fellBei(i+0,j-1)||
						fellBei(i+0,j+1)||
						fellBei(i+1,j-1)||
						fellBei(i+1,j+0)||
						fellBei(i+1,j+1)
					) {
						versuchBehaaren(i-1,j-1);
						versuchBehaaren(i-1,j-0);
						versuchBehaaren(i-1,j+1);
						versuchBehaaren(i-0,j-1);
						versuchBehaaren(i-0,j+1);
						versuchBehaaren(i+1,j-1);
						versuchBehaaren(i+1,j-0);
						versuchBehaaren(i+1,j+1);
					}
				}
			}
			frame++;
		}

		
		frame--;
		anim.maxabweichung=frame;
	
	}

	function spiralen(anim:AnimationFrame,hoverziel_x:Int,hoverziel_y:Int){
		var x= hoverziel_x;
		var y = hoverziel_y;
		var frame=0;
		y--;

		var quelle=anim.nach_brett[hoverziel_y][hoverziel_x];

		//heroben
		while (y>=0){
			if (anim.nach_brett[y][x]!=null){
				break;
			}
			anim.nach_brett[y][x]=quelle;
			anim.abweichung[y][x]=frame;
			frame++;
			y--;
		}
		y++;

		//rechts
		x++;
		while (x<sp_spalten){
			if (anim.nach_brett[y][x]!=null){
				break;
			}

			anim.nach_brett[y][x]=quelle;
			anim.abweichung[y][x]=frame;
			frame++;
			x++;
		}
		x--;
		
		y++;

		//herunten
		while (y<sp_zeilen){
			if (anim.nach_brett[y][x]!=null){
				break;
			}
			anim.nach_brett[y][x]=quelle;
			anim.abweichung[y][x]=frame;
			frame++;
			y++;
		}
		y--;


		//links
		x--;
		while (x>=0){
			if (anim.nach_brett[y][x]!=null){
				break;
			}

			anim.nach_brett[y][x]=quelle;
			anim.abweichung[y][x]=frame;
			frame++;
			x--;
		}
		x++;

		frame--;
		anim.maxabweichung=frame;
	}


	function schraegspiegeln(anim:AnimationFrame,x:Int,y:Int){
		var a = anim.nach_brett;
		var f = anim.abweichung;

		function setf(px,py,v){
			if (px<0||px>=sp_spalten ||py<0||py>=sp_zeilen){
				return;
			}
			f[py][px]=v;
		}


		function get_vorbrett(px,py){
			if (px<0||px>=sp_spalten ||py<0||py>=sp_zeilen){
				return null;
			}
			return anim.vor_brett[py][px];
		}

		function getf(px,py,def){
			if (px<0||px>=sp_spalten ||py<0||py>=sp_zeilen){
				return def;
			}
			return f[py][px];
		}


		var schritte = sp_spalten+sp_zeilen;
		for (i in 0...schritte){
			var l_x=x+i;
			var l_y=y-i;
			
			var u_x=x-i;
			var u_y=y+i;
			
			setf(u_x,u_y,0);
			setf(l_x,l_y,0);			
		}

		var frames=0;
		
		var geaendert=true;
		while(geaendert){
			geaendert=false;
			
			for (j in 0...sp_zeilen){
				for (i in 0...sp_spalten){
					var deltax = i-x;
					var deltay = j-y;
					if (deltax==0&&deltay==0){
						continue;
					}
					
					var i2 = x-deltay;
					var j2 = y-deltax;
					a[j][i]=get_vorbrett(i2,j2);

					if (f[j][i]>=0){
						continue;
					}
					var v1 = getf(i-1,j,-1);
					var v2 = getf(i,j-1,-1);
					var v3 = getf(i+1,j,-1);
					var v4 = getf(i,j+1,-1);
					var m = v1;
					if (v2>m){
						m=v2;
					}
					if (v3>m){
						m=v3;
					}
					if (v4>m){
						m=v4;
					}
					if (m>=0){
						m++;
						f[j][i]=m;
						geaendert=true;
						if (m>frames){
							frames=m;
						}
					}					
				}
			}

		}
		anim.maxabweichung=frames;
	}
	function spiegeln_hinunten(anim:AnimationFrame,hoverziel_x:Int,hoverziel_y:Int){
	
	
		var max_frame=0;

		for (j in 0...sp_zeilen){
			var j_von=hoverziel_y-j;
			var j_zu=hoverziel_y+j;
			if (j_von>=0 && j_von<sp_zeilen){
				for (x in 0...sp_spalten){
					anim.abweichung[j_von][x]=j;
					if (j>max_frame){
						max_frame=j;
					}
				}
			}
			if (j_zu>=0 && j_zu<sp_zeilen){
				for (x in 0...sp_spalten){
					if (j!=0){
						anim.nach_brett[j_zu][x]=null;
					}
					anim.abweichung[j_zu][x]=j;
					if (j>max_frame){
						max_frame=j;
					}
				}
			}

			if (j_von>=0 && j_von<sp_zeilen && j_zu>=0 && j_zu<sp_zeilen){
				for (x in 0...sp_spalten){
					anim.nach_brett[j_zu][x]=anim.nach_brett[j_von][x];
				}
			}
		}
		
		anim.maxabweichung=max_frame;

	}

	function spiegeln_hinoben(anim:AnimationFrame,hoverziel_x:Int,hoverziel_y:Int){
	
	
		var max_frame=0;

		for (j in 0...sp_zeilen){
			var j_von=hoverziel_y+j;
			var j_zu=hoverziel_y-j;
			if (j_von>=0 && j_von<sp_zeilen){
				for (x in 0...sp_spalten){
					anim.abweichung[j_von][x]=j;
					if (j>max_frame){
						max_frame=j;
					}
				}
			}
			if (j_zu>=0 && j_zu<sp_zeilen){
				for (x in 0...sp_spalten){
					if (j!=0){
						anim.nach_brett[j_zu][x]=null;
					}
					anim.abweichung[j_zu][x]=j;
					if (j>max_frame){
						max_frame=j;
					}
				}
			}

			if (j_von>=0 && j_von<sp_zeilen && j_zu>=0 && j_zu<sp_zeilen){
				for (x in 0...sp_spalten){
					anim.nach_brett[j_zu][x]=anim.nach_brett[j_von][x];
				}
			}
		}
		
		anim.maxabweichung=max_frame;
	}

	function versuchfallenzulassen(x:Int,y:Int){

		var z_names:Array<Int> = ziele[aktuellesZielIdx][2];

		var startframe = new AnimationFrame();
		startframe.vor_brett = Copy.copy(szs_brett);
		startframe.nach_brett = Copy.copy(szs_brett);
		startframe.abweichung = leererAbweichungsgitter();
		var animation = startframe;


		var startframe2 = new AnimationFrame();
		startframe2.vor_brett = Copy.copy(szs_brett);
		startframe2.nach_brett = Copy.copy(szs_brett);
		startframe2.abweichung = leererAbweichungsgitter();
		var animation2 = startframe2;

		animation.maxabweichung=0;
		animation2.maxabweichung=0;
		var etwgemacht=false;
		var anderung=true;
		while(anderung){
			anderung=false;
			for (i in 0...sp_spalten){
				for (j in 0...sp_zeilen){
						
					var erlauben=false;

					if (x==i&&y==j){
						continue;
					}
					
					if (animationen.length>0){
						if (animationen[0].vor_brett[j][i]==null){
							continue;
						}
					}

					var bgname = z_names[i+sp_spalten*j];
					if (bgname!=9){
						continue;
					}

					if (animation2.nach_brett[j][i]!=null && ( (j==sp_zeilen-1) ||animation2.nach_brett[j+1][i]==null) ){
						erlauben=true;
					}

					if (!erlauben){
						continue;
					}

					{
						// var j = sp_zeilen-1;
						// while(j>=0){
							// for (i in 0...sp_spalten){
								

									etwgemacht=true;
									if (j<(sp_zeilen-1) ){
										animation2.nach_brett[j+1][i]=animation2.nach_brett[j][i];
										animation2.abweichung[j+1][i]=0;
									}
									animation2.nach_brett[j][i]=null;
									animation.abweichung[j][i]=0;
									anderung=true;
							// }
							// j--;
						// }	
					}

				}
			}
		}

		if (etwgemacht){
			animationen.push(animation);
			animationen.push(animation2);
			szs_brett = Copy.copy(animation2.nach_brett);
		}

	}

	function versuchaufzuwachsen(x:Int,y:Int){
		var z_names:Array<Int> = ziele[aktuellesZielIdx][2];



		var startframe = new AnimationFrame();
		startframe.vor_brett = Copy.copy(szs_brett);
		startframe.nach_brett = Copy.copy(szs_brett);
		startframe.abweichung = leererAbweichungsgitter();
		startframe.maxabweichung=1;
		
		var animation = startframe;
		var modified=false;

		for (i in 0...sp_spalten){
			for (j in 0...sp_zeilen){
						
				if (i==x&&y==j){
					continue;
				}


					var bgname = z_names[i+sp_spalten*j];
					if (bgname!=20){
						continue;
					}


				if (animationen.length>0){
					if (animationen[0].vor_brett[j][i]==null){
						continue;
					}
				}

				var targets=[];
				// for (j in 0...sp_zeilen){
					// for (i in 0...sp_spalten){
						if (szs_brett[j][i]!=null && szs_brett[j][i].charAt(0)=="k" ){
							var k = j-1;
							var farbe = szs_brett[j][i].charAt(6);
							trace("farbe " +szs_brett[j][i]+"("+farbe+").");
							while(k>=0){
								var t = szs_brett[k][i];
								if (t==null){
									targets.push([i,k]);
									break;
								}
								if (t.charAt(0)!="h" || t.charAt(5)!=farbe){
									break;
								}
								k--;
							}
						}
					// }
				// }
				if (targets.length==0){
					continue;
				}
				
				var farbe = szs_brett[j][i].charAt(6);

				for (p in targets){
					var x = p[0];
					var y = p[1];
					animation.nach_brett[y][x]="halm_"+farbe;
					animation.abweichung[y][x]=1;
				}
				modified=true;
			}
		}


		if (modified){

			animationen.push(animation);
			szs_brett = Copy.copy(animation.nach_brett);
		}
	}

	function tuePlatzierung(hoverziel_x:Int,hoverziel_y:Int,z_name:String,nachkram:Bool){	

		// szs_inventory[zieh_quelle_j][zieh_quelle_i]=zieh_name;

		var startframe = new AnimationFrame();
		startframe.vor_brett = Copy.copy(szs_brett);

		szs_brett[hoverziel_y][hoverziel_x]=z_name;
		startframe.nach_brett = Copy.copy(szs_brett);
		startframe.abweichung = leererAbweichungsgitter();
		startframe.abweichung[hoverziel_y][hoverziel_x]=0;
		startframe.maxabweichung=0;
		var animation = startframe;
		animationen.push(animation);

		var c_idx=hoverziel_x+sp_spalten*hoverziel_y;

		var z_names:Array<Int> = ziele[aktuellesZielIdx][2];
		var z_n=z_names[c_idx];
		trace("z_n "+z_n);
		switch(z_n){
			case 1:
				loeschen(animation,hoverziel_x,hoverziel_y);
			case 2:
				behaaren(animation,hoverziel_x,hoverziel_y);			

			case 3:
				spalte_entleeren(animation,hoverziel_x,hoverziel_y);			
			case 4:
				zeile_entleeren(animation,hoverziel_x,hoverziel_y);
			
			case 5:
				spazieren(animation,hoverziel_x,hoverziel_y);
			case 6:
				fuellen(animation,hoverziel_x,hoverziel_y);
			case 7:
				spiegelkopien(animation,hoverziel_x,hoverziel_y);	
			
			case 8:
				ziehen(animation,hoverziel_x,hoverziel_y);
			case 9:
			
			case 10:
			
			case 11:
			
			case 12:
				spiralen(animation,hoverziel_x,hoverziel_y);	
			
			case 13:
				schieben(animation,hoverziel_x,hoverziel_y);
			
			case 14:
				drehen(animation,hoverziel_x,hoverziel_y);
			case 15:
				schraegspiegeln(animation,hoverziel_x,hoverziel_y);	
			case 16:
				spiegeln_hinunten(animation,hoverziel_x,hoverziel_y);		
			case 17:
				spiegeln_hinoben(animation,hoverziel_x,hoverziel_y);
			case 18:
				wiederholen(animation,hoverziel_x,hoverziel_y);
			case 19:
				bomben(animation,hoverziel_x,hoverziel_y);
			
			case 20:

			default:
				trace(z_name+" nicht gefunden.");
			
		}


		szs_brett = animationen[animationen.length-1].nach_brett;

		if (nachkram){
			var tx = hoverziel_x;
			var ty = hoverziel_y;
			var tb = animationen[animationen.length-1].nach_brett;
			if (z_name=="s18"){
				tx=-1;
				ty=-1;
			}
			versuchfallenzulassen(tx,ty);
			szs_brett = animationen[animationen.length-1].nach_brett;
			versuchaufzuwachsen(tx,ty);

			szs_brett = animationen[animationen.length-1].nach_brett;

			zustandSpeichern();
			checkSolve(true);
		}

	}

	public static var farbe_menutext = Col.WHITE;
	public static var tongue:FireTongue;
	public static var text_y_off_menu:Int=0;

	public static var dict:Map<String,String> =  new Map<String,String>();
	public static var dict_internal:Map<String,String> = new Map<String,String>();
	public static var thanks_str:String="";
	public static var goal_x_of_y_str:String="";

function regenAllText(){

		if (Globals.state.sprache=="ja"){
			text_y_off_menu=-1;
		} else if (Globals.state.sprache=="zh"){
			text_y_off_menu=-1;
		} else{
			text_y_off_menu=1;
		}
		var dumbkeys=["$GESTALT_31","$TABLEAU","$ABOUT_GESTALT_OS","$GESTALT_MANUFACTURING","$CORPORATION_R","$GESTALT_OS_VERSION","$COPYRIGHT_GMC_TRANSLATE_ACRONYM_PLEASE","$CREDITS_THANKS_TO","$CREDITS_LEVEL_DESIGN","$CREDITS_TRANSLATION","$CREDITS_THE_REST","$BUTTON_OK","$TOOLTIP_CLEAR_PAGE","$TOOLTIP_UNDO","$TOOLTIP_REDO","$TOOLTIP_FULLSCREEN","$TOOLTIP_LANGUAGE_TRANSLATE_LANGUAGE_NAME_ALSO","$TOOLTIP_ABOUT","$TOOLS","$WORKBENCH","$GOAL_X_OF_Y","$SOLVED","$SOLVE","$CONGRATS","$CONGRATS_SENTENCE","$WE_ARE_HAPPY","$TEXT_RESET","$TOOLTIP_RESET"];
		dict = new Map<String,String>();
		for (d in dumbkeys){
			dict[d]=tongue.get(d);
		}

		var dumbkeys_internal=["$FLAGGE_ICON","$FONT_BIG","$FONT_SMALL"];
		for (d in dumbkeys_internal){
			dict_internal[d]=tongue.get(d,"internal");	
		}	



		var nameListe = "Daniel Frier.Stephen Saver.David Kilford.Dani Soria.Adrian Toncean.Alvaro Salvagno.Ethan Clark.Blake Regehr.Happy Snake.Joel Gahr.Alexander Turner.Tatsunami.Matt Rix.Bigaston.Lajos Kis.Lorxus.Fachewachewa.Marcos Donnantuoni.That Scar.Llewelyn Griffiths.Capnsquishy.Alexander Martin.Guilherme Töws.Alex Fink.Christian Zachau.@Ilija.Celeste Brault.Cédric Coulon.Lukas Koudelka.George Kurelic.Konstantin Dediukhin.Jazz Mickle.Oori.Xanto.Jonah Ostroff.Felix Niklas.Carlos Pidox.Tarek Sabet.Jason Reed.Justin Smith.Scott Redig.Ugurcan Kilic.Nolan Daigle.Louis Fontaine.Tomas zelgaris Zahradnicek.MikkelP.Terry Cavanagh.Matt Mistele";
		var translatorListe = "Carlos Pidox.Francesco Mazzoli.Tatsunami.Lucas Le Slo.Stephen Lavelle";
		
		if (Globals.state.sprache=="ja"){
        	// nameListe = "D.Frier S.Saver D.Kilford D.Soria A.Toncean A.Salvagno E.Clark B.Regehr H.Snake J.Gahr A.Turner Tatsunami M.Rix Bigaston L.Kis Lorxus Fachewachewa M.Donnantuoni TheScar L.Griffiths Capnsquishy A.Martin G.Töws A.Fink C.Zachau Ilija C.Brault C.Coulon L.Koudelka G.Kurelic K.Dediukhin J.Mickle Oori Xanto J.Ostroff F.Niklas C.Pidox T.Sabet J.Reed J.Smith S.Redig U.Kilic N.Daigle L.Fontaine zelgaris MikkelP";
        	// translatorListe = "C.Pidox F.Mazzoli Tatsunami L.Le Slo S.Lavelle";
		}

		thanks_str = Replace.flags(tongue.get("$CREDITS_THANKS_TO"),["<NAMELIST>"],[nameListe])+"\n\n"
		+Replace.flags(tongue.get("$CREDITS_TRANSLATION"),["<NAMELIST>"],[translatorListe])+"\n\n"
		+tongue.get("$CREDITS_LEVEL_DESIGN")+"\n\n"
		+tongue.get("$CREDITS_THE_REST");

		goal_x_of_y_str = Replace.flags(
				tongue.get("$GOAL_X_OF_Y"),
				["<X>","<Y>"],
				[""+(aktuellesZielIdx+1),""+ziele.length]
				);



	}

	function onLanguageLoaded():Void{

		forceregentext=true;
		forcerender=true;
        //trace(dict["$HELLO_WORLD"]);  
        //outputs "Hello, World!" 
        //(which is stored in the flag $HELLO_WORD in a file indexed by context id "data")
    }

	function init(){
		Save.filename = "gestaltos_31";
		tongue = new FireTongue();
		// Text.font = "dos";
		// Sound.play("t2");
		//Music.play("music",0,true);
		Gfx.resizescreen(192, 220,true);//true->false for  non-pixel-perfect-scaling
		
		
		Gfx.createimage("fg", 192, 220);
		// Gfx.clearcolor=Col.RED;// desktop_farbe;
		// Gfx.loadtiles("dice_highlighted",16,16);
		setup();
	}	


// var i_contents = [
// 		10,11,
// 		13,8,
// 		3,4,
// 		9,20,
// 		16,17,
// 		12,5,
// 		6,2,
// 		14,15,
// 		1,7,
// 		19,18
// 	];


		var invfolge = [
			1,2,5,
			3,4,6
		];


	function neuesBlatt(){	

		animationen = new Array<AnimationFrame>();
		zieh_modus=false;

		if(zieh_modus){
				zieh_modus=false;
				szs_inventory[zieh_quelle_j][zieh_quelle_i]=zieh_name;
		}

		szs_inventory = new Array<Array<String>>();
		for (j in 0...i_zeilen){
			var zeile = new Array<String>();
			for (i in 0...i_spalten){
				var index = i+i_spalten*j;
				if (aktuellesZiel==null || aktuellesZiel.werkzeuge[index]==true)
				{
					zeile.push("kugel_"+invfolge[index]);
				} else {
					zeile.push(null);
				}
			}
			szs_inventory.push(zeile);

		} 


		szs_brett = new Array<Array<String>>();
		for (j in 0...sp_zeilen){
			var zeile = new Array<String>();
			for (i in 0...sp_spalten){
				var index = i+sp_spalten*j+1 ;
				zeile.push(null);
			}
			szs_brett.push(zeile);
		} 
		zustandSpeichern();
	}

	var undoStack:Array<Array<LevelZustand>>;
	var undoPos:Array<Int>;

	function reset_all(){
		for (lidx in 0...geloest.length){
			geloest[lidx]=null;
		}
		Save.delete();
		forceregentext=true;
		zeigabout=false;
		LoadLevel(0);
		forcerender=true;
	}

	function zustandSpeichern(){
		var curUndoPos = undoPos[aktuellesZielIdx];
		var curUndoStack = undoStack[aktuellesZielIdx];
		curUndoStack.splice(curUndoPos+1,curUndoStack.length);
		
		var curNames = ziele[aktuellesZielIdx][2];

		var lzs = new LevelZustand();
		lzs.i=Copy.copy(szs_inventory);
		lzs.sp=Copy.copy(szs_brett);
		lzs.names=Copy.copy(curNames);
		lzs.hash=Json.stringify([szs_inventory,szs_brett,lzs.names]);

		var dieser_undoStack = undoStack[aktuellesZielIdx];
		if (dieser_undoStack.length>0){
			if (dieser_undoStack[dieser_undoStack.length-1].hash==lzs.hash){
				return;//keine duplikaten
			}
		}
		dieser_undoStack.push(lzs);
		undoPos[aktuellesZielIdx]++;
	}
	
	function tueUndo(){

		if(zieh_modus){
				zieh_modus=false;
				szs_inventory[zieh_quelle_j][zieh_quelle_i]=zieh_name;
				return;
		}
		
		animationen.splice(0,animationen.length);	
		animPos=0;		
		var z_names:Array<Int> = ziele[aktuellesZielIdx][2];
		var curhash = Json.stringify([szs_inventory,szs_brett,z_names]);
		var i = undoPos[aktuellesZielIdx];
		while (i>=0){
			var zs = undoStack[aktuellesZielIdx][i];
			if (curhash!=zs.hash){
				szs_inventory=Copy.copy(zs.i);
				szs_brett=Copy.copy(zs.sp);
				checkSolve(false);
				do_playSound(0);
				undoPos[aktuellesZielIdx]=i;
				forcerender=true;
				ziele[aktuellesZielIdx][2]=Copy.copy(z_names);
				return;
			} else {
				if (i>0){
					// undoStack[aktuellesZielIdx].splice(i,1);
				}
			}
			i--;
		}
		forcerender=true;
	}

function tueRedo(){
	
		trace("A");
		if(zieh_modus){
				zieh_modus=false;
				szs_inventory[zieh_quelle_j][zieh_quelle_i]=zieh_name;
		}
		
		animationen.splice(0,animationen.length);	
		animPos=0;		
		var z_names:Array<Int> = ziele[aktuellesZielIdx][2];
		var curhash = Json.stringify([szs_inventory,szs_brett,z_names]);
		var i = undoPos[aktuellesZielIdx];


		while (i<undoStack[aktuellesZielIdx].length){
		trace("B" +i);
			var zs = undoStack[aktuellesZielIdx][i];
			if (curhash!=zs.hash){
				szs_inventory=Copy.copy(zs.i);
				szs_brett=Copy.copy(zs.sp);
				checkSolve(false);
				do_playSound(0);
				undoPos[aktuellesZielIdx]=i;
				forcerender=true;
				ziele[aktuellesZielIdx][2]=Copy.copy(z_names);

				return;
			} else {
				if (i>0){
					// undoStack[aktuellesZielIdx].splice(i,1);
				}
			}
			i++;
		}
	}

	private var alphabet =".abcdefghijklmnopqrstuvwxyz";
	function drueckBrett(){
		var z = new Array<Array<String>>();
		for (j in editor_tl_y...editor_br_y){
			var r = new Array<String>();
			for (i in editor_tl_x...editor_br_x){
				r.push(szs_brett[j][i]);
			}
			z.push(r);
		}
		var wz :Array<Bool>= Copy.copy(aktuellesZiel.werkzeuge);

		var new_z  = new Ziel(z,wz);
    	    
		var serializer = new Serializer();
		serializer.serialize(new_z);
		
		aktuellesZiel=new_z;

		var s = serializer.toString();
		
		var z_names:Array<Int> = Copy.copy(ziele[aktuellesZielIdx][2]);

		ziele[aktuellesZielIdx]=[""+version,s,z_names];

		var toprint='[
			"v1",\n';
		toprint+='			"'+s+'",\n';
		toprint+='			[';
		for (i in 0...z_names.length){
			if (i>0){
				toprint+=",";
			}
			toprint+=""+z_names[i];
		}
		toprint+='],\n		],';
		#if html5 
			Browser.alert(toprint);
		#end

		trace(s);
	}


	function versperre(i:Int,j:Int){
		aktuellesZiel.werkzeuge[i+i_spalten*j]=!aktuellesZiel.werkzeuge[i+i_spalten*j];
		if (aktuellesZiel.werkzeuge[i+i_spalten*j]==false){
			szs_inventory[j][i]=null;
		} else {
			szs_inventory[j][i]="kugel_"+(i+i_spalten*j+1);
		}
	}


	var forcerender:Bool=true;
	var forceregentext:Bool=false;
	
	var zeigabout:Bool=false;
	var zeigende:Bool=false;

	public static function shuffle(arr:Array<Int>):Array<Int> {
		var tmp:Int, j:Int, i:Int = arr.length;
		while (--i > 0) {
			j = Random.int(0, i);
			tmp = arr[i];
			arr[i] = arr[j];
			arr[j] = tmp;
		}
		
		return arr;
	}

	function betaNotice(){
		if (zeigBetaNotice){
			var oldfont = Text.font;
			Text.font="nokia";
			Text.display(3,Gfx.screenheight-10,"Beta: please do not distribute",0x00ffff);
			Text.font=oldfont;
		}
	}

	function update() {	
		if(editmodus){
			if (Input.justpressed(Key.G)){
				geloest[aktuellesZielIdx]=ziele[aktuellesZielIdx][0];
				Save.savevalue("level"+aktuellesZielIdx,ziele[aktuellesZielIdx][0]);
				forcerender=true;
				var won=true;
				for (i in 0...ziele.length){
					if (geloest[i]!=ziele[aktuellesZielIdx][0]){
						won=false;
						break;
					}
				}			
				if (won){
					zeigende=true;
				}
			}
		}
		if (zeigitemmenu){
			var inputs = [
				Key.ONE,
				Key.TWO,
				Key.THREE,
				Key.FOUR,
				Key.FIVE,
				Key.Q,
				Key.W,
				Key.E,
				Key.R,
				Key.T,
				Key.A,
				Key.S,
				Key.D,
				Key.F,
				Key.G,
				Key.Z,
				Key.X,
				Key.C,
				Key.V,
				Key.B ];
			for (i in 0...inputs.length){
				if (Input.justpressed(inputs[i])){
					var item_index=i+1;
					var position_index=itemmenu_ziel_x+4*itemmenu_ziel_y;
					var z_names:Array<Int> = ziele[aktuellesZielIdx][2];
					if (z_names[position_index]!=item_index){
						z_names[position_index]=item_index;
						forcerender=true;
						zeigitemmenu=false;
						zustandSpeichern();
						return;
					}
				}
			}
		}

		zeigabout=false;
		// zeigende=false;
		
		if(forceregentext){
			regenAllText();
			forcerender=true;
		}

		var keyrepeat=Math.floor(Core.fps/10);

		if (Input.justpressed(Key.A)&&enableEditor){
			editmodus=!editmodus;
			forcerender=true;
		}
		if (editmodus && Input.justpressed(Key.LBRACKET)){
			zeigende=true;
			forcerender=true;
		}

		if (editmodus&& Input.justpressed(Key.RBRACKET)){
			reset_all();
		}

		if (
			Mouse.deltax==0 &&
			Mouse.deltay==0 &&
			!Mouse.leftclick() && 
			!Mouse.leftreleased() &&
			!Mouse.leftheld() &&
			!Input.justpressed(Key.P) &&
			!Input.justpressed(Key.N) &&
			!Input.justpressed(Key.R) &&
			!Input.delaypressed(Key.Y,keyrepeat) &&
			!Input.justpressed(Key.M) &&
			!Input.delaypressed(Key.Z,keyrepeat) &&
			!Input.delaypressed(Key.U,keyrepeat) &&
			!Input.justpressed(Key.E) &&
			!Input.justpressed(Key.Q) &&
			!Input.justpressed(Key.SHIFT) &&
			!Input.justpressed(Key.W) &&
			!Input.justpressed(Key.O) &&
			!Input.justpressed(Key.I) &&
			!Input.delaypressed(Key.LEFT,keyrepeat) &&
			!Input.delaypressed(Key.RIGHT,keyrepeat) &&
			zeigitemmenu==false &&
			animationen.length==0 &&
			forcerender==false
			)
		{
				return;
		}

		if (Input.justreleased(Key.SHIFT)){
			if (zeigitemmenu){
				zeigitemmenu=false;
			}
		}
		
		Text.font=dict_internal["$FONT_BIG"];
		if (Globals.state.sprache=="zh"){
			Text.size=12;
		}

		if (zeigabout){
			Text.wordwrap=277+50;

			Gfx.drawimage(0,0,"aboutscreen");
			
			Text.display(32,18+text_y_off_menu,dict["$ABOUT_GESTALT_OS"],farbe_menutext);

			Text.display(123,38,dict["$GESTALT_MANUFACTURING"],0x20116d);

			Text.display(123,51,dict["$CORPORATION_R"],0x20116d);
			
			Text.display(123,67,dict["$GESTALT_OS_VERSION"],0x20116d);

			Text.display(123,86,dict["$COPYRIGHT_GMC_TRANSLATE_ACRONYM_PLEASE"],0x20116d);


			Text.font=dict_internal["$FONT_SMALL"];
			
			


			Text.display(31,108,thanks_str,0x20116d);
			
			Text.wordwrap=0;	
			Text.font=dict_internal["$FONT_BIG"];
			if (Globals.state.sprache=="zh"){
				Text.size=12;
			}
			
			
			if (
				IMGUI.presstextbutton(
					"ueber_ok",
					"btn_solve_bg_up",
					"btn_solve_bg_down",
					dict["$BUTTON_OK"],
					Col.BLACK,
					279+25,198
					))
			{
				zeigabout=false;
				forcerender=true;
			}

			if (
				IMGUI.presstextbutton(
					"ueber_ok",
					"btn_solve_bg_up",
					"btn_solve_bg_down",
					dict["$BUTTON_OK"],
					Col.BLACK,
					279+25,198
					))
			{
				zeigabout=false;
				forcerender=true;
			}

			// if (
			// 	IMGUI.presstextbutton(
			// 		"ueber_ok",
			// 		"btn_solve_bg_up_2",
			// 		"btn_solve_bg_down_2",
			// 		dict["$TEXT_RESET"],
			// 		0x20116d,
			// 		29,198,
			// 		dict["$TOOLTIP_RESET"]
			// 		))
			// {
			// 	reset_all();
			// }

			IMGUI.zeigtooltip();
			betaNotice();
	
			return;
		}



		if (zeigende){
			Text.wordwrap=116;

			Gfx.drawimage(0,0,"31/ende");
			
			
			var tw = Text.width(dict["$CONGRATS"]);
			Text.display(Gfx.screenwidth/2-tw/2,48,dict["$CONGRATS"],0xffffff);

			var s =dict["$CONGRATS_SENTENCE"]+"\n\n"+dict["$WE_ARE_HAPPY"];
			Text.display(37,62,s
				,0x000000);

			
			// Text.display(103,105,dict["$WE_ARE_HAPPY"],0x20116d);
				
			Text.wordwrap=0;			
			Text.font=dict_internal["$FONT_BIG"];
			if (Globals.state.sprache=="zh"){
				Text.size=12;
			}
			
			
			if (
				IMGUI.presstextbutton(
					"ueber_ok",
					"31/button_med",
					"31/button_med_down",
					dict["$BUTTON_OK"],
					Col.BLACK,
					80,125
					))
			{
				zeigende=false;
				forcerender=true;
			}
	
			betaNotice();
			return;
		}

		forcerender=false;

		if (editmodus&&Input.justpressed(Key.P)){
			drueckBrett();
		}

		if (editmodus&&Input.justpressed(Key.I)){
			var inhalt:Array<Int>=ziele[aktuellesZielIdx][2];
			for (i in 0...inhalt.length){
				inhalt[i]=Random.int(1,20);
			}
			forcerender=true;
		}
		if (editmodus&&Input.justpressed(Key.O)){
			var ar:Array<Int> = ziele[aktuellesZielIdx][2];
			trace(ar);
			shuffle(ar);
			forcerender=true;
		}

		if (Mouse.leftclick()){
			animationen.splice(0,animationen.length);	
			animPos=0;		
		}
		if (animationen.length>0){
			var animation=animationen[0];
			animPos++;
			if (animPos>animFrameDauer*(animation.maxabweichung+1)){
				animationen.shift();		
				animPos=0;		
			}
		}

		
		Gfx.drawimage(0,0,"31/bg");

		var ziele_zeilen=3;
		var zeile_lange = Math.ceil(ziele.length/ziele_zeilen);
		
		var step = Math.floor(117/zeile_lange);
		var stepy = Math.floor(21/ziele_zeilen);
		var winbox_height = stepy-1;

		for (i in 0...ziele.length){
			var gx = i%zeile_lange;
			var gy = Math.floor(i/zeile_lange);
			var gw=117;

			var px = 75 + step*gx;
			var py = 22+stepy*gy;
			
			if (editmodus && Mouse.leftclick()){
				if (Mouse.x>=(px-4)&&Mouse.y>=(py-2) && (Mouse.x<(px-2+9+2)) && (Mouse.y<(py-2+9))){
					LoadLevel(i);
				}
			}

			if (geloest[i]==ziele[i][0]){
				Gfx.drawimage(px,py,"31/geloest");	
				// Gfx.fillbox(px,py,step-1,winbox_height,0x008282);	
			}  else {
				Gfx.drawbox(px,py,step-1,winbox_height,0x000000);
			}

			if (i==aktuellesZielIdx){
				// Gfx.drawimage(px,py,"31/level_highlight");	
				Gfx.drawbox(px,py,step-1,stepy-1,0xffff00);		
				//Gfx.drawline(px,py+1,px+step-1,py,0xffff00);		
				//Gfx.drawline(px,py+1+19,px+step-1,py+19,0xffff00);
				// Gfx.drawline(px,py+20,px+step-1,py+20,0xffff00);
			}  

		}
	
		for (j in 0...i_zeilen){
			for (i in 0...i_spalten){

				var ix = 24+17*i;
				var iy = 158+17*j;
				

				var index = i+i_spalten*j;
				
				if (editmodus){
					if (IMGUI.mouseover(
							"31/kugel_1",
							ix,
							iy) &&
						Input.justpressed(Key.E) )
					{
						versperre(i,j);
					}
				}

				var inhalt = szs_inventory[j][i];
				

				if (inhalt!=null){
					if (IMGUI.clickableimage(
							"31/"+inhalt,
							ix,
							iy)){
						zieh_name = szs_inventory[j][i];
						szs_inventory[j][i] = null;
						zieh_modus=true;

						do_playSound(3);
						zieh_offset_x=(ix)-Mouse.x;
						zieh_offset_y=(iy)-Mouse.y;
						zieh_quelle_i=i;
						zieh_quelle_j=j;
					}
				} else {
					// Gfx.drawimage(ix,iy,"schatten/s"+invfolge[index]);
					if (aktuellesZiel.werkzeuge[index]==false){
						Gfx.drawimage(ix,iy,"versperrt");
					}
				}
				
			}
		}
		
		// Gfx.drawimage(7,7,"taste_t_bg_up");
		if (IMGUI.pressbutton(
					"rückgängig",
					"31/button_sm",
					"31/button_sm_down",
					"31/btn_neu",
					9,22,
				dict["$TOOLTIP_CLEAR_PAGE"]
				)  
				|| Input.justpressed(Key.N)
				|| Input.justpressed(Key.R)
				)
		{
			neuesBlatt();
			forcerender=true;
		}

		if (undoPos[aktuellesZielIdx]>0){
			if (IMGUI.pressbutton(
					"undo",
					"31/button_sm",
					"31/button_sm_down",
					"31/btn_ruckgaengig",
					30,22,
					dict["$TOOLTIP_UNDO"]
					)
					|| Input.delaypressed(Key.Z,keyrepeat)
					|| Input.delaypressed(Key.U,keyrepeat)
					)
			{
					tueUndo();
			}
		} else {
			Gfx.drawimage(30,22,"31/kein_undos_mehr");
		}


		if ( (undoPos[aktuellesZielIdx]+1)<undoStack[aktuellesZielIdx].length){

			if (IMGUI.pressbutton(
					"rueckgängig",
					"31/button_sm",
					"31/button_sm_down",
					"31/btn_wiederholen",
					51,22,
					dict["$TOOLTIP_REDO"]
					)
					|| Input.delaypressed(Key.Y,keyrepeat)
					)
			{

				trace("X");
					tueRedo();
			}
		} else {
			Gfx.drawimage(51,22,"31/kein_redoes_mehr");
		}

		var changelang = IMGUI.pressbutton(
			"sprache",
			"taste_t_bg_up",
			"taste_t_bg_down",
			dict_internal["$FLAGGE_ICON"],
			346,210,
			dict["$TOOLTIP_LANGUAGE_TRANSLATE_LANGUAGE_NAME_ALSO"]
			);

		if (changelang){
			
			var unterstuetzteSprachen = tongue.get_locales();
			var spridx = unterstuetzteSprachen.indexOf(Globals.state.sprache);

			if (spridx==-1){
				Globals.state.sprache="en";
			} else {
				spridx=(spridx+1)%unterstuetzteSprachen.length;
				Globals.state.sprache=unterstuetzteSprachen[spridx];	    
				Save.savevalue("global_sprache",Globals.state.sprache);

				tongue.init(Globals.state.sprache,onLanguageLoaded,true,true,null,"data/locales/");
				forcerender=true;

			}
			
		}

		if (IMGUI.pressbutton(
			"hilfe",
			"taste_t_bg_up",
			"taste_t_bg_down",
			"icon_hilfe",
			366,210,
			dict["$ABOUT_GESTALT_OS"]
			)){
				zeigabout=true;
				forcerender=true;
			}

		var tw = Text.width(dict["$GESTALT_31"]);
		Text.display(Gfx.screenwidth/2-tw/2,8+text_y_off_menu,dict["$GESTALT_31"],farbe_menutext);

		var w= Text.width(dict["$TABLEAU"]);
		Text.display(49-w/2,57+text_y_off_menu,dict["$TABLEAU"],farbe_menutext);


		var lebende = Lambda.count(Globals.state.solved, (w)->w==0);
		// var titeltext = dict["$WORKBENCH"];
		// Text.display(91,8+text_y_off_menu,titeltext,farbe_menutext);

		var gw = Text.width(goal_x_of_y_str);
		Text.display(138-gw/2,52+text_y_off_menu,
			goal_x_of_y_str,
			farbe_menutext);

		if (aktuellesZielIdx>0){
			if(IMGUI.pressbutton("menü_l","31/button_med","31/button_med_down","31/btn_pfeil_links",103,158)||Input.delaypressed(Key.LEFT,keyrepeat)){
				LoadLevel(aktuellesZielIdx-1);
			}
		} else {
			Gfx.drawimage(103,158,"31/button_med");
			Gfx.drawimage(103,158,"31/btn_pfeil_links");
			Gfx.drawimage(103,158,"31/button_med_deaktiviert");
		}


		if (geloest[aktuellesZielIdx]==ziele[aktuellesZielIdx][0]){
			IMGUI.presstextbutton_disabled(
						"menü_l",
						"31/button_big_transparent",
						"31/button_big_transparent",
						dict["$SOLVED"],
						"31/button_big_transparent",
						Col.BLACK,
						103,183
						);
		} else if (cansolve){
			if(IMGUI.presstextbutton(
						"loesentaste",
						"31/button_big",
						"31/button_big_down",
						dict["$SOLVE"],
						Col.BLACK,103,183)){
				geloest[aktuellesZielIdx]=ziele[aktuellesZielIdx][0];
				Save.savevalue("level"+aktuellesZielIdx,ziele[aktuellesZielIdx][0]);
				forcerender=true;
				var won=true;
				for (i in 0...ziele.length){
					if (geloest[i]!=ziele[aktuellesZielIdx][0]){
						won=false;
						break;
					}
				}			
				if (won){
					zeigende=true;
				}
			}
		} else {
					IMGUI.presstextbutton_disabled(
						"menü_l",
						"31/button_big",
						"31/btn_solve_bg_down",
						dict["$SOLVE"],
						"31/button_big_deaktiviert",
						Col.BLACK,
						103,183
						);
		}
		
		if (aktuellesZielIdx+1<ziele.length){
			if(IMGUI.pressbutton("menü_r","31/button_med","31/button_med_down","31/btn_pfeil_rechts",140,158)||Input.delaypressed(Key.RIGHT,keyrepeat)){
				LoadLevel(aktuellesZielIdx+1);
			}
		} else {
			Gfx.drawimage(140,158,"31/button_med");
			Gfx.drawimage(140,158,"31/btn_pfeil_rechts");
			Gfx.drawimage(140,158,"31/button_med_deaktiviert");
		}

		// Gfx.drawimage(Mouse.x-3,Mouse.y-3,"cursor_finger");


		var zielb_x=99;
		var zielb_y=65;

		var zielb_w=77;
		var zielb_h=88;
		
		//ziel zeigen
		// if (aktuellesZielIdx>=48){
		// 	var image_s = aktuellesZielIdx==48 ? "leererlevel" : "letzterlevel";

		// 	var ziel_darstellung_w=Gfx.imagewidth(image_s);
		// 	var ziel_darstellung_h=Gfx.imageheight(image_s);

		// 	var ziel_x=zielb_x+zielb_w/2-ziel_darstellung_w/2;
		// 	var ziel_y=zielb_y+zielb_h/2-ziel_darstellung_h/2;
		// 	Gfx.drawimage(ziel_x,ziel_y,image_s);
		// } else 
		{
			var alevel = aktuellesZiel;
			var z_raster = alevel.ziel;
			var z_w = z_raster[0].length;
			var z_h = z_raster.length;


			var ziel_darstellung_w=17*z_w+1;
			var ziel_darstellung_h=17*z_h+1;

			var ziel_x=zielb_x+zielb_w/2-ziel_darstellung_w/2;
			var ziel_y=zielb_y+zielb_h/2-ziel_darstellung_h/2;

			for (i in 0...z_w){
				for (j in 0...z_h){
					
					Gfx.drawimage(ziel_x+17*i,ziel_y+17*j,"zielgitterkiste");
					var inhalt = z_raster[j][i];
					if (inhalt!=null){
						Gfx.drawimage(ziel_x+17*i+1,ziel_y+17*j+1,"31/"+inhalt);
					}
				}
			}

		}

		var brett_vor = szs_brett;
		var brett_nach = szs_brett;
		var abweichungsbrett = null;
		var frame = Math.floor(animPos/animFrameDauer);
		if (animationen.length>0){
			var animation=animationen[0];
			brett_vor = animation.vor_brett;
			brett_nach = animation.nach_brett;
			abweichungsbrett = animation.abweichung;
		}

		var z_names:Array<Int> = ziele[aktuellesZielIdx][2];
		for (j in 0...sp_zeilen){
			for (i in 0...sp_spalten){
				var inhalt = brett_vor[j][i];
				var abw=-1;
				if (animationen.length>0){
					abw = abweichungsbrett[j][i];
					if (abw<=frame){
						inhalt=brett_nach[j][i];
					}
				}				
				if (inhalt!=null){
					Gfx.drawimage(16+17*i,70+17*j,"31/bg_"+z_names[i+sp_spalten*j]);
					Gfx.drawimage(16+17*i,70+17*j,"31/"+inhalt);
				} else {
					Gfx.drawimage(16+17*i,70+17*j,"31/ol_"+z_names[i+sp_spalten*j]);
				}
				if (abw==frame){
					Gfx.drawimage(16+17*i,70+17*j,"cursor_aktiv");
				}
			}
		}
		
		if (editmodus){
			var input:Int=0;
			if (Input.justpressed(Key.Q)){
				input=1;
			}
			if (Input.justpressed(Key.W)){
				input=2;
			}
			if (Input.justpressed(Key.SHIFT)){
				input=3;
			}
			if (input>0){
				var hoverziel_x=-1;
				var hoverziel_y=-1;

				var geltendes_hoverziel=false;

				var mx=Mouse.x;
				var my=Mouse.y;

				var ox = mx-16;
				var oy = my-70;
				var ox_d = ox % 17;
				var oy_d = oy % 17;

				var nope:Bool=false;
				if ((ox_d==16||oy_d==16) && (letztes_hoverziel_x>=0)){
					hoverziel_x=letztes_hoverziel_x;
					hoverziel_y=letztes_hoverziel_y;
					if (ox_d<16){
						hoverziel_x=Math.floor(ox/17);
					} else {
						hoverziel_y=Math.floor(oy/17);
					}
				} else if (ox_d<18 && oy_d<16){
					hoverziel_x=Math.floor(ox/17);
					hoverziel_y=Math.floor(oy/17);					
				}

				if (hoverziel_x>=0 && hoverziel_x<sp_spalten && hoverziel_y>=0 && hoverziel_y<sp_zeilen){
					geltendes_hoverziel=true;
					letztes_hoverziel_x=hoverziel_x;
					letztes_hoverziel_y=hoverziel_y;
				} else {
					letztes_hoverziel_x=-1;
					letztes_hoverziel_y=-1;
				}
				
				if (geltendes_hoverziel){
					if (input==1){
						editor_tl_x=hoverziel_x;
						editor_tl_y=hoverziel_y;
					} else if (input==2){
						editor_br_x=hoverziel_x+1;
						editor_br_y=hoverziel_y+1;
					} else if (input==3){
						zeigitemmenu=true;
						itemmenu_ziel_x=hoverziel_x;
						itemmenu_ziel_y=hoverziel_y;
						forcerender=true;
					}
					if (editor_tl_x>editor_br_x){
						var t = editor_tl_x;
						editor_tl_x=editor_br_x;
						editor_br_x=t;
					}
					if (editor_br_y<editor_tl_y){
						var t = editor_br_y;
						editor_br_y=editor_tl_y;
						editor_tl_y=t;
					}
				}
			}
			
			if (editor_tl_x>=0){
				var b_w=editor_br_x-editor_tl_x;
				var b_h=editor_br_y-editor_tl_y;
				b_w = b_w*17+1;
				b_h = b_h*17+1;
				Gfx.drawbox(15+editor_tl_x*17,69+editor_tl_y*17,b_w,b_h,Col.RED);
			}
		}
		
		if (zieh_modus==true){

			var hoverziel_x=-1;
			var hoverziel_y=-1;
			var geltendes_hoverziel=false;

			var mx=Mouse.x;
			var my=Mouse.y;

			var ox = mx-16;
			var oy = my-70;
			var ox_d = ox % 17;
			var oy_d = oy % 17;

			var nope:Bool=false;

			if ((ox_d==16||oy_d==16) && (letztes_hoverziel_x>=0)){
				hoverziel_x=letztes_hoverziel_x;
				hoverziel_y=letztes_hoverziel_y;
				if (ox_d<16){
					hoverziel_x=Math.floor(ox/17);
				} else {
					hoverziel_y=Math.floor(oy/17);
				}
			} else if (ox_d<16 && oy_d<16){
				hoverziel_x=Math.floor(ox/17);
				hoverziel_y=Math.floor(oy/17);					
			}

			if (hoverziel_x>=0 && hoverziel_x<sp_spalten && hoverziel_y>=0 && hoverziel_y<sp_zeilen){
				geltendes_hoverziel=true;
				letztes_hoverziel_x=hoverziel_x;
				letztes_hoverziel_y=hoverziel_y;
			} else {
				letztes_hoverziel_x=-1;
				letztes_hoverziel_y=-1;
			}

			
			if (geltendes_hoverziel){
				if (szs_brett[hoverziel_y][hoverziel_x]==null){
					Gfx.drawimage(16+17*hoverziel_x,70+17*hoverziel_y,"31/highlightcursor");
				} else {
					geltendes_hoverziel=false;
					nope=true;
				}
			}
			
			var im_x=Mouse.x+zieh_offset_x;
			var im_y=Mouse.y+zieh_offset_y;
			Gfx.drawimage(im_x,im_y,"31/"+zieh_name);
			// if (nope){
			// 	Gfx.drawimage(im_x,im_y,"keine_platzierung_erlaubt");
			// }
			if (Mouse.leftreleased()){
				zieh_modus=false;


				if (geltendes_hoverziel==false){
					szs_inventory[zieh_quelle_j][zieh_quelle_i]=zieh_name;
				} else {
					tuePlatzierung(hoverziel_x,hoverziel_y,zieh_name,true);
				}
				forcerender=true;
				do_playSound(2);
			}
		}

		
	
		if (zeigitemmenu){
			Gfx.drawimage(98,79,"editorkiste");		
			var chars=["1","2","3","4","5",
			"Q","W","E","R","T",
			"A","S","D","F","G",
			"Z","X","C","V","B"
			];

			for (i in 1...21){
				var x = 99+17*(i-1)%5;
				var y = 80+17*Math.floor((i-1)/5);
				Gfx.drawimage(x,y,"31/bg_"+i);
				Text.display(x+1,y,chars[i-1],Col.WHITE);

			}	
			Gfx.drawimage(16+17*itemmenu_ziel_x,70+17*itemmenu_ziel_y,"31/highlightcursor");
		}

		if (zeigabout||zeigende){
			IMGUI.tooltipstr=null;
		}
		IMGUI.zeigtooltip();
		betaNotice();

		// var oldfont=Text.font;
		// Text.font="baloo";
		// Text.size=12;
		// var astr="بعد مع وكسبت الحكومة الدولارات. إذ عدد يتمكن العاصمة, اليها والحزب ومحاولة تعد ان. مع الأخذ بتحدّي دار, تلك أطراف الأولية التغييرات تم. حادثة لبولندا، عدم ثم. أم قائمة لفرنسا وبداية ومن.";
		// astr="مع مع مع مع asd" ;
		// Text.display(100,2,astr,Col.WHITE);
		// Text.font=oldfont;
		// Text.size=1;
	}

}
