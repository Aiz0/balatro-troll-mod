return {
    key = "lucky_cat",
    calculate = function(self, card, context)
        if
            context.individual
            and context.cardarea == G.play
            and not context.blueprint
            and context.other_card.lucky_trigger
        then
            card.ability.x_mult = card.ability.x_mult + card.ability.extra
            return {
                message = localize("k_upgrade_ex"),
                colour = G.C.MULT,
                func = function()
                    if SMODS.pseudorandom_probability(card, self.key, 1, 100, self.key) then
                        SMODS.calculate_effect({ message = localize("k_folly_mega_jackpot") }, card)
                        for i = 1, 100 do
                            --TODO: make this not speed up
                            ease_dollars(1)
                            delay(2)
                        end
                    end
                end,
            }
        end
    end,
}
