return {
    key = "golden",
    cost = 1,
    set_ability = function(self, card, initial, delay_sprites)
        folly_utils.log.Info(G.GAME.discount_percent)
        local discount = 1 - G.GAME.discount_percent / 100
        card.base_cost = (G.GAME.dollars + 1) / discount
    end,
    calculate_dollar_bonus = function(self, card)
        return 0
    end,
    dollars_updated = function(self, card, change)
        local discount = 1 - G.GAME.discount_percent / 100
        card.base_cost = (G.GAME.dollars + 1) / discount
        if card.area == G.jokers then
            card:set_cost()
        end
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