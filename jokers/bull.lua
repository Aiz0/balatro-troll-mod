local red_jokers = {
    "lusty_joker",
    "credit_card",
    "raised_fist",
    "hack",
    "even_steven",
    "red_card",
    "madness",
    "gift",
    "reserved_parking",
    "popcorn",
    "bloodstone",
    "matador",
    "burnt",
    "bootstraps",
    "chicot",
}

local mod_prefix = SMODS.current_mod.prefix
local function find_red_joker()
    for _, joker in pairs(red_jokers) do
        if
            next(SMODS.find_card("j_" .. joker))
            or next(SMODS.find_card("j_" .. mod_prefix .. "_" .. joker))
        then
            return true
        end
    end
    return false
end

return {
    key = "bull",
    atlas = "folly_jokers",
    pos = { x = 6, y = 0 },
    -- atlas positions for alternate sprites
    angry_bull_pos = { x = 4, y = 0 },
    red_bull_pos = { x = 5, y = 0 },

    config = {
        extra = 2,
        red_bull = false,
        bull_seen_red = false,
        angry_bull_base = 8,
        angry_bull_loss = 2,
    },
    loc_vars = function(self, info_queue, card)
        local key
        if card.ability.red_bull then
            key = "j_" .. mod_prefix .. "_red_bull"
        elseif card.ability.bull_seen_red then
            key = "j_" .. mod_prefix .. "_angry_bull"
        end
        return {
            key = key or "j_bull",
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and not card.getting_sliced then
            if not card.ability.bull_seen_red and find_red_joker() then
                return {
                    message = localize("k_folly_bull_angry"),
                    colour = G.C.RED,
                    func = function()
                        card.ability.bull_seen_red = true
                        card.ability.extra = card.ability.angry_bull_base
                        card.children.center:set_sprite_pos(self.angry_bull_pos)
                        card:set_eternal(true)
                    end,
                }
            end
        elseif
            card.ability.bull_seen_red
            and not card.ability.red_bull
            and context.end_of_round
            and not context.individual
            and not context.repetition
            and not context.blueprint
        then
            card.ability.extra = card.ability.extra - card.ability.angry_bull_loss
            return { message = localize("k_folly_bull_angry"), colour = G.C.RED }
        elseif context.selling_card then
            -- Turn into redbull when diet cola sold while angry
            if
                card.ability.bull_seen_red
                and (
                    context.card.config.center_key == "j_diet_cola"
                    or context.card.config.center_key == "j_" .. mod_prefix .. "_diet_cola"
                )
            then
                return {
                    message = localize("k_folly_red_bull"),
                    colour = G.C.RED,
                    func = function()
                        card.ability.red_bull = true
                        card.children.center:set_sprite_pos(self.red_bull_pos)
                        card:set_eternal(false)
                    end,
                }
            end
        end
    end,
    set_sprites = function(self, card, front)
        if card.ability then
            if card.ability.red_bull then
                card.children.center:set_sprite_pos(self.red_bull_pos)
            elseif card.ability.bull_seen_red then
                card.children.center:set_sprite_pos(self.angry_bull_pos)
            end
        end
    end,
}
