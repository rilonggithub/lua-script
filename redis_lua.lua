local start = redis.call("get","goodId_start{lua-order}")
if start == "0" then
    return 0
end

local key=KEYS[1] 
local access = redis.call("get","goodId_access{lua-order}")
local count = redis.call("get","goodId_count{lua-order}")
if  tonumber(access)+1 > tonumber(count)  then
        return -1
else
	redis.call("set",key,tonumber(access)+1)
	redis.call("incr","goodId_access{lua-order}")

	return 1
end
