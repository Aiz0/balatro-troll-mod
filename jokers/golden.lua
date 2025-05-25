return {
    key = "golden",
    cost = 1,
    set_ability = function(self, card, initial, delay_sprites)
        card.base_cost = G.GAME.dollars + 1
    end,
    calculate_dollar_bonus = function(self, card)
        return 0
    end,
    dollars_updated = function(self, card, change)
        card.cost = G.GAME.dollars + 1
    end,
    loc_vars = function(self, info_queue, card)
        if card.area == G.jokers then
            return { vars = {
                0,
            } }
        end
        return { vars = {
                localize("k_folly_golden")
            } }
    end,
}