local queue = KEYS[1]
local now = tonumber(ARGV[1])
local priorities = cjson.decode(ARGV[2])
local task = nil

for _, priority in ipairs(priorities) do
    local key = queue .. ':' .. priority
    local tasks = redis.call('ZRANGEBYSCORE', key, '-inf', tostring(now), 'LIMIT', 0, 1)

    if #tasks > 0 then
        redis.call('ZREM', key, tasks[1])
        task = tasks[1]
        break
    end
end

return task
