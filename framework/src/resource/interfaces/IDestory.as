package resource.interfaces
{
	/**
	 *	重置、销毁、重用，规定这种结构顺序的调用，只能使用继承，可创建一个Reuse类
	 * 但是，PS：一个自定义显示对象类既想继承Image类又想继承Reuse类如何是好呢，我想到了两种处理方式
	 * 	1.使用多继承（但as并不支持多继承），立马排除
	 * 	2.自定义类作为一个包装器，继承Reuse类，包装一个image的实例
	 * 但一想又有诸多的缺点
	 * 	1.在dispose的时候，需要手动的将image回收至入对象池，create的时候需要从对象池取，实际上是我每次真正需要重用的是image，而并非这个自定义类
	 * 	2.既然作为显示对象的话，我需要提供一些常用的显示方法，这就意味着我需要另外再写一些方法可以直接访问image，操作麻烦费时
	 * 	3.如果有多个都想Reuse的话，那我都必须写个针对的继承Reuse的类，麻烦费时
	 * 
	 * 使用接口，难以规范化操作
	 * @author g7842
	 * 
	 */	
	public interface IDestory
	{
		function destory(isReuse:Boolean=true):void;
	}
}