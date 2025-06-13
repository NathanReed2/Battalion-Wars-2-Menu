function SavingPostSearch(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local close = false
	local goSaveCallback = function(status)
		SetGameSaveValid(MPSaveStatus, status)
		PopPageStack()
	end
	function tableData.Open()
		GetNANDDialog().Open()
		if GetGameSaveValid(MPSaveStatus) and MultiPlayerNeedsSaving() then
			GetNANDDialog().Save(RequestSaveMultiPlayer, goSaveCallback)
			close = false
		else
			close = true
		end
	end
	function tableData.Update()
		GetNANDDialog().Update()
		pollTitleLoop()
		if close then
			PopPageStack()
		end
	end
	function tableData.Close()
		GetNANDDialog().Close()
	end
	function GetSavingPostSearchPage()
		return tableData
	end
	DebugOut("Saving Post Searchticked ***")
end
