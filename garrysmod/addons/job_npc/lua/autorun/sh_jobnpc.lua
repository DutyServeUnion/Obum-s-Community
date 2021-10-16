hook.Add("InitPostEntity", "OverrideDarkRPNicknames", function()
	local meta = FindMetaTable("Player")

	local old = meta.Name
	function meta:Name()
		local cp = self:GetNWString("CPName", "")

		if cp ~= "" then
			return cp
		else
			return old(self)
		end
	end
	meta.GetName = meta.Name
	meta.Nick = meta.Name
end)