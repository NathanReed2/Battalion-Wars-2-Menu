function GO3(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	function tableData.setGO1()
		SetPageStack("GO1")
	end
	function tableData.setGO2()
		SetPageStack("GO2")
	end
	function tableData.Open()
	end
	function tableData.Update()
		pollTitleLoop()
	end
	function tableData.Close()
	end
	function GetGO3Page()
		return tableData
	end
	DebugOut("GO3 ticked ***")
end
