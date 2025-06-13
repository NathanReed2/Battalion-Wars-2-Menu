function PageStack(owner)
end
local PageStack = {}
local PageStackTop = 0
NextPage = 0
PageDone = false
function PushPageStack(aPage)
	PageStackTop = PageStackTop + 1
	PageStack[PageStackTop] = aPage
	NextPage = aPage
	PageDone = true
end
function PopPageStack()
	if 1 < PageStackTop then
		PageStack[PageStackTop] = nil
		PageStackTop = PageStackTop - 1
	end
	NextPage = PageStack[PageStackTop]
	PageDone = true
end
function SetPageStack(aPage)
	PageStack[PageStackTop] = aPage
	NextPage = aPage
	PageDone = true
end
function ResetPageStack(aPage)
	PageStackTop = 0
	PushPageStack(aPage)
end
function GetPageAtTop()
	return PageStack[PageStackTop]
end
function bPopPage()
	if bFadeNotDone() then
		return
	end
	PopPageStack()
	PlaySound(SoundID.UI_FE_Close)
end
function PageStackEnd()
end
