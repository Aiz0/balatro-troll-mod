return {
    key = "cartomancer",
    set_ability = function(self, card, initial, delay_sprites)
        card.extra = pseudorandom_element(get_current_pool("Tarot"), pseudoseed(self.key))
    end,
    calculate = function(self, card, context)
        if
            context.setting_blind
            and not context.blueprint
            and not card.getting_sliced
            and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
        then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            return {
                message = localize("k_plus_tarot"),
                colour = G.C.PURPLE,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card({ key = card.extra })
                            G.GAME.consumeable_buffer = 0
                            return true
                        end,
                    }))
                end,
            }
        end
    end,
}
