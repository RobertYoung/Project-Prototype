﻿package com.programminggame{	import flash.display.MovieClip;	import flash.geom.Point;	import flash.events.TouchEvent;	import com.greensock.TimelineLite;	import com.greensock.TweenLite;	import flash.display.Stage;	import flash.net.dns.ARecord;	public class ProgrammingGame	{		// Private variables		public var _mc:MovieClip;		private var _character:Character;		private var _characterPosition:Point;		private var _callstack:Array = new Array();		private var _stackIndicator:StackIndicator;		private var _stackIndicatorTimeline:TimelineLite;				// Public variables		public var movementArray:Array = new Array();		public function ProgrammingGame(mc:MovieClip)		{			_mc = mc;			// Create elements of game			CreateMovements();			CreateCharacter();			AddCallstackMovieclipsToArray();			// Event listeners			_mc.play_mc.addEventListener(TouchEvent.TOUCH_TAP, PlayStack);			_mc.reset_mc.addEventListener(TouchEvent.TOUCH_TAP, ResetGame);		}		private function CreateMovements()		{			trace("CreateMovements");			// Up			var up:Movement = new Movement();			up.x = _mc.upPlaceholder_mc.x;			up.y = _mc.upPlaceholder_mc.y;			up.movement_txt.text = "Up";			_mc.addChild(up);			// Down			var down:Movement = new Movement();			down.x = _mc.downPlaceholder_mc.x;			down.y = _mc.downPlaceholder_mc.y;			down.movement_txt.text = "Down";			_mc.addChild(down);			// Left			var left:Movement = new Movement();			left.x = _mc.leftPlaceholder_mc.x;			left.y = _mc.leftPlaceholder_mc.y;			left.movement_txt.text = "Left";			_mc.addChild(left);			// Right			var right:Movement = new Movement();			right.x = _mc.rightPlaceholder_mc.x;			right.y = _mc.rightPlaceholder_mc.y;			right.movement_txt.text = "Right";			_mc.addChild(right);		}		private function CreateCharacter()		{			_character = new Character();			_mc.addChild(_character);			var point = new Point(_mc.grid_mc.grid0_0_mc.x,_mc.grid_mc.grid0_0_mc.y);			var stagePoint = ConvertGridPointToStagePoint(point,"grid0_0_mc");			_character.x = stagePoint.x;			_character.y = stagePoint.y;			trace("X: ", stagePoint.x);			trace("Y: ", stagePoint.y);			_characterPosition = new Point(0,0);		}		private function AddCallstackMovieclipsToArray()		{			for (var i = 1; i <= 20; i++) {				_callstack.push(_mc.callstack_mc["controls_mc"]["callstack" + i + "_mc"]);			}		}		private function CreateStackIndicator()		{			_stackIndicator = new StackIndicator();			_mc.addChild(_stackIndicator);			var point = _mc.callstack_mc["controls_mc"].localToGlobal(new Point(_callstack[0].x,_callstack[0].y));			_stackIndicator.x = point.x;			_stackIndicator.y = point.y;		}		private function ConvertGridPointToStagePoint(point:Point, gridPos:String):Point		{			point = _mc.grid_mc[gridPos].parent.localToGlobal(point);			point = _mc.parent.globalToLocal(point);			return point;		}		function PlayStack(event:TouchEvent)		{			CreateStackIndicator();			var characterTimeline = new TimelineLite();			var stackIndicatorTimeline = new TimelineLite();			var stackTimeline = new TimelineLite			for (var i = 0; i < _callstack.length; i++) {				var movement = _callstack[i].movement;				switch (movement) {					case "Up" :						_characterPosition.y = _characterPosition.y + 1;						break;					case "Down" :						_characterPosition.y = _characterPosition.y - 1;						break;					case "Left" :						_characterPosition.x = _characterPosition.x - 1;						break;					case "Right" :						_characterPosition.x = _characterPosition.x + 1;						break;				}				var instanceString = "grid" + _characterPosition.x + "_" + _characterPosition.y + "_mc";				var gridPosition:MovieClip = _mc.grid_mc[instanceString] as MovieClip;				var poss:Point = new Point(gridPosition.x,gridPosition.y);				poss = ConvertGridPointToStagePoint(poss,instanceString);								// Update character				characterTimeline.append(new TweenLite(_character, 1.5, {x: poss.x, y: poss.y}) );								// Update stack indicator				var callstack:MovieClip = _mc.callstack_mc["controls_mc"]["callstack"+ (i + 1) +"_mc"];				var point = _mc.callstack_mc["controls_mc"].localToGlobal(new Point(callstack.x, callstack.y));								// The amount between the callstack movieclip and the controls movieclip				var controlDistance = _mc.callstack_mc.localToGlobal(new Point(0, _mc.callstack_mc["controls_mc"].y)).y - _mc.callstack_mc.y;								stackIndicatorTimeline.append(new TweenLite(_mc.callstack_mc["controls_mc"], 															1.5, 															{ x: _mc.callstack_mc["controls_mc"].x, y: _stackIndicator.y - point.y + controlDistance} ));			}		}				private function ResetGame(event:TouchEvent)		{			trace("Reset");						// Remove elements			_mc.removeChild(_character);						if (_stackIndicator)				_mc.removeChild(_stackIndicator);						CreateCharacter();			for (var index in movementArray) {				_mc.callstack_mc["controls_mc"].removeChild(movementArray[index]);			}						// Reset array			movementArray = new Array();		}	}}