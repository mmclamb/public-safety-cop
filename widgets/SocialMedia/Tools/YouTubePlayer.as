/*
Copyright 2009 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/*
This has been modified by Ping Jiang at ESRI based on the code from this site
http://code.google.com/p/gdata-samples/source/browse/trunk/ytplayer/actionscript3/com/google/youtube/examples/
*/

package widgets.SocialMedia.Tools {

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Security;

	import mx.containers.Canvas;
	import mx.controls.Button;
	//import mx.controls.ComboBox;
	import mx.controls.SWFLoader;
	import mx.core.ScrollPolicy;

	public class YouTubePlayer extends Canvas {
		private var isVideoCued:Boolean = false;
		private var isPlayerReady:Boolean = false;
		private var isWidescreen:Boolean = false;
		private var isQualityPopulated:Boolean = false;

		private var _videoID:String = "";
		private var _quality:String = "medium";
		private var _aspectRatio:String = "";
		private var _playerState:Number = -1;

		private var playPause:Button;
		private var videoPlayer:Object;
		private var playerLoader:SWFLoader;

		// CONSTANTS.
		private static const PLAYER_URL:String = "http://www.youtube.com/apiplayer?version=3";
		private static const STATE_ENDED:Number = 0;
		private static const STATE_PLAYING:Number = 1;
		private static const STATE_PAUSED:Number = 2;
		private static const STATE_CUED:Number = 5;

		private static const WIDESCREEN_ASPECT_RATIO:String = "widescreen";
		private static const QUALITY_TO_PLAYER_WIDTH:Object = {
			small: 320,
			medium: 640,
			large: 854,
			hd720: 1280
		};

		// Define public getter method.
		public function get videoID():String {
			return this._videoID;
		}

		// Define public setter method.
		public function set videoID(value:String):void {
			this._videoID = value;
			this.isVideoCued = false;

			if (this.isPlayerReady) {
				videoPlayer.stopVideo();
				videoPlayer.cueVideoById(this._videoID);
				this.isVideoCued = true;
			}
		}

		// Define public getter method.
		public function get aspectRatio():String {
			return this._aspectRatio;
		}

		// Define public setter method.
		public function set aspectRatio(value:String):void {
			this._aspectRatio = value;
			isWidescreen = this._aspectRatio == WIDESCREEN_ASPECT_RATIO;
		}

		// Define public getter method.
		public function get quality():String {
			return this._quality;
		}

		// Define public setter method.
		public function set quality(value:String):void {
			this._quality = value;
		}

		public function YouTubePlayer():void {
			// Specifically allow the chromless player .swf access to our .swf.
			Security.allowDomain("www.youtube.com");
			Security.allowDomain("youtube.com");
			Security.allowDomain("s.ytimg.com");
			Security.allowDomain("i.ytimg.com");

			setupPlayerLoader();
		}

		public function stopVideo():void {
			if (_playerState == STATE_PLAYING) {
				videoPlayer.stopVideo();
			}
		}
		public function stopVideoImmidieate():void {

				videoPlayer.stopVideo();

		}

		private function setupPlayerLoader():void {
			playerLoader = new SWFLoader();
			playerLoader.addEventListener(Event.INIT, playerLoaderInitHandler);
			playerLoader.load(PLAYER_URL);
		}

		private function playerLoaderInitHandler(event:Event):void {
			addChild(playerLoader);
			playerLoader.content.addEventListener("onReady", onPlayerReady);
			playerLoader.content.addEventListener("onError", onPlayerError);
			playerLoader.content.addEventListener("onStateChange", onPlayerStateChange);
			playerLoader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);

			// Add control buttons after playerLoader is added
			// to put the control buttons above the video player
			addControlButtons();
		}

		private function addControlButtons():void {
			// Create a pause Button for pausing the cued video.
//			pauseButton = new Button();
//			pauseButton.enabled = false;
//			pauseButton.label = "||";
//			pauseButton.toolTip = "Pause";
//			pauseButton.width = 36;
//			pauseButton.x = 5;
//			pauseButton.y = 5;
//			pauseButton.addEventListener(MouseEvent.CLICK, pauseButtonClickHandler);
//			addChild(pauseButton);

			// Create a Play-Pause Button for pausing or resuming the cued video.
			playPause = new Button();
			playPause.enabled = false;
			playPause.label = ">";
			playPause.toolTip = "Play";
			playPause.width = 36;
			playPause.x = 5;
			playPause.y = 5;
			playPause.addEventListener(MouseEvent.CLICK, PlayPause_ClickHandler);
			addChild(playPause);
		}

		private function PlayPause_ClickHandler(event:MouseEvent):void {
			if ((event.currentTarget as Button).toolTip == "Play") {
				videoPlayer.playVideo();
			}
			else {
				videoPlayer.pauseVideo();
			}
		}

		private function onPlayerReady(event:Event):void {
			this.isPlayerReady = true;
			videoPlayer = playerLoader.content;
			videoPlayer.visible = false;

			if (this._videoID != "" && !this.isVideoCued) {
				videoPlayer.cueVideoById(this._videoID);
				this.isVideoCued = true;
			}
		}

		private function onPlayerError(event:Event):void {
			trace("Player error:", Object(event).data);
		}

		private function onPlayerStateChange(event:Event):void {
			//trace("State is", Object(event).data);
			switch (Object(event).data) {
				case STATE_ENDED:
					//playButton.enabled = true;
					//pauseButton.enabled = false;
					playPause.enabled = true;
					playPause.label = ">";
					playPause.toolTip = "Play";
					_playerState = STATE_ENDED;
					break;

				case STATE_PLAYING:
					//playButton.enabled = false;
					//pauseButton.enabled = true;
					playPause.enabled = true;
					playPause.label = "||";
					playPause.toolTip = "Pause";
					_playerState = STATE_PLAYING;
//					if(!isQualityPopulated) {
//						populateQualityComboBox();
//					}
					break;

				case STATE_PAUSED:
					//playButton.enabled = true;
					//pauseButton.enabled = false;
					playPause.enabled = true;
					playPause.label = ">";
					playPause.toolTip = "Play";
					_playerState = STATE_PAUSED;
					break;

				case STATE_CUED:
					//playButton.enabled = true;
					//pauseButton.enabled = false;
					playPause.enabled = true;
					playPause.label = ">";
					playPause.toolTip = "Play";
					_playerState = STATE_CUED;
					resizePlayer(this._quality);
					break;
			}
		}

		private function onVideoPlaybackQualityChange(event:Event):void {
			//trace("Current video quality:", Object(event).data);
			resizePlayer(Object(event).data);
		}

		private function resizePlayer(qualityLevel:String):void {
			var newWidth:Number = QUALITY_TO_PLAYER_WIDTH[qualityLevel] || 640;
			var newHeight:Number;

			if (isWidescreen) {
				// Widescreen videos (usually) fit into a 16:9 player.
				newHeight = newWidth * 9 / 16;
			} else {
				// Non-widescreen videos fit into a 4:3 player.
				newHeight = newWidth * 3 / 4;
			}

			//trace("isWidescreen is", isWidescreen, ". Size:", newWidth, newHeight);
			videoPlayer.x = 0;
			videoPlayer.y = 0;
			videoPlayer.setSize(newWidth, newHeight);
			videoPlayer.visible = true;

			this.width = newWidth;
			this.height = newHeight;
			this.verticalScrollPolicy = mx.core.ScrollPolicy.OFF;
			this.horizontalScrollPolicy = mx.core.ScrollPolicy.OFF;
		}

		// If a Quality ComboBox is added to the player,
		// populate the available qualities here
		private function populateQualityComboBox():void {
			isQualityPopulated = true;

			var qualities:Array = videoPlayer.getAvailableQualityLevels();
			//qualityComboBox.dataProvider = qualities;

			var currentQuality:String = videoPlayer.getPlaybackQuality();
			//qualityComboBox.selectedItem = currentQuality;
		}

//		private function qualityComboBoxChangeHandler(event:Event):void {
//			var qualityLevel:String = ComboBox(event.target).selectedLabel;
//			videoPlayer.setPlaybackQuality(qualityLevel);
//		}
	}
}

