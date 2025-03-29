SMODS.Joker({
    key = "apartment",
    config = {
        extra = 0,
    },
    cost = 10,
    in_pool = function(self, args) return false end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand then
            local temp_Chips, temp_ID = 15, 15
            local raised_card = nil
            for i=1, #G.hand.cards do
                if temp_ID >= G.hand.cards[i].base.id and G.hand.cards[i].ability.effect ~= 'Stone Card' then
                    temp_Chips = G.hand.cards[i].base.nominal
                    temp_ID = G.hand.cards[i].base.id
                    raised_card = G.hand.cards[i]
                end
            end
            if raised_card == context.other_card then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = card
                    }
                else
                    card.ability.extra = card.ability.extra + temp_Chips
                    return {
                        message = "+"..temp_Chips,
                        colour = G.C.CHIPS,
                        card = card
                    }
                end
            end
        end

        if context.joker_main then
            return {
                chips = card.ability.extra,
            }
        end
    end,

    -- localization
    loc_txt = {
        name = "Apartment",
        text = {
            "This Joker gains",
            "Chips equal to the",
            "{C:attention}lowest{} ranked card",
            "held in hand",
            "{C:inactive}(Currently {C:chips}+#1# {C:inactive}Chips)"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
})

SMODS.Joker({
    key = "house",
    cost = 10,
    in_pool = function(self, args) return false end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + 1
            return {
                extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
                colour = G.C.MULT,
                card = card
            }
        end
    end,

    -- localization
    loc_txt = {
        name = "House",
        text = {
            "Every played {C:attention}card{}",
            "permanently gains",
            "{C:mult}+1{} Mult when scored",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
})

return {
    key = "blueprint"
}
