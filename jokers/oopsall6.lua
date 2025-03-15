return {
    key = "j_oops",
    cost = 99,
    config = {
        extra = {
            original_probabilities = -5,
        },
    },
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.probabilities) do
            original_probabilities = G.GAME.probabilities[k]
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.probabilities) do
            G.GAME.probabilities[k] = original_probabilities;
        end
    end,
    calculate = function(self, card, context)
        if pseudoramdom(self.key) <= 0.5 then
            for k, v in pairs(G.GAME.probabilities) do
                G.GAME.probabilities[k] = 0;
            end
        else
            for k, v in pairs(G.GAME.probabilities) do
                G.GAME.probabilities[k] = math.huge;
            end
        end
    end,

    -- localization
    loc_txt = {
        name = "Oops! All 6s",
        text = {
            "{C:green,E:1,S:1.1}Probabilities",
            "are {C:attention}50 / 50",
            "{C:inactive}(ex: {C:green}1 in 1000{C:inactive} -> {C:green}500 in 1000{C:inactive})"
        }
    },
}
