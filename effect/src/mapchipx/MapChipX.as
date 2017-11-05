/*
 * MapChipX
 * Copyright (c) 2009 KAZUMiX
 * 
 * Licensed under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 * 
*/

package mapchipx {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MapChipX extends Sprite {
		
		private var map:Array;
		private var chipInfos:ChipInfoArray;
		private var frameWidth:uint;
		private var frameHeight:uint;
		private var isTransparent:Boolean;
		private var isStaticChips:Boolean;
		
		private var mapRaws:uint;
		private var mapCols:uint;
		
		private var mapWidth:uint;
		private var mapHeight:uint;
		
		private var chipWidth:uint;
		private var chipHeight:uint;
		
		private var rollMap:Sprite;
		private var tiledBitmapContainer:Bitmap;
		private var tiledBitmapData:BitmapData;
		
		private var tiledBitmapRadius:uint;

		private var prevTiledMapLTPoint:Point = new Point();

		public function MapChipX(map:Array, chipInfos:ChipInfoArray, frameWidth:uint, frameHeight:uint, isTransparent:Boolean=false, isStaticChips:Boolean=false):void {
			this.map = map;
			this.chipInfos = chipInfos;
			this.frameWidth = frameWidth;
			this.frameHeight = frameHeight;
			this.isTransparent = isTransparent;
			this.isStaticChips = isStaticChips;
			
			this.mapRaws = this.map.length;
			this.mapCols = this.map[0].length;
			
			this.chipWidth = chipInfos.chipWidth;
			this.chipHeight = chipInfos.chipHeight;
			
			this.mapWidth = mapCols * chipWidth;
			this.mapHeight = mapRaws * chipHeight;
			
			this.setupRollMap();
			setupTiledBitmap();
		}
		
		private function setupRollMap():void {
			rollMap = new Sprite();
			rollMap.x = this.frameWidth / 2;
			rollMap.y = this.frameHeight / 2;
			addChild(rollMap);
		}
		
		private function setupTiledBitmap():void {
			tiledBitmapRadius = Math.sqrt(frameWidth * frameWidth / 4 + frameHeight * frameHeight / 4);
			var tiledBitmapWidth:uint = Math.ceil(tiledBitmapRadius * 2 / chipWidth + 1) * chipWidth;
			var tiledBitmapHeight:uint = Math.ceil(tiledBitmapRadius * 2 / chipHeight + 1) * chipHeight;
			tiledBitmapData = new BitmapData(tiledBitmapWidth, tiledBitmapHeight, isTransparent);
			tiledBitmapContainer = new Bitmap(tiledBitmapData);
			rollMap.addChild(tiledBitmapContainer);
		}
		
		public function update(_centerX:int, _centerY:int, _centerRotation:Number = 0):void {
			var centerX:int = _centerX % mapWidth;
			if (centerX < 0) {
				centerX += mapWidth;
			}
			var centerY:int = _centerY % mapHeight;
			if (centerY < 0) {
				centerY += mapHeight;
			}
			var centerRotation:Number = _centerRotation % 360;
			
			var visibleLTPoint:Point = getVisibleLeftTopPoint(centerX, centerY);
			var visibleRBPoint:Point = getVisibleRightBottomPoint(centerX, centerY);
			
			var tiledMapLTPoint:Point = getTiledMapLeftTopPoint(visibleLTPoint);
			var tiledMapRBPoint:Point = getTileMapRightBottomPoint(visibleRBPoint);
			
			setTiledBitmap(tiledMapLTPoint, tiledMapRBPoint);
			setTiledBitmapPosition(centerX, centerY, tiledMapLTPoint);
			
			rollMap.rotation = centerRotation;
		}
		
		private function getVisibleLeftTopPoint(centerX:int, centerY:int):Point {
			var x:Number = centerX - tiledBitmapRadius;
			var y:Number = centerY - tiledBitmapRadius;
			return new Point(x, y);
		}
		
		private function getVisibleRightBottomPoint(centerX:int, centerY:int):Point {
			var x:Number = centerX + tiledBitmapRadius;
			var y:Number = centerY + tiledBitmapRadius;
			return new Point(x, y);
		}
		
		private function getTiledMapLeftTopPoint(visibleLTPoint:Point):Point {
			var x:Number = Math.floor(visibleLTPoint.x / chipWidth);
			var y:Number = Math.floor(visibleLTPoint.y / chipHeight);
			return new Point(x, y);
		}
		
		private function getTileMapRightBottomPoint(visibleRBPoint:Point):Point {
			var x:Number = Math.ceil(visibleRBPoint.x / chipWidth);
			var y:Number = Math.ceil(visibleRBPoint.y / chipHeight);
			return new Point(x, y);
		}
		
		private function setTiledBitmap(tiledMapLTPoint:Point, tiledMapRBPoint:Point):void {
			if (isStaticChips && isSameBlock(tiledMapLTPoint)) {
				return;
			}
			prevTiledMapLTPoint = tiledMapLTPoint;
			
			var rawOffset:int = tiledMapLTPoint.y;
			var colOffset:int = tiledMapLTPoint.x;
			
			for (var raw:int = tiledMapLTPoint.y, raws:int = tiledMapRBPoint.y; raw <= raws; raw++) {
				var tileY:uint = (raw - rawOffset) * chipHeight;
				for ( var col:int = tiledMapLTPoint.x, cols:int = tiledMapRBPoint.x; col <= cols; col++) {
					var chipInfo:ChipInfo = getChipInfoFromMap(raw, col);
					var tileX:uint = (col - colOffset) * chipWidth;
					chipInfo.pasteTo(tiledBitmapData, new Point(tileX, tileY));
				}
			}
		}
		
		private function isSameBlock(tiledMapLTPoint:Point):Boolean {
			if (prevTiledMapLTPoint.x == tiledMapLTPoint.x && prevTiledMapLTPoint.y == tiledMapLTPoint.y) {
				return true;
			}
			return false;
		}
		
		private function getChipInfoFromMap(raw:int, col:int):ChipInfo {
			var x:int = col % mapCols;
			if (x < 0) {
				x += mapCols;
			}
			var y:int = raw % mapRaws;
			if (y < 0) {
				y += mapRaws;
			}
			//trace(y, x);
			return chipInfos[map[y][x]];
		}
		
		private function setTiledBitmapPosition(centerX:int, centerY:int, tiledMapLTPoint:Point):void {
			var centerTileX:int = centerX / chipWidth;
			var tileOffsetX:int = (tiledMapLTPoint.x - centerTileX) * chipWidth;
			var modX:int = centerX % chipWidth;
			var x:int = tileOffsetX - modX;
			
			var centerTileY:int = centerY / chipHeight;
			var tileOffsetY:int = (tiledMapLTPoint.y - centerTileY) * chipHeight;
			var modY:int = centerY % chipHeight;
			var y:int = tileOffsetY - modY;
			
			tiledBitmapContainer.x = x;
			tiledBitmapContainer.y = y;
		}
		
	}
	
}