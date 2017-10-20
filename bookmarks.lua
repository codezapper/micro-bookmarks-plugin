MakeCommand("toggle_bookmark", "bookmarks.toggle", 0)
MakeCommand("next_bookmark", "bookmarks.goto_next", 0)

bookmarks = {}
current_bookmark = {}

function bookmark_is_present(cur_path, cur_line)
	for i = 0, #bookmarks[cur_path] do
		if (bookmarks[cur_path][i] == cur_line) then
			bookmarks[cur_path][i] = nil
			return nil
		end
	end

	return cur_line
end

function get_count()
	count = 0
	for key, value in pairs(bookmarks[cur_path]) do
		if (value ~= nil) then
			count = count + 1
		end
	end
	return count
end

function toggle()
	cur_view = CurView()
	cur_path = cur_view.Buf.Path
	cur_line = cur_view.Cursor.Y

	if (bookmarks[cur_path] == nil)	then
		bookmarks[cur_path] = {}
		bookmarks[cur_path][0] = cur_line
		current_bookmark[cur_path] = 0
		cur_view:GutterMessage("bookmarks", cur_line+1, "Bookmark 0", 2)
		return
	end

	count = get_count()
	bookmarks[cur_path][count] = bookmark_is_present(cur_path, cur_line)
	cur_view:GutterMessage("bookmarks", cur_line+1, "Bookmark " .. count, 2)
end

function goto_next()
	cur_path = CurView().Buf.Path

	if ((bookmarks[cur_path] == nil) or (get_count() == 0)) then
		return
	end

	current_bookmark[cur_path] = current_bookmark[cur_path] + 1
	if (current_bookmark[cur_path] >= get_count()) then
		current_bookmark[cur_path] = 0
	end

	CurView().Cursor.Y = bookmarks[cur_path][current_bookmark[cur_path]]
	CurView():Relocate()
end

BindKey("F11", "bookmarks.toggle")
BindKey("F10", "bookmarks.goto_next")
