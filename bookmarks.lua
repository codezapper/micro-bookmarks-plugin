MakeCommand("toggle_bookmark", "bookmarks.toggle", 0)
MakeCommand("next_bookmark", "bookmarks.goto_next", 0)

bookmarks = {}

function toggle()
	local view = CurView()
	local newMark = view.Cursor.Y
	
	local previousMark = false -- Previous mark here?
	
	---[[ If there's already a mark in our spot, remove it.
	----- Then clear the gutter, resort the table from smallest to largest.
	----- And as long as we didn't remove the last bookmark, rebuild.
	for i,v in ipairs(bookmarks) do
		if (v == newMark) then
			previousMark = true
			table.remove(bookmarks, i)
			CurView():ClearGutterMessages("bookmarks")
			table.sort(bookmarks)
			if #bookmarks ~= 0 then
				rebuildMarks()
			end
		end
	end
	--]]
	
	---[[ If there wasn't a mark there previously, just add one and resort.
	if (previousMark == false) then	
		table.insert(bookmarks, newMark)
		view:GutterMessage("bookmarks", newMark + 1, "Bookmark added.", 1)
		table.sort(bookmarks)
	end
	--]]
end

function rebuildMarks()
  ---[[ Funny enough, the "Bookmark removed." message comes when we rebuild.
	local view = CurView()
	for i,v in ipairs(bookmarks) do
		view:GutterMessage("bookmarks", v + 1, "Bookmark removed.", 1)
	end
	--]]
end

function goto_next()
	local view = CurView()
	local bookmarkTableSize = #bookmarks
	local currentMarkSpot = 0
	
	---[[ If I'm on a bookmark and toggle to go to the next, 
	----- Take the current spot.
	for i,v in ipairs(bookmarks) do
		if (view.Cursor.Y == v) then
			currentMarkSpot = v
		end
	end
	
	----- Then look to see if there's a mark lower in the buffer.
	noFurtherMark = true
	for i,v in ipairs(bookmarks) do
		if (v > currentMarkSpot) then
			view.Cursor.Y = v
			noFurtherMark = false
			break
		end
	end
	
	----- If there's nothing lower, go to the first (highest) mark.
	if (noFurtherMark == true) then
		view.Cursor.Y = bookmarks[1]
	end
	CurView():Relocate()
	--]]
end

BindKey("F5", "bookmarks.toggle")
BindKey("F6", "bookmarks.goto_next")
