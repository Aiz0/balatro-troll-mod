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

local function find_red_joker()
    for _, joker in pairs(red_jokers) do
        if
            next(SMODS.find_card("j_" .. joker))
            or next(SMODS.find_card(folly_utils.prefix.joker .. joker))
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
        name = folly_utils.prefix.joker .. "bull",
        extra = {
            chips = 2,
            red_bull = {
                active = false,
                xmult_first = 25,
                xmult_rest = 0.25,
            },
            angry_bull = {
                active = false,
                chips_base = 8,
                chips_loss = 2,
            },
        },
    },
    loc_vars = function(self, info_queue, card)
        local loc_table = {
            key = "j_bull",
            vars = {
                card.ability.extra.chips,
                card.ability.extra.chips * (G.GAME.dollars + (G.GAME.dollar_buffer or 0)),
            },
        }

        if card.ability.extra.angry_bull.active then
            loc_table.key = folly_utils.prefix.joker .. "angry_bull"
        elseif card.ability.extra.red_bull.active then
            loc_table.key = folly_utils.prefix.joker .. "red_bull"
            loc_table.vars = {
                card.ability.extra.red_bull.xmult_first,
                card.ability.extra.red_bull.xmult_rest,
            }
        end
        return loc_table
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and not card.getting_sliced then
            if
                not (card.ability.extra.angry_bull.active or card.ability.extra.red_bull.active)
                and find_red_joker()
            then
                return {
                    message = localize("k_folly_bull_angry"),
                    colour = G.C.RED,
                    func = function()
                        card.ability.extra.angry_bull.active = true
                        card.ability.extra.chips = card.ability.extra.angry_bull.chips_base
                        card.children.center:set_sprite_pos(self.angry_bull_pos)
                        card:set_eternal(true)
                    end,
                }
            end
        elseif
            card.ability.extra.angry_bull.active
            and context.end_of_round
            and not context.individual
            and not context.repetition
            and not context.blueprint
        then
            card.ability.extra.chips = card.ability.extra.chips
                - card.ability.extra.angry_bull.chips_loss
            return { message = localize("k_folly_bull_angry"), colour = G.C.RED }
        elseif context.selling_card then
            -- Turn into redbull when diet cola sold while angry
            if
                card.ability.extra.angry_bull.active
                and (
                    context.card.config.center_key == "j_diet_cola"
                    or context.card.config.center_key == folly_utils.prefix.joker .. "diet_cola"
                )
            then
                return {
                    message = localize("k_folly_red_bull"),
                    colour = G.C.RED,
                    func = function()
                        card.ability.extra.red_bull.active = true
                        card.ability.extra.angry_bull.active = false
                        card.children.center:set_sprite_pos(self.red_bull_pos)
                        card:set_eternal(false)
                    end,
                }
            end
        elseif
            context.joker_main
            and not card.ability.extra.red_bull.active
            and (G.GAME.dollars + (G.GAME.dollar_buffer or 0)) > 0
        then
            return {
                chips = card.ability.extra.chips * (G.GAME.dollars + (G.GAME.dollar_buffer or 0)),
            }
        elseif context.final_scoring_step and card.ability.extra.red_bull.active then
            local xmult = G.GAME.current_round.hands_played == 0
                    and card.ability.extra.red_bull.xmult_first
                or card.ability.extra.red_bull.xmult_rest
            return { xmult = xmult }
        end
    end,
    set_sprites = function(self, card, front)
        if card.ability then
            if card.ability.extra.red_bull.active then
                card.children.center:set_sprite_pos(self.red_bull_pos)
            elseif card.ability.extra.angry_bull.active then
                card.children.center:set_sprite_pos(self.angry_bull_pos)
            end
        end
    end,
}
