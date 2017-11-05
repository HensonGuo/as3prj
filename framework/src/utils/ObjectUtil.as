/*
 * Copyright(c) 2006-2007 the Spark project.
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

public class ObjectUtil
{
	
    public static function hasOwnProperties( target:Object, ...propNames/* of String */ ):Boolean
    {
        var len:uint = propNames.length;
        for ( var i:uint = 0; i < len;i++ ) {
            if ( !target.hasOwnProperty(propNames[i]) ) return false;
        }
        return true;
    }
    
    public static function propLength( target:Object ):uint
    {
        var n:uint = 0;
        for (var val:String in target) n++;
        return n;
    }
	
    public static function toArray(target:Object, propNames:Array=null /* of String */ ):Array
    {
        var a:Array = [];
        if ( propNames ) {
            var len:uint = propNames.length;
            for (var i:uint = 0; i < len; i++ ) {
                a.push( target[propNames[i]] );
            }
            return a;
        } else {
            for (var val:String in target) {
                a.push(target[val]);
            }
            return a;
        }
    }
    
	public static function getPropNames(target:Object):Array
	{
		var a:Array = [];
		for (var val:String in target) a.push(val);
		return a;
	}
	
	public static function getPropValues(target:Object):Array
	{
		var a:Array = [];
		for each(var val:* in target) a.push(val);
		return a;
	}
	
}
}