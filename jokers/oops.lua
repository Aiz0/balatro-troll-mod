return {
    key = "oops",
    add_to_deck = function(self, card, from_debuff)
        -- set cardareas to 6
        G.jokers.config.card_limit = 6
        G.consumeables.config.card_limit = 6
        G.hand:change_size(6 - G.hand.config.card_limit)

        G.GAME.probabilities.normal = 6

        -- set cards to 6s
        for _, playing_card in ipairs(G.playing_cards) do
            assert(SMODS.change_base(playing_card, nil, "6"))
        end

        -- hand
        G.hand:change_size(6 - G.GAME.round_resets.hands)
        G.GAME.round_resets.hands = 6
        -- discards
        ease_discard(6 - G.GAME.round_resets.discards)
        G.GAME.round_resets.discards = 6
        -- dollars
        ease_dollars(6 - G.GAME.dollars)

        -- ante and round
        ease_ante(6 - G.GAME.round_resets.ante)
        ease_round(6 - G.GAME.round)
    end,
}
