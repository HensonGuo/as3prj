/*
 * Copyright(c) 2006-2008 the Spark project.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */


package utils
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.IBitmapDrawable;
import flash.display.Loader;
import flash.display.Sprite;
import flash.filters.BitmapFilter;
import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Transform;
import flash.errors.IllegalOperationError;

/**
 * BitmapData のためのユーティリティクラスです
 */
public class BitmapUtil
{
	/**
     * @private
     */
	public function BitmapUtil()
	{
		throw new IllegalOperationError("Error #2012: BitmapUtil class cannot be instantiated.");
	}
	
    /**
     * ビットマップにフィルタを適応します
     * 
     * @param	bitmap 対象となるBitmapDataインスタンス
     * @param	filter 適応するBitmapFilterインスタンス
     */
    public static function applyFilter( bitmap:BitmapData, filter:BitmapFilter ):void
    {
        bitmap.applyFilter(bitmap, bitmap.rect, new Point(), filter);
    }
    
    /**
     * BitmapDataを指定のコンテナ内に配置します。
     * 
     * @param	target コンテナインスタンス
     * @param	bitmapData 配置するBitmapData
     * @param	smoothing スムージングの有無
     * @return  コンテナに配置されたSpriteインスタンス
     */
    public static function attachBitmap( target:DisplayObjectContainer,
        bitmapData:BitmapData , smoothing:Boolean=false ):Sprite
    {
        var bitmap:Bitmap = new Bitmap( bitmapData, "auto", smoothing );
        var sprite:Sprite = new Sprite();
        sprite.addChild( bitmap );
        target.addChild( sprite );
        return sprite;
    }
    
    /**
     * DisplayObjectContainer 内に配置されている DisplayObject インスタンスのキャプチャを作成し
     * 対象と置き換えます。 対象はコンテナ内から削除されます。
     * 
     * @param	target 対象となるDisplayObjectインスタンス
     * @return  キャプチャBitmapを内包するSpriteインスタンス
     */
    public static function swapBitmap( target:DisplayObject ):Sprite
    {
        var bitmap:BitmapData = capture( target );
        var rect:Object = target.getBounds( target );
        var index:int = target.parent.getChildIndex( target );
        var transform:Transform = target.transform;
        var name:String = target.name;
        var image:Bitmap = new Bitmap( bitmap, "auto", true );
        var sprite:Sprite = new Sprite();
        sprite.addChild( image );
        image.x = rect.x;
        image.y = rect.y;
        sprite.transform = transform;
        target.parent.addChildAt( sprite , index );
        target.parent.removeChild( target );
        return sprite;
    }
    
    /**
     * DisplayObjectContainer 内に配置されている DisplayObject インスタンスのキャプチャを作成し
     * 対象と同じtransformプロパティを持つSpriteインスタンスを、対象と同階層に配置します
     * 
     * @param	target 対象となるDisplayObjectインスタンス
     * @return  キャプチャBitmapを内包するSpriteインスタンス
     */
    public static function dummy( target:DisplayObject ):Sprite
    {
        var bitmap:BitmapData = capture( target );
        var rect:Object = target.getBounds( target );
        var index:int = target.parent.getChildIndex( target );
        var transform:Transform = target.transform;
        var name:String = target.name;
        var image:Bitmap = new Bitmap( bitmap, "auto", true );
        var sprite:Sprite = new Sprite();
        image.name = "bitmap";
        sprite.addChild( image );
        image.x = rect.x;
        image.y = rect.y;
        sprite.transform = transform;
        target.parent.addChildAt( sprite , index+1 );
        return sprite;
    }
    
    /**
     * DisplayObjectインスタンスのキャプチャデータを作成します
     * 
     * @param	target 対象となる IBitmapDrawable オブジェクト
     * @return  キャプチャデータを持つ BitmapData オブジェクト
     */
    public static function capture (target:IBitmapDrawable):BitmapData
    {
		if (target is BitmapData) return (target as BitmapData).clone();
		var obj:DisplayObject = target as DisplayObject;
        var rect:Object = obj.getBounds( obj );
        var width:Number = rect.width;
        var height:Number = rect.height;
        var bitmap:BitmapData = new BitmapData( 
            width , height, true, 0x00000000 );
        var matrix:Matrix = new Matrix();
        matrix.translate( -rect.x , -rect.y );
        bitmap.draw( obj , matrix );
        return bitmap;
    }
    
}
}

