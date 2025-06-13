function ConceptPre(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	function tableData.Update()
		pollTitleLoop()
	end
	function GetConceptPrePage()
		return tableData
	end
	DebugOut("ConceptPre ticked ***")
end
