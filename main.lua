--- @sync entry
--- Pane toggles for Yazi, and an optional layout without the header line.
---
--- Yazi's `ratio` setting is fixed when it starts. This plugin keeps the three ratios in a state
--- that the commands `plugin layout toggle-parent` and `plugin layout toggle-preview` flip between
--- 0 and 1 while Yazi runs, then it asks Yazi to redraw.
---
--- Setup, in init.lua:
---
---   require("layout"):setup()                    -- the header line is hidden
---   require("layout"):setup { header = true }    -- the header line stays

local M = {}

local PANES = { parent = 1, current = 2, preview = 3 }

--- Replace the root layout with one that has no header line. This replaces `Root.layout` and
--- `Root.build` as a whole, so it follows what they are in the Yazi version that is used.
function M:setup(opts)
	opts = opts or {}
	if opts.header then
		return
	end

	Root.layout = function(self)
		self._chunks = ui.Layout()
			:direction(ui.Layout.VERTICAL)
			:constraints({
				ui.Constraint.Length(Tabs.height()),
				ui.Constraint.Fill(1),
				ui.Constraint.Length(1),
			})
			:split(self._area)
	end

	Root.build = function(self)
		self._children = {
			Tabs:new(self._chunks[1]),
			Tab:new(self._chunks[2], cx.active),
			Status:new(self._chunks[3], cx.active),
			Modal:new(self._area),
		}
	end
end

function M:entry(job)
	local _, pane = string.match(job.args[1] or "", "^(toggle)-(%a+)$")
	if not pane or not PANES[pane] or pane == "current" then
		return ya.notify {
			title = "layout.yazi",
			content = "Use `plugin layout toggle-parent` or `plugin layout toggle-preview`",
			timeout = 5,
			level = "error",
		}
	end

	local ratio = rt.mgr.ratio
	local state = self

	-- prepare the state with the ratios of the configuration
	state.parent = state.parent or ratio[PANES.parent]
	state.current = state.current or ratio[PANES.current]
	state.preview = state.preview or ratio[PANES.preview]

	-- toggle the pane
	state[pane] = state[pane] == 0 and 1 or 0

	if not state.layout then
		state.layout = Tab.layout

		Tab.layout = function(tab)
			local all = state.parent + state.current + state.preview
			tab._chunks = ui.Layout()
				:direction(ui.Layout.HORIZONTAL)
				:constraints({
					ui.Constraint.Ratio(state.parent, all),
					ui.Constraint.Ratio(state.current, all),
					ui.Constraint.Ratio(state.preview, all),
				})
				:split(tab._area)
		end
	end

	-- trigger the resize
	ya.emit("app:resize", {})
end

return M
