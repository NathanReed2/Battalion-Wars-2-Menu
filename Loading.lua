function Loading(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	function tableData.Update()
		pollTitleLoop()
	end
	function GetLoadingPage()
		return tableData
	end
	DebugOut("Loading page ticked ***")
end
