return {
    key = "astronomer",
    config = {
        extra = {
            astro = nil
        },
    },
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.extra.astro = pseudorandom_element(G.P_CENTER_POOLS.Planet, pseudoseed(self.key)).key
        end
    end,
}