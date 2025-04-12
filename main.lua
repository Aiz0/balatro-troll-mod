assert(SMODS.load_file("utils.lua"))()

SMODS.Atlas({
    key = "trading",
    path = "trading_card.png",
    px = 71,
    py = 95,
})

local function new_troll_joker(joker)
    local original_joker = SMODS.Joker:take_ownership(joker.key, {})
    local troll_joker = SMODS.merge_defaults({
        unlocked = true,
        discovered = true,
        registered = false,
        take_ownership = false,
        loc_txt = G.localization.descriptions.Joker[original_joker.key], -- use original jokers description
    }, original_joker)
    troll_joker.mod = nil --crashes if I don't fuck this
    if joker.loc_vars then troll_joker.generate_ui = nil end
    SMODS.Joker(SMODS.merge_defaults(joker, troll_joker))
end

-- load all jokers in joker dir
for _, file in ipairs(NFS.getDirectoryItems(SMODS.current_mod.path .. "jokers")) do
    local joker = assert(SMODS.load_file("jokers/" .. file))()
    if type(joker) == "table" then new_troll_joker(joker) end
end
