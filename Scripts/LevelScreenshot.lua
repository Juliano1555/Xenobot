lastLevel = Self.Level()

Module.New("Screenshot", function(module)
	if Self.Level() > lastLevel then
		screenshot(Self.Name() .. '_level_' .. Self.Level())
		lastLevel = Self.Level()
		print('Screenshot taken for advancing level.')
	end
end)