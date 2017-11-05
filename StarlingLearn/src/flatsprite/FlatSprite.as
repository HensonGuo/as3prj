package flatsprite
{
	import flash.display.Bitmap;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.deg2rad;

	/**
	 * 多层嵌套的Sprite对象:
	 * Starling在管理显示列表的时候，每个显示对象都有专属的顶点着色器及索引缓冲区（vertex and index buffer）来进行各自的渲染工作
	 * 这样会消耗大量的运算量且在子对象繁多时会显著地影响呈现性能。
	 * 
	 * 
	 * 
	 * Sprite被flat了之后:
	 * Starling提供了一种优化方案
	 * 将全部子对象的顶点着色器及索引缓冲区集成为一个大的并由它来接管全局的渲染工作
	 * （包括容器及其子对象）
	 * 且只需要调用一次绘制方法即可完成渲染的工作，就跟完成一个简单的纹理的渲染一样（如果所有子对象都共享同一个纹理的话，那自然是这样）。
	 * 这种特性理解为是在Starling中可用的cacheAsBitmap
	 * 
	 * 
	 * 
	 * 区别：
	 * 不过它们之间的区别在于，使用flat sprites不会像cacheAsBitmap一样只需要设置一次就一劳永逸，
	 * 在原生Flash中，显示对象一旦被设置了cacheAsBitmap为true之后，只要改显示对象或者其子对象发生了改变，Flash会自动生成新的位图缓存，
	 * 保证显示正确的图形，
	 * 但是flat sprites不会自动生成新的。因此你必须再次调用flatten方法来手动地重新生成一次才能看到改变
	 * 
	 * 
	 * 
	 * API:
	 * ∗ flatten: 如果你想尽可能地提高存在大量嵌套的Sprite对象的话，调用此方法可以让你达到满意效果。
	 * 一旦调用了此方法，Starling将会把显示树（即以一个Sprite对象为顶点，所有子对象为子节点）中的渲染工作全部统一管理，
	 * 在一次绘制操作中完成全部渲染工作。如果显示树中某个节点发生了外观改变，那么你需要再次调用此方法才能看见改变。
	 * 
	 * ∗ unflatten: 禁用flat行为.
	 * 
	 * isFlatenned: 判断是否使用了flat
	 * 
	 * 
	 * 注意：
	 * 如果子对象所用纹理不一致，那么Starling会对不同的纹理进行独立地绘制工作，这样的话，flatten特性所能带来的性能提升便也不那么明显了
	 * 你可以在任何时候改变一个子对象的外观并在希望屏幕反应出这个外观变化的时候重新调用一次flatten即可。
	 */	
	public class FlatSprite extends Sprite
	{
		private var container:Sprite; 
		private static const NUM_PIGS:uint = 100; 
		[Embed(source = "/../bin-debug/assets/pig.png")] 
		private static const PigParachute:Class;
		
		public function FlatSprite()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded (e:Event):void {
			// create the container 
			container = new Sprite(); 
			// change the registration point 
			container.pivotX = stage.stageWidth >> 1; 
			container.pivotY = stage.stageHeight >> 1; 
			container.x = stage.stageWidth >> 1; 
			container.y = stage.stageHeight >> 1; 
			// create a Bitmap object out of the embedded image 
			var pigTexture:Bitmap = new PigParachute(); 
			// create a Texture object to feed the Image object 
			var texture:Texture = Texture.fromBitmap(pigTexture); 
			// layout the pigs 
			for ( var i:uint = 0; i< NUM_PIGS; i++) 
			{ 
				// create a new pig 
				var pig:Image = new Image(texture); 
				// random position 
				pig.x = Math.random()*stage.stageWidth; 
				pig.y = Math.random()*stage.stageHeight; 
				pig.rotation = deg2rad(Math.random()*360);
				// nest the pig 
				container.addChild ( pig );
			}
			container.pivotX = stage.stageWidth >> 1; 
			container.pivotY = stage.stageHeight >> 1; 
			// show the pigs 
			addChild ( container ); 
			// on each frame 
			stage.addEventListener(Event.ENTER_FRAME, onFrame); 
		}
		
		private function onFrame (e:Event):void 
		{ 
			// freeze the children 
			container.flatten();
			// rotate the container 
			container.rotation += .01; 
		}
	}
}