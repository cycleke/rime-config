-- 根据候选词类型，在结尾加上一个特定标记

local M = {}

function M.init(env)
	local config = env.engine.schema.config
	env.name_space = env.name_space:gsub("^*", "")
	M.user_table = config:get_string(env.name_space .. "/user_table")
	M.user_phrase = config:get_string(env.name_space .. "/user_phrase")
	M.sentence = config:get_string(env.name_space .. "/sentence")
	M.phrase = config:get_string(env.name_space .. "/phrase")
	M.completion = config:get_string(env.name_space .. "/completion")
end

function M.func(input, env)
	-- 定义要应用于每个候选项的条件。
	local conditions = {
		{ type = "user_table", value = M.user_table }, -- 用户表条件
		{ type = "user_phrase", value = M.user_phrase }, -- 用户短语条件
		{ type = "sentence", value = M.sentence }, -- 句子条件
		{ type = "phrase", value = M.phrase }, -- 短语条件
		{ type = "completion", value = M.completion }, -- 完成条件
	}

	for cand in input:iter() do
		local tags = ""
		for _, condition in ipairs(conditions) do
			if condition.value and cand.type == condition.type then
				tags = condition.value
				break
			end
		end

		if tags ~= "" then
			-- if cand.comment == "" or cand.comment:match("^［(.-)］$") then
			-- 	cand:get_genuine().comment = tags
			-- else
			-- 	cand:get_genuine().comment = tags .. " " .. cand.comment
			-- end
			cand:get_genuine().comment = tags .. " " .. cand.comment
		end

		yield(cand)
	end
end

return M
