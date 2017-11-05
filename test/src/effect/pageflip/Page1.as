package effect.pageflip
{
	import flash.display.Sprite;
	
	public class Page1 extends Sprite
	{
		public function Page1()
		{
			super();
			this.graphics.beginFill(0x333333, 0.5);
			this.graphics.drawRect(0, 0, 200, 200);
			this.graphics.endFill();
		}
	}
}