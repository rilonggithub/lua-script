local config = {
                name = "test",
                serv_list = {
                    {ip="172.16.7.63", port = 6379},
                    {ip="172.16.7.63", port = 6380},
                    {ip="172.16.7.63", port = 6381},
                    {ip="172.16.7.63", port = 6382},
                    {ip="172.16.7.63", port = 6383},
                    {ip="172.16.7.63", port = 6384},
                },
            }
	local redis_cluster = require "rediscluster"
	local red_c = redis_cluster:new(config)
	    local resp, err = red_c:evalsha("a03b05d8ff8fe607ef3615e2677a96b6cc71dde6",1,ngx.var.arg_username.."{lua-order}")
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
        local cjson = require "cjson"
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

red_c:close()


