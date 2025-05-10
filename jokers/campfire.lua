SMODS.Joker({
    key = "charcoal",
    config = {
        extra = {
            mult = -5,
        },
        extra_value = -6,
    },
    cost = 1,
    in_pool = function(self, args)
        return false
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = -5,
            }
        end
    end,

    -- localization
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
})

return {
    key = "campfire",
    name = "fj_campfire",
    cost = 9,
    config = {
        extra = {
            x_mult_mod = 0.25,
            x_mult = 1.5,
        },
        name = "fj_campfire",
    },
    calculate = function(self, card, context)
        if context.selling_card and not context.blueprint then -- selling adds fuel to the fire
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(
                        card,
                        "extra",
                        nil,
                        nil,
                        nil,
                        { message = localize("k_upgrade_ex") }
                    )
                    return true
                end,
            }))
        end
        if context.after then -- reduce xMult when a hand is scored
            card.ability.extra.x_mult = card.ability.extra.x_mult - card.ability.extra.x_mult_mod
            if card.ability.extra.x_mult <= 0 then
                folly_utils.replace(card, folly_utils.prefix.joker .. "charcoal") -- get charcoaled idiot
            end
        end
        if context.joker_main then
            if card.ability.extra.x_mult ~= 1 then -- just a check for if the card does anything.
                return {
                    xmult = card.ability.extra.x_mult,
                }
            end
        end
    end,

    -- localization
    loc_vars = function(self, info_queue, card)
        return {
            key = self.key .. "_alt",
            vars = { card.ability.extra.x_mult_mod, card.ability.extra.x_mult },
        }
    end,
}
