local function requireInstances(instances: { Instance })
	for _, instance in instances do
		if instance:IsA("ModuleScript") then
			task.spawn(pcall, require, instance)
		end
	end
end

return requireInstances
