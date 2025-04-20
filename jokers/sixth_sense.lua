return {
    key = "sixth_sense",
    config = {
        extra = 1,
    },
    prev_state = nil,
    calculate = function(self, card, context)
        if context.individual and not self.prev_state and context.cardarea == G.play and
                #context.full_hand == 1 and context.full_hand[1]:get_id() == 6
                and G.GAME.current_round.hands_played == 0 then
            local created_card = create_card((pseudorandom(pseudoseed('stdset' .. G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base", G.pack_cards, nil, nil, nil, true, nil, 'sta')
            local edition = poll_edition('standard_edition' .. G.GAME.round_resets.ante, edition_rate, true)
            created_card:set_edition(edition)
            created_card:set_seal(SMODS.poll_seal({ mod = 10 }))
        end
    end
}