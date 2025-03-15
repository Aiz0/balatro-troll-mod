return {
    key = "wee",
    calculate = function(self, card, context)
        if
            context.individual
            and context.cardarea == G.play
            and not context.blueprint
            and context.other_card:get_id() == 2
        then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            return {
                message = localize("k_upgrade_ex"),
                colour = G.C.CHIPS,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card.children.center.T.w = card.children.center.T.w + G.CARD_W / 10
                            card.children.center.T.h = card.children.center.T.h + G.CARD_H / 10
                            return true
                        end,
                    }))
                end,
            }
        end
    end,
    load = function(self, card, card_table, other_card)
        card.T.w = (G.CARD_W * 0.7)
            + (G.CARD_W / 10 * card_table.ability.extra.chips / card_table.ability.extra.chip_mod)
        card.T.h = (G.CARD_H * 0.7)
            + (G.CARD_H / 10 * card_table.ability.extra.chips / card_table.ability.extra.chip_mod)
    end,
}
