/**
 * 
 * Convert DataGrid to Excel in AIR
Under AIR By admin

It��s heard that Flex can convert DataGrid to XML Spreadsheet, then submit xml to server in order to create Excel file for downloading. But AIR can directly output xml and write it into native file. That��s greate, the only problem is how to convert DataGrid to XML Spreadsheet, which is one of xls formats. I implemented it in my project.

check spec of xml spreadsheet format here.

download XMLSpreadsheet.as.

 */
package utils
{
	import flash.events.Event;
	import flash.filesystem.*;
	
	import mx.collections.ListCollectionView;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	
	/**
	 * Export to excel (XML spread sheet)
	 */ 
	public class XMLSpreadsheet
	{
		private static const header:String = "<?xml version=\"1.0\" encoding=\"utf-8\" ?> " +
      								"<?mso-application progid=\"Excel.Sheet\"?>" +
      								"<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:html=\"http://www.w3.org/TR/REC-html40\">" +
      								"<Styles>" +
      								"</Styles>" +
      								"<Worksheet ss:Name=\"Data\">" +
      								"<Table x:FullColumns=\"1\" x:FullRows=\"1\">";
      								
      	private static const trailer:String = "</Table></Worksheet></Workbook>";
      	
      	private static var xmlss:String;
      	
      	/**
      	 * convert to string of XMLSS
      	 */ 
      	public static function convertDataGridToXMLSS(_grid:DataGrid):String
      	{
      		if(_grid.dataProvider.length <=0)
      		{
      			return "";
      		}
      		
      		//column
      		var table_str:String = "<Row>";
      		for(var c:int=0 ; c<_grid.columns.length ; c++)
      		{
      			var _col:DataGridColumn = _grid.columns[c];
      			table_str += "<Cell><Data ss:Type=\"String\"><B>" + _col.headerText + "</B></Data></Cell>"
      		}
      		table_str += "</Row>";
      		
      		//Loop through the records in the dataprovider and 
        	//insert the column information into the table
        	var _dp:ListCollectionView = _grid.dataProvider as ListCollectionView;
        	for(var i:int=0 ; i<_dp.length ; i++)
        	{
        		if(_dp.getItemAt(i) != null)
        		{
        			table_str += "<Row>";
	        		for(var j:int=0 ; j<_grid.columns.length ; j++)
	        		{
	        			//Check to see if the user specified a labelfunction which we must
        				//use instead of the dataField
        				var func:Function = (_grid.columns[j] as DataGridColumn).labelFunction;
        				var cellData:String = "";
        				if(func != null)
        				{
        					cellData = func(_dp.getItemAt(i), _grid.columns[j])
        					//table_str += "<Cell><Data ss:Type=\"String\">" +  + "</Data></Cell>";
        				}
        				else
        				{
        					cellData = _dp.getItemAt(i)[(_grid.columns[j] as DataGridColumn).dataField];
        					//table_str += "<Cell><Data ss:Type=\"String\">" + _dp.getItemAt(i)[(_grid.columns[j] as DataGridColumn).dataField] + "</Data></Cell>";
        				}
        				table_str += "<Cell><Data ss:Type=\""+((cellData=="" || isNaN(Number(cellData)))?"String":"Number")+"\">" + cellData + "</Data></Cell>";
	        		}
	        		table_str += "</Row>";
	        	}
        	}
        	
      		return header + table_str + trailer;
      	}

	}
}