local M = {}

--- NOTE: lazy loaded
---@param f function
---@param ... any
---@return function
M.fn = function(f, ...)
    local args = { ... }
    return function(...)
        return f(unpack(args), ...)
    end
end

---Usage:
---inst_fn(obj, 'hello')({args}, false)(...)
---@param inst table
---@param method string
---@return fun(_args?:table, is_fn?:boolean): fun(...:any): any
M.inst_fn = function(inst, method)
    ---@param _args table?
    ---@param is_fn boolean?
    ---@return fun(...:any): any
    return function(_args, is_fn)
        local args = (type(_args) == "table" and _args)
            or (_args and { _args } or {})
        return function(...)
            local f = inst[method]
            if f == nil then
                error("function not found: " .. tostring(method))
            end

            if is_fn == true then
                return f(unpack(args), ...)
            else
                return f(inst, unpack(args), ...)
            end
        end
    end
end

return M
