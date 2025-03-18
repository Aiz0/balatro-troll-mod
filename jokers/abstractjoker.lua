return {
    key = "abstract",
    config = {
        extra = {
            mult = 0,
        }
    },
    calculate = function(self, card, context)
        card.ability.extra.mult = G.hand.config.card_limit + #G.jokers + #G.consumablees
        return {
            mult = card.ability.extra.mult
        }
    end,

    -- localization
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    loc_txt = {
        name = "Abstract Joker",
        text = {
            "{C:mult}+1{} Mult for",
            "each card outside",
            "your deck",
            "({C:inactive}Currently {C:mult}+#1#{} Mult)",
        }
    },
}
