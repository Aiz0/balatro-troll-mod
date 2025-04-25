return {
    key = "oops",
    config = {
        extra = {
            joker_limit = 0,
            consumables_limit = 0,
            hand_size_offset = 0,
            odds = 0,
            hands = 0,
            discards = 0,
            dollars = 0,
            ante = 0,
            round = 0,
        },
    },
    add_to_deck = function(self, card, from_debuff)
        -- set cardareas to 6
        card.ability.extra.joker_limit = G.jokers.config.card_limit
        G.jokers.config.card_limit = 6

        card.ability.extra.consumables_limit = G.consumeables.config.card_limit
        G.consumeables.config.card_limit = 6

        card.ability.extra.hand_size_offset = 6 - G.hand.config.card_limit
        G.hand:change_size(card.ability.extra.hand_size_offset)

        if G.GAME.probabilities.normal > 0 then
            card.ability.extra.odds = 6 / G.GAME.probabilities.normal
            G.GAME.probabilities.normal = 6
        end

        -- set cards to 6s
        for _, playing_card in ipairs(G.playing_cards) do
            assert(SMODS.change_base(playing_card, nil, "6"))
        end

        -- hand
        card.ability.extra.hands = 6 - G.GAME.round_resets.hands
        ease_hands_played(card.ability.extra.hands)
        G.GAME.round_resets.hands = 6
        -- discards
        card.ability.extra.discards = 6 - G.GAME.round_resets.discards
        ease_discard(card.ability.extra.discards)
        G.GAME.round_resets.discards = 6
        -- dollars
        card.ability.extra.dollars = 6 - G.GAME.dollars
        ease_dollars(card.ability.extra.dollars)

        -- ante and round
        card.ability.extra.ante = 6 - G.GAME.round_resets.ante
        ease_ante(card.ability.extra.ante)
        card.ability.extra.round = 6 - G.GAME.round
        ease_round(card.ability.extra.round)
    end,

    remove_from_deck = function(self, card, from_debuff)
        -- set cardareas to 6
        -- joker
        G.jokers.config.card_limit = card.ability.extra.joker_limit - (6 - G.jokers.config.card_limit)
        --consumables
        G.consumeables.config.card_limit = card.ability.extra.consumables_limit - (6 - G.consumeables.config.card_limit)
        -- hand size
        G.hand:change_size(-card.ability.extra.hand_size_offset)

        G.GAME.probabilities.normal = G.GAME.probabilities.normal / card.ability.extra.odds

        -- hand
        ease_hands_played(-card.ability.extra.hands)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        -- discards
        ease_discard(-card.ability.extra.discards)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
        -- dollars
        ease_dollars(-card.ability.extra.dollars)

        -- ante and round
        ease_ante(-card.ability.extra.ante)
        ease_round(-card.ability.extra.round)
    end,
}
