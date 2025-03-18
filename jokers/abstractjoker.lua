function getMult()
    if G.hand and G.jokers and G.consumables then
        return G.hand.config.card_limit + #G.jokers.cards + #G.consumables.cards;
    end
    return 0
end

return {
    key = "abstract",
    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = getMult() }
        end
    end,

    -- localization
    loc_vars = function(self, info_queue, card)
        return { vars = { getMult() } }
    end,
    loc_txt = {
        name = "Abstract Joker",
        text = {
            "{C:mult}+1{} Mult for",
            "each card outside",
            "your deck",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
        }
    },
}
