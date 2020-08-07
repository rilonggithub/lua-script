local function close_redis(red)  
    if not red then  
        return  
    end  

    local pool_max_idle_time = 10000  --毫秒  
    local pool_size = 500  --连接池大小  
    local ok, err = red:set_keepalive(pool_max_idle_time, pool_size)  
    if not ok then  
        ngx.say("set keepalive error : ", err)  
    end  
end    

local redis = require("resty.redis")  


local red = redis:new()  

red:set_timeout(1000)  

local ip = "127.0.0.1"  
local port = 6379  
local ok, err = red:connect(ip, port)  
if not ok then  
    ngx.say("connect to redis error : ", err)  
    return close_redis(red)  
end  
--local res, err = red:auth("123456")
--    if not res then
--        ngx.say("failed to authenticate: ", err)
--        return
--    end


local resp, err = red:evalsha("3e887c1ff3acdf309e54e7ff43d1da52e1c63a91",1,ngx.var.arg_username)
if not resp then
    ngx.say("get msg error : ", err)
    return close_redis(red)
end
 if resp == -1 then
     ngx.say("<h1>end</h1>");
 elseif resp == 0 then
     ngx.say("<h1>Not start</h1>")
 else
     ngx.say("<h1>ordered</h1>");
    
 	local args ="userName=" .. ngx.var.arg_username 
         local producer = require "resty.kafka.producer"
         local broker_list = {
             { host = "172.16.8.186", port = 9092 },
         }

         local bp = producer:new(broker_list, { producer_type = "async" })
         if args == nil then
             return
         end
         local ok, err = bp:send("lua-create-order", nil, args)
         if not ok then
             ngx.say("kafka send err:", err)
             return
         end
 end
close_redis(red)

