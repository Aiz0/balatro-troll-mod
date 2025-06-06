SMODS.Sound({
    key = "munch",
    path = "munch.ogg",
})
SMODS.Enhancement({
    key = "eated",
    atlas = "folly_enhancers",
    pos = { x = 2, y = 0 },
    no_collection = true, -- it's not used as a enhancment right now
    weight = 0,
    in_pool = function(self, args)
        return false
    end,
})
return {
    key = "gluttenous_joker",
    calculate = function(self, card, context)
        if
            context.destroy_card
            and context.cardarea == G.play
            and context.destroy_card:is_suit("Clubs")
            and context.destroy_card.ability.set == "Default"
        then
            if pseudorandom(self.key) < G.GAME.probabilities.normal / 6 then
                context.destroy_card:set_ability(G.P_CENTERS.m_folly_eated, nil, true)
                return {
                    remove = true,
                    message = localize("k_folly_gluttenous"),
                    sound = "folly_munch",
                }
            end
        end
    end,
}
