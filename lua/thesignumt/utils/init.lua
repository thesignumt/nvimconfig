local Utils = {}

--- get the operating system name
--- @return '"windows"'|'"mac"'|'"linux"'
function Utils.get_os()
    local uname = vim.uv.os_uname()
    local os_name = uname.sysname
    if os_name == "Windows_NT" then
        return "windows"
    elseif os_name == "Darwin" then
        return "mac"
    else
        return "linux"
    end
end

return Utils
