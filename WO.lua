function WO(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	function tableData.Update()
		pollTitleLoop()
	end
	function GetWOPage()
		return tableData
	end
	DebugOut("WO ticked ***")
end
