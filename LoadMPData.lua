function LoadMPData(owner)
	local tableData = {}
	local nandDialog
	local testStatus = 1
	function tableData.testUp()
		DebugOut("+")
		if testStatus < 27 then
			testStatus = testStatus + 1
		end
	end
	function tableData.testDown()
		DebugOut("-")
		if 1 < testStatus then
			testStatus = testStatus - 1
		end
	end
	function tableData.Open()
		testStatus = 1
		nandDialog = GetNANDDialog()
		nandDialog.Open()
	end
	function tableData.Update()
		nandDialog.UpdateTest(testStatus)
		PollTitleMusicLoop()
	end
	function tableData.Close()
		nandDialog.Close()
	end
	function GetLoadMPDataPage()
		return tableData
	end
	DebugOut("LoadMPData page ticked ***")
end
