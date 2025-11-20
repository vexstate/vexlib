EVX = EVX or {}
EVX.env = IsDuplicityVersion() and "server" or "client"

EVX.meta = {
    version = "3.0.0",
    author = "Matija & Vexstate",
    github = "https://github.com/vexstate",
    n_github = "https://github.com/n11kol11c",
    dist = "https://github.com/LuaDist" -- all credits for libs/ :)
}


--- @param env number
--- @return number|any
function EVX.isEnv(env)
    if EVX.env ~= env then
        return -1
    else return 0 end
end