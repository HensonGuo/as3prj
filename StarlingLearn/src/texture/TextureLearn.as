package texture
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import starling.display.Sprite;
	
	/**
	 * 如果你创建了一个Image对象，那你必须为其传入一个Texture对象作为外观。这两者的关系就像原生Flash中Bitmap和BitmapData的关系
	 * base : 该Texture对象所基于的Stage3D texture对象
	 * dispose : 销毁该Texture对象的潜在纹理数据
	 * empty : 静态方法。创建一个指定大小和颜色的空Texture对象
	 * frame : 一个Rectangle矩形对象，用于指示一个Texture对象的范围
	 * fromBitmap : 静态方法。从一个Bitmap对象创建一个外观与其一致的Texture纹理对象。
	 * fromBitmapData : 静态方法。从一个BitmapData对象创建一个外观与其一致的Texture纹理对象。
	 * fromAtfData : 静态方法。允许运用ATF (Adobe Texture Format)格式创建一个压缩过的材质。经过压缩的材质能让你节省大量空间，尤其是在像移动设备这样对存储空间异常苛刻的环境中尤为有用。
	 * fromTexture : 静态方法。从一个Texture对象创建一个外观与其一致的Texture纹理对象
	 * height 、width: 我想这两个属性就不用多说了
	 * mipmapping : 此属性用以指示该材质是否包含了mip映射
	 * premultipliedAlpha : 此属性用以指示该texture对象的透明度是否被预乘到了RGB值中(premultiplied into the RGB values).
	 * repeat : 用以指定当前材质是否启用重复平铺模式，就像铺壁纸那样。  
	 * 
	 * 
	 * 材质类型：
	 * PNG : 由于所需素材中经常需要保留透明通道，因此PNG格式的文件是Texture最常用的素材格式
	 * JPEG : 经典的JPEG格式文件也可以为Texture所用。有一点需要注意，就是在GPU中该格式的图片会被解压缩，这意味着JPEG格式的文件将无法发挥其节省空间的优势，且其不保留透明通道哦
	 * JPEG-XR : JPEG XR是一个为了让图片色调更加连贯，视觉效果更加逼真而存在的图片压缩标准及图片文件格式，它是基于一种被称作HD Photo的技术（起初由Microsoft微软公司开发并拥有专利，曾用名为Windows Media Photo）。
	 * 它同时支持有损和无损压缩，且它是Ecma-388 Open XML Paper Specification文档标准推荐的图片存储优先格式。
	 * ATF : Adobe Texture Format. 这是一种能提供最佳压缩效果的文件格式。ATF文件主要是一个存储有损纹理数据（lossy texture data）的文件容器。
	 * 它主要使用了两种类似技术：JPEG-XR1压缩技术和基于块的压缩技术（简称块压缩技术），来实现它的有损压缩。JPEG-XR压缩技术提供了一种非常有竞争力的方式来节省存储空间
	 * 及网络带宽。而块压缩技术则提供了一种能够在客户端削减纹理存储空间（与一般的RGBA纹理文件所占存储空间的比例为1:8）的方式。ATF提供了三种块压缩技术：DXT12, ETC13 及PVRTC4.
	 * 
	 * 
	 * Mip映射。
	 * Mip映射是一个重要却简单易懂的概念。将一个纹理保存多个缩小版本的方式就叫做Mip映射
	 * PS：如一个256*256尺寸的纹理被保存了128*128、64*64….1*1这么多版本的纹理于内存中
	 * 在GPU中工作时，一个图片若将被缩放，那么它将被缩放到的大小将取决于其原始尺寸。缩放行为一般会发生在镜头向物体移动或者物体向镜头移动时，这两种情况下都会对你的图片（在GPU中表现为纹理）产生缩放。
	 * 
	 * 需要注意的是，若要使用Mip映射，那么你的纹理尺寸必须保证为2的倍数（1, 2, 4, 8, 16, 32, 64, 128, 256,512, 1024, 2048), 但形状不一定必须是矩形。
	 * 如果你没有遵守这个规则，那么Starling将会为你自动创建一个与当前纹理尺寸最接近的能被2整除的数值作为尺寸的纹（如你使用的纹理尺寸为31*31，那么
	 * Starling会为你创建一个32*32尺寸的纹理），但这可能会对内存有一点消耗。
	 * 为了确保尽可能地优化纹理的内存占用，我们建议您最好使用texture atlases
	 * 
	 * 我们建议为2D内容使用Mip映射，这样可以使它们在缩放时能够减少锯齿的产生
	 * 
	 * 为了保证最佳的呈现品质，GPU需要一个图片的全部Mip映射等级，即由原始尺寸依次除以二直到除不尽2了为止
	 * PS：对于一个128*128尺寸的纹理来说，它的全部Mip映射等级为：64*64,32*32,16*16,8*8,4*4,2*2以及1*1
	 * Starling框架能够自动替你生成全部Mip映射等级
	 * 若是你不用Starling框架的话，那你就得通过使用BitmapData.draw这个API并使用一个缩小一倍的Matrix作为参数来手动地生成全部的映射等级。
	 * 
	 * 要在Starling中使用Mip映射只需要设置某个Texture对象的mipmapping属性为true即可
	 */	
	public class TextureLearn extends Sprite
	{
		public function TextureLearn()
		{
			super();
		}
	}
	
	private function caclMip():void
	{
		if (generateMipmaps) 
		{ 
			var currentWidth:int = data.width >> 1; 
			var currentHeight:int = data.height >> 1; 
			var level:int = 1; 
			var canvas:BitmapData = new BitmapData(currentWidth, currentHeight, true, 0); 
			var transform:Matrix = new Matrix(.5, 0, 0, .5); 
			while (currentWidth >= 1 || currentHeight >= 1) 
			{
				canvas.fillRect(new Rectangle(0, 0, currentWidth, currentHeight), 0); 
				canvas.draw(data, transform, null, null, null, true); 
				texture.uploadFromBitmapData(canvas, level++); 
				transform.scale(0.5, 0.5); 
				currentWidth = currentWidth >> 1;
				currentHeight = currentHeight >> 1; 
			}
			canvas.dispose(); 
		}
	}
}