return {
    key = "astronomer",
    config = {
        extra = {
            astro = nil
        },
    },
    astronomers = 0,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.astro = pseudorandom_element(G.P_CENTER_POOLS.Planet, pseudoseed(self.key)).key
    end,
}