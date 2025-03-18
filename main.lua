local function new_troll_joker(joker)
    local original_joker = SMODS.Joker:take_ownership(joker.key, {})
    local troll_joker = SMODS.merge_defaults({
        registered = false,
        take_ownership = false,
        loc_txt = G.localization.descriptions.Joker[original_joker.key], -- use original jokers description
    }, original_joker)
    troll_joker.mod = nil                                                --crashes if I don't do this
    if joker.loc_vars then
        troll_joker.generate_ui = nil
    end
    SMODS.Joker(SMODS.merge_defaults(joker, troll_joker))
end

-- load all jokers in joker dir
for i, joker in ipairs(NFS.getDirectoryItems(SMODS.current_mod.path .. "jokers")) do
    new_troll_joker(assert(SMODS.load_file("jokers/" .. joker))())
end

assert(SMODS.load_file("utils.lua"))()
