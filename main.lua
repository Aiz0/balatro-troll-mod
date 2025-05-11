assert(SMODS.load_file("utils.lua"))()
assert(SMODS.load_file("override.lua"))()

SMODS.Atlas({
    key = "jokers",
    path = "jokers.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "enhancers",
    path = "enhancers.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "consumables",
    path = "consumables.png",
    px = 71,
    py = 95,
})

local function new_troll_joker(joker)
    local original_joker = SMODS.Joker:take_ownership(joker.key, {})
    if not original_joker then
        folly_utils.log.Error("No joker found with key: " .. joker.key)
        return
    end
    local troll_joker = SMODS.merge_defaults({
        unlocked = true,
        discovered = true,
        registered = false,
        take_ownership = false,
        loc_txt = G.localization.descriptions.Joker[original_joker.key], -- use original jokers description
    }, original_joker)
    troll_joker.mod = nil --crashes if I don't fuck this
    if joker.loc_vars then
        troll_joker.generate_ui = nil
    end
    SMODS.Joker(SMODS.merge_defaults(joker, troll_joker))
end

-- load all jokers in joker dir
for _, file in ipairs(NFS.getDirectoryItems(SMODS.current_mod.path .. "jokers")) do
    local joker = assert(SMODS.load_file("jokers/" .. file))()
    if type(joker) == "table" then
        new_troll_joker(joker)
    end
end
