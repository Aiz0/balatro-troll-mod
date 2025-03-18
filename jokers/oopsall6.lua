return {
    key = "oops",
    cost = 99,
    config = {
        extra = {
            original_probabilities = -5,
        },
    },
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.probabilities) do
            card.ability.extra.original_probabilities = G.GAME.probabilities[k]
            G.GAME.probabilities[k] = 0;
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.probabilities) do
            G.GAME.probabilities[k] = card.ability.extra.original_probabilities;
        end
    end,
    calculate = function(self, card, context)
        if card.ability.name == 'Oops! All 6s' then
            if context.add_to_deck then
                for k, v in pairs(G.GAME.probabilities) do
                    card.ability.extra.original_probabilities[k] = card.ability.extra.original_probabilities[k] * 2;
                end
            end
            if context.remove_from_deck then
                for k, v in pairs(G.GAME.probabilities) do
                    card.ability.extra.original_probabilities[k] = card.ability.extra.original_probabilities[k] / 2;
                end
            end
        end
    end,

    -- localization
    loc_txt = {
        name = "Oops! All 6s",
        text = {
            "Nothing ever happens.",
            "{C:inactive}(ex: {C:green}1 in 2{C:inactive} -> {C:green}0 in 2{C:inactive})"
        }
    },
}
