function PlayPre(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	function tableData.Update()
		pollTitleLoop()
	end
	function GetPlayPrePage()
		return tableData
	end
	DebugOut("PlayPre ticked ***")
end
