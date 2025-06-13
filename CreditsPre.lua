function CreditsPre(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	function tableData.Update()
		pollTitleLoop()
	end
	function GetCreditsPrePage()
		return tableData
	end
	DebugOut("CreditsPre ticked ***")
end
